#!/bin/bash

# Define script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"

# Load conda
source ~/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq-tools

# Set paths
FASTQ_DIR="$DATA_DIR/processed/trimmed"
INDEX_DIR="$SCRIPT_DIR/../SalmonIndexes"
OUT_DIR="$DATA_DIR/processed/quant_results"
THREADS=8

# Create salmon index directory
mkdir -p "$INDEX_DIR"

# Download SA salmon index
URL=http://refgenomes.databio.org/v2/asset/hg38/salmon_partial_sa_index/archive?tag=default
wget --content-disposition -P "$INDEX_DIR" "$URL"
tar -xvzf $INDEX_DIR/salmon_partial_sa_index__default.tgz -C "$INDEX_DIR"

# Create output directory
mkdir -p "$OUT_DIR"
echo "Starting Salmon quantification..."

#-i: specify the location of the index directory; for us it is /n/groups/hbctraining/rna-seq_2023_02/salmon_index/
#-l A: Format string describing the library. A will automatically infer the most likely library type
#-r: sample file
#-o: output quantification file name
#--useVBOpt: use variational Bayesian EM algorithm rather than the ‘standard EM’ to optimize abundance estimates (more accurate)
#--seqBias will enable it to learn and correct for sequence-specific biases in the input data
#--validateMappings: developed for finding and scoring the potential mapping loci of a read by performing base-by-base alignment of the reads to the potential loci, scoring the loci, and removing loci falling below a threshold score. This option improves the sensitivity and specificity of the mapping.
#--gcBias: correct for GC-content bias in RNA-seq data.
#--numBootstraps: specifies computation of bootstrapped abundance estimates. Bootstraps are required for isoform level differential expression analysis for estimation of technical variance. Here, you can set the value to 30.

#✅ --validateMappings
#What it does: Verifies mappings with lightweight alignment.
#Benefit: Improves accuracy of read-to-transcript assignment.
#Cost: Slight increase in runtime.
#Safe to use? Absolutely. This is the default in many pipelines now.

#✅ --gcBias
#What it does: Corrects for bias from GC-content variation in transcripts, especially from random hexamer priming.
#Benefit: Makes quantification more accurate.
#Limitation: Only applies to single-end reads.
#Safe to use? Yes, but will be ignored in paired-end mode.

#✅ --seqBias
#What it does: Models sequence-specific bias (e.g., from priming, ligation).
#Benefit: Further improves transcript abundance estimates.
#Safe to use? Yes. No downside unless you're extremely constrained on compute.

#✅ --useVBOpt
#What it does: Uses variational Bayesian optimization instead of EM for abundance estimation.
#Benefit: Adds regularization, which helps with ambiguous mapping.
#Safe to use? Yes. Preferred when dealing with noisy or complex data.

#✅ --numBootstraps N → performs N bootstrap replicates. Common choices: 30–100.
#Bootstraps generate extra files in the output folder: aux_info/bootstraps/. Each bootstrap contains transcript-level counts.
#More bootstraps → better estimates of technical variance, but slower runtime and slightly more disk usage.


# Detect and run single-end (only if _2 pair not found)
for fastqFile in "$FASTQ_DIR"/*.fastq.gz; do
    sample=$(basename "$fastqFile" .fastq.gz)
    echo "$OUT_DIR/$sample"
    salmon quant \
        -i "$INDEX_DIR/salmon_partial_sa_index" \
        -l U \
        -r "$fastqFile" \
        -p "$THREADS" \
        -o "$OUT_DIR/$sample" \
        --validateMappings \
        --gcBias \
	--seqBias \
        --useVBOpt
done

echo "✅ All samples processed. Output location: $OUT_DIR"
