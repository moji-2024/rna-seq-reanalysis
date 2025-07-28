#!/bin/bash

mkdir -p data/raw/FastqFiles
# Run wget to each url in Fast_urls.txt
for url in $(cat data/raw/Fastq_urls.txt) ;do 
echo "Processing $url..." ;
wget -P /data/raw/FastqFiles/ $url;
doen
echo "all data is ready"
