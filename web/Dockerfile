FROM lukemathwalker/cargo-chef:latest-rust-1.70.0 as chef
WORKDIR app

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release
EXPOSE 3000
FROM gcr.io/distroless/cc-debian11
COPY --from=builder /app/target/release/web /
CMD ["./web"]