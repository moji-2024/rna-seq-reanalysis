#!/bin/bash

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUANT_DIR="$SCRIPT_DIR/../data/processed/quant_results"
OUTPUT_DIR="$SCRIPT_DIR/../data/processed/DataForDeseq2"
mkdir -p $OUTPUT_DIR

echo "Creating Sample file for deseq2 ..."

echo "" > $OUTPUT_DIR/SampleExperimentInfo.csv
echo "sample,condition,file" >> $OUTPUT_DIR/SampleExperimentInfo.csv
for file in $(ls $QUANT_DIR); do
condition=$(echo $file | grep -Po "(?<=_)\w+(?=_)")
path=$(echo "$QUANT_DIR/$file/quant.sf" | sed "s:scripts/../::1")
row="$file,$condition,$path"
echo $row >> $OUTPUT_DIR/SampleExperimentInfo.csv
done
cat $OUTPUT_DIR/SampleExperimentInfo.csv
