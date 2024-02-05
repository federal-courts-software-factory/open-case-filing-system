use axum::Router;

use tower_http::services::{ServeDir, ServeFile};

pub fn create_router() -> Router {
    Router::new().route_service("/", ServeFile::new("dist/index.html"))
}
