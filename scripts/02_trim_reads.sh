#!/bin/bash

# Initialize conda and activate environment
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate rnaseq-tools

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"

INPUT_DIR="$DATA_DIR/raw/FastqFiles"
OUTPUT_TRIMMED_DIR="$DATA_DIR/processed/trimmed"
OUTPUT_HTML_REPORT_DIR="$DATA_DIR/processed/trimmed_report"

# make output directories
mkdir -p "$OUTPUT_TRIMMED_DIR"
mkdir -p "$OUTPUT_HTML_REPORT_DIR"


# Loop through single-end FASTQ files
for file in "$INPUT_DIR"/*.fastq.gz; do
    base_name=$(basename "$file" .fastq.gz)
    echo "Trimming $base_name..."
    fastp \
    -i "$file" \
    -o "$OUTPUT_TRIMMED_DIR/trimmed_${base_name}.fastq.gz" \
    --qualified_quality_phred 28 \
    --unqualified_percent_limit 40 \
    --length_required 40 \
    --cut_mean_quality 20 \
    --cut_front \
    --cut_tail \
    --cut_right \
    -h "$OUTPUT_HTML_REPORT_DIR/${base_name}.html" \
    -j "$OUTPUT_HTML_REPORT_DIR/${base_name}.json"
done
echo "All trimming completed."
echo "Trimmed FASTQ files are in:     $OUTPUT_TRIMMED_DIR"
echo "Fastp HTML/JSON reports are in: $OUTPUT_HTML_REPORT_DIR"
