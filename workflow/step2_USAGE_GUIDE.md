┌────────────────────────────────────────────────────────────┐
│ 2️⃣ Trimming Reads Using fastp                              │
│                                                            │
│   ./scripts/02_trim_reads.sh                               │
│                                                            │
│   ↳ Runs fastp on all FASTQ files                          │
│   ↳ Removes low-quality bases (Q<28)                       │
│   ↳ Discards reads shorter than 40 bp                      │
│   ↳ Auto-detects and removes adapter sequences             │
│   ↳ Saves cleaned FASTQ to data/processed/trimmed/         │
│   ↳ Generates HTML and JSON reports per file               │
│                                                            │
│ ✅ Ensures all output reads are free of adapter content.   │
└────────────────────────────────────────────────────────────┘
