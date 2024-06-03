#' Calculate Chemical Descriptors using RCDK
#' @param x A dataframe with 3 mandatory column: "Name", "InChIKey", "SMILES".
#' @export getCD
#' @return A dataframe with calculated CD. Some compund can be missing if smiles is incorect or if molecule returns error in CDK
#' @examples
#' \donttest{
#' # RP and HILIC are previusly loaded dataset from excel with
#' # Name, InChIKey, SMILES and Retention Time
#' descs <- getCD(RP)
#' descs <- getCD(HILIC)}


getCD <- function(x) {

  print(paste0("Converting SMILES..."))

  for (i in 1:nrow(x)) {
    smiles <- tryCatch({
      smi <- rcdk::parse.smiles(as.character(unlist(x[i, "SMILES"]))) [[1]]
      smi1 <- rcdk::generate.2d.coordinates(smi)
      smi1 <- rcdk::get.smiles(smi, rcdk::smiles.flavors(c("CxSmiles")))
    }, error = function(err){
      print(unlist(x[i, "Name"]))
      print(err)
      return(matrix(data=NA, nrow=1, ncol=length(x)))
    })
    x$SMILES[i] <- smiles
    print(paste0(i, " of ", nrow(x)))
  }


  # select all possible descriptors
  descNames <- rcdk::get.desc.names(type = "all")
  # select only one descriptors. This helps to remove compounds
  # that makes errors
  descNames1 <-
    c("org.openscience.cdk.qsar.descriptors.molecular.BCUTDescriptor")

  print(paste0("Checking for compound errors..."))

  # calculate only 1 descriptor for all the molecules
  mols_x <- rcdk::parse.smiles(as.character(unlist(x[1, "SMILES"])))
  descs1_x <- rcdk::eval.desc(mols_x, descNames1)

  for (i in 2:nrow(x)) {
    mols_desc <- tryCatch({
      mols1 <- rcdk::parse.smiles(as.character(unlist(x[i, "SMILES"])))
      mols1_desc <- rcdk::eval.desc(mols1, descNames1)
    }, error = function(err) {
      print(unlist(x[i, "Name"]))
      print(err)
      return(matrix(data=NA, nrow=1, ncol=length(x)))
    })
    descs1_x[i, ] <- mols_desc
    print(paste0(i, " of ", nrow(x)))
  }

  # remove molecules that have NA values with only one descriptor
  x_na <- data.frame(descs1_x, x)

  x_na_rem <- x_na[stats::complete.cases(x_na), ]

  x_na_rem <- x_na_rem [, -c(1:6)]

  # computing the whole descriptos on the good on the clean dataset
  print(paste0("Computing Chemical Descriptors 1 of ",
               nrow(x_na_rem), " ... Please wait"))

  mols_x1 <-
    rcdk::parse.smiles(as.character(unlist(x_na_rem[1, "SMILES"])))[[1]]
  rcdk::convert.implicit.to.explicit(mols_x1)
  descs_x_loop <- rcdk::eval.desc(mols_x1, descNames[-20])

  for (i in 2:nrow(x_na_rem)) {
    mols_desc1 <- tryCatch({
      mols <- rcdk::parse.smiles(as.character(unlist(x_na_rem[i, "SMILES"])))[[1]]
      rcdk::convert.implicit.to.explicit(mols)
      mols_desc1 <- rcdk::eval.desc(mols, descNames[-20])
    }, error = function(err) {
      print(unlist(x[i, "Name"]))
      print(err)
      return(matrix(data=NA, nrow=1, ncol=length(x)))
    })
    if (sum(is.na(mols_desc1)) != length(mols_desc1)) {
      descs_x_loop[i, ] <- mols_desc1
    }
    print(paste0(i, " of ", nrow(x_na_rem)))
  }
  datadesc <- data.frame(x_na_rem, descs_x_loop)
  return(datadesc)
}
