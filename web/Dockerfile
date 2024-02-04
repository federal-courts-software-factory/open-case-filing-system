# Using the `rust-musl-builder` as base image, instead of 
# the official Rust toolchain
FROM clux/muslrust:stable AS chef
USER root
RUN cargo install cargo-chef
WORKDIR /app

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
# Notice that we are specifying the --target flag!
RUN cargo chef cook --release --target x86_64-unknown-linux-musl --recipe-path recipe.json
COPY . .
RUN cargo build --release --target x86_64-unknown-linux-musl --bin web

FROM alpine AS runtime
RUN addgroup -S ocfs && ocfs -S ocfs -G ocfs
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/web /usr/local/bin/
USER ocfs
CMD ["/usr/local/bin/web"]