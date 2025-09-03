#!/bin/bash

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"
# ----------------------------
# Config
# ----------------------------
THREADS=8
# path to HISAT2 index prefix
IDX=$SCRIPT_DIR/../GenomeIndexes/grch38_tran/genome_tran
# path to splice sites file
SS="$DATA_DIR/raw/hints_for_spliced_alignment_DIR/splice_sites.txt"
# folder with trimmed FASTQs
FASTQ_DIR="$DATA_DIR/processed/trimmed"
ALIGN_DIR="$DATA_DIR/processed/align"
LOG_DIR="$DATA_DIR/processed/logs"
mkdir -p $ALIGN_DIR $LOG_DIR

PATH_hisat2=~/Tools/hisat2-2.2.1
# ----------------------------
# Loop over FASTQ files
# ----------------------------
for R1 in ${FASTQ_DIR}/*.fastq.gz; do
    sample=$(basename "$R1" .fastq.gz)
    mkdir -p ${LOG_DIR}/logs_$sample
    echo ">>> Processing sample: $sample"

    # Align and create sorted BAM
    $PATH_hisat2/hisat2 -p $THREADS \
	--add-chrname \
        --dta \
        --known-splicesite-infile $SS \
        -x $IDX \
        -U $R1 \
        --rg-id $sample --rg SM:$sample --rg PL:BGISEQ \
        2> ${LOG_DIR}/logs_$sample/${sample}.hisat2.log \
    | samtools view -@ $THREADS -bS - \
    | samtools sort -@ $THREADS -o ${ALIGN_DIR}/${sample}.sorted.bam
    echo "samtool processing"
    # Index BAM
    samtools index ${ALIGN_DIR}/${sample}.sorted.bam

    # QC reports
    samtools flagstat ${ALIGN_DIR}/${sample}.sorted.bam > ${LOG_DIR}/logs_$sample/${sample}.flagstat.txt
    samtools stats ${ALIGN_DIR}/${sample}.sorted.bam > ${LOG_DIR}/logs_$sample/${sample}.samstats.txt

    echo ">>> Finished sample: $sample"
done

echo "All samples processed. BAMs in $ALIGN_DIR, logs in $LOG_DIR"

