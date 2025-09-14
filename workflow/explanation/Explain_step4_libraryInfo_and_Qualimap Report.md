**Note: Since this library is unstranded, there’s no need to realign using strand-specific flags, nor to apply strand flags in Qualimap.** 
- [library_info](../../results/texts/strandness/library_info.txt)

**For simplicity in explaining the workflow, this file focuses on the KO_SRR13633857 sample.**
1. Exonic reads (≈90% in your data)

These fall inside annotated exons — the protein-coding or mature transcript parts of genes.
Typical RNA types here:

mRNA (messenger RNA) → the main product of RNA-seq, spliced and coding.

lncRNA exons (long noncoding RNA) → also transcribed but not coding proteins.

miRNA precursors, snoRNAs, snRNAs that are annotated as exon-like regions.

Basically, any RNA that makes it into the “final transcript” after splicing.

👉 In RNA-seq, a high exonic fraction is good because it means you captured mature transcripts, not random noise.

2. Intronic reads (≈6% in your data)

These are inside introns, the parts usually cut out during splicing.
Possible explanations:

Unspliced pre-mRNA → immature transcripts still being processed in the nucleus.

Retained introns → some alternative splicing events keep introns in mature RNA.

Nascent transcription → reads caught while RNA polymerase was still working.

Noncoding RNAs → some lncRNAs and regulatory RNAs overlap intronic regions.

Technical artifact → incomplete removal of nuclear RNA during library prep.

👉 Some intronic signal is normal (often 5–15%). Very high intronic reads (>30–40%) may mean poor poly(A) selection or contamination with nuclear RNA.

3. Intergenic reads (≈4.5% in your data)

These fall outside annotated genes.
What could they be?

Unannotated transcripts → novel lncRNAs, enhancer RNAs (eRNAs).

Antisense RNAs → transcribed from opposite strands of genes.

Pseudogenes or lowly annotated gene fragments.

Noise/technical artifacts → random priming, misalignment, or sequencing errors.

👉 A small fraction of intergenic reads is expected. If it’s very high (>20–30%), it could indicate problems with annotation (using an incomplete GTF) or contamination.
1. Understanding the Report Sections
Reads Alignment (Table)

Mapped reads (26.8M): These are reads that aligned to the genome. This is a healthy number.

Secondary alignments (5.5M): Reads that align in more than one place. Expected in RNA-seq.

Not aligned (452k): Very small fraction. That’s good.

Strand specificity (0.51/0.49): Confirms your data is non-stranded.




Reads Genomic Origin (Graph & Table)
  Exonic (89.5%): Most reads fall in exons → excellent, means your library prep captured real transcripts.
  Intronic (6%) + Intergenic (4.5%): A small portion; normal background noise.
  rRNA (0%): Very good. Means ribosomal RNA contamination is absent.
  (Graph: pie chart showing where reads land in genome – exons, introns, intergenic.)

Coverage Profile Along Genes (3 plots: Total, Low, High expression genes)
What is coverage in RNA-seq?
Coverage = how many sequencing reads overlap a given position in the transcripts.
Imagine a transcript (gene) as a rope stretched from 5′ end → 3′ end.

If you have lots of sequencing reads all along the genome, you have good coverage.
If most of the sequencing reads is stuck only at one end, that’s biased coverage.

Note: the 3′ end is more likely to have bias in typical RNA-seq datasets.
3′ bias: Many RNA-seq protocols use poly(A) selection with oligo-dT primers, which grab transcripts starting at the poly(A) tail (3′ end). That naturally enriches reads near the 3′ end, giving you 3′ bias.

5′ bias: 5′ bias does happen, but usually less often. It can show up if:
  Reverse transcriptase stops early (so you only sequence the start of transcripts).
  Fragmentation favors the 5′ region.

Each plot is a line graph of read density across transcripts, from the 5′ end (start of the gene) on the left, to the 3′ end (end of the gene) on the right.
Qualimap squash all genes together, normalize them to the same length, and then average coverage across them.
X-axis = transcript position (0–100%)
  0% (left side) → the Transcription Start Site (TSS), the beginning of the mRNA (the 5′ end).
  100% (right side) → the Transcription Termination Site (TTS), the end of the mRNA (the 3′ end).
