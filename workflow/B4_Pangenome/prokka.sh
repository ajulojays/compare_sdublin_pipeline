#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need prokka
ASSEMB="$SDUBLIN_WORKDIR/3.0-unicycler_entero/assemblies"
OUT="$SDUBLIN_WORKDIR/4.0-prokka"
mkdir -p "$OUT/gff" "$OUT/faa" "$OUT/txt"
sd_glob "$ASSEMB/*_assembly.fasta"
for assembly in "$ASSEMB"/*_assembly.fasta; do
  id="${assembly##*/}"; id="${id%_assembly.fasta}"
  prokka "$assembly" --outdir "$OUT/$id" --prefix "$id" --force \
    --kingdom Bacteria --genus Salmonella --species enterica
  cp "$OUT/$id/$id.gff" "$OUT/gff/"
  cp "$OUT/$id/$id.faa" "$OUT/faa/"
  cp "$OUT/$id/$id.txt" "$OUT/txt/"
done
echo "[PASS] Prokka annotations and summary files: $OUT"
