
#' Predict Retention Time
#' @export RT.spell
#' @param training A training dataset with calculated Chemical Descriptors
#' used in the model
#' @param target A target dataset with calculated Chemical Descriptors where
#' you want to predict Retention Time
#' @param model A previusly computed model, like Xgboost, Keras etc
#' @param cesc A model for center and scale data calculated with cesc function
#' @return  Returns target dataframe with Retention time calculated
#' @examples
#' \donttest{
#' # target dataframe needs to have 3 mandatory columns Name, InChiKey and
#' SMILES and the whole descriptors calculated and not filtered
#' target_rtp <- RT.spell(training,target,model=xgb)}



RT.spell <- function(training, target, model = model, cesc = cesc) {
  retip_lib_v2 <- data.frame(Retip::retip_lib_head, Retiplib::retip_lib_v2)
  if ("ALL" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 1] != "N/A")
  } else if ("HMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 7] != "N/A")
  } else if ("KNAPSACK" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 8] != "N/A")
  } else if ("CHEBI" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 9] != "N/A")
  } else if ("DRUGBANK" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 10] != "N/A")
  } else if ("SMPDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 11] != "N/A")
  } else if ("YMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 12] != "N/A")
  } else if ("T3DB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 13] != "N/A")
  } else if ("FOODB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 14] != "N/A")
  } else if ("NANPDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 15] != "N/A")
  } else if ("STOFF" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 16] != "N/A")
  } else if ("BMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 17] != "N/A")
  } else if ("LIPIDMAPS" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 18] != "N/A")
  } else if ("URINE" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 19] != "N/A")
  } else if ("SALIVA" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 20] != "N/A")
  } else if ("FECES" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 21] != "N/A")
  } else if ("ECMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 22] != "N/A")
  } else if ("CSF" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 23] != "N/A")
  } else if ("SERUM" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 24] != "N/A")
  } else if ("PLANTCYC" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 26] != "N/A")
  } else if ("UNPD" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 27] != "N/A")
  } else {
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
