data <- read.table(
    "data/GSE211669/GSE211669_TMM.txt",
    header = TRUE,
    sep = "\t"
)

library(GEOquery)
my_id <- "GSE211669"
gse_la <- getGEO(my_id)
gse_la2 <- getGEO("GSE209964")

gse_la[[2]]
pdata1 <- pData(gse_la[[1]])
pdata2 <- pData(gse_la[[2]])
pdata3 <- pData(gse_la2[[1]])
pdata1
pdata2
pdata3

table(pdata1$source_name_ch1)
table(pdata2$source_name_ch1)

library(dplyr)

pdata2_1 <- filter(
    pdata2,
    pdata2["tissue:ch1"] != "Relapse Tumor"
)

table(pdata2["tissue:ch1"])
