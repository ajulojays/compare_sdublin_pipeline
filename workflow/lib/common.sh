#!/usr/bin/env bash
# Shared paths and preflight checks for the S. Dublin workflow.
set -euo pipefail
_SDUBLIN_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDUBLIN_ROOT="${SDUBLIN_ROOT:-$(cd "$_SDUBLIN_LIB_DIR/../.." && pwd)}"
if [[ -f "$SDUBLIN_ROOT/config/paths.env" ]]; then
  # shellcheck disable=SC1091
  source "$SDUBLIN_ROOT/config/paths.env"
fi
SDUBLIN_WORKDIR="${SDUBLIN_WORKDIR:-$SDUBLIN_ROOT/work}"
SDUBLIN_THREADS="${SDUBLIN_THREADS:-8}"
mkdir -p "$SDUBLIN_WORKDIR"
sd_die() { echo "[ERROR] $*" >&2; exit 1; }
sd_need() { command -v "$1" >/dev/null 2>&1 || sd_die "Missing executable: $1"; }
sd_glob() { compgen -G "$1" >/dev/null || sd_die "No input files matching $1"; }
sd_required_file() { [[ -s "$1" ]] || sd_die "Missing input: $1"; }
