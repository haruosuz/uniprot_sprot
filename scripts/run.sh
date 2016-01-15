#!/bin/bash
set -e
set -u
#set -o pipefail

# Creating directories
mkdir -p ./{data,analysis}

# Downloading data
URL=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
URL=ftp://ftp.ebi.ac.uk/pub/databases/uniprot/knowledgebase/uniprot_sprot.fasta.gz
#wget -P data/ $URL
#curl $URL > data/uniprot_sprot.fasta.gz

# Inspecting Data
ls -lh data/uniprot_sprot.fasta.gz
gzcat data/uniprot_sprot.fasta.gz | head -n 2
zgrep "^>" data/uniprot_sprot.fasta.gz > analysis/fasta_header.txt
grep -i "Homo.sapiens" analysis/fasta_header.txt > analysis/fasta_header_Homo.sapiens.txt
wc -l analysis/*.txt

# Running R scripts
Rscript --vanilla scripts/my_fasta.R
mv Rplots.pdf analysis/

# Print operating system characteristics
uname -a

echo "[$(date)] Thank you, come again."
