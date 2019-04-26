#' Plot Model
#' @export p.model
#' @param t A dataset with calculated Chemical Descriptors like testing or training or whole dataset
#' @param m A trained model
#' @param title A title for the plot. Example: FiehnHilic Xgboost
#' @param crh_leght the chromatographic lengths in minutes
#' @return  Returns two plots of the selected model
#' @examples
#' \donttest{
#' # db_rt is the dataset with calculated chemical descriptors
#' # and RT information coming from function getCD
#' set.seed(101)
#' inTraining <- createDataPartition(db_rt$XLogP, p = .8, list = FALSE)
#' training <- db_rt[ inTraining,]
#' testing  <- db_rt[-inTraining,]
#' model_xgb <- fit.xgboost(training)
#' p.model(testing,model_xgb)}



p.model <- function(t,m,title="title",crh_leght=16){
  # cheating devtools to avoid horrible notes
  ..density..<- "ciao"
  model_name2 <- paste0(title)

  t1 <- as.matrix(t)
  ncolt1 <- ncol(t1)

  # RT prediction on test dataframe
  prd <- stats::predict(m,t1[,2:ncolt1])
  prd <- data.frame(prd)
  names(prd) <- c("RTP")


  x <- t$RT
  y <- prd$RTP
  res_rf_fh <- data.frame(round((caret::postResample(x, y)),2))
  names(res_rf_fh) <- c("Stats")
  # plot the line graphic
  graphics::plot(t$RT, prd$RTP,
       xlab="Observed RT", ylab="Predicted RT",
       pch=19, xlim=c(0, crh_leght), ylim=c(0, crh_leght), main =paste0("Predicted RT vs Real - ", model_name2))
  graphics::abline(0,1, col='red')
  graphics::legend('topleft',inset=.05, text.font=4,ncol = 2, title = 'Stats',legend = c("RMSE", "R2", "MAE",res_rf_fh$Stats))

  # plotting histograms
  df <- data.frame(t$RT - prd$RTP)
  names(df) <- c("RT_ERR")
  ggplot2::ggplot(df, ggplot2::aes(df$RT_ERR)) +
    ggplot2::geom_histogram(ggplot2::aes(y =..density..),
                   breaks = seq(-5, 5, by = .1),
                   colour = "black",
                   fill = "white")+
    ggplot2::labs(title = paste0("Error distribution - ", model_name2),x="RT_ERR")+
    ggplot2::scale_color_manual("Legend", values = c("blue","red"))+
    ggplot2::stat_function(fun = stats::pnorm, ggplot2::aes(colour = "pnorm"), args = list(mean = mean(df$RT_ERR), sd = stats::sd(df$RT_ERR)))+
    ggplot2::stat_function(fun = stats::dnorm, ggplot2::aes(colour = "dnorm"), args = list(mean = mean(df$RT_ERR), sd = stats::sd(df$RT_ERR)))



}


