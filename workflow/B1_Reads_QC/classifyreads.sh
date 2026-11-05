#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need kraken2
TR="$SDUBLIN_WORKDIR/1.0-trimmed"
OUT="$SDUBLIN_WORKDIR/2.0-kraken2"
DB="${SDUBLIN_KRAKEN_DB:-}"
[[ -n "$DB" && -d "$DB" ]] || sd_die "Configure an installed Kraken2 database via SDUBLIN_KRAKEN_DB"
mkdir -p "$OUT"
sd_glob "$TR/*_1P.fq.gz"
for r1 in "$TR"/*_1P.fq.gz; do
  id="${r1##*/}"; id="${id%_1P.fq.gz}"
  r2="$TR/${id}_2P.fq.gz"; sd_required_file "$r2"
  kraken2 --threads "$SDUBLIN_THREADS" --db "$DB" --gzip-compressed \
    --paired --classified-out "$OUT/${id}.classified-out.R#.fastq" \
    --unclassified-out "$OUT/${id}.unclassified-out.R#.fastq" \
    --report "$OUT/${id}.k2report" --report-minimizer-data \
    --minimum-hit-groups 3 "$r1" "$r2" > "$OUT/${id}.kraken2"
done
echo "[PASS] Kraken2 read classification: $OUT"
