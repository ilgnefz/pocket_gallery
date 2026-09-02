use std::{os::windows::fs::MetadataExt, path::Path};

use jwalk::WalkDir;
use uuid::Uuid;

use crate::api::model::{ImageFile, ImageOrientation};

#[flutter_rust_bridge::frb(sync)]
pub fn get_all_image(
    folder: String,
    exist_images: Vec<ImageFile>,
    #[frb(default = true)]
    recursive: bool,
) -> Vec<ImageFile> {
    let mut images: Vec<ImageFile> = Vec::new();
    let walker = if recursive {
        WalkDir::new(folder).sort(true)
    } else {
        WalkDir::new(folder).max_depth(1).sort(true)
    };
    for entry in walker {
        if let Ok(entry) = entry {
            if !entry.file_type().is_file() {
                continue;
            }
            let path = entry.path();
            if !is_image(&path) {
                continue;
            }
            if exist_images
                .iter()
                .any(|i| i.path == path.to_string_lossy())
            {
                continue;
            }
            let image = get_image_info(&path);
            images.push(image);
        }
    }
    images
}

fn is_image(path: &Path) -> bool {
    let ext = path
        .extension()
        .and_then(|e| e.to_str())
        .unwrap_or("")
        .to_lowercase();

    matches!(
        ext.as_str(),
        "jpg" | "jpeg" | "png" | "gif" | "webp" | "jfif" | "bmp"
    )
}

fn get_image_info(path: &Path) -> ImageFile {
    let id = Uuid::new_v4().to_string();
    let name = path
        .file_name()
        .map(|n| n.to_string_lossy().to_string())
        .unwrap_or_default();

    let folder = path
        .parent()
        .map(|p| p.to_string_lossy().to_string())
        .unwrap_or_default(); // String 实现了 Default，默认值是 ""

    let mut width: usize = 0;
    let mut height: usize = 0;
    let mut orientation = ImageOrientation::Other;

    match imagesize::size(path) {
        Ok(size) => {
            width = size.width;
            height = size.height;
            orientation = get_orientation(width, height);
        }
        Err(why) => println!("获取图片尺寸出错: {:?}", why),
    }

    let mut modified = 0;
    let mut size = 0;

    if let Ok(meta) = path.metadata() {
        modified = meta.last_write_time();
        size = meta.len();
    }

    ImageFile {
        id,
        name,
        folder,
        path: path.to_string_lossy().to_string(),
        width,
        height,
        orientation,
        modified,
        size,
        like: false,
    }
}

fn get_orientation(width: usize, height: usize) -> ImageOrientation {
    if width > height {
        ImageOrientation::Landscape
    } else if width < height {
        ImageOrientation::Portrait
    } else if width == height {
        ImageOrientation::Square
    } else {
        ImageOrientation::Other
    }
}
