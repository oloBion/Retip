#' Build Bayesian Regularized Neural Network Model
#' @export fit.brnn
#' @param t A training dataset with calculated Chemical Descriptors
#' @return  Returns a trained model ready to predict
#' @examples
#' \donttest{
#' brnn <- fit.brnn(training)}

fit.brnn <- function(t) {

  # setting initial weight of neural network
  seeds <- base::vector(mode = "list", length = nrow(t) + 1)
  seeds <- base::lapply(seeds, function(x) 1:20)

  # setting the tune grid with 1 to 5 neurons and cross validation set.
  # In the case of BRNN there is no need of 10x cross validation, with 3 is ok
  tune.grd <- base::expand.grid(neurons = c(1, 2, 3, 4, 5))
  rctrl1 <- caret::trainControl(method = "cv", number = 10,
                                returnResamp = "all", seeds = seeds)

  set.seed(1001)

  print("Computing model BRNN  ... Please wait ...")

  # building the model
  model_brnn <- caret::train(RT ~ ., data = t,
                             method = "brnn",
                             tuneLength = 1,
                             trControl = rctrl1,
                             allowParallel = T,
                             tuneGrid = tune.grd)


  print("End training")

  return(model_brnn)

}
