cat("\n  This R script analyzes multiple FASTA format sequences.\n\n")

# Set Working Directory
#setwd("~/projects/uniprot_sprot/")

# Loading seqinr package
library(seqinr)

# Reading sequence data into R
ld <- read.fasta(file = "data/uniprot_sprot.fasta.gz", seqtype = c("AA"))

# Indexing all elements that match pattern
i <- grep(pattern="Homo.sapiens", x=getAnnot(ld), ignore.case=TRUE); ld <- ld[i]

# Writing sequence data out as a FASTA file
write.fasta(sequences=ld, names=getName(ld), file.out="analysis/sequence.fasta")

cat("# How many sequences\n")
length(ld)

cat("# Length of sequences\n")
len <- sapply(ld, length); summary(len)

# Exploring Data Visually
hist(len, main = "Histogram", xlab = "Length of sequences")

cat("# Protein sequence information\n")
AAstat(ld[[2]], plot = TRUE)

# Print R version and packages
sessionInfo()
