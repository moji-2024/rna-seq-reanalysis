# RNA-seq Quantification with Salmon

## Why Salmon?
For transcript quantification in RNA-seq, **Salmon** is one of the most widely used tools because it is:

- **Fast**: Lightweight mapping with selective alignment avoids the overhead of full aligners.  
- **Accurate**: Bias correction options (`--seqBias`, `--gcBias`, `--validateMappings`) improve transcript abundance estimates.  
- **Resource-friendly**: Uses less CPU and memory than full genome alignments.  
- **Well-supported**: Compatible with common downstream tools such as **tximport (R)**, **DESeq2**, and **edgeR**.  

📌 **Case Study**:  
Dataset: [GEO: GSE166219](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE166219), [BioProject PRJNA699603](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA699603)  
Human **HT-29 cell line** mRNA sequencing runs.  
Salmon was the right choice to rapidly quantify transcripts and prepare the data for **gene-level differential expression analysis**.

---

## Why the Partial Selective-Alignment Index?
Salmon supports two flavors of the selective alignment (SA) index:

- **Full SA index (~16 GB)**: includes the entire genome as decoy sequences. Maximizes accuracy but heavy on RAM and disk.  
- **Partial SA index (~2.5 GB)**: includes the transcriptome plus only genomic regions most likely to cause mis-mapping (generated using the *gentrome/decoy* method).  

👉 For this study, the **partial SA index** was selected because:

- Dataset is **bulk RNA-seq** with standard read lengths.  
- Partial index is **lighter, faster, and accurate enough** for typical mRNA profiling tasks.  
- Saves significant **computational resources** while retaining robust quantification.  

---

## What Salmon Produced
Running `salmon quant` on each sample created a directory (one per sample) containing key outputs:

- `quant.sf` – main table of transcript IDs with TPM, estimated counts, and effective lengths.  
- `libParams` – inferred library type information.  
- `cmd_info.json` – record of parameters used.  
- **Bootstrap files** (if enabled) – quantify technical variance at the transcript level.  

These outputs provide **transcript-level abundance estimates** across all samples.

## 🧬 Understanding `quant.sf` from **Salmon**

When you run **Salmon**, each sample generates a folder containing a file called **`quant.sf`**.  
This file contains **transcript-level quantification results**, where **each row = one transcript**.

---

## 📂 File Structure

The file has **5 columns**:

| Column           | Description                               |
|------------------|-------------------------------------------|
| **Name**         | Transcript ID                             |
| **Length**       | Full transcript length (nt)               |
| **EffectiveLength** | Adjusted length used for normalization  |
| **TPM**          | Transcripts Per Million                   |
| **NumReads**     | Estimated number of reads                 |

---

## 📖 Column Details

### 🔹 1. **Name**
- Transcript identifier (e.g., `ENST00000456328.2`)
- Comes from reference **FASTA/GTF**
- Used to map transcripts → genes (`tx2gene`)

---

### 🔹 2. **Length**
- The total number of nucleotides in the reference transcript sequence as defined in the transcriptome FASTA/GTF used to build the Salmon index.
- This value is fixed for each transcript and does not depend on the sequencing reads.

**Example:** `if transcript ENST00000456328.2 has 2000 bases in the Ensembl GRCh38 reference, then Length = 2000.`

---

### 🔹 3. **EffectiveLength**
- Adjusted transcript length used for normalization  
- Accounts for valid fragment placement and bias corrections

**Formula:**

---

## Downstream Analysis
The raw `quant.sf` tables are not the end goal. They feed into downstream steps, typically via **tximport in R**, which aggregates transcript-level estimates into **gene-level counts**. From there:

- **Differential expression analysis**: DESeq2, edgeR.  
- **Pathway enrichment & functional annotation**: GO, KEGG.  
- **Visualization**: heatmaps, PCA, volcano plots.  
- **Integration with metadata**: treatments, conditions → biological conclusions.  

---
---

# MultiQC Report Aggregation

## Why MultiQC?
RNA-seq pipelines generate a wide variety of logs and QC outputs (e.g., from alignment, quantification, trimming). **MultiQC** is a lightweight and modular tool that scans these outputs and compiles them into a single, interactive HTML report. This provides a **holistic quality assessment** across all samples in one place.

- **Aggregates logs**: STAR / HISAT2 alignment rates, Salmon quant stats, FastQC reports, etc.  
- **Cross-sample comparison**: Quickly spot outliers in read quality, mapping rate, duplication, or bias.  
- **Reproducible reports**: Each run creates a timestamped HTML file for tracking.

## What MultiQC Produced

The uploaded HTML file contains:

- **Summary statistics**: Alignment rates, mapping efficiency, duplication levels.  
- **Sample-by-sample QC plots**: Read quality distributions, GC content, sequence length.  
- **Warnings/flags**: Highlighting any samples with unusually low quality or poor alignment.  

This step provides a **global snapshot of sequencing and quantification quality**, ensuring confidence before downstream analysis (e.g., **DESeq2**, **pathway enrichment**).


📌 **Case Study in this workflow**:  
After quantification with **Salmon**, MultiQC was run across the processed data directory.  
The generated report (`multiqc_YYYYMMDD.html`) is located in:  [Summary_info](../../results/multiqc_results/multiqc_20250929.html)



## Summary
- ✅ Chose **Salmon** for fast, accurate, and bias-aware transcript quantification.  
- ✅ Used the **partial SA index** for efficiency and sufficient accuracy in a bulk RNA-seq context.  
- ✅ Obtained transcript abundance estimates (`quant.sf`) → foundation for **gene-level analysis** and **biological interpretation**.  

This step bridges **raw sequencing reads → meaningful expression values**, enabling downstream discovery.
