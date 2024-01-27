use std::sync::Arc;

use axum::{
    routing::{get, post},
    Router,
};

use crate::{
    handler::{
        homepage, create_note_handler, delete_note_handler, edit_note_handler, get_note_handler,
        health_checker_handler, note_list_handler, case_list_handler
    },
    AppState,
};
use tower_http::services::{ServeDir, ServeFile};


pub fn create_router(app_state: Arc<AppState>) -> Router {
    Router::new()

        .route("/api/healthchecker", get(health_checker_handler))
        .route("/api/notes/", post(create_note_handler))
        .route("/api/notes", get(note_list_handler))
        .route("/api/court_cases", get(case_list_handler))
        .route(
            "/api/notes/:id",
            get(get_note_handler)
                .patch(edit_note_handler)
                .delete(delete_note_handler),
        )
        
        .nest_service(
            "/", ServeDir::new("dist")
           .not_found_service(ServeFile::new("dist/index.html")),
       )
        .with_state(app_state)
}
