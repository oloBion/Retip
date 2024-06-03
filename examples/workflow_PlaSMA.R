# Variables
keras_installed <- TRUE
remove_descriptors <- TRUE
cesc <- FALSE
build_models <- FALSE
model <- "h2o" # all, xgb, rf, lightgbm, keras, brnn, h2o

# Packages import
setwd("~/Documentos/Retip/examples")
library(Retip)
if (!keras_installed) {
  keras::install_keras()
}

# Starts parallel computing
prep.wizard()

# Import excel file for training and testing data
rp2 <- readxl::read_excel("Plasma_positive.xlsx", sheet = "lib_2",
                          col_types = c("text", "text", "text", "numeric"))

# Calculate Chemical Descriptors fron RCDK
descs <- getCD(rp2)

# Clean dataset from NA and low variance value
db_rt <- proc.data(descs)

# Remove missing descriptors in Retip library
if (remove_descriptors) {
  db_rt <- dplyr::select(db_rt, -c(Fsp3, nA, nG))
}

# Optional center and scale data
if (cesc) {
  # Build a model to use for center and scale a dataframe
  preproc <- cesc(db_rt)
  # use the above created model for center and scale dataframe
  db_rt <- predict(preproc, db_rt)
}

# Split in training and testing using caret::createDataPartition
set.seed(101)
in_training <- caret::createDataPartition(db_rt$XLogP, p = .8, list = FALSE)
training <- db_rt[in_training, ]
testing <- db_rt[-in_training, ]

# Train Model
if (model == "all") {
  if (build_models) {
    rf  <- fit.rf(training)
    saveRDS(rf, "rf_model.rds")

    brnn <- fit.brnn(training)
    saveRDS(brnn, "brnn_model.rds")

    keras <- fit.keras(training, testing)
    save_model_hdf5(keras, filepath = "keras_HI")

    lightgbm <- fit.lightgbm(training, testing)
    saveRDS(lightgbm, "lightgbm_model.rds")

    xgb <- fit.xgboost(training)
    saveRDS(xgb, "xgb_model.rds")

    aml <- fit.automl.h2o(training)
    h2o::h2o.saveModel(aml@leader, "automl_h2o_model")
  } else  {
    rf <- readRDS("rf_model.rds")
    brnn <- readRDS("brnn_model.rds")
    keras <- keras::load_model_hdf5("keras_HI")
    lightgbm <- readRDS("lightgbm_model.rds")
    xgb <- readRDS("xgb_model.rds")
    h2o::h2o.init(nthreads = -1, strict_version_check=FALSE)
    aml <- h2o.loadModel("automl_h2o_model/###")
    # replace ### with the name of your saved model
  }
} else if (model == "rf") {
  if (build_models) {
    mdl <- fit.rf(training)
    saveRDS(rf, "rf_model.rds")
  } else {
    mdl <- readRDS("rf_model.rds")
  }
} else if (model == "brnn") {
  mdl <- fit.brnn(training)
  saveRDS(brnn, "brnn_model.rds")
} else if (model == "keras") {
  if (build_models) {
    mdl <- fit.keras(training, testing)
    save_model_hdf5(keras, filepath = "keras_HI")
  } else {
    mdl <- keras::load_model_hdf5("keras_HI")
  }
} else if (model == "lightgbm") {
  if (build_models) {
    mdl <- fit.lightgbm(training, testing)
    saveRDS(lightgbm, "lightgbm_model.rds")
  } else {
    mdl <- readRDS("lightgbm_model.rds")
  }
} else if (model == "xgb") {
  if (build_models) {
    mdl <- fit.xgboost(training)
    saveRDS(xgb, "xgb_model.rds")
  } else {
    mdl <- readRDS("xgb_model.rds")
  }
} else if (model == "h2o") {
  if (build_models) {
    mdl <- fit.automl.h2o(training)
    h2o::h2o.saveModel(aml@leader, "automl_h2o_model")
  } else {
    h2o::h2o.init(nthreads = -1, strict_version_check=FALSE)
    mdl <- h2o::h2o.loadModel("automl_h2o_model/##")
  }
}

# Model stats
if (model == "all") {
  stat <- get.score(testing, xgb, rf, brnn, keras, lightgbm, aml)
} else {
  stat <- get.score(testing, mdl)
}
print(stat)

# Retention Time Prediction SPELL

## Personal database

# Import excel file for external validation set
rp_ext <- readxl::read_excel("Plasma_positive.xlsx", sheet = "ext",
                             col_types = c("text", "text", "text", "numeric"))

# Calculate Chemical Descriptors fron RCDK
rp_ext_desc <- getCD(rp_ext)

# Clean dataset from NA and low variance value
db_rt_ext <- proc.data(rp_ext_desc)

# Optional center and scale data
if (cesc) {
  # Build a model to use for center and scale a dataframe
  preproc_ext <- cesc(db_rt_ext)
  # use the above created model for center and scale dataframe
  db_rt_ext <- predict(preproc_ext, db_rt_ext)
}

