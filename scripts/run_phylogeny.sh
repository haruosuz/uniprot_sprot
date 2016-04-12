#!/bin/bash
set -euo pipefail

# Multiple sequence alignment with MUSCLE http://www.american.edu/cas/hpc/upload/Muscle_User_Guide.pdf
for FILE in data/*.aa.fasta; do muscle -seqtype protein -in $FILE -fastaout $FILE.aln; done

# Gblocks http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_documentation.html
for FILE in data/*.aln; do Gblocks $FILE -t=p; done

# FastTree http://www.microbesonline.org/fasttree/
for FILE in data/*.aln-gb; do FastTree -out $FILE.fasttree $FILE; done

# Print operating system characteristics
uname -a

echo "[$(date)] $0 has been successfully completed."
