use std::path::Path;

use uuid::Uuid;
use walkdir::WalkDir;

use crate::api::model::{ImageFile, ImageOrientation};

fn is_image_file(path: &str) -> bool {
    let ext = Path::new(path)
        .extension()
        .and_then(|e| e.to_str())
        .unwrap_or("")
        .to_lowercase();

    matches!(
        ext.as_str(),
        "jpg" | "jpeg" | "png" | "gif" | "webp" | "jfif" | "bmp"
    )
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_all_image(folders: Vec<String>, exist_files: Vec<ImageFile>) -> Vec<ImageFile> {
    let mut image_files = Vec::new();

    for folder in folders {
        for entry in WalkDir::new(folder).into_iter().filter_map(|e| e.ok()) {
            if !entry.file_type().is_file() {
                continue;
            }

            let path = entry.path();
            let path_str = path.to_string_lossy();

            if !is_image_file(&path_str) {
                continue;
            }

            if exist_files.iter().any(|f| f.path == path_str.to_string()) {
                continue;
            }

            image_files.push(get_image_info(path));
        }
    }

    image_files
}

fn get_image_info(path: &Path) -> ImageFile {
    let name = path.file_name().and_then(|n| n.to_str()).unwrap_or("");
    let parent_folder = path
        .parent()
        .and_then(|p| p.to_str())
        .unwrap_or("")
        .to_string();

    let mut width = 0;
    let mut height = 0;
    let mut orientation = ImageOrientation::Other;

    match imagesize::size(path) {
        Ok(size) => {
            width = size.width;
            height = size.height;
            if width > height {
                orientation = ImageOrientation::Landscape;
            } else if height > width {
                orientation = ImageOrientation::Portrait;
            } else {
                orientation = ImageOrientation::Square;
            }
        }
        Err(why) => println!("获取图片尺寸出错: {:?}", why),
    }

    let name = path.file_name().and_then(|n| n.to_str()).unwrap_or("");
    let parent_folder = path
        .parent()
        .and_then(|p| p.to_str())
        .unwrap_or("")
        .to_string();

    let mut width = 0;
    let mut height = 0;
    let mut orientation = ImageOrientation::Other;

    match imagesize::size(path) {
        Ok(size) => {
            width = size.width;
            height = size.height;
            if width > height {
                orientation = ImageOrientation::Landscape;
            } else if height > width {
                orientation = ImageOrientation::Portrait;
            } else {
                orientation = ImageOrientation::Square;
            }
        }
        Err(why) => println!("获取图片尺寸出错: {:?}", why),
    }

    let size = entry.metadata().map(|m| m.len()).unwrap_or(0);
    let name = path.file_name().and_then(|n| n.to_str()).unwrap_or("");
    let folder = path
        .parent()
        .and_then(|p| p.to_str())
        .unwrap_or("")
        .to_string();

    let mut width = 0;
    let mut height = 0;
    let mut orientation = ImageOrientation::Other;

    match imagesize::size(path) {
        Ok(size) => {
            width = size.width;
            height = size.height;
            if width > height {
                orientation = ImageOrientation::Landscape;
            } else if height > width {
                orientation = ImageOrientation::Portrait;
            } else {
                orientation = ImageOrientation::Square;
            }
        }
        Err(why) => println!("获取图片尺寸出错: {:?}", why),
    }

    let size = entry.metadata().map(|m| m.len()).unwrap_or(0);

    ImageFile {
        id: Uuid::new_v4().to_string(),
        name: name.to_string(),
        folder,
        path: path.to_string_lossy(),
        width,
        height,
        orientation,
        size,
    }
}
