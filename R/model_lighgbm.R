#' Build LightGBM model
#' @export fit.lightgbm
#' @param training A training dataset with calculated Chemical Descriptors
#' @param testing A testing dataset with calculated Chemical Descriptors
#' @return  Returns a trained model ready to predict
#' @examples
#' \donttest{
#' lightgbm <- fit.lightgbm(training,testing)}



fit.lightgbm <- function(training,testing) {


# lightgbm needs matrix to work not dataframe
train <- as.matrix(training)
test <- as.matrix(testing)
coltrain <- ncol(train)
coltest <- ncol(test)
# set up the dataset with specific fuction of lightgbm
dtrain <- lightgbm::lgb.Dataset(train[,2:coltrain], label = train[, 1])


lightgbm::lgb.Dataset.construct(dtrain)

dtest <- lightgbm::lgb.Dataset.create.valid(dtrain, test[,2:coltest], label = test[, 1], max_bin=100)


valids <- list(test = dtest)


# parameters to build the cross validated model
params <- list(objective = "regression", metric = "rmse")

# building cross validation model
modelcv <- lightgbm::lgb.cv(params, dtrain, nrounds=5000,nfold = 10, valids,verbose = 1, early_stopping_rounds = 1000, record = TRUE, eval_freq = 1L,stratified = TRUE,max_depth=4,max_leaf=20)

# select the best iter in cross validation
best.iter <- modelcv$best_iter

# parameters to build the final model
params <- list(objective = "regression_l2",metric = "rmse")

# building final model
model <- lightgbm::lgb.train(params, dtrain, nrounds=best.iter, valids,verbose = 0, early_stopping_rounds =1000, record = TRUE, eval_freq = 1L,max_depth=4,max_leaf=20)

print(paste0("End training"))


return(model)

}



