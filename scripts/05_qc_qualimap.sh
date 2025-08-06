#!/bin/bash

# Activate environment with qualimap
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate rnaseq-tools

# Set paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/../data/processed/bam_files"
OUTPUT_DIR="$SCRIPT_DIR/../results/qualimap_reports"

mkdir -p "$OUTPUT_DIR"

# Loop through all BAM files
for bam_file in "$INPUT_DIR"/*.bam; do
    sample=$(basename "$bam_file" .bam)
    echo "Running Qualimap on $sample..."

    qualimap bamqc \
        -bam "$bam_file" \
        -gtf "$GTF_FILE" \
        -outdir "$OUTPUT_DIR/$sample" \
        -outfile "${sample}_qualimap.pdf" \
        -outformat PDF:HTML
        -a proportional \
        -p strand-specific-reverse \
        --java-mem-size=8G

    echo "✔ Done: $sample"
done

echo "✅ All Qualimap reports saved to: $OUTPUT_DIR"
