library(GEOquery)
my_id <- "GSE178913"
gse_la <- getGEO(my_id)

gset <- getGEO("GSE178913", getGPL = FALSE)
class(gset[[1]])
length(gse_la)

gse <- gse_la[[1]]

sam <- pData(gse) ## the sample information
View(sam)
anno <- fData(gse) ## the gene annotation
ex <-  exprs(gse) ## the expression data
summary(exprs(gse))

View(ex)
View(gse)
summary(exprs(gse))
exprs(gse) <- log2(exprs(gse))
boxplot(exprs(gse), outline = FALSE)
View(p)
library(dplyr)

sample_info <- pData(gse)

sample_info <- dplyr::select(
    sample_info,
    source_name_ch1,
    characteristics_ch1
)

sample_info <- dplyr::rename(
    sample_info,
    group = source_name_ch1,
    patient = characteristics_ch1
)

View(sample_info)

library(readr)

library(ggrepel)

library(pheatmap)
## argument use="c" stops an error if there are any missing data points

cor_matrix <- cor(
    exprs(gse),
    use = "c"
)

pheatmap(cor_matrix) 

library(ggplot2)
suppressPackageStartupMessages()
library(ggrepel)
## MAKE SURE TO TRANSPOSE THE EXPRESSION MATRIX

pca <- prcomp(t(exprs(gse)))

## Join the PCs to the sample information
data <- cbind(
    sample_info,
    pca$x
)

ggplot(
    data,
    aes(
        x = PC1,
        y = PC2,
        col = group,
        label = paste("Patient", patient)
    )
) + geom_point() + geom_text_repel()



View(ex)

library(limma)
design <- model.matrix(
    ~0 + sample_info$group
)

colnames(design) <- c("Normal", "Tumour")
cutoff <- median(exprs(gse))
is_expressed <- exprs(gse) > cutoff
keep <- rowSums(is_expressed) > 2
table(keep)
gse <- gse[keep, ]
fit <- lmFit(exprs(gse), design)
head(fit$coefficients)
contrasts <- makeContrasts(Tumour - Normal, levels=design)
fit2 <- contrasts.fit(fit, contrasts)
fit2 <- eBayes(fit2)
topTable(fit2)
topTable(fit2, coef=1)
decideTests(fit2)
table(decideTests(fit2))
aw <- arrayWeights(exprs(gse), design)

fit <- lmFit(exprs(gse), design,
             weights = aw)
contrasts <- makeContrasts(Tumour - Normal, levels=design)
fit2 <- contrasts.fit(fit, contrasts)
fit2 <- eBayes(fit2)

anno <- fData(gse)
View(anno)

annos <- dplyr::select(
    anno,
    "Representative Public ID",
    "Gene Symbol",
    ENTREZ_GENE_ID,
    GB_ACC,
    "Representative Public ID"
)

View(fit2)

fit2$genes <- anno
topTable(fit2)
full_results <- topTable(
    fit2,
    number = Inf
)
full_results <- tibble::rownames_to_column(
    full_results,
    # "GB_ACC"
)
View(full_results)
library(ggplot2)
ggplot(full_results,aes(x = logFC, y=B)) + geom_point()

p_cutoff <- 0.05
fc_cutoff <- 1

full_results %>%  # nolint
  mutate(Significant = adj.P.Val < p_cutoff, abs(logFC) > fc_cutoff) %>% 
  ggplot(aes(x = logFC, y = B, col=Significant)) + geom_point()


library(ggrepel)
p_cutoff <- 0.05
fc_cutoff <- 1
topN <- 40

full_results %>% 
  mutate(Significant = adj.P.Val < p_cutoff, abs(logFC) > fc_cutoff ) %>% 
  mutate(Rank = 1: n(), Label = ifelse(Rank < topN, GB_ACC,"")) %>% 
  ggplot(aes(x = logFC, y = B, col=Significant,label=Label)) + geom_point() + geom_text_repel(col="black")

class(full_results)

filter(full_results, Gene.Symbol == "Bcl2a1")

write.table(
    full_results,
    file = "results.csv",
    quote = FALSE,
    sep = "\t"
)

write.table(
    anno,
    file = "anno.csv",
    quote = FALSE,
    sep = "\t"
)
