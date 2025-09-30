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
- Goal is **gene-level expression analysis**, not isoform disambiguation.  
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

---

## Downstream Analysis
The raw `quant.sf` tables are not the end goal. They feed into downstream steps, typically via **tximport in R**, which aggregates transcript-level estimates into **gene-level counts**. From there:

- **Differential expression analysis**: DESeq2, edgeR.  
- **Pathway enrichment & functional annotation**: GO, KEGG.  
- **Visualization**: heatmaps, PCA, volcano plots.  
- **Integration with metadata**: treatments, conditions → biological conclusions.  

---

## Summary
- ✅ Chose **Salmon** for fast, accurate, and bias-aware transcript quantification.  
- ✅ Used the **partial SA index** for efficiency and sufficient accuracy in a bulk RNA-seq context.  
- ✅ Obtained transcript abundance estimates (`quant.sf`) → foundation for **gene-level analysis** and **biological interpretation**.  

This step bridges **raw sequencing reads → meaningful expression values**, enabling downstream discovery.
