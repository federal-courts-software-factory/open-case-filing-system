use once_cell::sync::Lazy;
use surrealdb::{
    engine::remote::ws::{Client, Ws},
    opt::auth::Root,
    Result, Surreal,
};

pub static DB: Lazy<Surreal<Client>> = Lazy::new(Surreal::init);

pub async fn connect_db() -> Result<()> {
    let db = Surreal::new::<Ws>("0.0.0.0:8000").await?;
    
    db.signin(Root {
        username: "root",
        password: "root",
    })
    .await?;

    db.use_ns("ocfs").use_db("ocfs").await?;

    Ok(())
}
