#!/bin/bash
# Usage: ./run_qualimap.sh input.bam annotation.gtf output_dir
source ~/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq-tools

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"
BAM_FILE_DIR="$DATA_DIR/processed/align"
GTF_FILE="$DATA_DIR/raw/GenomeFASTA_and_AnnotationGTF/edited_Homo_sapiens.GRCh38.84.gtf"
OUT_DIR="$SCRIPT_DIR/../results/qualimap_results"

# Make sure output directory exists
mkdir -p "$OUT_DIR"
for bam_file in $BAM_FILE_DIR/*.bam ; do
   BAM_BASENAME="$(basename $bam_file .sorted.bam)"
   OUTPUT_PATH="$OUT_DIR/${BAM_BASENAME}_sorted_bam_qualimap"
   mkdir -p $OUTPUT_PATH
   echo "processing Sample: $BAM_BASENAME"
   qualimap rnaseq \
	-bam "$bam_file" \
	-gtf "$GTF_FILE" \
	-outdir "$OUTPUT_PATH" \
	-outformat HTML \
	-a proportional \
	-p non-strand-specific \
	--java-mem-size=12G
  echo "Finish process Sample: $BAM_BASENAME"
done
echo "qualimap data for rnaseq is ready in $OUT_DIR"
