ARG PACKAGE=web
FROM rust:1.71.1 as builder
WORKDIR /app

COPY Cargo.toml .
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo remove common -v
RUN cargo build --release --bin web

COPY src src
RUN touch src/main.rs

RUN cargo add --git https://github.com/federal-courts-software-factory/open-case-filing-system.git common
RUN cargo build --release --bin web

RUN strip target/release/web

FROM gcr.io/distroless/cc-debian12 as release
WORKDIR /app
COPY --from=builder /app/target/release/web .
COPY ./dist ./dist

EXPOSE 3000

CMD ["./web"]