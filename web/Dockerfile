
ARG PACKAGE=web

FROM rust:1.71.0-slim as builder

ARG PACKAGE

WORKDIR /app
#RUN apt update && apt install lld clang -y
COPY . .
# cargo vendor and add the toml configuration to config.offline
# We can build if crates.io goes offline.
RUN cargo remove common -v
RUN cargo add --git https://github.com/federal-courts-software-factory/open-case-filing-system.git common

RUN cargo build --release --bin $PACKAGE

FROM debian:bullseye-slim as runtime

ARG PACKAGE
ENV APP=$PACKAGE

WORKDIR /app
# RUN apt-get update -y \
#     && apt-get install -y --no-install-recommends openssl ca-certificates \
#     # Clean up
#     && apt-get autoremove -y \
#     && apt-get clean -y \
#     && rm -rf /var/lib/apt/lists/*
COPY ./dist ./dist
COPY --from=builder /app/target/release/$PACKAGE $PACKAGE


ENTRYPOINT ["./web"]