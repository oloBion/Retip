

#' Extract information from msp file downloaded from MoNA
#' @export chem.space
#' @param db_rt A user library dataframe with chemical descriptors calculated
#' @param target Target database to be compared. Choice with: "ALL",  "HMDB",  "KNAPSACK",
#' @param title A title for the plot. Example: Plasma - HMDB
#' @return  plot chemical space between user library and target database
#' @examples
#' \donttest{
#' chem.space(db_rt,t="HMDB")}

chem.space <- function (db_rt, target, title='') {

  retip_lib_v2 <- data.frame(Retip::retip_lib_head,Retiplib::retip_lib_v2)

  if ("ALL" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 1] != "N/A")
  }else if ("HMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 7] != "N/A")
  }else if ("KNAPSACK" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 8] != "N/A")
  }else if ("CHEBI" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 9] != "N/A")
  }else if ("DRUGBANK" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 10] != "N/A")
  }else if ("SMPDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 11] != "N/A")
  }else if ("YMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 12] != "N/A")
  }else if ("T3DB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 13] != "N/A")
  }else if ("FOODB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 14] != "N/A")
  }else if ("NANPDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 15] != "N/A")
  }else if ("STOFF" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 16] != "N/A")
  }else if ("BMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 17] != "N/A")
  }else if ("LIPIDMAPS" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 18] != "N/A")
  }else if ("URINE" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 19] != "N/A")
  }else if ("SALIVA" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 20] != "N/A")
  }else if ("FECES" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 21] != "N/A")
  }else if ("ECMDB" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 22] != "N/A")
  }else if ("CSF" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 23] != "N/A")
  }else if ("SERUM" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 24] != "N/A")
  }else if ("PLANTCYC" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 26] != "N/A")
  }else if ("UNPD" %in% target) {
    target <- dplyr::filter(retip_lib_v2, retip_lib_v2[, 27] != "N/A")
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
