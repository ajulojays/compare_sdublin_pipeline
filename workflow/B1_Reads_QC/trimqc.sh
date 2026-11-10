#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"
sd_need trimmomatic; sd_need fastqc; sd_need multiqc; sd_need seqkit
RAW="$SDUBLIN_WORKDIR/0.0-raw"
FIRST="$SDUBLIN_WORKDIR/1.0-trimmed/truseq_first_pass"
TR="$SDUBLIN_WORKDIR/1.0-trimmed"
QC="$SDUBLIN_WORKDIR/1.1-trimqc"
ADAPTER_DIR="${SDUBLIN_ADAPTER_DIR:-}"
[[ -n "$ADAPTER_DIR" ]] || sd_die "Set SDUBLIN_ADAPTER_DIR to the Trimmomatic adapters directory"
sd_required_file "$ADAPTER_DIR/TruSeq3-PE-2.fa"
sd_required_file "$ADAPTER_DIR/NexteraPE-PE.fa"
mkdir -p "$FIRST" "$TR" "$QC"
sd_glob "$RAW/*_1.fastq.gz"
for r1 in "$RAW"/*_1.fastq.gz; do
  id="${r1##*/}"; id="${id%_1.fastq.gz}"
  r2="$RAW/${id}_2.fastq.gz"; sd_required_file "$r2"
  trimmomatic PE -threads "$SDUBLIN_THREADS" "$r1" "$r2" \
    "$FIRST/${id}_1P.fq.gz" "$FIRST/${id}_1U.fq.gz" \
    "$FIRST/${id}_2P.fq.gz" "$FIRST/${id}_2U.fq.gz" \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
    "ILLUMINACLIP:$ADAPTER_DIR/TruSeq3-PE-2.fa:2:30:10"
  trimmomatic PE -threads "$SDUBLIN_THREADS" \
    "$FIRST/${id}_1P.fq.gz" "$FIRST/${id}_2P.fq.gz" \
    "$TR/${id}_1P.fq.gz" "$TR/${id}_1U.fq.gz" \
    "$TR/${id}_2P.fq.gz" "$TR/${id}_2U.fq.gz" \
    "ILLUMINACLIP:$ADAPTER_DIR/NexteraPE-PE.fa:2:30:10:2:True"
done
fastqc "$TR"/*P.fq.gz -o "$QC" -t "$SDUBLIN_THREADS"
multiqc "$QC" -o "$QC"
seqkit stats "$TR"/*.fq.gz -T > "$QC/trimstats.txt"
echo "[PASS] Two-pass Trimmomatic and trimmed-read QC: $TR"
