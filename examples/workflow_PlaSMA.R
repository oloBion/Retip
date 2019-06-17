library(Retip)


#Starts parallel computing
prep.wizard()

# import excel file for training and testing data
RP2 <- readxl::read_excel("Plasma_positive.xlsx", sheet = "lib_2", col_types = c("text", 
                                                                              "text", "text", "numeric"))
# import excel file for external validation set
RP_ext <- readxl::read_excel("Plasma_positive.xlsx", sheet = "ext", col_types = c("text", 
                                                                                  "text", "text", "numeric"))

# Calculate Chemical Descriptors fron RCDK
descs2 <- getCD(RP2)
descs_ext <- getCD(RP_ext)

# Clean dataset from NA and low variance value
db_rt <- proc.data(descs2)
db_ext <- descs_ext[names(descs_ext) %in% names(db_rt)]

#####################################################################################
################# Options center and scale data  ####################################

# this option improves Keras model

preProc <- cesc(db_rt) #Build a model to use for center and scale a dataframe 
db_rt <- predict(preProc,db_rt) # use the above created model for center and scale dataframe
db_ext <- predict(preProc,db_ext)

# IMPORTANT : if you use this option remember to set cesc variable 
# #########   into rt.spell and getRT.smile functions

#####################################################################################
#####################################################################################


#Split in training and testing using caret::createDataPartition
set.seed(101)
inTraining <- caret::createDataPartition(db_rt$XLogP, p = .8, list = FALSE)
training <- db_rt[ inTraining,]
testing  <- db_rt[-inTraining,]



# Train Model

xgb <- fit.xgboost(training)

rf  <- fit.rf(training)

brnn <- fit.brnn(training)

keras <- fit.keras(training,testing)

lightgbm <- fit.lightgbm(training,testing)


# Plot Variable importance for Xgboost or Random Forest or Brnn using Caret function

plot(caret::varImp(xgb), top =20, main="Top 20 Variable Impact Plot - XGB - RIKEN PLASMA")


# Plot Model

p.model2(training, m=xgb,title = "RP - TRAINING- XGB",crh_leght = 12)


stat <- get.score(db_ext,keras)


# save or load model all except keras #

saveRDS(lightgbm, "light_plasma.rds")

light_plasma <- readRDS("light_plasma.rds")


# save or load model  keras #

save_model_hdf5(keras1,filepath = "keras_HI")

keras_HI <- load_model_hdf5("keras_HI")



#mona

db_mona <- prep.mona(msp="MoNA-export-CASMI_2016.msp")

mona <- getCD(db_mona)

mona_rt3 <- RT.spell(training,mona,model=keras_HI)

addRT.mona(msp="MoNA-export-CASMI_2016.msp",mona_rt)


all_pred <- RT.spell(training,target = "ALL",model=xgb)
all_pred$Name <- NULL
all_pred$SMILES <- NULL
colnames(all_pred) <- c("INCHKEY","RT")
write.table(x = all_pred, "all_msfinder_Riken.txt", sep = "\t", col.names = T, row.names=F, dec = ".", quote = F)



#get individual prediction from single smile

smi <- "C1=CC(=CC=C1C(=O)O)N"
getRT.smile(smile=smi,training,model=xgb)


