
#' Export RT to external Mass Spectrometry Software
#' @export RT.export
#' @param data The dataframe with RT prediction calculated you want to export
#' @param program The name of the software you want to use. Options are: MSDIAL, MSFINDER, AGILENT, THERMO, WATERS
#' @param pol Polarity you are going to use, could be positive "pos" or negative "neg"
#' @return  Write a file (txt or csv) formatted with external software requirements with Retention time calculated in the main folder
#' @examples
#' \donttest{
#' export_rtp <- RT.export(data,program="MSDIAL",pol="pos")}


RT.export <- function(data, program = "MSFINDER", pol = "pos") {

  retip_lib_desc <- Retiplib::get.retiplib()
  retip_lib <- data.frame(Retip::retip_lib_head, retip_lib_desc)

  if ("pos" %in% pol) {
    H <- 1.007276
    ion <- "[M+H]+"
    ion_w <- "+H"
    look <- "Lookup_M+H"
  }else if ("neg" %in% pol) {
    H <- -1.007276
    ion <- "[M-H]-"
    look <- "Lookup_M-H"
    ion_w <- "-H"
  }else {
    print("Error - no polarity have been defined")
  }

  if ("MSDIAL" %in% program) {
    export <- dplyr::inner_join(data,retip_lib[, 2:6], "InChIKey")
    export$pos <- export$Exact.mass + H
    export$adduct <- ion
    export <- data.frame(export$Name, export$pos, export$RTP, export$adduct,
                         export$InChIKey)
    colnames(export) <- c("Name", "Pos-m/z", "RT", "Adduct", "InChIKey")
    utils::write.table(x = export, "MSDIAL_export.txt", sep = "\t",
                       col.names = T, row.names = F, dec = ".", quote = F)
  } else if ("MSFINDER" %in% program) {
    export <- data.frame(data$InChIKey, data$RTP)
    colnames(export) <- c("INCHKEY", "RT")
    utils::write.table(x = export, "MSFINDER_export.txt", sep = "\t",
                       col.names = T, row.names = F, dec = ".", quote = F)
  } else if ("AGILENT" %in% program) {
    export <- dplyr::inner_join(data, retip_lib[, 2:6], "InChIKey")
    export <- data.frame(export$Name, export$Formula, export$RTP)
    colnames(export) <- c("Name", "Formula", "RT")
    gsub(",", "*", export$Name) -> export$Name
    utils::write.table(x = export, "AGILENT_export.csv", sep = ",",
                       col.names = T, row.names = F, dec = ".", quote = F)
  } else if ("THERMO" %in% program) {
    export <- dplyr::inner_join(data, retip_lib[, 2:6], "InChIKey")
    export$pos <- export$Exact.mass + H
    export <- data.frame(export$Exact.mass, export$Name, export$Formula,
                         export$pos, export$RTP)
    colnames(export) <- c("Lookup_MW", "Lookup_CompoundName", look,
                          "Lookup_M+H", "RetentionTime")
    gsub(",", "*", export$Lookup_CompoundName) -> export$Lookup_CompoundName
    utils::write.table(x = export, "THERMO_export.csv", sep = ",",
                       col.names = T, row.names = F, dec = ".", quote = F)
  } else if ("WATERS" %in% program) {
    export <- dplyr::inner_join(data, retip_lib[, 2:6], "InChIKey")
    export$adduct <- ion_w
    gsub(",", "*", export$Name) -> export$Name
    export <- data.frame(export$Name, export$Formula, export$adduct,
                         export$RTP)
    colnames(export) <- c("Item Name", "Formula", "Adduct", "Retention Time")
    utils::write.table(x = export, "WATERS_export.csv", sep = ",",
                       col.names = T, row.names = F, dec = ".", quote = F)
  }else {
    print("Error - no software have been selected")
  }

  return(export)

}
