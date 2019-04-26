
#' Extract information from msp file downloaded from MoNA
#' @export prep.mona
#' @param mspfile A msp file downloaded from MoNA
#' @return  dataframe with Name, InchIKey and SMILES
#' @examples
#' \donttest{
#' mona <- prep.mona(msp=mona.msp)}



  prep.mona2 <- function(mspfile="mona.msp") {

    specfile <- readLines(mspfile, n=-1L)
    startind <- grep("NAME:", specfile)
    endind <- c(startind[-1]-1, length(specfile))

    det_list <- lapply(1:length(startind), function(i){
      spect <- specfile[startind[i]:endind[i]]
      ik <- gsub("INCHIKEY: ","",spect[grep("INCHIKEY: ", spect)])

      cname <- gsub("NAME: ","",spect[1])
      c(cname,ik)
    })
    det_list <- det_list[which(sapply(det_list, length)==2)]
    det_list.df <- data.frame(do.call(rbind,det_list), stringsAsFactors = F)
    names(det_list.df) <- c("Name","InChIKey")
    det_list.df[!duplicated(det_list.df),]
  }



