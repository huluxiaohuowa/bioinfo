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

sample_info <- pData(gse)

sample_info <- dplyr::select(
    sampleInfo,
    source_name_ch1,
    characteristics_ch1
)

sample_info <- dplyr::rename(
    sample_info,
    group = source_name_ch1,
    patient = characteristics_ch1
)

View(sample_info)

library(ggplot2)
library(readr)


library(ggrepel)

library(pheatmap)
## argument use="c" stops an error if there are any missing data points

cor_matrix <- cor(
    exprs(gse),
    use = "c"
)

pheatmap(cor_matrix) 
