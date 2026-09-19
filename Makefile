# Development and build tasks.
#
# `make check` is the single deterministic "run all checks" entrypoint (fmt +
# clippy + test + cargo-deny) for local dev and AI agents. The `docker-*`
# targets wrap the verbose `docker compose` / `docker build` commands so you can
# develop and build without a local Rust toolchain.

IMAGE ?= rust-template

.DEFAULT_GOAL := help

.PHONY: help check docker-check docker-shell docker-build docker-run

help: ## List available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

check: ## Run all checks: fmt, clippy, test, cargo-deny (single entrypoint)
	cargo fmt --all --check
	cargo clippy --all-targets --all-features -- -D warnings
	cargo test --all-features
	cargo deny check

docker-check: ## Run fmt check, clippy, and tests in a dev container
	docker compose run --rm dev bash -c "\
		rustup component add rustfmt clippy >/dev/null 2>&1; \
		cargo fmt --all --check && \
		cargo clippy --all-targets --all-features -- -D warnings && \
		cargo test --all-features"

docker-shell: ## Open an interactive dev shell (source mounted, cache persisted)
	docker compose run --rm dev

docker-build: ## Build the minimal production image
	docker build -t $(IMAGE) .

docker-run: docker-build ## Build and run the production image
	docker run --rm $(IMAGE)
