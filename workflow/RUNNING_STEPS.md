┌─────────────────────────────────────────────┐
│ 1. Clone the repository                     │
│    git clone https://github.com/moji-2024/  │
│               rna-seq-reanalysis.git        │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│ 2. Change into project directory            │
│    cd rna-seq-reanalysis                    │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│ 3. Make scripts executable                  │
│    chmod +x scripts/*.sh                    │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│ 4. Install required tools                   │
│    - fastqc (e.g., sudo apt install fastqc) │
│    - wget (if not installed)                │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│ 5. Download FASTQ files                     │
│    ./scripts/00_Download_fastqFiles.sh      │
│    ↳ Downloads from FTP                     │
│    ↳ Auto-renames to KO_ or WT_             │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│ 6. Run FastQC on downloaded files           │
│    ./scripts/01_qc_fastqc.sh                │
│    ↳ Runs FastQC on .fastq.gz files         │
│    ↳ Saves results in results/plots/        │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│ ✅ Done: Quality Control Complete           │
│    Next steps: Trimming → Alignment → DESeq2│
└─────────────────────────────────────────────┘