Y-axis = average read coverage at that position (normalized).

1) Total (all genes combined):
  This averages coverage across all genes.
  It gives you a global sense of bias.
  In your data, coverage is slightly higher at the 5′ end and drops a bit toward the 3′ end.
  (Graphs: line plots showing read coverage across transcripts. If one end is too skewed, it signals bias from library prep.)
3) Low expression genes:
  Shows coverage distribution only for genes with low read counts.
  These often look noisier and less uniform, because there aren’t many reads to smooth the curve.
  If low-expression genes show extreme bias, it might mean short transcripts or uneven capture in weakly expressed genes.
4) High expression genes:
  Shows coverage across highly expressed transcripts only.
  These curves are usually smoother, since there are many reads.
  If there’s a strong 5′ or 3′ skew here, it reflects a true systematic bias from library prep rather than random noise.
This data(KO_SRR13633857) bias= 5′ bias = 0.84, 3′ bias = 0.67, 5′–3′ ratio = 1.27





Coverage Histogram (0–50X)
  It shows at how many places in the transcriptome do we see 1 read, 2 reads, 10 reads, 20 reads…?
  X-axis = coverage depth (how many reads overlap each base in a transcript)
  Y-axis = number of bases (or fraction of the transcriptome) that have that coverage
  Good RNA-seq should have many transcripts covered at useful depth.
  This tells downstream tools (like DESeq2/edgeR) that you have enough coverage to detect expression.





Junction Analysis
  When RNA is transcribed, introns get spliced out, and exons are stitched together.
    A junction read is a sequencing read that spans across an exon–exon boundary.
  The Junction Analysis graph counts these reads and classifies them by the splice motifs they use (the bases at the splice donor and acceptor sites).
  What do the motifs mean?
    Splice sites are defined by short sequence patterns at the boundaries of introns:
      Most common in humans:
      GT–AG rule: introns usually begin with GT and end with AG.
      So, an exon–intron boundary will look like “AG|GT” when you align exons and introns together.
    Less common motifs also exist (like GC–AG or AT–AC), and noncanonical sites are rare but real.
    In this report, the graph shows percentages of different motifs:
      ACCT, AGGT, AGGA, etc. → these are the sequence signatures observed at the junctions your reads covered.
  Reads at junctions: 5.5M → plenty of reads spanning exon-exon boundaries, confirming splicing was captured.
  Shows percentages of canonical splice motifs (AGGT is common in human).
  Your values look consistent with normal biology.
  (Graph: bar chart of splice motifs seen. Confirms that alignments are biologically reasonable.)







2. Is this Data Good or Bad?
✅ Good signs in this data:
  High exonic reads (89.5%) → strong signal from transcripts.
  Very low rRNA contamination.
  Balanced strand specificity (expected for non-stranded).
  Junction reads are present in large numbers → good splice representation.
  Only 1.3% of reads failed to align → excellent mapping.

⚠️ Minor caveats:
  Slight 5′ coverage bias. This is normal for RNA-seq, not fatal.
  Around 10% of reads fell in intronic/intergenic regions → expected, but can be trimmed down with stricter filtering.
Overall: Your RNA-seq data is high quality and perfectly usable for downstream analysis.

3. Next Steps
  1.Generate count matrix:
    By "Salmon" to get a gene-by-sample counts table.
  2.Normalization:
    Apply DESeq2 (R) to account for sequencing depth and library size.
  3.Differential Expression Analysis:
    Compare KO vs WT or conditions of interest. Find up- and down-regulated genes.
  4.Exploratory Analysis:
    PCA/Clustering → see if samples group by condition.
    Heatmaps → visualize top DE genes.
  5.Functional Analysis
  Pathway enrichment (KEGG, GSEA, Reactome) to interpret biological meaning.


*This RNA-seq dataset passed QC with ~90% exonic reads, strong mapping rates, and minimal contamination. Coverage is balanced across transcripts, with only a mild 5′ bias typical of RNA-seq. Junction reads confirm splicing capture. Overall, the dataset is high-quality and ready for downstream differential expression and functional analysis.
