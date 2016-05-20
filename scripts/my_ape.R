
# Set Working Directory
#setwd("~/projects/uniprot_sprot/")

#system("zgrep '^>' data/uniprot_sprot.fasta.gz > data/uniprot_sprot.fasta.header.txt")

myfile <- "data/parse_sprot.txt.gz"; annot <- read.delim(myfile, header = FALSE, quote = "", stringsAsFactors = FALSE)
annot[,3] <- apply(as.matrix(annot[, 3]), MARGIN=c(1,2), function(x) paste(unlist(strsplit(x, split=" "))[1:2], collapse=" ") )[,1]
annot[,4] <- apply(as.matrix(annot[, 4]), MARGIN=c(1,2), function(x) paste(unlist(strsplit(x, split=" ; "))[1:2], collapse="; ") )[,1]
annot <- apply(cbind(annot[,1], annot[,4], annot[,3]), 1, paste, collapse="; ")

#myfile <- "data/uniprot_sprot.fasta.header.txt"; annot <- read.delim(myfile, header = FALSE, quote = ""); annot <- annot[,1]

# Loading package ape
library(ape); #ls("package:ape"); #install.packages("ape"); library(help=ape)

# draw trees
#pdf("tree.pdf", pointsize=15, width=15, height=9)
for(myfile in dir(path="data", pattern="\\.fasttree$", full.names=TRUE)){
print(myfile)
tre = read.tree(myfile)

x <- tre$tip.label[1] # "sp|P31937|3HIDH_HUMAN"
tre$tip.label = apply(as.matrix(tre$tip.label), MARGIN=c(1,2), function(x) annot[ grep(pattern=unlist(strsplit(x, split="\\|"))[3], x=annot) ] )
#tre$tip.label = apply(as.matrix(tre$tip.label), MARGIN=c(1,2), function(x) paste(unlist(strsplit(annot[grep(pattern=unlist(strsplit(x, split="\\|"))[3], x=annot[,1]), 4], split=" ; "))[1:3], collapse=";") )

write.tree(tre, file=paste0(myfile,".tre"))

par(mfcol=c(1,1), mgp=c(1.7, 0.5, 0), mar=c(1, 0.5, 1, 0.8), cex=0.8) # mar=c(底左上右)
plot.phylo(tre, type="phylogram", use.edge.length=TRUE, show.node.label=TRUE, font=3)
add.scale.bar(x=0.01, y=0.7)
legend("topleft", legend=myfile, box.lty=0)
}
#dev.off()

