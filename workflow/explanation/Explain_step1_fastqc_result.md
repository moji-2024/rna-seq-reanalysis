General Summary of FastQC Results (All 6 Files)
<p align="center">
  <img src="../images/Per base sequence quality_KO_SRR13633857.png" alt="Per base sequence quality_KO_SRR13633857.png" width="600">
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
