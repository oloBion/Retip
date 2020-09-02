library(Retip)
library(feather)
library(readr)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 4) stop("usage: spell.R descr-train.feather model.hdf5 in.tsv out.tsv") 

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

data <- read_tsv(args[3])
desc <- getCD(data)

rt <- RT.spell(training,desc,model=keras)

write_tsv(rt,args[4])
