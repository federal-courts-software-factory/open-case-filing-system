use once_cell::sync::Lazy;
use surrealdb::{
    engine::remote::ws::{Client, Ws},
    opt::auth::Root,
    Result, Surreal,
};

pub static DB: Lazy<Surreal<Client>> = Lazy::new(Surreal::init);

pub async fn connect_db() -> Result<()> {
    let _ = DB.connect::<Ws>("0.0.0.0:8000").await?;
    let _ = DB
        .signin(Root {
            username: "root",
            password: "root",
        })
        .await;
    let _ = DB.use_ns("ofcs").use_db("ofcs").await?;

    Ok(())
}