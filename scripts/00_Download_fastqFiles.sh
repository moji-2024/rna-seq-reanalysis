#!/bin/bash

mkdir -p data/raw/FastqFiles
# Run wget to each url in Fast_urls.txt
for url in $(cat data/raw/Fastq_urls.txt) ;do
echo "Processing $url..." ;
wget -P ../data/raw/FastqFiles/ $url;

# Extract basename (filename only)
file_name=$(basename "$url")
# Extract SRR ID from filename
BaseName=$(echo "$file_name" | grep -Eo "SRR[0-9]+")
if [ "$BaseName" == "SRR13633855" ]; then
  mv ../data/raw/FastqFiles/$file_name ../data/raw/FastqFiles/WT$file_name
elif [ "$BaseName" == "SRR13633856" ]; then
  mv ../data/raw/FastqFiles/$file_name ../data/raw/FastqFiles/WT$file_name
else
  mv ../data/raw/FastqFiles/$file_name ../data/raw/FastqFiles/KO$file_name
fi

done ;
echo "all data is ready"
