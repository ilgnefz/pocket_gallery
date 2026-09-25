use std::{os::windows::fs::MetadataExt, path::Path};

use blurhash::encode;
use image::GenericImageView;
use jwalk::WalkDir;
use uuid::Uuid;

use crate::api::model::{ImageFile, ImageOrientation, ScanResult};

#[flutter_rust_bridge::frb(sync)]
pub fn get_all_image(
    folder: String,
    exist_images: Vec<ImageFile>,
    #[frb(default = true)]
    recursive: bool,
) -> ScanResult {
    let mut result = ScanResult {
        added: Vec::new(),
        changed: Vec::new(),
    };
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
            let path_str = path.to_string_lossy();
            let mut meta_modified = 0u64;
            let mut meta_size = 0u64;
            if let Ok(meta) = std::fs::metadata(&path) {
                meta_modified = meta.last_write_time();
                meta_size = meta.len();
            }
            // 用 path + modified + size 组合指纹判断，
            // 避免"改名后其他文件占用同名路径"导致的脏数据残留
            match exist_images.iter().find(|i| i.path == path_str) {
                Some(exist)
                    if exist.modified == meta_modified && exist.size == meta_size =>
                {
                    // 文件未变化，跳过
                }
                Some(_) => {
                    // 路径相同但内容已变化：旧记录过期，重建新 ImageFile（新 id）
                    result.changed.push(get_image_info(&path));
                }
                None => {
                    result.added.push(get_image_info(&path));
                }
            }
        }
    }
    result
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

    let blurhash = String::new();

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
        blurhash,
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

pub fn generate_blurhash(path: String) -> String {
    let img = match open_image(Path::new(&path)) {
        Some(img) => img,
        None => {
            println!("打开图片出错(扩展名与内容不匹配或文件损坏): {:?}", path);
            return String::new();
        }
    };
    let small = img.thumbnail(32, 32);
    let (width, height) = small.dimensions();
    let rgba = small.to_rgba8();
    std::panic::catch_unwind(|| encode(4, 3, width, height, rgba.as_raw()))
        .ok()
        .and_then(Result::ok)
        .unwrap_or_default()
}

fn open_image(path: &Path) -> Option<image::DynamicImage> {
    image::ImageReader::open(path)
        .ok()?
        .with_guessed_format()
        .ok()?
        .decode()
        .ok()
}
