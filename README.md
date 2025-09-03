# RNA-seq Reanalysis
This repository contains a reproducible pipeline for reanalyzing RNA-seq data from FASTQ to differential expression and visualization.

## Goals
- Reproduce the authors' RNA-seq results
- Update tools and annotations
- Improve visualizations and downstream interpretation
- Compare outcomes between original and new pipelines

## Workflow
0. Download fastq files
1. Quality Control
2. Trimming
3. Alignment
4. Gene Quantification
5. Differential Expression
6. Functional Enrichment
7. Visualization & Reporting

## Structure
- `data/`: raw and processed input files (FASTQ, BAM, counts)
- `scripts/`: stepwise scripts for QC, trimming, alignment, quantification, DE analysis
- `results/`: output tables and plots
- `workflow/`: Snakemake pipeline file
- `notebooks/`: optional exploration or reports

## Tools Used
- `fastqc version v0.11.9`
- `Trim Galore`
- `HISAT2 version 2.2.1 `
- `featureCounts` / `HTSeq`
- `DESeq2`
- `matplotlib`, `seaborn`, `ggplot2`

## Getting Started
#Run below codes in your terminal:
git clone https://github.com/moji-2024/rna-seq-reanalysis.git
cd rna-seq-reanalysis/scripts

#Run chmod +x scriptName on files inside the scripts/ folder to give them executable permission.
for file in *; do chmod +x $file ; done

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
####  Install **FastQC**:
```bash
wget https://cloud.biohpc.swmed.edu/index.php/s/hisat2-220/download -O hisat2-2.2.1-Linux_x86_64.zip
unzip hisat2-2.2.1-Linux_x86_64.zip
cd hisat2-2.2.1
chmod +x hisat2*
```
### install fastp on conda:
```bash
wget https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-Linux-x86_64.sh
bash Miniforge3-24.11.3-2-Linux-x86_64.sh

conda create -n rnaseq-tools fastp star qualimap samtools -c bioconda -y
```


