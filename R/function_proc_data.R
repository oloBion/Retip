
#' Clean dataset removing NA value and Near zero variance columns.
#' @export proc.data
#' @param x A dataset with calculated Chemical Descriptors.
#' @return  Returns cleaned up dataset removing column with NA value and Near zero variance.
#' @examples
#' \donttest{
#' # descs is a previusly dataset with calculate chemical descriptors from function getCD
#' db_rt <- proc.data(descs)}



proc.data  <- function(x){
            # remove na columns
            db <- x[, !apply(x, 2, function(x) any(is.na(x)) )]

            set.seed(101)

            # remove columns with near zero variance values
            nzvColumns <- caret::nearZeroVar(db)

            mdrDescFH <- db[, -nzvColumns]

            db_rt <- data.frame(mdrDescFH[,-c(1:3)])

            return(db_rt)

          }


