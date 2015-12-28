----------

Haruo Suzuki  
Last Update: 2015-12-28  

----------

# UniProtKB/Swiss-Prot project
Project started 2015-10-12.

Protein sequences were retrieved from UniProtKB/Swiss-Prot protein sequence database.
As of 2015-10-26, there were 549646 entries in the FASTA file.

## Project directories

    uniprot_sprot/
     README.md: project documentation 
     data/: contains sequence data in FASTA format
     scripts/: contains R and Shell scripts
     analysis/: contains results of data analyses

## Data

UniProtKB/Swiss-Prot protein sequence database was downloaded on 2015-10-26 from <http://www.ebi.ac.uk/uniprot/database/download.html> into `data/` and decompressed, using:  

    nohup wget ftp://ftp.ebi.ac.uk/pub/databases/uniprot/knowledgebase/uniprot_sprot.fasta.gz &
    gunzip -c uniprot_sprot.fasta.gz > uniprot_sprot.fasta

## Scripts

The shell script `scripts/run.sh` automatically carries out the entire steps: creating subdirectories, downloading data, and inspecting data.

## Usage

In the `uniprot_sprot/` directory, we run the shell script `scripts/run.sh` with:

    bash scripts/run.sh > log.txt 2>&1 &

----------

## Steps

### Inspecting Data

    DB=data/2015-10-26/uniprot_sprot.fasta.gz

    ls -lh $DB
    zgrep "^>" $DB | wc -l
    zgrep "^>" $DB | head -n 3

	>sp|Q6UY62|Z_SABVB RING finger protein Z OS=Sabia mammarenavirus (isolate Human/Brasil/SPH114202/1990) GN=Z PE=1 SV=1
	>sp|P08105|Z_SHEEP Putative uncharacterized protein Z OS=Ovis aries PE=4 SV=1

