#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need amrfinder
PROT="$SDUBLIN_WORKDIR/4.0-prokka/faa"
ANNO="$SDUBLIN_WORKDIR/4.0-prokka/gff"
ASSEMB="$SDUBLIN_WORKDIR/3.0-unicycler_entero/assemblies"
OUT="$SDUBLIN_WORKDIR/4.3-amrfinder"
mkdir -p "$OUT"
sd_glob "$ASSEMB/*_assembly.fasta"
for f in "$ASSEMB"/*_assembly.fasta; do
  id="${f##*/}"; id="${id%_assembly.fasta}"
  sd_required_file "$PROT/$id.faa"
  sd_required_file "$ANNO/$id.gff"
  amrfinder -p "$PROT/$id.faa" -n "$f" -g "$ANNO/$id.gff" \
    -a prokka -O Salmonella --plus -o "$OUT/$id"
done
echo "[PASS] AMRFinderPlus outputs: $OUT"
