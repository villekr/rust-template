# syntax=docker/dockerfile:1

# ---- Build stage ----
FROM rust:1-slim AS builder
WORKDIR /app

# Cache dependencies separately from source for faster rebuilds.
COPY Cargo.toml Cargo.lock ./
RUN mkdir src \
    && echo 'fn main() {}' > src/main.rs \
    && echo '' > src/lib.rs \
    && cargo build --release \
    && rm -rf src

# Build the real sources.
COPY . .
RUN touch src/main.rs src/lib.rs && cargo build --release

# ---- Runtime stage ----
FROM debian:bookworm-slim AS runtime
WORKDIR /app
COPY --from=builder /app/target/release/rust-template /usr/local/bin/rust-template
ENTRYPOINT ["rust-template"]
