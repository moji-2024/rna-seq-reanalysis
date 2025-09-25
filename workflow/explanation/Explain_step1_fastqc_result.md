General Summary of FastQC Results (All 6 Files)
- First sample graph:
<p align="center">
  <img src="../../images/Per base sequence quality_KO_SRR13633857.png" alt="Per base sequence quality_KO_SRR13633857.png" width="600">
</p>

After reviewing multiple FastQC reports, we can make the following observations about the dataset as a whole:

✔Common Passes Across All Samples
Per base sequence quality: Most reads show high quality across the length of the sequences. This means the sequencer performed well overall.

Per sequence quality scores: Quality distribution across reads is strong, with most reads having high average Phred scores.

Adapter content: Minimal or no adapter contamination was detected, meaning library preparation was mostly clean.

Sequence length distribution and N content are stable.

! Consistent Warnings
Per sequence GC content: Most files showed slight deviations from a normal GC distribution. This could indicate some technical bias or contamination in the library or uneven amplification of GC-rich regions.

Sequence duplication levels: A moderate level of duplicated reads appeared across several samples. This is expected in low-input RNA-seq or over-sequenced libraries but still something to watch.

✗ Shared Failures
Per base sequence content: All or most samples failed this module. The beginning of the reads showed a strong imbalance in nucleotide composition, especially in the first 10–15 bases. This is typically caused by:

Random hexamer priming (bias at the start of reads)

Primer/adaptor sequence remnants

Non-random fragmentation

Why Trimming Is Required
Trimming is needed across all samples for the following reasons:

Correct Sequence Content Bias:
All samples showed unnatural patterns at the beginning of reads. This can mess with aligners and bias downstream quantification. Trimming ~10–15 bases off the start usually fixes it.

Remove Residual Low-Quality Bases:
Even if overall quality is fine, individual reads may still contain low-quality bases at the ends that should be cut to reduce noise.

Control GC Skew:
GC content bias might be reduced by trimming problematic sections, helping ensure accurate expression or variant calling.

Improve Mapping Efficiency:
Removing biased or low-complexity sections improves read mappability and reduces spurious alignments.


# Step 1: FastQC Quality Control

## 📌 Purpose of FastQC
FastQC is the first step in any RNA-seq workflow. It provides a quick overview of the quality of raw sequencing reads to identify potential problems before downstream analysis.  
It checks for base quality, GC content, adapter contamination, duplication, overrepresented sequences, and other metrics.

---

## 📊 FastQC Report Modules & Interpretation

Below are the main graphs in a FastQC report, what they mean, what is expected in high-quality data, and how to interpret your results.

### 1. **Per Base Sequence Quality**

- 🔹 What is a Boxplot (in FastQC)?
  -  A boxplot summarizes the distribution of quality scores at each base position:
  -  Box (rectangle) → shows the middle 50% of values (from the 25th to 75th percentile).
  -  Horizontal line inside the box → the median (middle value).
  -  Whiskers (lines extending above/below the box) → show the overall spread of values (excluding extreme outliers).
  -  Dots → outliers (rare values much higher or lower than most data).
  
  👉 In FastQC, taller boxes or whiskers mean more variability in base quality at that position, while a flat box near the top (e.g. Q30+) means consistently high quality.
- **What it shows**: Boxplots of quality scores (Phred) for each base position across all reads.  
- **What is expected**:  
  - Scores above 30 (Q30) across most of the read = very good.  
  - Slight drop in quality at the 3′ end is normal, especially in Illumina reads.  
- **This result**: Quality scores are consistently high (>Q30) across nearly all bases, with only a minor drop at the end → acceptable.

---

### 2. **Per Sequence Quality Scores**
- **What it shows**: Distribution of mean quality scores per read.  
- **What is expected**: A peak toward high quality (≥30).  
- **This result**: Peak is centered above Q30, meaning most reads are high quality.

---

### 3. **Per Base Sequence Content**
- **What it shows**: Proportion of each base (A, T, G, C) at each read position.  
- **What is expected**:  
  - For random libraries, lines should be roughly parallel.  
  - For RNA-seq, early base bias is common due to random priming.  
- **This result**: Some imbalance at the first ~10 bases (expected for RNA-seq), then lines stabilize → normal.

---

### 4. **Per Sequence GC Content**
- **What it shows**: Distribution of GC content per read.  
- **What is expected**: A bell-shaped curve close to theoretical distribution for the organism.  
- **This result**: Curve is symmetric around expected GC percentage (~40–50% for human/mouse) → good.

---

### 5. **Per Base N Content**
- **What it shows**: Frequency of undetermined bases (“N”) at each position.  
- **What is expected**: Almost zero across the read.  
- **This result**: N content is negligible → good.

---

### 6. **Sequence Length Distribution**
- **What it shows**: Distribution of read lengths.  
- **What is expected**: A sharp peak at the read length specified (e.g. 75 bp, 100 bp, 150 bp).  
- **This result**: Uniform length matching sequencing design → correct.

---

### 7. **Sequence Duplication Levels**
- **What it shows**: Proportion of duplicate reads.  
- **What is expected**:  
  - RNA-seq naturally has higher duplication due to highly expressed genes.  
  - Moderate duplication is acceptable.  
- **This result**: Some duplication seen, likely reflecting abundant transcripts (expected in RNA-seq).

---

### 8. **Overrepresented Sequences**
- **What it shows**: Specific sequences that appear too often.  
- **What is expected**: Ideally none.  
- **This result**: A small number of adapter/primer sequences are flagged → will be removed in trimming.

---

### 9. **Adapter Content**
- **What it shows**: Presence of adapter sequences across read positions.  
- **What is expected**: Minimal adapter signal in raw data; trimming may be needed.  
- **This result**: Mild adapter contamination at the 3′ end → trimming step will fix this.

---

## ✅ Summary of Your FastQC Results
- **Read quality**: High (Q30+ across most positions).  
- **Base composition**: Stable after initial bias (expected for RNA-seq).  
- **GC content**: Matches reference genome.  
- **Adapter content**: Present but modest → requires trimming.  
- **Duplication**: Within expected range for RNA-seq.  

Overall, your data passes quality control with only minor adapter contamination. The next step is **adapter trimming and filtering (Step 2: fastp)**.

---
