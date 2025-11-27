setwd("E:/Bioteck_Project/combined result/GSE86374/cel.files")
getwd()

# Differential Expression Analysis

library(limma)

norm_data_1 <- read.csv("normalized_data_1.csv", row.names = 1)

group <- factor(c(rep("treatment",50),rep("control",10)))
design <- model.matrix(~group)
fit <- lmFit(norm_data_1,design)
fit <- eBayes(fit)
top_genes <- topTable(fit, coef = 2, number = Inf)

write.csv(top_genes, file = "DEA_result.csv")

# To get significicant differentially expresed genes

significant_genes <- top_genes[top_genes$adj.P.Val<0.05,]
write.csv(significant_genes, file = "sign_DEG.csv")

#To get upregulated and downregulated genes

library(dplyr)

input_file <- "sign_DEG.csv"
output_1 <- "upreg_gene.csv"
output_2 <- "downreg_gene.csv"

sign_genes <- read.csv(input_file, header = TRUE, stringsAsFactors = FALSE)
logFC_threshold <- 1.0
pval_threshold <- 0.05

upregulated_genes <- sign_genes%>%
  filter(logFC>logFC_threshold & adj.P.Val<pval_threshold)

downregulated_genes <- sign_genes%>%
  filter(logFC<logFC_threshold & adj.P.Val<pval_threshold)

write.csv(upregulated_genes, file = output_1, row.names = FALSE, quote = FALSE)
write.csv(downregulated_genes, file = output_2, row.names = FALSE, quote = FALSE)



