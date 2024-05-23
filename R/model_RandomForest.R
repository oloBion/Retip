#' Build Random Forest model
#' @export fit.rf
#' @param x A training dataset with calculated Chemical Descriptors
#' @return  Returns a trained model ready to predict
#' @examples
#' \donttest{
#' rf <- fit.rf(training)}

fit.rf <- function(x) {
  # set up train control for 10 times cross validation and random search of
  # mtry tune parameters
  control2 <- caret::trainControl(method = "cv",
                                  number = 10,
                                  search = "random",
                                  verbose = T)

  print("Computing model Random Forest  ... Please wait ...")

  #Random generate mtry values with tuneLength = 10
  set.seed(100)
  model_rf <- caret::train(RT ~ .,
                           data = x,
                           method = "rf",
                           metric = "Rsquared",
                           tuneLength  = 10,
                           trControl = control2,
                           importance = T,
                           allowParallel = T)

  print("End training")

  return(model_rf)

}
