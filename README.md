# rust-template

Rust project template with modern defaults: cargo, rustfmt, clippy, pre-commit, GitHub Actions.

## Getting Started

1. Create a new repo from this template (GitHub "Use this template" button)
2. Clone your new repo
3. Run the one-time setup to rename the crate to match your project:

```bash
./scripts/setup-once.sh
```

4. Activate pre-commit hooks and build:

```bash
pre-commit install
cargo build
```

## Commands

There are two optional workflows — pick whichever suits you. They run the same
checks, so you can freely mix them.

### Option 1 — Local (cargo)

Use this if you have a Rust toolchain installed. Everything is plain `cargo`,
plus a few convenience aliases defined in `.cargo/config.toml`.

```bash
cargo test               # Run tests
cargo fmt                # Format code
cargo run                # Run the binary
cargo build              # Build

cargo fmt-check          # Check formatting without changes (alias)
cargo lint               # Clippy with warnings as errors (alias)
```

Run `cargo --list` to see all aliases. To run the full check suite (format
check + lint + tests, same as CI), use the pre-commit hooks:

```bash
pre-commit run --all-files
```

### Option 2 — Docker (no local toolchain)

Use this if you don't have (or don't want) Rust installed locally. A `Makefile`
wraps the verbose Docker commands into short targets.

```bash
make                     # List available Docker targets
make docker-check        # fmt check + lint + test in a dev container
make docker-shell        # Interactive dev shell (source mounted, cache persisted)
make docker-build        # Build the minimal production image
make docker-run          # Build and run the production image
```

The Makefile intentionally covers only Docker tasks; local development is all
`cargo` (Option 1).

## Tools

- **cargo** — Build, dependency management, and test runner (aliases in `.cargo/config.toml`)
- **rustfmt** — Formatting (config in `rustfmt.toml`)
- **clippy** — Linting (lints in `Cargo.toml`)
- **pre-commit** — Git hooks (format check, lint, tests)
- **GitHub Actions** — PR checks (same as pre-commit)
- **Docker** — Multi-stage build + Compose dev container, driven via `Makefile`

## Project Structure

```
src/lib.rs             # Library crate
src/main.rs            # Binary crate
tests/                 # Integration tests
.cargo/config.toml     # Cargo aliases (local workflow)
Makefile               # Docker task shortcuts (Docker workflow)
.github/workflows/     # CI
AGENTS.md              # Agent instructions (canonical)
CLAUDE.md              # Pointer to AGENTS.md (Claude Code)
.github/copilot-instructions.md  # Pointer to AGENTS.md (Copilot)
Dockerfile             # Multi-stage production build
docker-compose.yml     # Dev container + prod service
```
