#!/bin/bash
set -euo pipefail

# Variables
DBTYPE=nucl; PROGRAM=blastn
DBTYPE=prot; PROGRAM=blastp
DB=data/uniprot_sprot.fasta

echo; echo "# Building a BLAST database http://www.ncbi.nlm.nih.gov/books/NBK279688/."
#makeblastdb -in $DB -dbtype $DBTYPE -hash_index -parse_seqids

echo; echo "# Extracting data from BLAST databases with blastdbcmd http://www.ncbi.nlm.nih.gov/books/NBK279689/."
NAME='MMSB_PSEAE' #>sp|P28811|MMSB_PSEAE 3-hydroxyisobutyrate dehydrogenase
QUERY=data/`basename $DB .fasta`.$NAME.fasta

blastdbcmd -db $DB -entry all -outfmt "%i %t" | grep "$NAME" | \
# grep -v "Chloroplast\|Mitochondria" | \
awk '{print $1}' | blastdbcmd -db $DB -entry_batch - > $QUERY

echo; echo "# Running BLAST."
EVALUE=1e-20
OUTPUT=analysis/${PROGRAM}-$(basename $QUERY)-$(basename $DB).out

$PROGRAM -db $DB -query $QUERY -evalue $EVALUE \
-max_target_seqs $(grep -c '^>' $DB) -outfmt 7 > $OUTPUT
# -max_hsps 1 

echo; echo "# Inspecting and Manipulating $OUTPUT."
#grep -v '#' $OUTPUT | sort -k4,4nr > $OUTPUT.sorted

grep -v '#' $OUTPUT | awk '{print $2}' | uniq | head -10 | blastdbcmd -db $DB -entry_batch - > data/$(basename $QUERY).homologs.annot.aa.fasta
sed 's/ .*//' data/$(basename $QUERY).homologs.annot.aa.fasta > data/$(basename $QUERY).homologs.name.aa.fasta
sed 's/ .*//' data/$(basename $QUERY).homologs.annot.aa.fasta > data/homologs.name.aa.fasta

#grep -v '#' $OUTPUT | awk '{print $2}' | sort -u | head -10 | blastdbcmd -db $DB -entry_batch - | sed 's/ .*//' > data/homologs.aa.fasta

# Print operating system characteristics
uname -a

echo "[$(date)] $0 has been successfully completed."
