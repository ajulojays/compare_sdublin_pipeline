#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need SeqSero2_package.py
ASSEMB="$SDUBLIN_WORKDIR/3.0-unicycler_entero/assemblies"
OUT="$SDUBLIN_WORKDIR/3.2-sero/seqsero"
mkdir -p "$OUT"
sd_glob "$ASSEMB/*_assembly.fasta"
for assembly in "$ASSEMB"/*_assembly.fasta; do
  id="${assembly##*/}"; id="${id%_assembly.fasta}"
  SeqSero2_package.py -m k -t 4 -i "$assembly" -d "$OUT/${id}_seqsero" -n "$id"
done
sd_glob "$OUT/*_seqsero/SeqSero_result.tsv"
reports=("$OUT"/*_seqsero/SeqSero_result.tsv)
{
  head -n 1 "${reports[0]}"
  for f in "${reports[@]}"; do tail -n +2 "$f"; done
} > "$OUT/enteroseqsero_summary.tsv"
echo "[PASS] SeqSero2 assembly-based serotyping: $OUT"
