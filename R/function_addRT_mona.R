#' Add Retention Time to a mona.msp
#' @export addRT.mona
#' @param msp A msp file downloaded from MoNA
#' @param prediction a dataframe from RT.spell function
#' @return  msp file with Predicted Retention time
#' @examples
#' \donttest{
#' addRT.mona(msp="MoNA-export-CASMI_2016.msp",mona_rt)}


addRT.mona <- function(msp = "mspfile", prediction) {

  # Read the MSP file
  mspfile <- msp
  specfile <- readLines(mspfile, n = -1L)

  # Read the RT information

  rtvec <- prediction$RTP
  names(rtvec) <- prediction$InChIKey



  # Loop through each spectra
  startind <- grep("Name:", specfile)
  endind <- c(startind[-1] - 1, length(specfile))

  con1 <- file(msp,"w")
  for (i in 1:length(startind)) {
    spect <- specfile[startind[i]:endind[i]]

    ik <- gsub("InChIKey: ", "", spect[grep("InChIKey:", spect)])

    vec_print <- paste0("RETENTIONTIME: ", rtvec[ik])

    spect1 <- c(spect[1:5], paste0(vec_print), spect[6:length(spect)])

    writeLines(spect1, con1)

    print(i)
  }
  close(con1)

}
