#!/bin/bash

# Input/output directories
INPUT_DIR="data/raw/FastqFiles"
OUTPUT_DIR="data/processed/trimmed"
ADAPTERS="TruSeq3-SE.fa"  # Make sure this adapter file is available

# Create output directory if not exists
mkdir -p "$OUTPUT_DIR"

# Loop through single-end FASTQ files
for file in "$INPUT_DIR"/*.fastq.gz; do
    base=$(basename "$file" .fastq.gz)
    echo "Trimming $base..."

    trimmomatic SE -threads 4 \
        "$file" \
        "$OUTPUT_DIR/${base}.trimmed.fastq.gz" \
        ILLUMINACLIP:"$ADAPTERS":2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

    echo "$base trimming done."
done

echo "All trimming completed."
