----------

Haruo Suzuki (haruo[at]g-language[dot]org)  
Last Update: 2015-10-11  

----------

# UniProtKB/Swiss-Prot project
Project started 2015-10-12.

## Run environment
Mac OS X 10.9.5  
R version 3.2.2 (2015-08-14)  

## Project directories

	uniprot_sprot/
	  README.md: project documentation 
	  bin/: scripts
	  data/: sequence data
	  results/: results of analyses

## Data
Data files were downloaded on 2015-10-11 from http://www.ebi.ac.uk/uniprot/database/download.html into `data/` and decompressed, using:

	cd data/
	wget -o wget.log ftp://ftp.ebi.ac.uk/pub/databases/uniprot/knowledgebase/uniprot_sprot.fasta.gz & 
	gunzip uniprot_sprot.fasta.gz

## Scripts

----------

## Steps

	date +%F
	mkdir -p uniprot_sprot/{bin,data,results}

### Inspecting Data

	cd data/
	$ls -lh uniprot_sprot.fasta 
	-rw-r--r--  1 haruo  staff   252M Oct 11 10:37 uniprot_sprot.fasta

	$for FILE in *.fasta; do echo -n $FILE' '; grep '>' $FILE | wc -l; done
	uniprot_sprot.fasta   549215

	grep ">" uniprot_sprot.fasta | head 

	grep ">" uniprot_sprot.fasta | head | perl -nle '$_=~/^>(\S+) (.+) OS=(.+) GN=/; print "$1 | $2 | $3";'

- Perlワンライナー覚書 - Qiita http://qiita.com/tossh/items/f8d448c0c039f68c0ea3
- 正規表現・ワイルドカード http://www.cudo29.org/regexp.html

#### Top 10 organisms

	grep ">" uniprot_sprot.fasta | perl -nle '$_=~/^>(\S+) (.+) OS=(.+) GN=/; print "$3";' | sort | uniq -c | sort -nr | head | sed s/^/$'\t'/g

	21604 Homo sapiens
	17949 Mus musculus
	15441 Arabidopsis thaliana
	9080 Rattus norvegicus
	7974 Saccharomyces cerevisiae (strain ATCC 204508 / S288c)
	5882 Bos taurus
	5716 Schizosaccharomyces pombe (strain 972 / ATCC 24843)
	4582 Escherichia coli (strain K12)
	4580 Bacillus subtilis (strain 168)
	4335 Dictyostelium discoideum

	grep ">" uniprot_sprot.fasta | perl -nle '$_=~/^>(\S+) (.+) OS=(.+) GN=/; $tmp = $3; $tmp =~ s/ /_/g; print "$tmp";' | sort | uniq -c | sort -nr | head -20 | awk '{print $2,":",$1}'

[![](https://github.com/haruosuz/GENOME_REPORTS/blob/master/images/wordle_overview.png)]()
[Word clouds](http://www.wordle.net/advanced) representing the 15 most abundant organisms in UniProtKB/Swiss-Prot. The font size of each organism is proportional to its number in the database.

#### Top 15 functions

	grep ">" uniprot_sprot.fasta | perl -nle '$_=~/^>(\S+) (.+) OS=(.+) GN=/; print "$2";' | sort | uniq -c | sort -nr | head -15 | sed s/^/$'\t'/g

	1689 Cytochrome b
	 868 50S ribosomal protein L2
	 867 50S ribosomal protein L14
	 866 30S ribosomal protein S19
	 865 DNA ligase
	 860 30S ribosomal protein S7
	 855 DNA-directed RNA polymerase subunit beta
	 855 30S ribosomal protein S8
	 843 30S ribosomal protein S4
	 843 30S ribosomal protein S15
	 842 30S ribosomal protein S12
	 839 50S ribosomal protein L1
	 831 Ribosomal RNA small subunit methyltransferase H
	 829 50S ribosomal protein L11
	 827 Enolase

	grep ">" uniprot_sprot.fasta | perl -nle '$_=~/^>(\S+) (.+) OS=(.+) GN=/; $tmp = $2; $tmp =~ s/ /_/g; print "$tmp";' | sort | uniq -c | sort -nr | head -16 | awk '{print $2,":",$1}'

[![](https://github.com/haruosuz/GENOME_REPORTS/blob/master/images/wordle_overview.png)]()
[Word clouds](http://www.wordle.net/advanced) representing the 15 most abundant functions in UniProtKB/Swiss-Prot. The font size of each function is proportional to its number in the database.

#### 

	DB=uniprot_sprot.fasta
	grep -i "Cyanobacteria" $DB | wc -l # 
	grep ">.*\(Bifidobacterium\|Enterococcus\|Lactococcus\|Lactobacillus\|Leuconostoc\|Pediococcus\)" $DB | wc -l # lactic acid bacteria (LAB)
	grep -i ">.*\(virus\|phage\|plasmid\)" $DB | wc -l # Mobile Genetic Elements

	grep -i "chloroplast\|plastid" $DB | wc -l
	grep -i "chloroplast" $DB | wc -l
	grep -i "plastid" $DB | wc -l

	grep -i "mitochondri" $DB | wc -l

##### typo

	DB=uniprot_sprot.fasta
	grep -i "mitochondria" $DB > tmp.mitochondria.txt
	grep -i "mitochondri" $DB > tmp.mitochondri.txt

	>sp|Q0DF13|SDH8A_ORYSJ Succinate dehydrogenase subunit 8A, mitochondrila OS=Oryza sativa subsp. japonica GN=SDH8A PE=3 SV=2

http://www.uniprot.org/uniprot/Q0DF13  
Succinate dehydrogenase subunit 8A, mitochondrila  
*should be * 
Succinate dehydrogenase subunit 8A, mitochondrial  

----------

## Results & Discussion

----------

## References
- [Swiss-Prot](https://ja.wikipedia.org/wiki/Swiss-Prot)

----------
