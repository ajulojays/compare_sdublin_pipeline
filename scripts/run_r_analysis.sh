#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
export SDUBLIN_ROOT="$ROOT"
if [[ $# -ne 1 ]]; then
  echo "Usage: bash scripts/run_r_analysis.sh {plotmeta|readqc|assembqc|abricate|amrfinder|pangenome|anno|snp}" >&2
  exit 2
fi
case "$1" in
  plotmeta|readqc|assembqc|abricate|amrfinder|pangenome|anno|snp) ;;
  *) echo "[ERROR] Unknown analysis: $1" >&2; exit 2 ;;
esac
command -v Rscript >/dev/null 2>&1 || { echo "[ERROR] Rscript is not installed" >&2; exit 1; }
if [[ "$1" == pangenome ]]; then
  for file in data/pangenome/raw/gene_presence_absence.csv data/pangenome/raw/gene_presence_absence.Rtab; do
    [[ -s "$file" ]] || { echo "[ERROR] Missing $file; see docs/DATA_REQUIREMENTS.md" >&2; exit 1; }
  done
fi
exec Rscript "workflow/B6_Comparative_Analyses/$1.R"
