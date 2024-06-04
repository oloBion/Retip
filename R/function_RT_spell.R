#' Predict Retention Time
#' @export RT.spell
#' @param training A training dataset with calculated Chemical Descriptors
#' used in the model
#' @param target A target dataset with calculated Chemical Descriptors where
#' you want to predict Retention Time. The options of the Retip libraty are:
#' "ALL",  "HMDB",  "KNAPSACK", "CHEBI", "DRUGBANK", "SMPDB", "YMDB", "T3DB",
#' "FOODB", "NANPDB", "STOFF", "BMDB", "LIPIDMAPS", "URINE", "SALIVA", "FECES",
#' "ECMDB", "CSF", "SERUM", "PUBCHEM.1", "PLANTCYC", "UNPD", "BLEXP", "NPA", "COCONUT"
#' @param model A previusly computed model, like Xgboost, Keras etc
#' @param cesc A model for center and scale data calculated with cesc function
#' @return  Returns target dataframe with Retention time calculated
#' @examples
#' \donttest{
#' # target dataframe needs to have 3 mandatory columns Name, InChIKey and
#' SMILES and the whole descriptors calculated and not filtered
#' target_rtp <- RT.spell(training,target,model=xgb)}



RT.spell <- function(training, target, model = model, cesc = cesc) {

  retip_lib <- Retiplib::get.retiplib()

  if ("ALL" %in% target) {
    target <- retip_lib[!is.na(retip_lib$Name), ]
  }else if ("HMDB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$HMDB), ]
  }else if ("KNAPSACK" %in% target) {
    target <- retip_lib[!is.na(retip_lib$KNApSAcK), ]
  }else if ("CHEBI" %in% target) {
    target <- retip_lib[!is.na(retip_lib$ChEBI), ]
  }else if ("DRUGBANK" %in% target) {
    target <- retip_lib[!is.na(retip_lib$DrugBank), ]
  }else if ("SMPDB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$SMPDB), ]
  }else if ("YMDB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$YMDB), ]
  }else if ("T3DB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$T3DB), ]
  }else if ("FOODB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$FooDB), ]
  }else if ("NANPDB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$NANPDB), ]
  }else if ("STOFF" %in% target) {
    target <- retip_lib[!is.na(retip_lib$STOFF), ]
  }else if ("BMDB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$BMDB), ]
  }else if ("LIPIDMAPS" %in% target) {
    target <- retip_lib[!is.na(retip_lib$LipidMAPS), ]
  }else if ("URINE" %in% target) {
    target <- retip_lib[!is.na(retip_lib$Urine), ]
  }else if ("SALIVA" %in% target) {
    target <- retip_lib[!is.na(retip_lib$Saliva), ]
  }else if ("FECES" %in% target) {
    target <- retip_lib[!is.na(retip_lib$Feces), ]
  }else if ("ECMDB" %in% target) {
    target <- retip_lib[!is.na(retip_lib$ECMDB), ]
  }else if ("CSF" %in% target) {
    target <- retip_lib[!is.na(retip_lib$CSF), ]
  }else if ("SERUM" %in% target) {
    target <- retip_lib[!is.na(retip_lib$Serum), ]
  }else if ("PUBCHEM1" %in% target) {
    target <- retip_lib[!is.na(retip_lib$PubChem.1), ]
  }else if ("PLANTCYC" %in% target) {
    target <- retip_lib[!is.na(retip_lib$PlantCyc), ]
  }else if ("UNPD" %in% target) {
    target <- retip_lib[!is.na(retip_lib$UNPD), ]
  }else if ("BLEXP" %in% target) {
    target <- retip_lib[!is.na(retip_lib$BLEXP), ]
  }else if ("NPA" %in% target) {
    target <- retip_lib[!is.na(retip_lib$NPA), ]
  }else if ("COCONUT" %in% target) {
    target <- retip_lib[!is.na(retip_lib$COCONUT), ]
  }else {
    target <- target
  }

  # Scripts are the same, the only difference is if there is center and scaling

  if (missing(cesc)) {
    # use only descriptors column present in custom rt original library
    target_desc_f <- target[names(target) %in% names(training)]
    # build again dataframe with description column
    target_db <- data.frame(target[, c(1:3)], target_desc_f)
    # remuove na values
    target_db <- target_db [stats::complete.cases(target_db), ]
    if (is.element("RT", names(target_db))) {
      target_db <- target_db[names(target_db) != "RT"]
    }
    # separate column with descriptions
    target_head <- target_db[, c(1:3)]
    # convert to matrix to work with keras and lightgbm
    target_desc <- as.matrix(target_db[, -c(1:3)])
    # set number of columns
    ncol1 <- ncol(target_desc)
    # predict RT with the model selected
    if (isS4(model)) {
      pred1_target <- stats::predict(model, h2o::as.h2o(target_desc)[, 1:ncol1])
      # convert from vector to dataframe
      pred2_target <- as.data.frame(pred1_target)
    } else {
      pred1_target <- stats::predict(model, target_desc[, 1:ncol1])
      # convert from vector to dataframe
      pred2_target <- data.frame(pred1_target)
    }
    # add again description column and round prediction to 2 decimals
    pred_target <- data.frame(target_head, round((pred2_target), 2))
    # add name to retention time prediction column
    colnames(pred_target)[4] <- "RTP"


  } else { # center and scale script
    target <- stats::predict(cesc, target)

    target_desc_f <- target[names(target) %in% names(training)]

    target_db <- data.frame(target[, c(1:3)], target_desc_f)

    target_db <- target_db [stats::complete.cases(target_db), ]
    if (is.element("RT", names(target_db))) {
      target_db <- target_db[names(target_db) != "RT"]
    }

    target_head <- target_db[, c(1:3)]

    target_desc <- as.matrix(target_db[, -c(1:3)])

    ncol1 <- ncol(target_desc)

    if (isS4(model)) {
      pred1_target <- stats::predict(model, h2o::as.h2o(target_desc)[, 1:ncol1])
      pred2_target <- as.data.frame(pred1_target)
    } else {
      pred1_target <- stats::predict(model, target_desc[, 1:ncol1])
      pred2_target <- data.frame(pred1_target)
    }

    pred_target <- data.frame(target_head, round((pred2_target), 2))

    colnames(pred_target)[4] <- "RTP"

  }

  return(pred_target)

}
