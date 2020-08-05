library(Retip)
library(feather)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) stop("usage: oneKeras.R descr-centered.feather model.hdf5 SMILES") 

prep.wizard()

training <- read_feather(args[1])
keras <- load_model_hdf5(args[2])

getRT.smile(smile=args[3],training,model=keras)
