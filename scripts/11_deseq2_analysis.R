# create a new env (optional)
conda create -n rnaseq-deseq2 r-base=4.4.1 -y
conda activate rnaseq-deseq2

# install DESeq2 workflow + supporting R packages
conda install -c bioconda -c conda-forge \
  bioconductor-deseq2=1.42.0 \
  bioconductor-tximport=1.32.0 \
  bioconductor-apeglm=1.24.0 \
  r-readr=2.1.5 \
  r-pheatmap=1.0.12 \
  r-optparse=1.7.5 \
  r-ggplot2=3.5.1 -y

