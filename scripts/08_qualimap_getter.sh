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
# ------------------------------
# Input / Output
# ------------------------------

# -bam "$bam_file"
#   Input BAM file containing aligned RNA-seq reads.

# -gtf "$GTF_FILE"
#   Reference annotation file in GTF format.

# -outdir "$OUTPUT_PATH"
#   Directory where Qualimap results will be stored.

# -outformat HTML
#   Output report format: generates an interactive HTML report.

# ------------------------------
# Analysis settings
# ------------------------------

# -a proportional
#   Normalization method. "proportional" normalizes read counts per base 
#   across features, accounting for gene length.

# -p non-strand-specific
#   Protocol type. Specifies that the RNA-seq library is non-strand-specific, 
#   so reads are not assigned to a particular strand.

# ------------------------------
# Resource settings
# ------------------------------

# --java-mem-size=12G
#   Allocate 12 GB of memory for the Java virtual machine, important for 
#   handling large BAM files efficiently.

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
