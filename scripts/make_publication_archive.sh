#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
if [[ $# -ne 1 ]]; then echo "Usage: bash scripts/make_publication_archive.sh v1.0.0" >&2; exit 2; fi
TAG="$1"
if [[ ! "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "[FAIL] Use a stable semantic release tag such as v1.0.0" >&2; exit 2
fi
if [[ -n "$(git status --porcelain)" ]]; then
  echo "[FAIL] Commit or discard local changes before creating a publication archive" >&2; exit 1
fi
if ! git show-ref --verify --quiet "refs/tags/$TAG"; then
  echo "[FAIL] Tag $TAG does not exist locally" >&2; exit 1
fi
TAG_SHA="$(git rev-parse "$TAG^{commit}")"
HEAD_SHA="$(git rev-parse HEAD)"
if [[ "$TAG_SHA" != "$HEAD_SHA" ]]; then
  echo "[FAIL] Checkout the exact frozen tag/commit before archiving" >&2; exit 1
fi
mkdir -p dist
ARCHIVE="dist/compare_sdublin_pipeline-${TAG}.tar.gz"
git -c core.autocrlf=false archive --format=tar --prefix="compare_sdublin_pipeline-${TAG}/" "$TAG" | gzip -n > "$ARCHIVE"
(cd dist && sha256sum "${ARCHIVE##*/}" > "${ARCHIVE##*/}.sha256")
echo "[PASS] Frozen commit: $HEAD_SHA"
echo "[PASS] Archive: $ARCHIVE"
echo "[PASS] Checksum: $ARCHIVE.sha256"
