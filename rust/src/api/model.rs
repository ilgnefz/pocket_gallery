use flutter_rust_bridge::frb;

#[derive(Debug)]
pub enum ImageOrientation {
    All,
    Landscape,
    Portrait,
    Square,
    Other,
}

#[frb(type_64bit_int)]
#[derive(Debug)]
pub struct ImageFile {
    pub id: String,
    pub name: String,
    pub folder: String,
    pub path: String,
    pub width: usize,
    pub height: usize,
    pub orientation: ImageOrientation,
    pub size: u64,
}
