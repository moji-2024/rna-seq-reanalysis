#!/bin/bash

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SALMON_GTF_DIR="$SCRIPT_DIR/../data/raw/GTF_align_with_salmon_partial_sa_index"
OUTPUT_DIR="$SCRIPT_DIR/../data/processed/DataForDeseq2"

echo "Creating Make Gene Id Table File For Deseq2..."

mkdir -p $OUTPUT_DIR $SALMON_GTF_DIR
# download right SALMON_annotation.gtf to align with salmon quant.sf in tximport
URL="http://awspds.refgenie.databio.org/refgenomes.databio.org/2230c535660fb4774114bfa966a62f823fdb6d21acf138d4/ensembl_gtf__default/2230c535660fb4774114bfa966a62f823fdb6d21acf138d4.gtf.gz"
wget -P "$SALMON_GTF_DIR" "$URL"
mv $SALMON_GTF_DIR/2230c535660fb4774114bfa966a62f823fdb6d21acf138d4.gtf.gz $SALMON_GTF_DIR/SALMON_annotation.gtf.gz
gunzip $SALMON_GTF_DIR/SALMON_annotation.gtf.gz

# extract transcriptID and geneID from downloaded file
gawk -F'\t' '$3=="transcript" {
  if (match($9,/gene_id "([^"]+)"/,geneID) && match($9,/transcript_id "([^"]+)"/,transcriptID)) {
    match($9,/gene_name "([^"]+)"/,geneName)
    OFS=","
    print transcriptID[1], geneID[1], geneName[1]
  }
}' $SALMON_GTF_DIR/SALMON_annotation.gtf > $OUTPUT_DIR/transcriptID_GeneID_GeneName.csv

sed -i '1iTranscriptID,GeneID,GeneName' $OUTPUT_DIR/transcriptID_GeneID_GeneName.csv
cut -d ',' -f 1,2 $OUTPUT_DIR/transcriptID_GeneID_GeneName.csv > $OUTPUT_DIR/transcriptID_GeneID.csv

head $OUTPUT_DIR/transcriptID_GeneID_GeneName.csv
head $OUTPUT_DIR/transcriptID_GeneID.csv
echo "Data is located in $OUTPUT_DIR"
