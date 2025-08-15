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
echo "all data is ready"
