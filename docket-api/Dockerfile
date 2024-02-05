# Build stage
FROM rust:bookworm as builder
WORKDIR /usr/src/app
# Build dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir ./src && echo 'fn main() {}' > ./src/main.rs
RUN cargo build --release
# Replace with real src
RUN rm -rf ./src
COPY . .
# break the Cargo cache
RUN touch ./src/main.rs
# Build the project
RUN cargo build --release
# Run stage
FROM debian:bookworm-slim as run
RUN apt-get update && apt install -y openssl && rm -rf /var/lib/apt/lists/* && apt-get clean
COPY --from=builder /usr/src/app/target/release/docket-api /usr/local/bin
ENTRYPOINT ["/usr/local/bin/docket-api"]