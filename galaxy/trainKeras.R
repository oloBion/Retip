library(Retip)
library(hdf5r)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) stop("usage: trainKeras.R descr-train.h5 model.h5") 

prep.wizard()

# cleanTrain <- proc.data(read_feather(args[1]))
desc <- H5File$new(args[1],mode="r")
ds <- desc[["/desc"]]
cleanTrain <- ds[]
#ht5attr_names(ds)
row.names(cleanTrain) <- h5attr(ds,"rownames")

preProc <- cesc(cleanTrain)
centerTrain <- predict(preProc,cleanTrain)

set.seed(815)
toTrain <- caret::createDataPartition(centerTrain$XLogP, p = .8, list = FALSE)
training <- centerTrain[ toTrain,]
testing  <- centerTrain[-toTrain,]

keras <- fit.keras(training,testing)

save_model_hdf5(keras, filepath = args[2])
