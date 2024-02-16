FROM lukemathwalker/cargo-chef:latest-rust-1.72.0 as chef
WORKDIR /app

FROM chef AS planner
COPY .  .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release

FROM gcr.io/distroless/cc-debian11
COPY --from=builder /app/target/release/web /
COPY --from=builder /app/dist /dist
CMD ["./web"]