#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need modeltest-ng
ALIGNMENT="$SDUBLIN_WORKDIR/4.1-roary/core_gene_alignment.aln"
OUT="$SDUBLIN_WORKDIR/5.0-modeltest"
sd_required_file "$ALIGNMENT"
mkdir -p "$OUT"
modeltest-ng -i "$ALIGNMENT" -o "$OUT/modeltest" \
  -t ml -d nt -T raxml -p "$SDUBLIN_THREADS"
echo "[PASS] ModelTest-NG analysis: $OUT"
