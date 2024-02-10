
use docket_api::{
    api::router::create_router, infrastructure::data::db_context::surreal_context::connect_db,
};
use tower_http::cors::CorsLayer;

#[tokio::main]
async fn main() {
    connect_db().await.unwrap();


    let app = create_router().layer(CorsLayer::permissive());

    println!("🚀 Server started successfully");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:9000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
