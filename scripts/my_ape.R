
# Set Working Directory
#setwd("~/projects/uniprot_sprot/")

system("zgrep '^>' data/uniprot_sprot.fasta.gz > data/uniprot_sprot.fasta.header.txt")

annot <- read.delim("data/fasta_header.txt", header = FALSE, quote = "")
annot <- annot[,1]

# Loading package ape
library(ape); #ls("package:ape"); #install.packages("ape"); library(help=ape)

# draw trees
pdf("tree.pdf", pointsize=15, width=15, height=9)
for(myfile in dir(path="data", pattern="\\.fasttree$", full.names=TRUE)){
print(myfile)
tre = read.tree(myfile)

tre$tip.label = apply(as.matrix(tre$tip.label), MARGIN=c(1,2), function(x) annot[ grep(pattern=unlist(strsplit(x, split="\\|"))[2], x=annot) ] )
write.tree(tre, file=paste0(myfile,".tre"))

par(mfcol=c(1,1), mgp=c(1.7, 0.5, 0), mar=c(1, 0.5, 1, 0.8), cex=0.8) # mar=c(底左上右)
plot.phylo(tre, type="phylogram", use.edge.length=TRUE, show.node.label=TRUE, font=3)
add.scale.bar(x=0.01, y=0.7)
legend("topleft", legend=myfile, box.lty=0)
}
dev.off()



