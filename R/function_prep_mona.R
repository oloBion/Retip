
#' Extract information from msp file downloaded from MoNA
#' @export prep.mona
#' @param mspfile A msp file downloaded from MoNA
#' @return  dataframe with Name, InchIKey and SMILES
#' @examples
#' \donttest{
#' mona <- prep.mona(msp=mona.msp)}



  prep.mona <- function(mspfile="mona.msp") {
  specfile <- readLines(mspfile, n=-1L)
  startind <- grep("Name:", specfile)
  endind <- c(startind[-1]-1, length(specfile))

  det_list <- lapply(1:length(startind), function(i){
    spect <- specfile[startind[i]:endind[i]]
    ik <- gsub("InChIKey: ","",spect[grep("InChIKey: ", spect)])
    com_vec <- spect[grep("Comments: ",spect)]

    smi <- gsub("\"|computed SMILES=","",stringi::stri_extract_all_regex(com_vec,"computed SMILES.+?\""))

    cname <- gsub("Name: ","",spect[1])
    c(cname,ik,smi)
  })
  det_list <- det_list[which(sapply(det_list, length)==3)]
  det_list.df <- data.frame(do.call(rbind,det_list), stringsAsFactors = F)
  names(det_list.df) <- c("Name", "InChIKey","SMILES")
  det_list.df[!duplicated(det_list.df),]
}






