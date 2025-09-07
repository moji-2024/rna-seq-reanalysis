1. Prepare Reference Files
What happens: Download the reference annotation (GTF) and genome sequence (FASTA). From the GTF file, splice sites and exon information are extracted. These hints improve the accuracy of spliced alignment.
Script: scripts/03_download_and_extract_FASTA_and_GTF_then_create_hints_for_spliced_alignment.sh

2. Download HISAT2 Index
What happens: Prebuilt HISAT2 index files are downloaded and extracted. The index is stored in the GenomeIndexes directory for efficient read alignment.
Script: scripts/04_download_and_extract_Hisat2IndexFiles_and_put_them_in_GenomeIndexes.sh

3. Align Reads to the Reference Genome
What happens: Quality-trimmed FASTQ files are aligned to the reference genome using HISAT2. The alignments are converted into sorted BAM files, and logs are saved for reproducibility and troubleshooting.
Script: scripts/05_create_bamFile_by_hisat2_and_save_logs.sh

4. Gene Quantification (Next Step)

What happens: After alignment, the next stage is quantifying gene expression. This involves counting reads mapped to each gene using the aligned BAM files and the reference annotation.