- UniProtKB [FASTA headers](http://www.uniprot.org/help/fasta-headers)

	>db|UniqueIdentifier|EntryName ProteinName OS=OrganismName[ GN=GeneName]PE=ProteinExistence SV=SequenceVersion

GeneName is the first gene name of the UniProtKB entry. If there is no gene name, OrderedLocusName or ORFname, the GN field is not listed.

- Perlワンライナー覚書 - Qiita http://qiita.com/tossh/items/f8d448c0c039f68c0ea3
- 正規表現・ワイルドカード http://www.cudo29.org/regexp.html 最短マッチ +?
- 正規表現について-正規表現サンプル集 http://www.megasoft.co.jp/mifes/seiki/about.html 最長一致と最短一致

    zgrep "^>" $DB | perl -ne '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; print "$1 | $2 | $3\n";' | head

#### Most abundant organisms

    zgrep "^>" $DB | perl -ne '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; print "$3\n";' | sort | uniq -c | sort -nr | head -20 | sed s/^/$'\t'/g

	20196 Homo sapiens
	16727 Mus musculus
	14246 Arabidopsis thaliana
	7937 Rattus norvegicus
	6720 Saccharomyces cerevisiae (strain ATCC 204508 / S288c)
	5995 Bos taurus
	5120 Schizosaccharomyces pombe (strain 972 / ATCC 24843)
	4433 Escherichia coli (strain K12)
	4185 Bacillus subtilis (strain 168)
	4131 Dictyostelium discoideum
	3629 Caenorhabditis elegans
	3426 Oryza sativa subsp. japonica
	3401 Xenopus laevis
	3256 Drosophila melanogaster
	2955 Danio rerio
	2272 Gallus gallus
	2219 Pongo abelii
	2086 Mycobacterium tuberculosis (strain ATCC 25618 / H37Rv)
	2028 Escherichia coli O157:H7
	1890 Mycobacterium tuberculosis (strain CDC 1551 / Oshkosh)

    zgrep "^>" $DB | perl -ne '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; $tmp = $3; $tmp =~ s/ /./g; print "$tmp\n";' | sort | uniq -c | sort -nr | head -20 | awk '{print $2,":",$1}'
    # Word clouds http://www.wordle.net/advanced Font=Steelfish; Layout=Horizontal; Color=Firenze

[![](https://github.com/haruosuz/uniprot_sprot/blob/master/images/wordle_sprot_OS.png)]()
[Word clouds](http://www.wordle.net/advanced) representing the 20 most abundant organisms in UniProtKB/Swiss-Prot. The font size of each organism is proportional to its number in the database.

#### Most abundant functions

    zgrep "^>" $DB | perl -nle '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; print "$2";' | sort | uniq -c | sort -nr | head -20 | sed s/^/$'\t'/g

	1689 Cytochrome b
	 868 50S ribosomal protein L2
	 866 30S ribosomal protein S19
	 865 DNA ligase
	 864 50S ribosomal protein L14
	 860 30S ribosomal protein S7
	 855 DNA-directed RNA polymerase subunit beta
	 855 30S ribosomal protein S8
	 843 30S ribosomal protein S15
	 842 30S ribosomal protein S4
	 841 30S ribosomal protein S12
	 839 50S ribosomal protein L1
	 831 Ribosomal RNA small subunit methyltransferase H
	 829 50S ribosomal protein L11
	 823 30S ribosomal protein S10
	 822 Enolase
	 821 50S ribosomal protein L22
	 817 50S ribosomal protein L18
	 816 DNA-directed RNA polymerase subunit beta'
	 813 50S ribosomal protein L3

    zgrep "^>" $DB | perl -nle '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; $tmp = $2; $tmp =~ s/ /./g; print "$tmp";' | sort | uniq -c | sort -nr | head -20 | awk '{print $2,":",$1}'
    # Word clouds http://www.wordle.net/advanced Font=Steelfish; Layout=Horizontal; Color=Firenze

![](https://github.com/haruosuz/uniprot_sprot/blob/master/images/wordle_sprot_FUN.png)
[Word clouds](http://www.wordle.net/advanced) representing the 20 most abundant functions in UniProtKB/Swiss-Prot. The font size of each function is proportional to its number in the database.

#### Count keywords in uniprot_sprot.fasta
キーワードの計数

##### each keyword

	grep -i ">.*mitochondri" $DB | wc -l # 8427
	grep -i ">.*chloroplast\|plastid" $DB | wc -l # 8339

	grep -i ">.*\(virus\|phage\|plasmid\)" $DB | wc -l # Mobile Genetic Elements # 17320
	grep -i ">.*\(Bifidobacterium\|Enterococcus\|Lactococcus\|Lactobacillus\|Leuconostoc\|Pediococcus\)" $DB | wc -l # lactic acid bacteria (LAB) # 8051

##### multiple keywords

	DB=uniprot_sprot.fasta
	for REGEXP in ">.*Cyanobacteria" ">.*mitochondri" ">.*chloroplast\|plastid" ">.*\(virus\|phage\|plasmid\)" ">.*\(Bifidobacterium\|Enterococcus\|Lactococcus\|Lactobacillus\|Leuconostoc\|Pediococcus\)"; do echo -n \"$REGEXP\"' '; cat $DB | grep -i "$REGEXP" | wc -l; done

	">.*Cyanobacteria"        2
	">.*mitochondri"     8427
	">.*chloroplast\|plastid"     8339
	">.*\(virus\|phage\|plasmid\)"    17320
	">.*\(Bifidobacterium\|Enterococcus\|Lactococcus\|Lactobacillus\|Leuconostoc\|Pediococcus\)"     8051

##### Chloroplast\|plastid
葉緑体

	DB=uniprot_sprot.fasta
	grep -i ">.*chloroplast\|plastid" $DB | wc -l # 8339
	grep -i ">.*chloroplast" $DB | wc -l # 8128
	grep -i ">.*plastid" $DB | wc -l # 236
	grep -i ">.*chloroplast.*plastid" $DB | wc -l # 0
	grep -i ">.*plastid.*chloroplast" $DB | wc -l # 25
	# 8128 + 236 - 25 = 8339

##### Mitochondria
ミトコンドリア

	DB=uniprot_sprot.fasta
	grep -i "mitochondria" $DB > tmp.mitochondria.txt
	grep -i "mitochondri" $DB > tmp.mitochondri.txt
	diff tmp.mitochondri.txt tmp.mitochondria.txt

	>sp|Q0DF13|SDH8A_ORYSJ Succinate dehydrogenase subunit 8A, mitochondrila OS=Oryza sativa subsp. japonica GN=SDH8A PE=3 SV=2

I reported the typographical error (i.e. "mitochondrila" should be "mitochondrial") at http://www.uniprot.org/contact, and got a response  
From: "Elisabeth Gasteiger via RT" <help@uniprot.org>  
Subject: [help #108963] [uuw] typo in sp|Q0DF13|SDH8A_ORYSJ  

##### Cyanobacteria

    DIR=data/2015-10-26
    # Get Genus names of Cyanobacteria from ncbiGenomeList # 'Nostoc [Oscillatoria] [Scytonema
    ProkList=~/projects/ncbiGenomeList/data/prokaryotes.txt
    grep "Cyanobacteria" $ProkList | cut -f6 | sort -u | perl -pe 's/\n/\\|/g' # SubGroup
    grep "Cyanobacteria" $ProkList | cut -f1 | grep -v "Candidatus" | cut -d" " -f1 | perl -pe "s/[\'\[\]]//g" | sort -u > $DIR/tmp.txt
    zgrep "^>" $DIR/uniprot_sprot.fasta.gz | grep -f $DIR/tmp.txt

----------

## References
- [Swiss-Prot - Wikipedia](https://ja.wikipedia.org/wiki/Swiss-Prot)
- [Nucleic Acids Res. 2015 Jan;43(Database issue):D204-12. UniProt: a hub for protein information.](http://www.ncbi.nlm.nih.gov/pubmed/25348405)
- [Database (Oxford). 2014 Mar 12;2014:bau016. Expert curation in UniProtKB: a case study on dealing with conflicting and erroneous data.](http://www.ncbi.nlm.nih.gov/pubmed/24622611)

- [Nucleic Acids Res. 2010 Jul;38(13):4207-17. Transposases are the most abundant, most ubiquitous genes in nature.](http://www.ncbi.nlm.nih.gov/pubmed/20215432)

----------

 | sed s/^/$'\t'/g
sed s/^/$'\t'/g tmp.txt > tab.txt     # 行頭にタブを追加
