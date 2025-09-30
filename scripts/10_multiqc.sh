#!/bin/bash

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROC_DIR="$SCRIPT_DIR/../data/processed"
OUT_DIR="$SCRIPT_DIR/../results/multiqc_results"
mkdir -p "$OUT_DIR"
# Load conda
source ~/miniconda3/etc/profile.d/conda.sh
conda activate report-env
# (Optional) Quick sanity checks
grep -R "overall alignment rate" -n "$PROC_DIR/Bam_related_logs" || true
for b in "$PROC_DIR/aligned"/*.sorted.bam; do [[ -f "${b}.bai" ]] || echo "Missing index: $b"; done

# MultiQC aggregation
multiqc "$PROC_DIR" -o "$OUT_DIR" -n "multiqc_$(date +%Y%m%d).html" --dirs-depth 3 --force
echo "MultiQC report: $OUT_DIR/multiqc_$(date +%Y%m%d).html"
