#usage:
#echo makeGraph.r <ploidy> <ratio.txt> <BAF.txt> <ID>

args <- commandArgs(trailingOnly=TRUE)

dataTable <-read.table(args[2], header=TRUE);

ratio<-data.frame(dataTable)
ploidy <- type.convert(args[1])

maxLevelToPlot <- 3
for (i in c(1:length(ratio$Ratio))) {
	if (ratio$Ratio[i]>maxLevelToPlot) {
		ratio$Ratio[i]=maxLevelToPlot;
	}
}

#added this -CA

lesser_p_2 = t.test(ratio$Ratio[ratio$Chromosome == 2 & ratio$Ratio != -1]*2, mu=1.25, alternative="less")$p.value
greater_p_2 = t.test(ratio$Ratio[ratio$Chromosome == 2 & ratio$Ratio != -1]*2, mu=2.75, alternative="greater")$p.value
lesser_p_10 = t.test(ratio$Ratio[ratio$Chromosome == 10 & ratio$Ratio != -1]*2, mu=1.25, alternative="less")$p.value
greater_p_10 = t.test(ratio$Ratio[ratio$Chromosome == 10 & ratio$Ratio != -1]*2, mu=2.75, alternative="greater")$p.value

t = c()
for(i in 1:22)
{
	t = c(t, sd(ratio$Ratio[ratio$Ratio != -1 & ratio$Chromosome == i]))
}
t = median(t)

passfilter = 0
if(((lesser_p_10 > 0.1 & greater_p_10 > 0.1) | (lesser_p_2 > 0.1 & greater_p_2 > 0.1)) &
	t <= 0.3)
{
	png(filename = paste("good/",args[4],".png",sep = ""), width = 1180, height = 1180,
    	units = "px", pointsize = 20, bg = "white", res = NA)
	passfilter = "PASS"
} else
{
	png(filename = paste("bad/",args[4],".png",sep = ""), width = 1180, height = 1180,
    	units = "px", pointsize = 20, bg = "white", res = NA)
	passfilter = "FAIL"
}
if(lesser_p_2 < 0.001)
{
	lesser_p_2 = 0.001
}

if(lesser_p_10 < 0.001)
{
	lesser_p_10 = 0.001
}

if(greater_p_2 < 0.001)
{
	greater_p_2 = 0.001
}

if(greater_p_10 < 0.001)
{
	greater_p_10 = 0.001
}
write.table(t(c(args[4], lesser_p_2, greater_p_2, lesser_p_10, greater_p_10,t,passfilter)), file="pvalues.txt", append=T, row.names=F, col.names=F, sep="\t", quote=F)

plot(1:10)
op <- par(mfrow = c(5,5))

#ended this -CA




for (i in c(1:22,'X','Y')) {
	tt <- which(ratio$Chromosome==i)
	if (length(tt)>0) {
	 plot(ratio$Start[tt],ratio$Ratio[tt]*ploidy,ylim = c(0,maxLevelToPlot*ploidy),xlab = paste ("position, chr",i),ylab = "normalized copy number profile",pch = ".",col = colors()[88])
	 tt <- which(ratio$Chromosome==i  & ratio$CopyNumber>ploidy )
	 points(ratio$Start[tt],ratio$Ratio[tt]*ploidy,pch = ".",col = colors()[136])
	
	tt <- which(ratio$Chromosome==i  & ratio$Ratio==maxLevelToPlot & ratio$CopyNumber>ploidy)	
	points(ratio$Start[tt],ratio$Ratio[tt]*ploidy,pch = ".",col = colors()[136],cex=4)
	 
	tt <- which(ratio$Chromosome==i  & ratio$CopyNumber<ploidy & ratio$CopyNumber!= -1)
	 points(ratio$Start[tt],ratio$Ratio[tt]*ploidy,pch = ".",col = colors()[461])
	 tt <- which(ratio$Chromosome==i)
	 
	 #UNCOMMENT HERE TO SEE THE PREDICTED COPY NUMBER LEVEL:
	 #points(ratio$Start[tt],ratio$CopyNumber[tt], pch = ".", col = colors()[24],cex=4)
	 
	}
	tt <- which(ratio$Chromosome==i)
	
	#UNCOMMENT HERE TO SEE THE EVALUATED MEDIAN LEVEL PER SEGMENT:
	#points(ratio$Start[tt],ratio$MedianRatio[tt]*ploidy, pch = ".", col = colors()[463],cex=4)
	
}

dev.off()

if (length(args)>5) {
	dataTable <-read.table(args[3], header=TRUE);
	BAF<-data.frame(dataTable)

	png(filename = paste(args[3],".png",sep = ""), width = 1180, height = 1180,
	    units = "px", pointsize = 20, bg = "white", res = NA)
	plot(1:10)
	op <- par(mfrow = c(5,5))

	for (i in c(1:22,'X','Y')) {
	    tt <- which(BAF$Chromosome==i)
	    if (length(tt)>0){
		lBAF <-BAF[tt,]
		plot(lBAF$Position,lBAF$BAF,ylim = c(-0.1,1.1),xlab = paste ("position, chr",i),ylab = "BAF",pch = ".",col = colors()[1])

		tt <- which(lBAF$A==0.5)		
		points(lBAF$Position[tt],lBAF$BAF[tt],pch = ".",col = colors()[92])
		tt <- which(lBAF$A!=0.5 & lBAF$A>=0)
		points(lBAF$Position[tt],lBAF$BAF[tt],pch = ".",col = colors()[62])
		tt <- 1
		pres <- 1

		if (length(lBAF$A)>4) {
			for (j in c(2:(length(lBAF$A)-pres-1))) {
				if (lBAF$A[j]==lBAF$A[j+pres]) {	
					tt[length(tt)+1] <- j 
				}
			}
			points(lBAF$Position[tt],lBAF$A[tt],pch = ".",col = colors()[24],cex=4)
			points(lBAF$Position[tt],lBAF$B[tt],pch = ".",col = colors()[24],cex=4)	
		}

		tt <- 1
		pres <- 1
		if (length(lBAF$FittedA)>4) {
			for (j in c(2:(length(lBAF$FittedA)-pres-1))) {
				if (lBAF$FittedA[j]==lBAF$FittedA[j+pres]) {	
					tt[length(tt)+1] <- j 
				}
			}
			points(lBAF$Position[tt],lBAF$FittedA[tt],pch = ".",col = colors()[463],cex=4)
			points(lBAF$Position[tt],lBAF$FittedB[tt],pch = ".",col = colors()[463],cex=4)	
		}

	   }

	}
	dev.off()

}