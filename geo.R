library(GEOquery)
my_id <- "GSE17891"
gse_la <- getGEO(my_id)

length(gse_la)

gse <- gse_la[[2]]

pData(gse) ## print the sample information
fData(gse) ## print the gene annotation
exprs(gse) ## print the expression data

summary(exprs(gse))
View(gse)
exprs(gse) <- log2(exprs(gse))
boxplot(exprs(gse), outline=FALSE)

library(dplyr)

sampleInfo <- pData(gse)
View(sampleInfo)

library(ggplot2)
library(readr)
