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
2. Read Trimming
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

- `FastQC`
- `Trim Galore`
- `STAR`
- `featureCounts` / `HTSeq`
- `DESeq2`
- `matplotlib`, `seaborn`, `ggplot2`

## Getting Started
git clone https://github.com/moji-2024/rna-seq-reanalysis.git

use chmod +x scriptName for files in script directory to make them excuteable.

Install required tools and libraries using:

```bash
conda env create -f environment.yml
