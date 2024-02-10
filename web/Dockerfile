FROM lukemathwalker/cargo-chef:latest-rust-1.70.0 as chef
WORKDIR /app

FROM chef AS planner
COPY web/src  .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder

COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY web/src web/dist /app/

RUN cargo build --release

FROM gcr.io/distroless/cc-debian11
COPY --from=builder /app/target/release/web /
COPY --from=builder /app/web/dist /dist
CMD ["./web"]