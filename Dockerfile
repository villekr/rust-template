# syntax=docker/dockerfile:1

# ---- Build stage ----
# Pinned by digest for reproducible builds; the tag is kept for readability and
# so Dependabot (docker ecosystem) can propose digest bumps.
FROM rust:1.97-slim@sha256:8e8cf8f7fd54a2d23d5a743b3a03f56e26b6c774276c33fa0595111704ebb15c AS builder
WORKDIR /app

COPY . .

# BuildKit cache mounts keep the cargo registry and target dir warm across
# builds without leaking them into the final image. Because the target dir is
# a cache mount (not persisted in the layer), copy the binary out to a stable
# path within the same RUN step.
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/app/target \
    cargo build --release \
    && cp /app/target/release/rust-template /usr/local/bin/rust-template

# ---- Runtime stage ----
FROM debian:bookworm-slim@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251 AS runtime

# Run as an unprivileged, non-root user.
RUN groupadd --system --gid 10001 app \
    && useradd --system --uid 10001 --gid app --no-create-home app

COPY --from=builder /usr/local/bin/rust-template /usr/local/bin/rust-template

USER app
ENTRYPOINT ["rust-template"]
