Why Salmon?

For transcript quantification in RNA-seq, Salmon is one of the most widely used tools because it is:

Fast: Lightweight mapping with selective alignment avoids the overhead of full aligners.

Accurate: Bias correction options (--seqBias, --gcBias, --validateMappings) improve transcript abundance estimates.

Resource-friendly: Uses less CPU and memory than full genome alignments.

Well-supported: Compatible with common downstream tools such as tximport (R), DESeq2, and edgeR.

In my case study (GEO: GSE166219
, BioProject PRJNA699603), the dataset consists of human HT-29 cell line mRNA sequencing runs. Salmon was the right choice to rapidly quantify transcripts and prepare the data for gene-level differential expression analysis.

Why the partial selective-alignment index?

Salmon supports two flavors of the selective alignment (SA) index:

Full SA index (~16 GB): includes the entire genome as decoy sequences. Maximizes accuracy but heavy on RAM and disk.

Partial SA index (~2.5 GB): includes transcriptome plus only the genomic regions most likely to cause mis-mapping (generated using the gentrome/decoy method
).

For this study, I selected the partial SA index because:

The dataset is bulk RNA-seq with standard read lengths.

The goal is gene-level expression analysis, not ultra-fine isoform disambiguation.

The partial index is lighter, faster, and accurate enough for typical mRNA profiling tasks.

Saves significant computational resources while retaining robust quantification.

What Salmon produced

Running salmon quant on each sample created a directory (one per sample) containing key outputs:

quant.sf – main table of transcript IDs with TPM, estimated counts, and effective lengths.

libParams – inferred library type information.

cmd_info.json – record of parameters used.

Bootstrap files (if enabled) – quantify technical variance at the transcript level.

These outputs provide transcript-level abundance estimates across all samples.

How the results are used downstream

The raw quant.sf tables are not the end goal. They feed into downstream analysis steps, typically via tximport in R, which aggregates transcript-level estimates into gene-level counts. From there, the quantification results can be used for:

Differential expression analysis (e.g., DESeq2, edgeR).

Pathway enrichment and functional annotation (GO, KEGG).

Visualization of expression profiles (heatmaps, PCA, volcano plots).

Integration with metadata (treatments, conditions) to draw biological conclusions.

Summary

Chose Salmon for fast, accurate, and bias-aware transcript quantification.

Used the partial SA index for efficiency and sufficient accuracy in a bulk RNA-seq context.

Obtained transcript abundance estimates (quant.sf) that serve as the foundation for gene-level analysis and biological interpretation.

This step bridges the raw sequencing reads to meaningful expression values, enabling downstream discovery.
