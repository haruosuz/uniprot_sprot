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
curl $URL > data/uniprot_sprot.fasta.gz

# Inspecting Data
ls -lh data/uniprot_sprot.fasta.gz
gzcat data/uniprot_sprot.fasta.gz | head -n 2
zgrep "^>" data/uniprot_sprot.fasta.gz > analysis/header_fasta.txt
wc -l analysis/header_fasta.txt
grep -i "cancer" analysis/header_fasta.txt > analysis/output_cancer.txt
grep -i "pancrea" analysis/header_fasta.txt > analysis/output_pancrea.txt
grep -i "cardiomyo" analysis/header_fasta.txt > analysis/output_cardiomyo.txt
grep -i "VCAM1" analysis/header_fasta.txt > analysis/output_VCAM1.txt
wc -l analysis/output_*

# Print operating system characteristics
uname -a

echo "[$(date)] Thank you, come again."
