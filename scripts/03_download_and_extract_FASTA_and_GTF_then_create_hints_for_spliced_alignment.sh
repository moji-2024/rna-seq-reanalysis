#!/bin/bash

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data/raw"

INPUT_and_OUTPUT_DIR="$DATA_DIR/GenomeFASTA_and_AnnotationGTF"
for url in $(cat "$INPUT_and_OUTPUT_DIR/links.txt") ;do
echo "Processing $url..." ;
 wget -c -P "$INPUT_and_OUTPUT_DIR" "$url"
echo "data is located in $INPUT_and_OUTPUT_DIR"
done
gunzip $INPUT_and_OUTPUT_DIR/*.gz
# create hints_for_spliced_alignment files
mkdir -p "$DATA_DIR/hints_for_spliced_alignment_DIR"
PATH_hisat2=~/Tools/hisat2-2.2.1
echo "$INPUT_and_OUTPUT_DIR/*.gtf"
$PATH_hisat2/hisat2_extract_splice_sites.py $INPUT_and_OUTPUT_DIR/*.gtf > "$DATA_DIR/hints_for_spliced_alignment_DIR/splice_sites.txt"
$PATH_hisat2/hisat2_extract_exons.py $INPUT_and_OUTPUT_DIR/*.gtf > "$DATA_DIR/hints_for_spliced_alignment_DIR/exons.txt"
echo "hints_for_spliced_alignment files located in $DATA_DIR/hints_for_spliced_alignment_DIR"
echo "all data is ready"

