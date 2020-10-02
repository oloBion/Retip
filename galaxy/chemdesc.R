library(Retip)
#library(feather)
library(hdf5r)
library(readr)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) stop("usage: chemdesc.R compounds.tsv descriptors.h5") 


data <- read_tsv(args[1])
desc <- proc.data(getCD(data))
#write_feather(desc,args[2])

out=H5File$new(args[2],mode="w")

# XXX: Name InChIKey SMILES RT
# out[["/desc"]] <- desc[4:ncol(desc)]
out[["/desc"]] <- desc

ds <- out[["/desc"]]
h5attr(ds,"rownames") <- rownames(desc)
out$close_all()

#print(desc)
#print(row.names(desc))
#print(names(desc))

