library(Retip)
library(feather)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) stop("usage: oneKeras.R descr-train.feather model.hdf5 SMILES") 

prep.wizard()

cleanTrain <- proc.data(read_feather(args[1]))
preProc <- cesc(cleanTrain)
centerTrain <- predict(preProc,cleanTrain)

# must be the same as trainKeras.R
set.seed(815)
toTrain <- caret::createDataPartition(centerTrain$XLogP, p = .8, list = FALSE)
training <- centerTrain[ toTrain,]
testing  <- centerTrain[-toTrain,]

keras <- load_model_hdf5(args[2])

getRT.smile(smile=args[3],training,model=keras,cesc=preProc)
