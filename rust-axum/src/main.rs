use std::net::SocketAddr;
use axum::{Router, Json, routing::post, response::IntoResponse};
use serde_json::Value;




async fn echo_handler(body: Json<Value>) -> impl IntoResponse {
    return body
}

#[tokio::main] async fn main() {
    let app = Router::new()
        .route("/api/echo", post(echo_handler));

    let addr = SocketAddr::from(([0, 0, 0, 0], 2000));
    println!("Starting the server on {}...", addr);
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

