#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data/raw"
FASTQ_DIR="$DATA_DIR/FastqFiles"

mkdir -p "$FASTQ_DIR"
# Run wget to each url in Fast_urls.txt
for url in $(cat "$DATA_DIR/Fastq_urls.txt") ;do
echo "Processing $url..." ;
 wget -c -P "$FASTQ_DIR" "$url"

# Extract basename (filename only)
file_name=$(basename "$url")
# Extract SRR ID from filename
BaseName=$(echo "$file_name" | grep -Eo "SRR[0-9]+")
    if [ "$base_name" == "SRR13633855" ] || [ "$base_name" == "SRR13633856" ]; then
        mv "$FASTQ_DIR/$file_name" "$FASTQ_DIR/WT_$file_name"
    else
        mv "$FASTQ_DIR/$file_name" "$FASTQ_DIR/KO_$file_name"
    fi
done
echo "all data is ready"
