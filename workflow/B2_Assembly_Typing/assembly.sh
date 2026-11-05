#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need unicycler
FILT="$SDUBLIN_WORKDIR/2.1-k2filteredentero"
OUT="$SDUBLIN_WORKDIR/3.0-unicycler_entero"
mkdir -p "$OUT/assemblies"
sd_glob "$FILT/*.filt_1P.fq"
for r1 in "$FILT"/*.filt_1P.fq; do
  id="${r1##*/}"; id="${id%.filt_1P.fq}"
  r2="$FILT/${id}.filt_2P.fq"; sd_required_file "$r2"
  unicycler -1 "$r1" -2 "$r2" -o "$OUT/$id"
  sd_required_file "$OUT/$id/assembly.fasta"
  cp "$OUT/$id/assembly.fasta" "$OUT/assemblies/${id}_assembly.fasta"
done
echo "[PASS] Unicycler draft assemblies: $OUT/assemblies"
