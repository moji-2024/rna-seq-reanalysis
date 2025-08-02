#!/bin/bash

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data/raw/"

INPUT_DIR="$DATA_DIR/FastqFiles"
OUTPUT_DIR="$SCRIPT_DIR/../results/plots/fastqc_results"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run FastQC on all .fastq and .fastq.gz files
echo "Running FastQC on files in $INPUT_DIR..."

for file in "$INPUT_DIR"/*.fastq*; do
    echo "Processing $file..."
    fastqc -o "$OUTPUT_DIR" "$file"
done

echo "FastQC analysis completed. Results saved in $OUTPUT_DIR."
