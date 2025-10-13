# 1) txi object structure

names(txi)
`[1] "abundance" "counts" "length" "countsFromAbundance"`

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

# 2) DESeq2 

## Design formula

In DESeq2, the **design formula** tells R what explains the differences in gene expression.
Example: **design = ~ condition** means “find genes whose expression changes with condition.”
if there’s another source of variation, like batch, subclone, or sex, you must include it: **design = ~ batch + condition**
→ This way, DESeq2 first removes batch effects, then tests condition.

## The purpose of design
In DESeq2, (**dds <- DESeqDataSetFromTximport(txi, colData = coldata, design = ~ ...)**) the **design formula** tells DESeq2 what factor(s) explain expression differences between samples.
It determines which comparisons (contrasts; Example: WT vers KO), DESeq2 makes and how it accounts for unwanted variation.
## The logic of factors
Each column in  **colData** table describes an experimental variable:
| Example column | What it represents                                | Example values |
| -------------- | ------------------------------------------------- | -------------- |
| `condition`    | main biological question                          | WT, KO         |
| `batch`        | technical source of variation                     | batch1, batch2 |
| `replicate`    | sample identity (for tracking, not used directly) | 1, 2, 3        |
| `subclone`     | biological variation between clones               | clone1, clone2 |
## Major scenarios:

**Note: At least two biological replicate for each condition is needed**

### Scenario 1 – Simple comparison

`design = ~condition`

Example colData:
| sample | condition |
| ------ | --------- |
| WT_1   | WT        |
| WT_2   | WT        |
| KO_1   | KO        |
| KO_2   | KO        |
### Scenario 2 – Add batch effect

`design = ~batch +condition`

Example colData:
| sample | condition | batch |
| ------ | --------- | ----- |
| WT_1   | WT        | 1     |
| WT_2   | WT        | 2     |
| KO_1   | KO        | 2     |
| KO_2   | KO        | 2     |
| KO_2   | KO        | 1     |
### Scenario 3 – Subclones or donors

Suppose you have two independent clones of KO cells (biological replicates)
You want to test if **KO vs WT** has a consistent effect across clones.

`design = ~ subclone + condition`

Example colData:
| sample | condition | subclone |
| ------ | --------- | -------- |
| WT_1   | WT        | clone1   |
| WT_2   | WT        | clone2   |
| KO_1   | KO        | clone1   |
| KO_2   | KO        | clone2   |
| KO_2   | KO        | clone2   |
### Scenario 4 – Interaction design

Used when you want to test whether the effect of one variable (e.g., condition)
If you want to know whether the KO effect is different in each clone

`design = ~ subclone + condition + subclone:condition`

Example colData:
| sample | condition | subclone |
| ------ | --------- | -------- |
| WT_1   | WT        | clone1   |
| WT_2   | WT        | clone2   |
| KO_1   | KO        | clone1   |
| KO_2   | KO        | clone2   |
| KO_2   | KO        | clone2   |

**Simpler alternative (combined factor)** → Instead of adding an interaction term, you can combine both factors into one variable. 

**group = subcloneCondition**

`design = ~ group`
Example colData:
| **sample** | **group** |
| ---------- | --------- |
| WT_sub1_1  | sub1_WT   |
| WT_sub1_2  | sub1_WT   |
| KO_sub1_1  | sub1_KO   |
| KO_sub1_2  | sub1_KO   |
| WT_sub2_1  | sub2_WT   |
| WT_sub2_2  | sub2_WT   |
| KO_sub2_1  | sub2_KO   |
| KO_sub2_2  | sub2_KO   |

### Scenario 5 – Technical replicates
take Row means from sample of Technical replicates
## Building colData correctly
- 1. Each row = one biological sample.
- 2. Each column = one variable in the design.
- 3. Levels of categorical variables should be factors; for example: "WT" as refrence and "KO" as contrast 

Example colData:
| sample | condition | subclone | batch  |
| ------ | --------- | -------- | ------ |
| WT_A_1 | WT        | clone1   | batch1 |
| WT_A_2 | WT        | clone2   | batch2 |
| KO_B_1 | KO        | clone1   | batch1 |
| KO_B_2 | KO        | clone2   | batch2 |

`design = ~ batch + subclone + condition`

---

# 3) DESeq2 summaries
[DESeq2_summary_result_KO1](../../data/processed/normalCountByDeseq2_DIR/DESeq2_summary_result_KO1.txt)

[DESeq2_summary_result_KO2](../../data/processed/normalCountByDeseq2_DIR/DESeq2_summary_result_KO1.txt)
