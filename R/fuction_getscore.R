
#' Calculate score from each model to testing dataset. You can also use training data or whole dataset. It accept untill 5 models
#' @export get.score
#' @param t A dataset with RT and Chemical Descriptors, like training or testing.
#' @param m1 a model previusly trained (XGBoost, BRNN, RF, Keras or Lightgbm)
#' @param m2 a model previusly trained (XGBoost, BRNN, RF, Keras or Lightgbm)
#' @param m3 a model previusly trained (XGBoost, BRNN, RF, Keras or Lightgbm)
#' @param m4 a model previusly trained (XGBoost, BRNN, RF, Keras or Lightgbm)
#' @param m5 a model previusly trained (XGBoost, BRNN, RF, Keras or Lightgbm)
#' @return  Returns score, RMSE, R2, MAE and 95% range confidence in minutes.It is orderd by RMSE ascending so always you have best ranking model on top
#' @examples
#' \donttest{
#' stat <- get.score(testing,model_xgb,model_lightgbm,model_keras,model_brnn,model_rf)}



get.score <- function(t,m1,m2,m3,m4,m5){



            t1 <- as.matrix(t)
            ncolt1 <- ncol(t1)


            prd <- stats::predict(m1,t1[,2:ncolt1])
            prd <- data.frame(prd)
            names(prd) <- c("RTP")

            x <- t$RT
            y <- prd$RTP
            stat1 <- data.frame(round((caret::postResample(x, y)),2))
            colnames(stat1) <- deparse(substitute(m1))

            stat1 <- as.data.frame(t(stat1))

            df <- data.frame(RT_ERR = (t$RT - prd$RTP))
            qnorm_fh_rf_95 <- round((stats::qnorm(0.95,mean = mean(df$RT_ERR), sd = stats::sd(df$RT_ERR))),2)
            stat1$"95% +/-min" <- qnorm_fh_rf_95


            if(missing(m2)) {stat2 <- data.frame("RMSE" = "NA", "Rsquared"= "NA","MAE"= "NA", "95% +/-min"= "NA")
            colnames(stat2) <- colnames(stat1)
            row.names(stat2) <- "model2"
            }

            else{
            prd <- stats::predict(m2,t1[,2:ncolt1])
            prd <- data.frame(prd)
            names(prd) <- c("RTP")


            x <- t$RT
            y <- prd$RTP
            stat2 <- data.frame(round((caret::postResample(x, y)),2))
            colnames(stat2) <- deparse(substitute(m2))

            stat2 <- as.data.frame(t(stat2))
            df <- data.frame(RT_ERR = (t$RT - prd$RTP))
            qnorm_fh_rf_95 <- round((stats::qnorm(0.95,mean = mean(df$RT_ERR), sd = stats::sd(df$RT_ERR))),2)
            stat2$"95% +/-min" <- qnorm_fh_rf_95
            }

            if(missing(m3)) {stat3 <- data.frame("RMSE" = "NA", "Rsquared"= "NA","MAE"= "NA", "95% +/-min"= "NA")
            colnames(stat3) <- colnames(stat1)
            row.names(stat3) <- "model3"
            }

            else{

            prd <- stats::predict(m3,t1[,2:ncolt1])
            prd <- data.frame(prd)
            names(prd) <- c("RTP")


            x <- t$RT
            y <- prd$RTP
            stat3 <- data.frame(round((caret::postResample(x, y)),2))
            colnames(stat3) <- deparse(substitute(m3))

            stat3 <- as.data.frame(t(stat3))
            df <- data.frame(RT_ERR = (t$RT - prd$RTP))
            qnorm_fh_rf_95 <- round((stats::qnorm(0.95,mean = mean(df$RT_ERR), sd = stats::sd(df$RT_ERR))),2)
            stat3$"95% +/-min" <- qnorm_fh_rf_95
            }


            if(missing(m4)) {stat4 <- data.frame("RMSE" = "NA", "Rsquared"= "NA","MAE"= "NA", "95% +/-min"= "NA")
            colnames(stat4) <- colnames(stat1)
            row.names(stat4) <- "model4"
            }

            else{

              prd <- stats::predict(m4,t1[,2:ncolt1])
              prd <- data.frame(prd)
              names(prd) <- c("RTP")


              x <- t$RT
              y <- prd$RTP
              stat4 <- data.frame(round((caret::postResample(x, y)),2))
              colnames(stat4) <- deparse(substitute(m4))

              stat4 <- as.data.frame(t(stat4))
              df <- data.frame(RT_ERR = (t$RT - prd$RTP))
              qnorm_fh_rf_95 <- round((stats::qnorm(0.95,mean = mean(df$RT_ERR), sd = stats::sd(df$RT_ERR))),2)
              stat4$"95% +/-min" <- qnorm_fh_rf_95
            }


            if(missing(m5)) {stat5 <- data.frame("RMSE" = "NA", "Rsquared"= "NA","MAE"= "NA", "95% +/-min"= "NA")
            colnames(stat5) <- colnames(stat1)
            row.names(stat5) <- "model5"
            }

            else{

              prd <- stats::predict(m5,t1[,2:ncolt1])
              prd <- data.frame(prd)
              names(prd) <- c("RTP")


              x <- t$RT
              y <- prd$RTP
              stat5 <- data.frame(round((caret::postResample(x, y)),2))
              colnames(stat5) <- deparse(substitute(m5))

              stat5 <- as.data.frame(t(stat5))
              df <- data.frame(RT_ERR = (t$RT - prd$RTP))
              qnorm_fh_rf_95 <- round((stats::qnorm(0.95,mean = mean(df$RT_ERR), sd = stats::sd(df$RT_ERR))),2)
              stat5$"95% +/-min" <- qnorm_fh_rf_95
            }



            statf <- rbind(stat1,stat2,stat3,stat4,stat5)
            statf <- statf[order(statf$RMSE),]
            statf <- subset(statf, RMSE!="NA")
            print(statf)

return(statf)




}
