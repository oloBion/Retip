library(Retip)
library(feather)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) stop("usage: trainKeras.R descr-train.feather model.hdf5") 

prep.wizard()

cleanTrain <- proc.data(read_feather(args[1]))

preProc <- cesc(cleanTrain)
centerTrain <- predict(preProc,cleanTrain)

set.seed(815)
toTrain <- caret::createDataPartition(centerTrain$XLogP, p = .8, list = FALSE)
training <- centerTrain[ toTrain,]
testing  <- centerTrain[-toTrain,]

# keras <- fit.keras(training,testing)
# XXX
keras <- fit.keras(training,testing)

save_model_hdf5(keras, filepath = args[2])
