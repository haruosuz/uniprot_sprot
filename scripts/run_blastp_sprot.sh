#!/bin/bash
set -euo pipefail

# Variables
DBTYPE=nucl; PROGRAM=blastn
DBTYPE=prot; PROGRAM=blastp
DB=data/uniprot_sprot.fasta

# [Building a BLAST database](http://www.ncbi.nlm.nih.gov/books/NBK279688/)
makeblastdb -in $DB -dbtype $DBTYPE -hash_index -parse_seqids

# [Extracting data from BLAST databases with blastdbcmd](http://www.ncbi.nlm.nih.gov/books/NBK279689/)
NAME='MMSB_PSEAE' #>sp|P28811|MMSB_PSEAE 3-hydroxyisobutyrate dehydrogenase

blastdbcmd -db $DB -entry all -outfmt "%i %t" | grep "$NAME" | \
# grep -v "Chloroplast\|Mitochondria" | \
awk '{print $1}' | blastdbcmd -db $DB -entry_batch - > data/`basename $DB .fasta`.$NAME.fasta

QUERY=data/`basename $DB .fasta`.$NAME.fasta

# Running BLAST
EVALUE=1e-20
OUTPUT=analysis/${PROGRAM}-$(basename $QUERY)-$(basename $DB).out

$PROGRAM -db $DB -query $QUERY -evalue $EVALUE \
-max_target_seqs $(grep -c '^>' $DB) -outfmt 7 > $OUTPUT
# -max_hsps 1 

# Inspecting and Manipulating $OUTPUT
#grep -v '#' $OUTPUT | sort -k4,4nr > $OUTPUT.sorted

grep -v '#' $OUTPUT | awk '{print $2}' | sort -u | head -20 | blastdbcmd -db $DB -entry_batch - | sed 's/ .*//' > data/homologs.aa.fasta

# Print operating system characteristics
uname -a

echo "[$(date)] $0 has been successfully completed."
