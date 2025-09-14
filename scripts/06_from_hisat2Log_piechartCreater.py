#!/bin/bash
source ~/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq-tools

# Define input and output directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"
LogFolder_DIR="$DATA_DIR/processed/logs"
OutputFolder_DIR="$SCRIPT_DIR/../results/pieChartCreater_results"
echo "progress make dir $OutputFolder_DIR"
mkdir -p "$OutputFolder_DIR"

python - <<EOF
import re
import os
import argparse
import matplotlib.pyplot as plt

def parse_hisat2_log(file_path):
    with open(file_path, 'r') as f:
        log = f.read()

    unaligned = int(re.search(r'(\d+)\s+\(\S+%\)\s+aligned 0 times', log).group(1))
    unique = int(re.search(r'(\d+)\s+\(\S+%\)\s+aligned exactly 1 time', log).group(1))
    multi = int(re.search(r'(\d+)\s+\(\S+%\)\s+aligned >1 times', log).group(1))
    total_reads = unaligned + unique + multi
    overall_rate = re.search(r'([\d.]+)% overall alignment rate', log).group(1)
    return unaligned, unique, multi, total_reads, overall_rate

def plot_piechart(unaligned, unique, multi, total_reads, overall_rate, output_Folder,core_sampleName):
    labels = ['Unaligned', 'Unique Alignment', 'Multi-mapped']
    values = [unaligned, unique, multi]
    colors = ['#ff6666', '#66b3ff', '#99ff99']
    explode = (0.1, 0.05, 0.05)

    plt.figure(figsize=(8,8))
    wedges, texts, autotexts = plt.pie(
        values, labels=labels, autopct='%1.2f%%',
        startangle=140, colors=colors, explode=explode,
        shadow=True, textprops={'fontsize': 12, 'weight': 'bold'}
    )

    plt.title("HISAT2 Alignment Summary", fontsize=16, weight='bold')

    plt.legend(
        wedges,
        [f"{l}: {v:,} reads" for l, v in zip(labels, values)],
        title="Categories", loc="center left", bbox_to_anchor=(1, 0, 0.5, 1),
        fontsize=12
    )

    plt.text(0, -1.35, f"Total reads: {total_reads:,}\nOverall alignment rate: {overall_rate}%",
             ha='center', fontsize=13, weight='bold')

    plt.tight_layout()
    plt.savefig(os.path.join(output_Folder,core_sampleName + '_log_hisat2.png'), dpi=300, bbox_inches='tight')
    print(f"Saved pie chart in {output_Folder} as {core_sampleName + '_log_hisat2.png'}")

print('Directory of log folder: ',"$LogFolder_DIR")
for sample in os.listdir("$LogFolder_DIR"):
  print('sample: ' ,sample)
  full_paths_sample = os.path.join("$LogFolder_DIR", sample)
  items = [i for i in os.listdir(full_paths_sample) if not i.startswith(".")]
  for file in items:
    if file.endswith(".hisat2.log"):
      full_paths_file = os.path.join(full_paths_sample, file)
      core_sampleName = re.sub(r'.hisat2.log','', file)
      unaligned, unique, multi, total_reads, overall_rate = parse_hisat2_log(full_paths_file)
      plot_piechart(unaligned, unique, multi, total_reads, overall_rate, "$OutputFolder_DIR",core_sampleName)
EOF
