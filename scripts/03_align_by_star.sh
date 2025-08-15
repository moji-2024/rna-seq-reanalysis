STAR --runThreadN 4 \
     --genomeDir genome_index/ \
     --readFilesIn data/raw/FastqFiles/WT_SRR13633855.fastq.gz \
     --readFilesCommand zcat \
     --outFileNamePrefix alignments/WT_SRR13633855_ \
     --outSAMtype BAM SortedByCoordinate

