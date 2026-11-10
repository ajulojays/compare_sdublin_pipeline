#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need fasterq-dump; sd_need fastqc; sd_need multiqc; sd_need seqkit; sd_need gzip
RAW="$SDUBLIN_WORKDIR/0.0-raw"
QC="$SDUBLIN_WORKDIR/0.1-rawqc"
mkdir -p "$RAW" "$QC"
ACCESSIONS="${SDUBLIN_ACCESSION_LIST:-$RAW/acclist.txt}"
sd_required_file "$ACCESSIONS"
while IFS= read -r accession || [[ -n "$accession" ]]; do
  accession="${accession//$'\r'/}"
  [[ -z "$accession" || "$accession" == \#* ]] && continue
  if [[ ! -s "$RAW/${accession}_1.fastq.gz" || ! -s "$RAW/${accession}_2.fastq.gz" ]]; then
    fasterq-dump "$accession" --split-files -O "$RAW"
    gzip -f "$RAW/${accession}_1.fastq" "$RAW/${accession}_2.fastq"
  fi
done < "$ACCESSIONS"
sd_glob "$RAW/*_1.fastq.gz"
fastqc "$RAW"/*.fastq.gz -o "$QC" -t "$SDUBLIN_THREADS"
multiqc "$QC" -o "$QC"
seqkit stats "$RAW"/*.fastq.gz -T > "$QC/rawstats.txt"
echo "[PASS] SRA retrieval and raw read QC: $QC"
