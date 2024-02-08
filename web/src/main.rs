mod route;
use tokio::signal;
use tracing::info;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};
// use dotenv::dotenv;
use tower_http::cors::CorsLayer;

#[tokio::main]
async fn main() {
    // Load environment variables from a .env file.
    // dotenv().ok();

    let num = 10;
    println!(
        "Common lib loaded: {num} plus one is {}!",
        common::add_one(num)
    );

    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "web=debug".into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    info!("hello, web server!");

    // Create a CORS layer to handle Cross-Origin Resource Sharing.

    // Create the application router and attach the CORS layer.
    let app = route::create_index().layer(CorsLayer::permissive());


    // Bind the server to listen on the specified address and port.
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("->> LISTENING on {:?}\n", listener.local_addr());
    // Start serving the application.
    axum::serve(listener, app)
    .with_graceful_shutdown(shutdown_signal())
    .await.unwrap();

    
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