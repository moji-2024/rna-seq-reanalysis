#!/bin/bash

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p $SCRIPT_DIR/../GenomeIndexes
cd $SCRIPT_DIR/../GenomeIndexes
echo "Processing $url..." ;
wget -c -P "$INPUT_and_OUTPUT_DIR" "https://genome-idx.s3.amazonaws.com/hisat/grch38_tran.tar.gz"
echo "Indexes are located in $SCRIPT_DIR/../GenomeIndexes"
tar -xzvf $SCRIPT_DIR/../GenomeIndexes/*.tar.gz
rm grch38_tran/make_grch38_tran.sh
echo "all data is ready
