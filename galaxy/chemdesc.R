library(Retip)
library(feather)
library(readr)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) stop("usage: chemdesc.R compounds.tsv descriptors.feather") 


data <- read_tsv(args[1])
desc <- getCD(data)
write_feather(desc,args[2])
