use axum::Router;
use tokio::net::TcpListener;

use tower_http::services::{ServeDir, ServeFile};
use dotenv::dotenv;

#[tokio::main]
async fn main() {
  // Load environment variables from a .env file.
  dotenv().ok();
let routes_all =
  Router::new()
  .nest_service(
      "/", ServeDir::new("dist")
     .not_found_service(ServeFile::new("dist/index.html"))
 );


 	// region:    --- Start Server
   let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
     println!("->> LISTENING on {:?}\n", listener.local_addr());
     axum::serve(listener, routes_all.into_make_service())
         .await
         .unwrap();
     // endregion: --- Start Server
 
}
