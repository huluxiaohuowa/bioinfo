exp <- matrix(rnorm(300), nrow = 30, ncol = 10)

View(exp)

exp[1:15, 1:5] <- exp[
    1:15, 1:5
] + matrix(
    rnorm(75, mean = 4), nrow = 15, ncol = 5
)
exp[16:30, 6:10] <- exp[16:30, 6:10] + matrix(rnorm(75,mean = 3), nrow = 15, ncol = 5)

exp <- round(exp, 2)
colnames(exp) <- paste("Sample", 1:10, sep = "")
rownames(exp) <- paste("Gene", 1:30, sep = "")
head(exp)

library(pheatmap)
ph <- pheatmap(exp)
ph$tree_row$order

ph$tree_col$order

ph_exp <- exp[
    ph$tree_row$order, ph$tree_col$order
]

ph_exp[1:4, 1:4] 
ph_exp
View(ph)
