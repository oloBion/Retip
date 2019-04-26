
#' Start parallel computing
#' @export prep.wizard
#' @import caret doParallel ggplot2 rcdk keras
#' @return  numbers of cores
#' @examples
#' \donttest{
#' prep_wizard()}


prep.wizard <- function() {
  # check numbers of core in the computer and start parallel processing unit
  cores <- parallel::makeCluster(parallel::detectCores())
  doParallel::registerDoParallel(cores = cores)
  return(cores)

}
