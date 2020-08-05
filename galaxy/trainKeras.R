library(Retip)
library(feather)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 4) stop("usage: trainKeras.R descr-train.feather descr-centered.feather model.hdf5 cesc.feather") 

prep.wizard()

cleanTrain <- proc.data(read_feather(args[1]))

preProc <- cesc(cleanTrain)
print(preProc)
centerTrain <- predict(preProc,cleanTrain)

set.seed(815)
toTrain <- caret::createDataPartition(centerTrain$XLogP, p = .8, list = FALSE)
training <- centerTrain[ toTrain,]
testing  <- centerTrain[-toTrain,]

keras <- fit.keras(training,testing)

write_feather(training,args[2])
save_model_hdf5(keras, filepath = args[3])
#write_feather(preProc,args[4])
print(class(preProc))
