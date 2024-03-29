use docket_api::{
    api::router::create_router, infrastructure::data::db_context::surreal_context::connect_db,
};
use tokio::signal;
use tower_http::cors::CorsLayer;
#[tokio::main]
async fn main() {
    connect_db().await.unwrap();

    let app = create_router().layer(CorsLayer::permissive());
    println!("🚀 Server started successfully");

    let listener = tokio::net::TcpListener::bind("0.0.0.0:9000").await.unwrap();

    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await
        .unwrap();
}

async fn shutdown_signal() {
    let ctrl_c = async {
        signal::ctrl_c()
            .await
            .expect("failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        signal::unix::signal(signal::unix::SignalKind::terminate())
            .expect("failed to install signal handler")
            .recv()
            .await;
    };

    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        _ = ctrl_c => {},
        _ = terminate => {},
    }
}
