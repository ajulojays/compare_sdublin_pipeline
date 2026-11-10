#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo "S. Dublin repository input inventory"
for f in data/meta/finalset_meta.tsv data/phylo/iq.treefile data/phylo/distances.tab data/amrfinder/amrfinderentero.txt data/abricate/vf-all_summary.txt data/pangenome/raw/bovclin_gene_presence_absence.csv data/pangenome/raw/bovenv_gene_presence_absence.csv data/pangenome/raw/humall_gene_presence_absence.csv; do
  if [[ -s "$f" ]]; then echo "[PRESENT] $f"; else echo "[MISSING] $f"; fi
done
for f in data/pangenome/raw/gene_presence_absence.csv data/pangenome/raw/gene_presence_absence.Rtab; do
  if [[ -s "$f" ]]; then echo "[PRESENT] $f"; else echo "[EXTERNAL] $f (retrieve from original study deposit)"; fi
done
echo "[INFO] Full reads-to-tree execution additionally needs an accession list, Kraken2, adapter FASTAs, and analysis environments."
