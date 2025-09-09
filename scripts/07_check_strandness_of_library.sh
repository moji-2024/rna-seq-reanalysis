#!/bin/bash
source ~/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq-tools

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"
FirstBamFile_PATH="$DATA_DIR/processed/align/trimmed_KO_SRR13633857.sorted.bam"
GTF_PATH="$DATA_DIR/raw/GenomeFASTA_and_AnnotationGTF/gencode.v36.primary_assembly.annotation.gtf"
BED_DIR="$DATA_DIR/processed/BED_DIR"
RESULT="$SCRIPT_DIR/../results/texts/strandness"
mkdir -p $RESULT
mkdir -p $BED_DIR
gxf2bed -i $GTF_PATH -o "$BED_DIR/gencode.v36.exons.bed"
infer_experiment.py -r "$BED_DIR/gencode.v36.exons.bed" -i $FirstBamFile_PATH > "$RESULT/library_info.txt"
