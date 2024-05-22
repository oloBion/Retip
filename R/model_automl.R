#' Build autoML Model
#' @export fit.automl.h2o
#' @param x A training dataset with calculated Chemical Descriptors
#' @return  Returns a trained model ready to predict
#' @examples
#' \donttest{
#' aml <- fit.automl.h2o(training)}


fit.automl.h2o <- function(training, max_models = 30) {
  h2o::h2o.init(nthreads = -1)
  training <- h2o::as.h2o(training)
  nonx <- c("Name", "InChiKey", "SMILES", "RT")
  x <- setdiff(names(training), nonx)
  y <- "RT"
  print("Computing model autoML  ... Please wait ...")
  # Model training using the above parameters
  aml <- h2o::h2o.automl(x = x, y = y,
                         training_frame = training,
                         nfolds = 10,
                         max_models = max_models,
                         seed = 1)
  print("End training")
  return(aml)
}