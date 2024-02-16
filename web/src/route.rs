use axum::Router;

use tower_http::services::ServeFile;

pub fn create_index() -> Router {
    Router::new().route_service("/", ServeFile::new("dist/index.html"))
    .nest_service(
        "/assets",
        ServeDir::new(format!("{}/assets", assets_path.to_str().unwrap())),
    );
}
