#!/bin/bash
#set -e
set -u
set -o pipefail
#set -euo pipefail

echo; echo "# Create multiple sequence alignments with MUSCLE http://www.american.edu/cas/hpc/upload/Muscle_User_Guide.pdf."
for FILE in data/*.name.aa.fasta; do muscle -seqtype protein -in $FILE -fastaout $FILE.aln; done

echo; echo "# Trim the alignments with Gblocks http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_documentation.html."
for FILE in data/*.aln; do Gblocks $FILE -t=p; done

echo "exit status: $?"

echo; echo "# Infer phylogenetic trees using FastTree http://www.microbesonline.org/fasttree/."
for FILE in data/*.aln-gb; do FastTree -out $FILE.fasttree $FILE; done

# Print operating system characteristics
uname -a

echo "[$(date)] $0 has been successfully completed."
