mod handler;
mod model;
mod route;
mod schema;
use tokio::net::TcpListener;
use std::net::SocketAddr;
use std::sync::Arc;

use axum::http::{
    header::{ACCEPT, AUTHORIZATION, CONTENT_TYPE},
    HeaderValue, Method,
};
use dotenv::dotenv;
use route::create_router;
use tower_http::cors::CorsLayer;

use sqlx::{postgres::PgPoolOptions, Pool, Postgres};
use sqlx::migrate::Migrator;

// Define the application state struct to hold the database pool.
pub struct AppState {
    db: Pool<Postgres>,
}

// Define the SQLx migrator to manage database migrations.
static MIGRATOR: Migrator = sqlx::migrate!(); // defaults to "./migrations"

#[tokio::main]
async fn main() {
    // Load environment variables from a .env file.
    dotenv().ok();

    // Retrieve the database URL from the environment variables.
    let database_url = std::env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    // Create a database connection pool.
    let pool = match PgPoolOptions::new()
        .max_connections(10)
        .connect(&database_url)
        .await
    {
        Ok(pool) => {
            println!("✅ Connection to the database is successful!");
            
            pool
        }
        Err(err) => {
            println!("🔥 Failed to connect to the database: {:?}", err);
            std::process::exit(1);
        }
        
    };
    // This should add our migrations at runtime without using the sqlx migrate run
    MIGRATOR.run(&pool).await.unwrap();
    println!("cargo:rerun-if-changed=migrations");
    

    // Create a CORS layer to handle Cross-Origin Resource Sharing.
    let cors = CorsLayer::new()
        .allow_origin("http://localhost:3000".parse::<HeaderValue>().unwrap())
        .allow_methods([Method::GET, Method::POST, Method::PATCH, Method::DELETE])
        .allow_credentials(true)
        .allow_headers([AUTHORIZATION, ACCEPT, CONTENT_TYPE]);
    // Create the application router and attach the CORS layer.
    let app = create_router(Arc::new(AppState { db: pool.clone() })).layer(cors);


    // Bind the server to listen on the specified address and port.
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();
println!("->> LISTENING on {:?}\n", listener.local_addr());
    // Start serving the application.
    axum::serve(listener, app).await.unwrap();
}

