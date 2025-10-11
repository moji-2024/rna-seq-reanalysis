# RNA-seq Reanalysis
This repository contains a reproducible pipeline for reanalyzing RNA-seq data from FASTQ to differential expression and visualization.

## Goals
- Reproduce the authors' RNA-seq results
- Update tools and annotations
- Improve visualizations and downstream interpretation
- Compare outcomes between original and new pipelines

## Workflow
0. Download requirements
1. Download fastq files
2. Quality Control
3. Trimming
4. Alignment
5. Gene Quantification
6. Differential Expression
7. Functional Enrichment
8. Visualization & Reporting

## Structure
- `data/`: raw and processed input files (FASTQ, BAM, counts)
- `scripts/`: stepwise scripts for QC, trimming, alignment, quantification, DE analysis
- `results/`: output tables and plots
- `workflow/`: pipeline file
- `GenomeIndexes/`: hisat2 indexes

## Tools Used
- `samtools version 1.10`
- `fastqc version v0.11.9`
- `fastp version 0.22.0`
- `HISAT2 version 2.2.1 `
- `featureCounts` / `HTSeq`
- `DESeq2`
- `matplotlib`, `seaborn`, `ggplot2`

###  Install Required Tools and Libraries
```bash
mkdir -p Tools
cd Tools
```
####  Install **FastQC**:
```bash
sudo apt update
sudo apt install openjdk-11-jre
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
cd FastQC
chmod +x fastqc
sudo cp fastqc /usr/local/bin/
```
####  Install **hisat2**:
```bash
wget https://cloud.biohpc.swmed.edu/index.php/s/hisat2-220/download -O hisat2-2.2.1-Linux_x86_64.zip
unzip hisat2-2.2.1-Linux_x86_64.zip
cd hisat2-2.2.1
chmod +x hisat2*
```
####  Install **samtools**:
```bash
wget https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2
tar -xvjf samtools-1.10.tar.bz2
cd samtools-1.10
./configure --prefix=/usr/local
make
sudo make install
```


### install requaired tools on conda:
```bash
cd ~
wget https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-Linux-x86_64.sh
bash Miniforge3-24.11.3-2-Linux-x86_64.sh

conda create -n rnaseq-tools fastp=0.22.0 qualimap=2.2.2a rseqc=5.0.1 gxf2bed=0.2.7 multiqc=1.30 bedtools mashmap -c conda-forge -c bioconda -c defaults -y
conda create -n rnaseq-tools2 -y -c conda-forge -c bioconda \
  r-base=4.3.* \
  r-readr r-dplyr r-ggplot2 r-tibble r-stringr r-matrix r-mass r-jsonlite \
  bioconductor-biocparallel \
  bioconductor-deseq2=1.40.* \
  bioconductor-tximport=1.30.* \
  bioconductor-apeglm=1.22.* \
  bioconductor-summarizedexperiment=1.30.* \
  bioconductor-delayedarray=0.26.* \
  bioconductor-s4arrays=1.0.* \
  bioconductor-sparsearray=1.0.*
```
## Getting Started
#Run below codes in your terminal:
cd ~
git clone https://github.com/moji-2024/rna-seq-reanalysis.git
cd rna-seq-reanalysis/scripts
#Run chmod +x scriptName on files inside the scripts/ folder to give them executable permission.
for file in *; do chmod +x $file ; done
Run scripts in order

