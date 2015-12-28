----------

Haruo Suzuki  
Last Update: 2015-12-28  

----------

# UniProtKB/Swiss-Prot project
Project started 2015-10-12.

Protein sequences were retrieved from UniProtKB/Swiss-Prot protein sequence database.
As of 2015-10-26, there were 549646 entries in the FASTA file.
The most abundant organism was 'Homo sapiens' (20196) followed by Mus musculus (16727) and Arabidopsis thaliana (14246).
The most abundant function was 'Cytochrome b' (1689) followed by 50S and 30S ribosomal proteins.

## Project directories

    uniprot_sprot/
     README.md: project documentation 
     data/: contains sequence data in FASTA format
     scripts/: contains Shell scripts
     analysis/: contains results of data analyses
     images/: contains images produced by Word clouds

## Data

Data downloaded 2015-10-26 and 2015-12-27 from <http://www.ebi.ac.uk/uniprot/database/download.html> into `data/`:

    data/2015-10-26/uniprot_sprot.fasta.gz
    data/2015-12-27/uniprot_sprot.fasta.gz

----------

## Steps

### Creating directories

    mkdir -p uniprot_sprot/{data,scripts,analysis/results-$(date +%F)}

### Downloading data

Data were downloaded on 2015-10-26 and 2015-12-27 and decompressed, using:  

    URL=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
    URL=ftp://ftp.ebi.ac.uk/pub/databases/uniprot/knowledgebase/uniprot_sprot.fasta.gz
    nohup wget $URL &	# 2015-10-26
    wget -b $URL	# 2015-12-27
    gunzip -c uniprot_sprot.fasta.gz > uniprot_sprot.fasta

### Inspecting Data

    # Commands
    find data -name "uniprot_sprot.fasta.gz" | xargs ls -lh
	# Results
	-rw-r--r--  1 haruo  staff    79M Oct 26 10:00 data/2015-10-26/uniprot_sprot.fasta.gz
	-rw-r--r--  1 haruo  staff    79M Dec 27 11:46 data/2015-12-27/uniprot_sprot.fasta.gz

    # Commands
    find data -name "uniprot_sprot.fasta.gz" | xargs zgrep -c '^>'
	# Results
	data/2015-10-26/uniprot_sprot.fasta.gz:549646
	data/2015-12-27/uniprot_sprot.fasta.gz:550116

    # Commands
    DB=data/2015-10-26/uniprot_sprot.fasta.gz
    DB=data/2015-12-27/uniprot_sprot.fasta.gz
    zgrep '^>' $DB | wc -l
    zgrep '^>' $DB | head -n 3

	# Examples
	>sp|Q6IUF9|Z_MACHU RING finger protein Z OS=Machupo virus GN=Z PE=1 SV=1
	>sp|P08105|Z_SHEEP Putative uncharacterized protein Z OS=Ovis aries PE=4 SV=1

	>db|UniqueIdentifier|EntryName ProteinName OS=OrganismName[ GN=GeneName]PE=ProteinExistence SV=SequenceVersion

