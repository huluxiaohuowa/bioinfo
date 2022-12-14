df1 <- read.table(
    "data/GSE211669/GSE211669_TMM.txt",
    header = TRUE,
    sep = "\t"
)

df3 <- read.table(
    "data/GSE209964_raw.txt",
    header = TRUE,
    sep = "\t"
)
library("tibble")
df1 <- as_tibble(df1)
df3 <- as_tibble(df3)

library(GEOquery)

gse_la <- getGEO(
    GSE211669,
    destdir = "data/"
)
gse_la2 <- getGEO(
    "GSE209964",
    destdir = "data/"
)

pdata1 <- pData(gse_la[[1]])
pdata2 <- pData(gse_la[[2]])
pdata3 <- pData(gse_la2[[1]])

exprs(gse_la[[2]])

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


table(pdata1["tissue:ch1"])
table(pdata2["tissue:ch1"])
table(pdata3["tissue:ch1"])

temp <- seq(
    from = 8,
    by = 9,
    length.out = nrow(df3)
)

df4 <- df3 %>% mutate(
    df3,
    GeneID = unlist(strsplit(
        GeneID,
        split = "\\|"
    ))[temp]
)

table(df4["GeneID"])

tdf1 <- filter(df1, GeneID == "BCL2A1")
tdf2 <- filter(df4, GeneID == "BCL2A1")

write.table(
    tdf1,
    file = "data/tdf1.tsv",
    sep = "\t"
)

write.table(
    tdf2,
    file = "data/tdf2.tsv",
    sep = "\t"
)

tdf1 <- read.table(
    "data/tdf1.tsv",
    sep = "\t"
)

tdf2 <- read.table(
    "data/tdf2.tsv",
    sep = "\t"
)

library(ggplot2)
test_df <- read.table(
    "data/test.tsv",
    sep = "\t",
    header = TRUE
)
ggplot(
    data = test_df,
    aes(
        x = group,
        y = value,
        color = group
    )
) +
    geom_jitter()

pdata1_sts <- filter(
    pdata1,
    pdata1["survival group:ch1"] == "STS",
)

pdata1_mts <- filter(
    pdata1,
    pdata1["survival group:ch1"] == "MTS",
)

pdata1_lts <- filter(
    pdata1,
    pdata1["survival group:ch1"] == "LTS",
)

pdata2_lts <- filter(
    pdata2_1,
    pdata2_1["survival group:ch1"] == "LTS"
)

pdata1_lts <- select(
    pdata1_lts,
    geo_accession,
    "survival group:ch1",
    "tissue:ch1"
)

pdata2_lts <- select(
    pdata2_lts,
    geo_accession,
    "survival group:ch1",
    "tissue:ch1"
)

pdata12_lts <- rbind(pdata1_lts, pdata2_lts)

pdata12_sts <- select(
    pdata1_sts,
    geo_accession,
    "survival group:ch1",
    "tissue:ch1"
)

pdata12_mts <- select(
    pdata1_mts,
    geo_accession,
    "survival group:ch1",
    "tissue:ch1"
)
rownames(pdata12_sts)

select(tdf1, rownames(pdata12_sts))

library(xlsx)

write.xlsx(
    pdata12_sts,
    "data/pdata1_2.xlsx",
    sheetName = "STS",
    append = TRUE
)

write.xlsx(
    pdata12_mts,
    "data/pdata1_2.xlsx",
    sheetName = "MTS",
    append = TRUE
)

write.xlsx(
    pdata12_lts,
    "data/pdata1_2.xlsx",
    sheetName = "LTS",
    append = TRUE
)
