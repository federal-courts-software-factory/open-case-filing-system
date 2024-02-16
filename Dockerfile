FROM rust:slim-bookworm as chef
RUN apt-get update && apt-get install -y musl-tools
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo install cargo-chef
WORKDIR /src

FROM chef as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /src/recipe.json recipe.json
RUN cargo chef cook --target=x86_64-unknown-linux-musl --release --recipe-path=recipe.json
COPY . .
RUN cargo build --target=x86_64-unknown-linux-musl --release

FROM scratch as web
COPY --from=builder /src/target/x86_64-unknown-linux-musl/release/web /web
CMD [ "/web" ]
LABEL service=web

FROM scratch as docket-api
COPY --from=builder /src/target/x86_64-unknown-linux-musl/release/docket-api /docket-api
CMD [ "/docket-api" ]
LABEL service=docket-api