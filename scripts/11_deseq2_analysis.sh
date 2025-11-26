#!/bin/bash
# load conda & install packages
source ~/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq-tools2


# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DataForDeseq2_DIR="$SCRIPT_DIR/../data/processed/DataForDeseq2"
export OUT_DIR="$SCRIPT_DIR/../data/processed/normalCountByDeseq2_DIR"
mkdir -p "$OUT_DIR"
echo "process MakeGeneIdTableFileForDeseq2"
$SCRIPT_DIR/MakeGeneIdTableFileForDeseq2.sh
echo "process MakeSampleFileForDeseq2"
$SCRIPT_DIR/MakeSampleFileForDeseq2.sh

Rscript - <<EOF
library(DESeq2)
library(tximport)
samples <- read.csv(paste0("$DataForDeseq2_DIR" , "/SampleExperimentInfo.csv"))
files <- setNames(samples[['file']], samples[['sample']])

# load two columns: transcript ID, gene ID
tx2gene <- read.csv(paste0("$DataForDeseq2_DIR", "/transcriptID_GeneID.csv"))
# load experiment info
coldata <- read.csv(paste0("$DataForDeseq2_DIR" , "/coldataForDesign.csv"), row.names = 1,stringsAsFactors = FALSE)
# convert counts from transcript level to gene level
txi <- tximport(files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion=T, countsFromAbundance = "lengthScaledTPM")
# head(txi[['counts']])
# align order txi column names with coldata row names
coldata <- coldata[colnames(txi[['counts']]), ]
# create DESeq object by subclone column in coldata(data frame) assuming replicates are biological
dds <- DESeqDataSetFromTximport(txi, colData = coldata, design = ~subclone)
# make sure subcolon WT consider as control
dds[['subclone']] = relevel(dds[['subclone']], ref = "WT")
# 1- Estimate Size Factors
# Adjusts for differences in sequencing depth across samples so counts are comparable.
# 2- Estimate Dispersions
# Models the variability of gene expression across replicates. This is crucial for statistical testing.
# 3- Fit Negative Binomial GLM
# Fits a generalized linear model for each gene using the design formula (e.g., ~ Condition).
# 4- Wald Test or Likelihood Ratio Test
# Performs statistical tests to identify genes with significant changes in expression between conditions.
# 5- Stores Results Internally
# The dds object now contains all model fits, dispersions, and test statistics — ready for downstream analysis.
dds <- DESeq(dds)
# get variance-stabilized transformed (VST) values
vsd <- vst(dds, blind = FALSE)
# VST values are:

#       Log-like numbers (similar to log2 counts)

#       Normalized for library size

#       Variance stabilized (low-count genes get adjusted)

#       Continuous values, not integers
# VST usage:
#       for PCA, heatmaps, clustering, correlation analysis, not for differential expression testing.
expr <- assay(vsd)
write.csv(expr, file =  file.path("$OUT_DIR", "vsd_expression_matrix.csv"))
# create normalize counts table by deseq2
NormalizedTableByDeseq2 = counts(estimateSizeFactors(dds),normalized=T)
write.csv(as.data.frame(NormalizedTableByDeseq2),
          file = file.path("$OUT_DIR", "NormalizedTableByDeseq2.csv"),
          row.names = TRUE)
# create results
# 1️⃣ WT vs KO1
res_KO1 <- results(dds, contrast = c("subclone", "KO1", "WT"))
write.csv(as.data.frame(res_KO1),
          file = file.path("$OUT_DIR", "RESULT_DESeq2_WT_vs_KO1.csv"),
          row.names = TRUE)

# 2️⃣ WT vs KO2
res_KO2 <- results(dds, contrast = c("subclone", "KO2", "WT"))
write.csv(as.data.frame(res_KO2),
          file = file.path("$OUT_DIR", "RESULT_DESeq2_WT_vs_KO2.csv"),
          row.names = TRUE)
cat("\n\n\nCount results:\n")
head(res_KO2)
head(res_KO1)
# quick summary
sink(file.path("$OUT_DIR", "DESeq2_summary_result_KO1.txt"))
summary(res_KO1)
sink()

sink(file.path("$OUT_DIR", "DESeq2_summary_result_KO2.txt"))
summary(res_KO2)
sink()

summary(res_KO1)
summary(res_KO2)
EOF
echo "normal count data is located in $OUT_DIR"
#Note about tximport: countsFromAbundance = "lengthScaledTPM" means ;
#counts adjusted using average transcript lengths (recommended for DESeq2).

# Note1 about transcript mismatches:
# - The `salmon_partial_sa_index` is not a full transcriptome index.
# - It is a partial selective-alignment index that only includes a subset
#   of transcripts (e.g., canonical or collapsed sequences).
#
# - The matching `ensembl_gtf` file, however, contains the full Ensembl
#   annotation with all transcripts and all biotypes.
#   Therefore, when building tx2gene from the GTF, we get more transcript IDs
#   than Salmon actually used. These extra IDs in tx2gene will not be present
#   in the quant.sf files, which leads to the "transcripts missing from tx2gene"
#   message in tximport.

# Note2:
# - tximport result has 4 attributes in which formats of abundance, counts, and length is matrix. keep in mind if you wish change them,
#   because it result in DESeqDataSetFromTximport must preseved the format.
