library(DESeq2); library(ggplot2)
options(stringsAsFactors=F)


SAVE_IMAGE = TRUE


# load data
# datExpr <- read.csv(file="./DATA/GSE77460_allCount_reduced.csv", header=T, row.names=1)
datExpr <- read.csv(file="./DATA/GSE77460_allCount.csv", header=T, row.names=1)
datMeta <- read.csv(file="./DATA/GSE_META.csv", header=T, row.names=1)

# normalization
datExpr <- vst(round(as.matrix(datExpr)))

pca=prcomp(datExpr, scale=T, center=T)      # principal component analysis
pcadata=data.frame(scale(pca$rotation))            
pcadata$Time <- datMeta$Age[match(row.names(pcadata), row.names(datMeta))]
pcadata$Condition <- datMeta$Condition[match(row.names(pcadata), row.names(datMeta))]

if (SAVE_IMAGE) {
    png("samplePCA.png", width=1920, height=1080)
}
print(ggplot(pcadata) 
      + geom_point(aes(PC1, PC2, col=Time, shape=Condition), size=10) 
      + ggtitle("Sample PCA") 
      + labs(x=paste("PC1 (", 
                     as.character(summary(pca)$importance["Proportion of Variance", "PC1"] * 100),
                     "% explained variance)", collapse=""),
             y=paste("PC2 (", 
                     as.character(summary(pca)$importance["Proportion of Variance", "PC2"] * 100),
                     "% explained variance)", collapse="")
             )
      + theme(text = element_text(size=60),
              panel.grid.major = element_blank(), 
              panel.grid.minor = element_blank(), 
              panel.background = element_blank(), 
              axis.line = element_line(colour="black"),
              legend.key.size = unit(5, 'lines')
              )
      )
if (SAVE_IMAGE) {
    dev.off()
}
