#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need sistr
ASSEMB="$SDUBLIN_WORKDIR/3.0-unicycler_entero/assemblies"
OUT="$SDUBLIN_WORKDIR/3.2-sero/sistr"
mkdir -p "$OUT/alleles" "$OUT/novel" "$OUT/cgmlst" "$OUT/output"
sd_glob "$ASSEMB/*_assembly.fasta"
for assembly in "$ASSEMB"/*_assembly.fasta; do
  id="${assembly##*/}"; id="${id%_assembly.fasta}"
  sistr --qc -vv -t 4 \
    --alleles-output "$OUT/alleles/${id}_allele-results.json" \
    --novel-alleles "$OUT/novel/${id}_novel-alleles.fasta" \
    --cgmlst-profiles "$OUT/cgmlst/${id}_cgmlst-profiles.csv" \
    -f tab -o "$OUT/output/${id}-output.tab" "$assembly"
done
sd_glob "$OUT/output/*-output.tab"
reports=("$OUT/output"/*-output.tab)
{
  head -n 1 "${reports[0]}"
  for f in "${reports[@]}"; do tail -n +2 "$f"; done
} > "$OUT/output/sistr_output.txt"
sd_glob "$OUT/cgmlst/*_cgmlst-profiles.csv"
profiles=("$OUT/cgmlst"/*_cgmlst-profiles.csv)
{
  head -n 1 "${profiles[0]}"
  for f in "${profiles[@]}"; do tail -n +2 "$f"; done
} > "$OUT/cgmlst/sistr_cgmlst.csv"
echo "[PASS] SISTR serotyping/cgMLST: $OUT"
