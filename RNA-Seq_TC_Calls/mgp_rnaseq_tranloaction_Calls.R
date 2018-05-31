#############################################
#Author: Michael Bauer
#file: mmrf_translocation_Calls.R
#input: table of salmon expression values
#Date: 02/20/2018
#############################################
library(RColorBrewer)

genes<- c("SULF2","CCND2","PTP4A3","USP49","ISL2","CCND1","MAFA","MAF","MAFB","NSD2","ITGB7","FGFR3","NUAK1","WHSC1","CCND3")
#pairs<- data.frame(P1=c("FGFR3","CCND3","MAF","MAF","CCND1"),P2=c("WHSC1","USP49","MAFB","MAFA","CCND2"),cut1=c(13,15,13,13,15),cut2=c(14,0,12,11,0), TCG=c(4,6,20,8,11), stringsAsFactors = F)
pairs<- data.frame(P1=c("FGFR3","WHSC1","CCND3","MAF","MAFB","MAFA","CCND1"),cut=c(13,14,15,13,12,11,15), TCG=c(4,4,6,16,20,8,11), stringsAsFactors = F)
interest_genes<-id2name[id2name$gene_name %in% c("SULF2","CCND2","PTP4A3","USP49","ISL2","CCND1","MAFA","MAF","MAFB","NSD2","ITGB7","FGFR3","NUAK1","WHSC1","CCND3"),]

setwd("[WORKING DIRECTORY]")
mmrf_data <- read.table("[RNASEQ_log2NormalizedExpressionData.csv]", row.names = 1, header = TRUE, stringsAsFactors = FALSE, sep = ",")

data<-mmrf_data[rownames(mmrf_data) %in% genes,]
tdata<-t(data)

annot<-data.frame(sample=colnames(data),TGROUP=0)

for (row in 1:nrow(pairs)){
  p1   <- pairs[row, "P1"]
  cut <- pairs[row, "cut"]
  tc   <- pairs[row, "TCG"]
  print(p1)
  annot$TGROUP[(tdata[,p1] > cut & annot$TGROUP==0)]<-tc
}

mdata<-merge(tdata,annot,by.x="row.names",by.y="sample")
#gdata<-read.csv("dfci_groups.csv", stringsAsFactors = F)
  mdata$TGROUP<-levels(factor(annot$TGROUP))
(myColors <-
    with(annot,
         data.frame(TGROUP = levels(factor(annot$TGROUP)),
                    color = I(brewer.pal(7, name = 'Set1'))))) 


plot(WHSC1~FGFR3,mdata,xlab="FGFR3",ylab="WHSC1",col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="bottomright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(CCND2~CCND1,mdata,xlab="CCND1",ylab="CCND2", col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="topright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(ISL2~CCND1,mdata,xlab="CCND1",ylab="ISL2", col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="topright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(PTP4A3~CCND2,mdata,xlab="CCND2",ylab="PTP4A3", col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="topright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(SULF2~CCND2,mdata,xlab="CCND2",ylab="SULF2",col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="topright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(USP49~CCND3,mdata,xlab="CCND3",ylab="USP49", col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="bottomright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(NUAK1~ITGB7,mdata,xlab="ITGB7",ylab="NUAK1", col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="bottomright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(MAFA~MAF,mdata,xlab="MAF",ylab="MAFA", col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="topright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)

plot(MAFB~MAF,mdata,xlab="MAF",ylab="MAFB", col=myColors$color[match(mdata$TGROUP,myColors$TGROUP)], pch=16,cex=.9, xlim=c(1,20), ylim=c(1,20))
legend(x="bottomright", col=myColors$color, pch=16, legend =as.character(myColors$TGROUP), cex = 0.5)
