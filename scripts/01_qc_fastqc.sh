#!/bin/bash

# Define input and output directories
INPUT_DIR="data/raw"
OUTPUT_DIR="data/processed/fastqc_results"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run FastQC on all .fastq and .fastq.gz files
echo "Running FastQC on files in $INPUT_DIR..."

for file in "$INPUT_DIR"/*.fastq*; do
    echo "Processing $file..."
    fastqc -o "$OUTPUT_DIR" "$file"
done

echo "FastQC analysis completed. Results saved in $OUTPUT_DIR."
