#!/usr/bin/env bash
set -euo pipefail

# One-time project initialization script.
# Renames the crate based on the current directory name, then deletes itself.

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DIR_NAME="$(basename "$PROJECT_DIR")"

# Derive names
DIST_NAME="$DIR_NAME"              # cargo package name, e.g. my-awesome-project
CRATE_NAME="${DIR_NAME//-/_}"      # crate/lib name, e.g. my_awesome_project

OLD_DIST="rust-template"
OLD_CRATE="rust_template"

if [ "$CRATE_NAME" = "$OLD_CRATE" ]; then
  echo "Directory name is already '$DIR_NAME', nothing to rename."
  exit 0
fi

echo "Initializing project: $DIST_NAME (crate: $CRATE_NAME)"

# Portable in-place sed
if [[ "$(uname)" == "Darwin" ]]; then
  SED_CMD=(sed -i '')
else
  SED_CMD=(sed -i)
fi

FILES=(
  "$PROJECT_DIR/Cargo.toml"
  "$PROJECT_DIR/README.md"
  "$PROJECT_DIR/src/main.rs"
  "$PROJECT_DIR/src/lib.rs"
  "$PROJECT_DIR/tests/integration.rs"
  "$PROJECT_DIR/Dockerfile"
  "$PROJECT_DIR/Makefile"
  "$PROJECT_DIR/.github/workflows/pr.yml"
)

for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue
  # Order matters: replace crate (underscore) form first, then dist (hyphen) form.
  "${SED_CMD[@]}" "s|$OLD_CRATE|$CRATE_NAME|g" "$f"
  "${SED_CMD[@]}" "s|$OLD_DIST|$DIST_NAME|g" "$f"
done

echo "Done. You can now run: cargo build"

# Self-delete
rm -- "$0"
