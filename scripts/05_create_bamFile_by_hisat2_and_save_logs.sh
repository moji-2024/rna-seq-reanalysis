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
SS="$DATA_DIR/processed/raw/hints_for_spliced_alignment_DIR/splice_sites.txt"
# folder with trimmed FASTQs
FASTQ_DIR="$DATA_DIR/processed/trimmed"
ALIGN_DIR="$DATA_DIR/processed/aligned"
LOG_DIR="$DATA_DIR/processed/Bam_related_logs"
mkdir -p $ALIGN_DIR $LOG_DIR


    # ----------------------------
    # Read group (RG) flags explained:
    # ----------------------------
    # --rg-id $sample    : Assigns a unique Read Group ID for this run. 
    #                      Each sample should have its own ID to distinguish data sources.
    #
    # --rg SM:$sample    : Sets the "Sample" (SM) field. This tags all reads as belonging 
    #                      to a particular biological sample. Critical for multi-sample analysis.
    #
    # --rg PL:BGISEQ     : Sets the "Platform" (PL) field to BGISEQ, identifying the 
    #                      sequencing technology (e.g., ILLUMINA, BGISEQ, IONTORRENT).
    #
    # Why this matters:
    # Many downstream tools (e.g., samtools, GATK, RNA-seq QC tools) rely on read group
    # information to track which reads came from which sample or sequencing platform.
    # Without proper RG tags, joint analysis of multiple samples can fail or produce errors.
#Those flags are adding read group (RG) metadata into the BAM file headers during alignment.

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
