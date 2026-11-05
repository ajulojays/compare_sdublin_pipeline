#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need checkm
ASSEMB="$SDUBLIN_WORKDIR/3.0-unicycler_entero/assemblies"
QC="$SDUBLIN_WORKDIR/3.1-uniqc"
mkdir -p "$QC/checkm" "$QC/quast"
sd_glob "$ASSEMB/*_assembly.fasta"
[[ -n "${SDUBLIN_CHECKM_DATA_PATH:-}" ]] || sd_die "Set SDUBLIN_CHECKM_DATA_PATH"
export CHECKM_DATA_PATH="$SDUBLIN_CHECKM_DATA_PATH"
checkm lineage_wf -f "$QC/checkm.tsv" -x fasta "$ASSEMB" "$QC/checkm" --tab_table
if command -v quast.py >/dev/null 2>&1; then
  QUAST=quast.py
elif command -v quast >/dev/null 2>&1; then
  QUAST=quast
else
  sd_die "Missing QUAST (quast.py or quast)"
fi
"$QUAST" -o "$QC/quast" --min-contig 500 --threads 4 "$ASSEMB"/*_assembly.fasta
echo "[PASS] CheckM and QUAST: $QC"
