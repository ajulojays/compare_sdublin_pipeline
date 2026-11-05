#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
if command -v iqtree >/dev/null 2>&1; then
  IQTREE=iqtree
elif command -v iqtree2 >/dev/null 2>&1; then
  IQTREE=iqtree2
else
  sd_die "Missing IQ-TREE (iqtree or iqtree2)"
fi
ALIGNMENT="$SDUBLIN_WORKDIR/4.1-roary/core_gene_alignment.aln"
OUT="$SDUBLIN_WORKDIR/5.1-iqtree"
sd_required_file "$ALIGNMENT"
mkdir -p "$OUT"
"$IQTREE" -s "$ALIGNMENT" -m GTR+I+G4 --seed 1234 \
  --verbose --ufboot 1000 -bnni -nt AUTO --prefix "$OUT/iq1"
echo "[PASS] Core-gene IQ-TREE phylogeny: $OUT"