- UniProtKB [FASTA headers](http://www.uniprot.org/help/fasta-headers)  
GeneName is the first gene name of the UniProtKB entry. If there is no gene name, OrderedLocusName or ORFname, the GN field is not listed.

- Perlワンライナー覚書 - Qiita http://qiita.com/tossh/items/f8d448c0c039f68c0ea3
- 正規表現・ワイルドカード http://www.cudo29.org/regexp.html 最短マッチ +?
- 正規表現について-正規表現サンプル集 http://www.megasoft.co.jp/mifes/seiki/about.html 最長一致と最短一致

        zgrep '^>' $DB | perl -ne '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; print "$1 | $2 | $3\n";' | head

#### Most abundant organisms
配列の由来する生物の計数

    # Commands
    zgrep '^>' $DB | perl -ne '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; print "$3\n";' | sort | uniq -c | sort -nr | head -20 | sed s/^/$'\t'/g

	# Results
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

![](https://github.com/haruosuz/uniprot_sprot/blob/master/images/wordle_sprot_OS.png)

[Word clouds](http://www.wordle.net/advanced) representing the 20 most abundant organisms in UniProtKB/Swiss-Prot. The font size of each organism is proportional to its number in the database.
At [Word clouds](http://www.wordle.net/advanced), pasted weighted words, clicked the "Go" button, and selected from the menu (Font=Steelfish; Layout=Horizontal; Color=Firenze). The weighted words were generated with the following command:

    zgrep '^>' $DB | perl -ne '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; $tmp = $3; $tmp =~ s/ /./g; print "$tmp\n";' | sort | uniq -c | sort -nr | head -20 | awk '{print $2,":",$1}'

#### Most abundant functions
配列の機能の計数

    # Commands
    zgrep '^>' $DB | perl -nle '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; print "$2";' | sort | uniq -c | sort -nr | head -20 | sed s/^/$'\t'/g

	# Results
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

![](https://github.com/haruosuz/uniprot_sprot/blob/master/images/wordle_sprot_FUN.png)

[Word clouds](http://www.wordle.net/advanced) representing the 20 most abundant functions in UniProtKB/Swiss-Prot. The font size of each function is proportional to its number in the database.
At [Word clouds](http://www.wordle.net/advanced), pasted weighted words, clicked the "Go" button, and selected from the menu (Font=Steelfish; Layout=Horizontal; Color=Firenze). The weighted words were generated with the following command:

    zgrep '^>' $DB | perl -nle '$_=~/^>(\S+) (.+) OS=(.+?) (GN|PE)=/; $tmp = $2; $tmp =~ s/ /./g; print "$tmp";' | sort | uniq -c | sort -nr | head -20 | awk '{print $2,":",$1}'

#### Count how many lines match a pattern
ミトコンドリア (mitochondri)、
葉緑体 (chloroplast\|plastid)、
可動性遺伝因子 Mobile Genetic Elements (virus\|phage\|plasmid)、
シアノバクテリア、
乳酸菌 lactic acid bacteria (Bifidobacterium\|Enterococcus\|Lactococcus\|Lactobacillus\|Leuconostoc\|Pediococcus)
に由来する配列の計数

    # Commands
    DB=data/2015-10-26/uniprot_sprot.fasta.gz
    for PATTERN in "mitochondri" "chloroplast\|plastid" "virus\|phage\|plasmid" \
     "Bifidobacterium\|Enterococcus\|Lactococcus\|Lactobacillus\|Leuconostoc\|Pediococcus"; 
     do echo -n "$PATTERN"' '; zgrep '^>' $DB | grep -i "$PATTERN" | wc -l; done

	# Results
	mitochondri     8434
	chloroplast\|plastid     8358
	virus\|phage\|plasmid    17322
	Bifidobacterium\|Enterococcus\|Lactococcus\|Lactobacillus\|Leuconostoc\|Pediococcus     8051

##### Cyanobacteria

    # Commands
    # get genus names of Cyanobacteria from ncbiGenomeList # 'Nostoc [Oscillatoria] [Scytonema
    ProkList=~/projects/ncbiGenomeList/data/prokaryotes.txt
    grep "Cyanobacteria" $ProkList | cut -f6 | sort -u | perl -pe 's/\n/\\|/g' # SubGroup
    grep "Cyanobacteria" $ProkList | cut -f1 | grep -v "Candidatus" | \
     cut -d" " -f1 | perl -pe "s/[\'\[\]]//g" | sort -u > data/genusCyanobacteria.txt

    # count genus names of Cyanobacteria in uniprot_sprot.fasta
    DB=data/2015-10-26/uniprot_sprot.fasta.gz
    DB=data/2015-12-27/uniprot_sprot.fasta.gz
    zgrep '^>' $DB | grep -f data/genusCyanobacteria.txt | wc -l

	# Results
	13839	# 2015-10-26
	13841	# 2015-12-27

##### Mitochondria

    # Commands
    DIR=data/2015-10-26
    zgrep '^>' $DIR/uniprot_sprot.fasta.gz | grep -i "mitochondria" > $DIR/lines.mitochondria.txt
    zgrep '^>' $DIR/uniprot_sprot.fasta.gz | grep -i "mitochondri"  > $DIR/lines.mitochondri.txt
    diff $DIR/lines.mitochondria.txt $DIR/lines.mitochondri.txt

	# Results
	>sp|Q0DF13|SDH8A_ORYSJ Succinate dehydrogenase subunit 8A, mitochondrila OS=Oryza sativa subsp. japonica GN=SDH8A PE=3 SV=2

I reported the typographical error (i.e. "mitochondrila" should be "mitochondrial") at http://www.uniprot.org/contact, and got a response  
From: "Elisabeth Gasteiger via RT" <help@uniprot.org>  
Subject: [help #108963] [uuw] typo in sp|Q0DF13|SDH8A_ORYSJ  
Date: October 12, 2015 at 15:27:03 GMT+9  

----------

## References
- [Swiss-Prot - Wikipedia](https://ja.wikipedia.org/wiki/Swiss-Prot)
- [Nucleic Acids Res. 2015 Jan;43(Database issue):D204-12. UniProt: a hub for protein information.](http://www.ncbi.nlm.nih.gov/pubmed/25348405)
- [Database (Oxford). 2014 Mar 12;2014:bau016. Expert curation in UniProtKB: a case study on dealing with conflicting and erroneous data.](http://www.ncbi.nlm.nih.gov/pubmed/24622611)

- [Nucleic Acids Res. 2010 Jul;38(13):4207-17. Transposases are the most abundant, most ubiquitous genes in nature.](http://www.ncbi.nlm.nih.gov/pubmed/20215432)

----------

