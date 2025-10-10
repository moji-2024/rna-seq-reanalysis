txi object structure
`names(txi)
# [1] "abundance" "counts" "length" "countsFromAbundance"`

## 1. abundance

-  Gene-level normalized abundance estimates.

-  For Salmon, this is TPM (Transcripts Per Million), aggregated across all transcripts of a gene using your tx2gene mapping.

-  Good for visualization or reporting expression levels, but not used directly by DESeq2.

## 2. counts

-  Gene-level estimated counts (aggregated NumReads from transcripts → genes).

-  This is the matrix DESeq2 acespt as input for differential expression analysis.

-  Units: counts (can be fractional, because transcript-level reads may be split across isoforms).

## 3. length

-  Gene-level average transcript length, used for normalization.

-  Calculated as a weighted average of transcript lengths (weights = transcript abundance).

-  the length value for each gene is not just a raw transcript length, but an **abundance-weighted average** of all its transcripts. This way, the effective gene length reflects the isoforms that actually contribute most of the reads, making normalization fair across genes.
-  An abundance-weighted average means each transcript’s length contributes to the gene’s average length in proportion to how much that transcript is expressed.
-  **Example:** If a short isoform makes up 90% of the abundance, the average gene length will be close to that short transcript’s length.
-  Used internally by DESeq2/edgeR if you want length-scaled normalization or effective gene lengths.

## 4. countsFromAbundance

-  A metadata flag that tells you how counts were derived from the transcript abundance.

-  Options:

  -  "no" → counts are the raw estimated counts from Salmon.

  -  "scaledTPM" → counts were back-calculated from TPMs, scaled to library size.

  -  "lengthScaledTPM" → counts adjusted using average transcript lengths (recommended for DESeq2).

  -  "dtuScaledTPM" → adjusted further for isoform switching (differential transcript usage).

This choice matters: it controls whether you want your counts corrected for transcript length bias.

For DESeq2 gene-level DE: "lengthScaledTPM" is often recommended.

For isoform-level analysis: "no" or "dtuScaledTPM" may be preferred.
