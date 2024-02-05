mod route;

use tracing::info;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

use axum::http::{
    header::{ACCEPT, AUTHORIZATION, CONTENT_TYPE},
    HeaderValue, Method,
};
// use dotenv::dotenv;
use route::create_router;
use tower_http::cors::CorsLayer;



#[tokio::main]
async fn main() {
    // Load environment variables from a .env file.
    // dotenv().ok();

    let num = 10;
    println!("Common lib loaded: {num} plus one is {}!", common::add_one(num));

    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "web=debug".into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    info!("hello, web server!");

    // Create a CORS layer to handle Cross-Origin Resource Sharing.
    let cors = CorsLayer::new()
        .allow_origin("http://localhost:3000".parse::<HeaderValue>().unwrap())
        .allow_methods([Method::GET, Method::POST, Method::PATCH, Method::DELETE])
        .allow_credentials(true)
        .allow_headers([AUTHORIZATION, ACCEPT, CONTENT_TYPE]);
    // Create the application router and attach the CORS layer.
    let app = create_router().layer(cors);

    // Bind the server to listen on the specified address and port.
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();
    println!("->> LISTENING on {:?}\n", listener.local_addr());
    // Start serving the application.
    axum::serve(listener, app).await.unwrap();
}
