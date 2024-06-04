

#' Extract information from msp file downloaded from MoNA
#' @export chem.space
#' @param db_rt A user library dataframe with chemical descriptors calculated
#' @param target Target database to be compared. Choice with: "ALL",  "HMDB",  "KNAPSACK",
#' @param title A title for the plot. Example: Plasma - HMDB
#' @return  plot chemical space between user library and target database
#' @examples
#' \donttest{
#' chem.space(db_rt,t="HMDB")}

chem.space <- function (db_rt, target, title = '') {

  retip_lib_v2 <- data.frame(Retip::retip_lib_head, Retiplib::retip_lib_v2)

  if ("ALL" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$Name), ]
  }else if ("HMDB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$HMDB), ]
  }else if ("KNAPSACK" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$KNApSAcK), ]
  }else if ("CHEBI" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$ChEBI), ]
  }else if ("DRUGBANK" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$DrugBank), ]
  }else if ("SMPDB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$SMPDB), ]
  }else if ("YMDB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$YMDB), ]
  }else if ("T3DB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$T3DB), ]
  }else if ("FOODB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$FooDB), ]
  }else if ("NANPDB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$NANPDB), ]
  }else if ("STOFF" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$STOFF), ]
  }else if ("BMDB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$BMDB), ]
  }else if ("LIPIDMAPS" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$LipidMAPS), ]
  }else if ("URINE" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$Urine), ]
  }else if ("SALIVA" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$Saliva), ]
  }else if ("FECES" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$Feces), ]
  }else if ("ECMDB" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$ECMDB), ]
  }else if ("CSF" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$CSF), ]
  }else if ("SERUM" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$Serum), ]
  }else if ("PUBCHEM1" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$PubChem.1), ]
  }else if ("PLANTCYC" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$PlantCyc), ]
  }else if ("UNPD" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$UNPD), ]
  }else if ("BLEXP" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$BLEXP), ]
  }else if ("NPA" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$NPA), ]
  }else if ("COCONUT" %in% target) {
    target <- retip_lib_v2[!is.na(retip_lib_v2$COCONUT), ]
  }else {
    target <- target
  }

  db_rt$RT <- NULL
  db <- target[names(target) %in% names(db_rt)]

  pca_model <-  caret::preProcess(db, method = c("pca"))

  pca_db <-  stats::predict(pca_model, db)
  pca_db_df <- as.data.frame(pca_db)

  pca_db_rt <- stats::predict(pca_model, db_rt)
  pca_db_rt_df <- as.data.frame(pca_db_rt)

  ggplot2::ggplot() +
    # database pca
    ggplot2::geom_point(data = pca_db_df, aes(x = PC1, y = PC2,
                                              colour = "Database"), size = 1) +
    # target pca
    ggplot2::geom_point(data = pca_db_rt_df, aes(x = PC1, y = PC2,
                                                 colour = "Target"), size = 1) +
    ggplot2::labs(title=paste0("ChemSpace - ", title)) +
    ggplot2::theme_classic() +
    ggplot2::theme(plot.title = element_text(color = "#384049", face = "bold",
                                             hjust = 0.5),
                   axis.line = element_line(colour = "#384049"),
                   axis.text = element_text(colour = "#384049"),
                   axis.title = element_text(colour = "#384049"),
                   legend.text = element_text(colour = "#384049"),
                   legend.title = element_text(colour = "#384049")) +
    ggplot2::scale_color_manual(name = "", breaks = c("Database", "Target"),
                                values = c("Database" = "#5E676F",
                                           "Target" = "#D02937"))
}
