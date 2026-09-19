# AGENTS.md

Instructions for AI coding agents working in this repository. This is the
canonical source of truth; `CLAUDE.md` and `.github/copilot-instructions.md`
are pointer files to it, and Kiro loads it automatically.

## Conversation style

- Focus on efficient communication; use minimal words.
- Results matter, not explanations.
- I won't always thank you for good work. I appreciate you regardless.

## Tech & Workflow

Stack: Rust (edition 2024, stable toolchain), cargo (build/test/deps), rustfmt
(format), clippy (lint), pre-commit + GitHub Actions (CI).

- `cargo build` / `cargo run` — build / run the binary
- `cargo test --all-features` — run tests
- `cargo fmt` — format; `cargo fmt-check` / `cargo lint` — aliases (see `.cargo/config.toml`)
- `make check` — the single "run all checks" entrypoint (see Verification)

Rules:
- Don't loosen the clippy lint set (`all` + `pedantic`) or `unsafe_code = "forbid"` to pass lint.
- Keep `Cargo.lock` committed and in sync with `Cargo.toml`.
- Manage dependencies with `cargo add` / `cargo remove`; don't hand-edit `[dependencies]` unless necessary.

## Engineering Conduct

Approach:
- Investigate before editing: read the relevant code; don't guess at APIs.
- Make the smallest change that fully solves the task. No unrequested refactors, abstractions, or defensive code.
- Prefer editing existing files over creating new ones. Create files only when the task requires it.
- If an approach fails twice, stop and diagnose the root cause before trying again.

Code:
- Document public items; prefer explicit over clever.
- Fail loudly: return `Result` with context (e.g. via the crate's error type); don't swallow errors or `unwrap()` on fallible paths outside tests.
- No secrets, tokens, or credentials in code, tests, or commits.
- Validate external input; never build shell/SQL strings via interpolation.

## Structure

```
src/lib.rs             # library crate (import as rust_template)
src/main.rs            # binary crate
tests/                 # integration tests, mirror the unit under test
.cargo/config.toml     # cargo aliases (local workflow)
Makefile               # `make check` (all checks) + Docker task shortcuts
deny.toml              # cargo-deny supply-chain policy
.github/workflows/     # CI (mirrors pre-commit + coverage)
AGENTS.md              # this file — CLAUDE.md, .github/copilot-instructions.md are pointer files to it
```

- Unit tests live in a `#[cfg(test)] mod tests` beside the code; integration tests go in `tests/`.
- Name tests `<unit>_<behavior>` (e.g. `add_returns_sum`).
- New public items get a matching test before the change is considered done.

## Verification (definition of done)

Run the single check entrypoint and expect it to exit `0` with no output beyond
the tools' own progress:

```
make check
```

which runs, and all must pass clean:
- `cargo fmt --all --check` — no formatting diffs.
- `cargo clippy --all-targets --all-features -- -D warnings` — no warnings.
- `cargo test --all-features` — all tests green.
- `cargo deny check` — advisories, bans, licenses, sources all pass.

Add tests covering new behavior and edge cases. Remove temp/scratch files before finishing.

## Git

- `main` is protected: never commit or push directly to it. All changes go through a PR from a feature branch.
- Use Conventional Commits for commit messages and PR titles (`feat:`, `fix:`, `chore(deps):`, `docs:`, …). A `commit-msg` pre-commit hook and a CI check enforce this.
- Commit only when asked. Stage specific files, not `git add .`.
- No force-push, hard reset, or history rewrite without explicit approval.

## Content creation

- Only create files when explicitly asked. No unsolicited documentation, summaries, or "helpful" extras.
