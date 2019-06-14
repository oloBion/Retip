#' Build XGboost Model
#' @export fit.xgboost
#' @param x A training dataset with calculated Chemical Descriptors
#' @return  Returns a trained model ready to predict
#' @examples
#' \donttest{
#' xgb <- fit.xgboost(training)}


fit.xgboost <- function(x){

      # set up train control for 10 times cross validation
      cv.ctrl <-caret::trainControl(method = "cv",number = 10)

      # These are the tune grid parameters
      xgb.grid <- base::expand.grid(nrounds=c(100,200,300,400,500,600,700),
                              max_depth = c(5),
                              eta = c(0.025,0.05),
                              gamma = c(0.01),
                              colsample_bytree = c(0.75),
                              subsample = c(0.50),
                              min_child_weight = c(0))

      print("Computing model Xgboost  ... Please wait ...")

      # Model training using the above parameters
      set.seed(101)
      model_xgb <-caret::train(RT ~.,
                        data=x,
                        method="xgbTree",
                        metric = "RMSE",
                        trControl=cv.ctrl,
                        tuneGrid=xgb.grid,
                        tuneLength = 14)




      print("End training")


      return(model_xgb)
}



