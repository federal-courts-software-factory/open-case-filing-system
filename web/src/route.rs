use axum::Router;

use tower_http::services::ServeFile;

pub fn create_index() -> Router {
    Router::new().route_service("/", ServeFile::new("dist/index.html"))
}
