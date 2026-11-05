#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need python; sd_need seqkit
TR="$SDUBLIN_WORKDIR/1.0-trimmed"
K2="$SDUBLIN_WORKDIR/2.0-kraken2"
FILT="$SDUBLIN_WORKDIR/2.1-k2filteredentero"
mkdir -p "$FILT"
if [[ -n "${SDUBLIN_KRAKEN_TOOLS:-}" ]]; then
  EXTRACT="$SDUBLIN_KRAKEN_TOOLS/extract_kraken_reads.py"
else
  EXTRACT="$(command -v extract_kraken_reads.py || true)"
fi
[[ -n "$EXTRACT" ]] && sd_required_file "$EXTRACT" || sd_die "Set SDUBLIN_KRAKEN_TOOLS to the KrakenTools directory"
sd_glob "$TR/*_1P.fq.gz"
for r1 in "$TR"/*_1P.fq.gz; do
  id="${r1##*/}"; id="${id%_1P.fq.gz}"
  sd_required_file "$TR/${id}_2P.fq.gz"
  sd_required_file "$K2/${id}.kraken2"
  sd_required_file "$K2/${id}.k2report"
  python "$EXTRACT" -t 543 --include-children \
    -k "$K2/${id}.kraken2" \
    -s1 "$r1" -s2 "$TR/${id}_2P.fq.gz" \
    -o "$FILT/${id}.filt_1P.fq" -o2 "$FILT/${id}.filt_2P.fq" \
    --fastq-output -r "$K2/${id}.k2report"
done
seqkit stats "$FILT"/*.fq -T > "$FILT/k2filtstats.txt"
echo "[PASS] Enterobacteriaceae paired-read extraction (TaxID 543): $FILT"
