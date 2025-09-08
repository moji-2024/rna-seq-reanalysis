1. Prepare Reference Files
What happens: Download the reference annotation (GTF) and genome sequence (FASTA). From the GTF file, splice sites and exon information are extracted. These hints improve the accuracy of spliced alignment.
Script: scripts/03_download_and_extract_FASTA_and_GTF_then_create_hints_for_spliced_alignment.sh

2. Download HISAT2 Index
What happens: Prebuilt HISAT2 index files are downloaded and extracted. The index is stored in the GenomeIndexes directory for efficient read alignment.
Script: scripts/04_download_and_extract_Hisat2IndexFiles_and_put_them_in_GenomeIndexes.sh

3. Align Reads to the Reference Genome
What happens: Quality-trimmed FASTQ files are aligned to the reference genome using HISAT2. The alignments are converted into sorted BAM files, and logs are saved for reproducibility and troubleshooting.
Script: scripts/05_create_bamFile_by_hisat2_and_save_logs.sh

4. check function of hisat2
What happens: After alignment, logs of hisat2 used for visualization to show its performance.
Script: 06_hisat2_piechartCreater.py

6. Gene Quantification (Next Step)

What happens: After alignment, the next stage is quantifying gene expression. This involves counting reads mapped to each gene using the aligned BAM files and the reference annotation.

Alignment Results

Across all samples, the alignment quality was very high. According to the HISAT2 logs, most reads mapped uniquely to the reference genome, with only a small fraction unmapped or multi-mapped. The flagstat logs confirmed the presence of secondary alignments, which are expected in RNA-seq data, but no duplicates or paired-end reads were reported. The “+ 0” entries in the flagstat output results indicate that no reads were flagged as failed during QC. Together, these results confirm the dataset is clean, single-end, and suitable for downstream gene quantification.
