#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need abricate
ASSEMB="$SDUBLIN_WORKDIR/3.0-unicycler_entero/assemblies"
OUT="$SDUBLIN_WORKDIR/4.2-abricate"
mkdir -p "$OUT"
sd_glob "$ASSEMB/*_assembly.fasta"
abricate --db plasmidfinder "$ASSEMB"/*_assembly.fasta > "$OUT/enteroplasmid-all.tab"
abricate --summary "$OUT/enteroplasmid-all.tab" > "$OUT/enteroplasmid-all_summary.txt"
echo "[PASS] ABRicate PlasmidFinder and summary: $OUT"
