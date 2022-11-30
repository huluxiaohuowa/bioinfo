df1 <- read.table(
    "data/percent_B.tsv",
    header = TRUE,
    sep = "\t",
    stringsAsFactors = FALSE
)

df2 <- read.table(
    "data/percent_p.tsv",
    header = TRUE,
    sep = "\t",
    stringsAsFactors = FALSE
)

library("ggplot2")
p <- ggplot(
        df1,
        aes(x = Group, y = Percent, fill = Expresion_level)
    ) +
    geom_bar(stat = "identity", colour = "black") +
    guides(fill = guide_legend(reverse = TRUE)) +
    scale_fill_brewer(palette = "Pastel1") +
    theme(
        text = element_text(size = 40),
        axis.text = element_text(size = 33)
    )
ggsave(p, filename = "plot_B.png")

p <- ggplot(
    df2,
    aes(
        x = Group,
        y = Percent,
        fill = Expresion_level
    )
) +
    geom_bar(stat = "identity", colour = "black") +
    guides(fill = guide_legend(reverse = TRUE)) +
    scale_fill_brewer(palette = "Pastel1") +
    theme(
        text = element_text(size = 40),
        axis.text = element_text(size = 33)
    )
ggsave(p, filename = "plot_p.png")
