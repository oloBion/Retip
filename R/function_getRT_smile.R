
#' Calculate the Retention Time from a smiles entry
#' @export getRT.smile
#' @param training A training dataset with calculated Chemical Descriptors used in the model
#' @param smile A SMILE code
#' @param model A previusly computed model, like Xgboost, Keras etc
#' @param cesc A model for center and scale data calculated with cesc function
#' @return  Returns the Retention Time prediction in minutes
#' @examples
#' \donttest{
#' smi <- "O=C2C(OC=3C=C(OC1OC(CO)C(O)C(O)C1(O))C=C(O)C2=3)=CC4=CC(O)=C(O)C(O)=C4"
#' getRT.smile(smile=smi,training,model=model_xgb)}


getRT.smile <- function(smile="O=C(O)C(NC(=O)C(N)C)CC(C)C",training,model=model,cesc=cesc) {
# without center and scale function activated
  if (missing(cesc)){
# convert smile into CDK object
mol <- parse.smiles(smile)
# set the descriptors that have to be computed
descNames <- get.desc.names(type = "all")
# calculate the descriptors with CDK
target <- eval.desc(mol, descNames)

# convert to matrix and use only column present in custom training set
target_desc <- as.matrix(target[names(target) %in% names(training)])
# make the RTP prediction and print in console
ncolt1 <- ncol(target_desc)
pred_target <- round(stats::predict(model, target_desc),2)

}
# The same but with center and scale function activated
  else {

  mol <- parse.smiles(smile)
  descNames <- get.desc.names(type = "all")
  target <- eval.desc(mol, descNames)

  target <- stats::predict(cesc,target)

  target_desc <- as.matrix(target[names(target) %in% names(training)])

  ncolt1 <- ncol(target_desc)
  pred_target <- round(stats::predict(model, target_desc),2)


  }

return(pred_target)

}