# Models
if (model == "all") {
  if (cesc) {
    rp_ext_pred_xgb <- Retip::RT.spell(training, db_rt_ext, model = xgb,
                                       cesc = preproc)
    rp_ext_pred_rf <- Retip::RT.spell(training, db_rt_ext, model = rf,
                                      cesc = preproc)
    rp_ext_pred_brnn <- Retip::RT.spell(training, db_rt_ext, model = brnn,
                                        cesc = preproc)
    rp_ext_pred_lightgbm <- RT.spell(training, db_rt_ext, model = lightgbm,
                                     cesc = preproc)
    rp_ext_pred_keras <- RT.spell(training, db_rt_ext, model = keras,
                                  cesc = preproc)
    rp_ext_pred_aml <- RT.spell(training, db_rt_ext, model = aml,
                                cesc = preproc)
  } else {
    rp_ext_pred_xgb <- Retip::RT.spell(training, rp_ext_desc, model = xgb)
    rp_ext_pred_rf <- Retip::RT.spell(training, rp_ext_desc, model = rf)
    rp_ext_pred_brnn <- Retip::RT.spell(training, rp_ext_desc, model = brnn)
    rp_ext_pred_lightgbm <- RT.spell(training, rp_ext_desc, model = lightgbm)
    rp_ext_pred_keras <- RT.spell(training, rp_ext_desc, model = keras)
    rp_ext_pred_aml <- RT.spell(training, rp_ext_desc, model = aml)
  }
} else {
  if (cesc) {
    rp_ext_pred <- Retip::RT.spell(training, db_rt_ext, model = mdl,
                                   cesc = preproc)
  } else {
    rp_ext_pred <- Retip::RT.spell(training, rp_ext_desc, model = mdl)
  }
}

## Mona database

# From downloaded file
db_mona <- prep.mona(msp = "MoNA-export-CASMI_2016.msp")

# Calculate Chemical Descriptors fron RCDK
mona <- getCD(db_mona)

# Models
if (model == "all") {
  if (cesc) {
    mona_rt_xgb <- Retip::RT.spell(training, mona, model = xgb,
                                   cesc = preproc)
    mona_rt_rf <- Retip::RT.spell(training, mona, model = rf,
                                  cesc = preproc)
    mona_rt_brnn <- Retip::RT.spell(training, mona, model = brnn,
                                    cesc = preproc)
    mona_rt_lightgbm <- RT.spell(training, mona, model = lightgbm,
                                 cesc = preproc)
    mona_rt_keras <- RT.spell(training, mona, model = keras,
                              cesc = preproc)
    mona_rt_aml <- RT.spell(training, mona, model = aml,
                            cesc = preproc)
  } else {
    mona_rt_xgb <- Retip::RT.spell(training, mona, model = xgb)
    mona_rt_rf <- Retip::RT.spell(training, mona, model = rf)
    mona_rt_brnn <- Retip::RT.spell(training, mona, model = brnn)
    mona_rt_lightgbm <- RT.spell(training, mona, model = lightgbm)
    mona_rt_keras <- RT.spell(training, mona, model = keras)
    mona_rt_aml <- RT.spell(training, mona, model = aml)
  }

  addRT.mona(msp = "MoNA-export-CASMI_2016.msp", mona_rt_xgb)
  addRT.mona(msp = "MoNA-export-CASMI_2016.msp", mona_rt_rf)
  addRT.mona(msp = "MoNA-export-CASMI_2016.msp", mona_rt_brnn)
  addRT.mona(msp = "MoNA-export-CASMI_2016.msp", mona_rt_lightgbm)
  addRT.mona(msp = "MoNA-export-CASMI_2016.msp", mona_rt_keras)
  addRT.mona(msp = "MoNA-export-CASMI_2016.msp", mona_rt_aml)
} else {
  if (cesc) {
    mona_rt <- Retip::RT.spell(training, mona, model = mdl, cesc = preproc)
  } else {
    mona_rt <- Retip::RT.spell(training, mona, model = mdl)
  }

  addRT.mona(msp = "MoNA-export-CASMI_2016.msp", mona_rt)
}

## Retip included library
if (model == "all") {
  if (cesc) {
    all_pred_xgb <- RT.spell(training, target = "ALL", model = xgb,
                             cesc = preproc)
    all_pred_rf <- RT.spell(training, target = "ALL", model = rf,
                            cesc = preproc)
    all_pred_brnn <- RT.spell(training, target = "ALL", model = brnn,
                              cesc = preproc)
    all_pred_lightgbm <- RT.spell(training, target = "ALL", model = lightgbm,
                                  cesc = preproc)
    all_pred_keras <- RT.spell(training, target = "ALL", model = keras,
                               cesc = preproc)
    all_pred_aml <- RT.spell(training, target = "ALL", model = aml,
                             cesc = preproc)
  } else {
    all_pred_xgb <- RT.spell(training, target = "ALL", model = xgb)
    all_pred_rf <- RT.spell(training, target = "ALL", model = rf)
    all_pred_brnn <- RT.spell(training, target = "ALL", model = brnn)
    all_pred_lightgbm <- RT.spell(training, target = "ALL", model = lightgbm)
    all_pred_keras <- RT.spell(training, target = "ALL", model = keras)
    all_pred_aml <- RT.spell(training, target = "ALL", model = aml)
  }

  export_rtp <- RT.export(all_pred_xgb, program = "MSFINDER", pol = "pos")
  export_rtp <- RT.export(all_pred_rf, program = "MSFINDER", pol = "pos")
  export_rtp <- RT.export(all_pred_brnn, program = "MSFINDER", pol = "pos")
  export_rtp <- RT.export(all_pred_lightgbm, program = "MSFINDER", pol = "pos")
  export_rtp <- RT.export(all_pred_keras, program = "MSFINDER", pol = "pos")
  export_rtp <- RT.export(all_pred_aml, program = "MSFINDER", pol = "pos")
} else {
  if (cesc) {
    all_pred <- RT.spell(training, target = "ALL", model = mdl, cesc = preproc)
  } else {
    all_pred <- RT.spell(training, target = "ALL", model = mdl)
  }

  export_rtp <- RT.export(all_pred, program = "MSFINDER", pol = "pos")
}
