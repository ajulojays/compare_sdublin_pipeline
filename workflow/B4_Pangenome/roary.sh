#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need roary
GFF="$SDUBLIN_WORKDIR/4.0-prokka/gff"
OUT="$SDUBLIN_WORKDIR/4.1-roary"
mkdir -p "$OUT"
sd_glob "$GFF/*.gff"
roary -e --mafft -p "$SDUBLIN_THREADS" "$GFF"/*.gff -f "$OUT" -v
echo "[PASS] Roary pangenome and core-gene alignment: $OUT"
