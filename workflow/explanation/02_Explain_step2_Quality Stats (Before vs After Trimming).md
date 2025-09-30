##  Common Observations

✨ **High Quality Maintained**  
After trimming, **Q30 rates improved in all samples**, surpassing **92.7%**, which indicates excellent base quality.

🧬 **Low Adapter Contamination**  
Only **KO_SRR13633858** showed detectable adapter trimming.

📉 **Minimal Loss**  
Only ~2–3% of reads were discarded for low quality or being too short.

🔁 **Duplication Rates**  
Duplication ranged from **56.8% to 60.9%** — somewhat high, likely owing to single-end sequencing or limited library complexity.

---

### Trimming Summary

[Summary_info](../../results/trimmed_report/Trim_stats.csv)

| Sample ID       | Reads Before | Reads After | Q30 Increase       | Adapters Trimmed |
|-----------------|--------------|-------------|--------------------|------------------|
| KO_SRR13633857  | 28.17 M      | 27.29 M     | 91.75 → **92.94**  | 0                |
| KO_SRR13633858  | 28.17 M      | 27.25 M     | 91.72 → **92.91**  | 53,535           |
| KO_SRR13633859  | 28.17 M      | 27.40 M     | 91.61 → **92.74**  | 0                |
| KO_SRR13633860  | 28.16 M      | 27.37 M     | 91.58 → **92.70**  | 0                |
| WT_SRR13633855  | 28.19 M      | 27.44 M     | 91.94 → **92.99**  | 0                |
| WT_SRR13633856  | 28.16 M      | 27.41 M     | 92.26 → **93.33**  | 0                |

---

> ✅ *Trimming enhanced base quality while preserving most of the reads, preparing the dataset for robust downstream analyses.*
