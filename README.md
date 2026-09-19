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
check + lint + tests + supply-chain audit, same as CI) in one command, use:

```bash
make check               # fmt check + clippy + test + cargo-deny (single entrypoint)
```

Or run the pre-commit hooks:

```bash
pre-commit run --all-files
```

Coverage & extra correctness (opt-in — CI runs coverage automatically):

```bash
cargo install cargo-llvm-cov          # one-time
cargo llvm-cov --all-features         # line/region coverage report
cargo test --doc                      # run documentation tests
cargo install cargo-mutants && cargo mutants   # mutation testing (finds weak tests)
```

### Option 2 — Docker (no local toolchain)

Use this if you don't have (or don't want) Rust installed locally. A `Makefile`
wraps the verbose Docker commands into short targets.

```bash
make                     # List available targets
make docker-check        # fmt check + lint + test in a dev container
make docker-shell        # Interactive dev shell (source mounted, cache persisted)
make docker-build        # Build the minimal production image
make docker-run          # Build and run the production image
```

The `docker-*` targets need only Docker; local development is all `cargo`
(Option 1). The `Makefile` also provides `make check` (Option 1) as the single
"run all checks" entrypoint.

## Contributing

`main` is protected — all changes go through a pull request from a feature branch.

1. Branch: `git checkout -b feat/my-change`
2. Commit using [Conventional Commits](https://www.conventionalcommits.org/)
   (`feat:`, `fix:`, `docs:`, `chore(deps):`, …). The `commit-msg` pre-commit
   hook validates this locally, and CI validates the PR title.
3. Open a PR. Required checks: format, lint, test, Docker build, security audit,
   secret scan, workflow audit, and conventional PR title.

```bash
pre-commit install   # installs both pre-commit and commit-msg hooks
```

## Tools

- **cargo** — Build, dependency management, and test runner (aliases in `.cargo/config.toml`)
- **rustfmt** — Formatting (config in `rustfmt.toml`)
- **clippy** — Linting (lints in `Cargo.toml`)
- **pre-commit** — Git hooks (format check, lint, tests, secret scan, workflow audit, conventional commit message)
- **gitleaks** — Secret scanning (pre-commit + CI)
- **zizmor** — GitHub Actions workflow security auditing (pre-commit + CI)
- **GitHub Actions** — PR checks (same as pre-commit)
- **Docker** — Multi-stage build + Compose dev container, driven via `Makefile`
- **cargo-audit / cargo-deny** — Dependency vulnerability, license, and supply-chain checks (`deny.toml`)
- **cargo-llvm-cov** — Code coverage in CI (report-only; LCOV artifact + PR summary)
- **OpenSSF Scorecard** — Supply-chain posture scoring (scheduled + on push to main)
- **Dependabot** — Automated dependency + action updates (`.github/dependabot.yml`)

## Project Structure

```
src/lib.rs             # Library crate
src/main.rs            # Binary crate
tests/                 # Integration tests
.cargo/config.toml     # Cargo aliases (local workflow)
Makefile               # `make check` (all checks) + Docker task shortcuts
deny.toml              # cargo-deny supply-chain policy
.github/workflows/     # CI (checks, Docker, security, secret scan, workflow audit, commit lint) + OpenSSF Scorecard
.github/dependabot.yml # Dependency update automation
.github/zizmor.yml     # zizmor (GitHub Actions audit) config
SECURITY.md            # Vulnerability disclosure policy
AGENTS.md              # Agent instructions (canonical)
CLAUDE.md              # Pointer to AGENTS.md (Claude Code)
.github/copilot-instructions.md  # Pointer to AGENTS.md (Copilot)
Dockerfile             # Multi-stage production build
docker-compose.yml     # Dev container + prod service
```
