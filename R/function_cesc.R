#' Build a model to center and scale dataframe
#' @export cesc
#' @param db_rt A dataframe previusly processed to clean na values
#' @return  model to use for center and scale a dataframe
#' @examples
#' \donttest{
#' preProc <- cesc(db_rt)}


cesc <- function(db_rt){
# calculate center and scale with caret function
db_rt_rt <- data.frame(db_rt$RT)
db_rt2 <- db_rt[,-1]
preProc <- caret::preProcess(db_rt2,method = c("center","scale"),rangeBounds = c(0,1))


return(preProc)

}


