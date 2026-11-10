#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need mlst
ASSEMB="$SDUBLIN_WORKDIR/3.0-unicycler_entero/assemblies"
OUT="$SDUBLIN_WORKDIR/3.2-sero/mlst"
mkdir -p "$OUT"
sd_glob "$ASSEMB/*_assembly.fasta"
mlst --scheme senterica_achtman_2 "$ASSEMB"/*_assembly.fasta > "$OUT/mlst.tsv"
echo "[PASS] Achtman MLST calls: $OUT/mlst.tsv"
