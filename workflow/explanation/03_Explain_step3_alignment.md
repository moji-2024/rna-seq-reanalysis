## Alignment Results (HISAT2)

For alignment, the **HISAT2 pre-built index** for human was downloaded from:  
🔗 [https://genome-idx.s3.amazonaws.com/hisat/grch38_tran.tar.gz](https://genome-idx.s3.amazonaws.com/hisat/grch38_tran.tar.gz)  

This index includes both the **human genome (GRCh38)** and known **transcripts from GENCODE/Ensembl**.  
👉 It is particularly useful for **RNA-seq** because it supports accurate alignment of reads that span **exon–exon junctions**, which is essential when working with spliced mRNA.

---

### Alignment Summary

Across all six samples, the alignment quality was very high:

- **Unique alignment**: ~89% of reads mapped to a single location.  
- **Multi-mapped**: ~9% of reads matched multiple locations (expected for repetitive regions).  
- **Unaligned**: ~1–2% of reads did not map at all.  

✅ **Overall alignment rate: ~98%** — an excellent result for RNA-seq data.

---

### Why this matters

- Using the **GRCh38+transcript index** ensures both genome and transcriptome are represented, improving alignment at splice junctions.  
- A high proportion of **unique alignments** means the dataset is clean and reliable for downstream analysis.  
- The small number of multi-mapped and unaligned reads is normal and expected in RNA-seq.  

---

### Next step

Check the BAM files to confirm library type and assess any sequencing biases.
