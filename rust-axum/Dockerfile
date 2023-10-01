FROM rust:1.70-slim-bookworm AS chef
LABEL description="Rust Axum benchmark"
WORKDIR /app

RUN cargo install cargo-chef
RUN apt-get update && apt-get install -yq --no-install-recommends \
    pkg-config libssh-dev



# Prepare recipe
FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json



# Build
FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --recipe-path recipe.json

COPY . .
RUN cargo build --bin app



# Run application
FROM debian:bookworm-slim AS runtime
WORKDIR /app

RUN apt-get update && apt-get install -yq --no-install-recommends \
    ca-certificates libssl-dev

COPY --from=builder /app/target/debug/app /usr/local/bin

EXPOSE 2000
CMD ["/usr/local/bin/app"]

