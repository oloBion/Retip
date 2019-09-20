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
      xgb.grid <- base::expand.grid(nrounds=c(300,400,500,600,700,800,1000),
                                    max_depth = c(2,3,4,5),
                                    eta = c(0.01,0.02),
                                    gamma = c(1),
                                    colsample_bytree = c(0.5),
                                    subsample = c(0.5),
                                    min_child_weight = c(10))

      print("Computing model Xgboost  ... Please wait ...")

      # Model training using the above parameters
      set.seed(101)
      model_xgb <-caret::train(RT ~.,
                               data=x,
                               method="xgbTree",
                               metric = "RMSE",
                               trControl=cv.ctrl,
                               tuneGrid=xgb.grid)



      print("End training")


      return(model_xgb)
}



