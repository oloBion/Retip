
#' Calculate score from each model to testing dataset. You can also use
#' training data or whole dataset. It accept untill 6 models
#' @export get.score
#' @param t A dataset with RT and Chemical Descriptors, like training or
#' testing.
#' @param m1 a model previusly trained (XGBoost, BRNN, RF, Keras, Lightgbm
#'  or autoML)
#' @param m2 a model previusly trained (XGBoost, BRNN, RF, Keras, Lightgbm
#'  or autoML)
#' @param m4 a model previusly trained (XGBoost, BRNN, RF, Keras, Lightgbm
#'  or autoML)
#' @param m5 a model previusly trained (XGBoost, BRNN, RF, Keras, Lightgbm
#'  or autoML)
#' @param m6 a model previusly trained (XGBoost, BRNN, RF, Keras, Lightgbm
#'  or autoML)
#' @return  Returns score, RMSE, R2, MAE and 95% range confidence in minutes.
#' It is orderd by RMSE ascending so always you have best ranking model on top
#' @examples
#' \donttest{
#' stat <- get.score(testing, model_xgb, model_lightgbm, model_keras,
#'                   model_brnn, model_rf, model_h2o)}



get.score <- function(t, m1, m2, m3, m4, m5, m6) {
  # Test data
  ncolt <- ncol(t)
  tmtx <- as.matrix(t)
  th2o <- h2o::as.h2o(t)
  rt_obs <- t$RT

  if (isS4(m1)) {
    # RT prediction on test dataframe
    prd <- stats::predict(m1, th2o[, 2:ncolt])
    prd <- as.data.frame(prd)
    names(prd) <- c("RTP")
  } else {
    # RT prediction on test dataframe
    prd <- stats::predict(m1, tmtx[, 2:ncolt])
    prd <- data.frame(prd)
    names(prd) <- c("RTP")
  }

  rt_pred <- prd$RTP
  stat1 <- data.frame(round((caret::postResample(rt_obs, rt_pred)), 2))
  colnames(stat1) <- deparse(substitute(m1))

  stat1 <- as.data.frame(t(stat1))

  df <- data.frame(RT_ERR = (rt_obs - rt_pred))
  qnorm_fh_rf_95 <- round((stats::qnorm(0.95, mean = mean(df$RT_ERR),
                                        sd = stats::sd(df$RT_ERR))), 2)
  stat1$"95% +/-min" <- qnorm_fh_rf_95

  if (missing(m2)) {
    stat2 <- data.frame("RMSE" = "NA", "Rsquared" = "NA",
                        "MAE" = "NA", "95% +/-min" = "NA")
    colnames(stat2) <- colnames(stat1)
    row.names(stat2) <- "model2"
  } else {
    if (isS4(m2)) {
      # RT prediction on test dataframe
      prd <- stats::predict(m2, th2o[, 2:ncolt])
      prd <- as.data.frame(prd)
      names(prd) <- c("RTP")
    } else {
      # RT prediction on test dataframe
      prd <- stats::predict(m2, tmtx[, 2:ncolt])
      prd <- data.frame(prd)
      names(prd) <- c("RTP")
    }

    rt_pred <- prd$RTP
    stat2 <- data.frame(round((caret::postResample(rt_obs, rt_pred)), 2))
    colnames(stat2) <- deparse(substitute(m2))

    stat2 <- as.data.frame(t(stat2))
    df <- data.frame(RT_ERR = (rt_obs - rt_pred))
    qnorm_fh_rf_95 <- round((stats::qnorm(0.95, mean = mean(df$RT_ERR),
                                          sd = stats::sd(df$RT_ERR))), 2)
    stat2$"95% +/-min" <- qnorm_fh_rf_95
  }

  if (missing(m3)) {
    stat3 <- data.frame("RMSE" = "NA", "Rsquared" = "NA",
                        "MAE" = "NA", "95% +/-min" = "NA")
    colnames(stat3) <- colnames(stat1)
    row.names(stat3) <- "model3"
  } else {
    if (isS4(m3)) {
      # RT prediction on test dataframe
      prd <- stats::predict(m3, th2o[, 2:ncolt])
      prd <- as.data.frame(prd)
      names(prd) <- c("RTP")
    } else {
      # RT prediction on test dataframe
      prd <- stats::predict(m3, tmtx[, 2:ncolt])
      prd <- data.frame(prd)
      names(prd) <- c("RTP")
    }

    rt_pred <- prd$RTP
    stat3 <- data.frame(round((caret::postResample(rt_obs, rt_pred)), 2))
    colnames(stat3) <- deparse(substitute(m3))

    stat3 <- as.data.frame(t(stat3))
    df <- data.frame(RT_ERR = (rt_obs - rt_pred))
    qnorm_fh_rf_95 <- round((stats::qnorm(0.95, mean = mean(df$RT_ERR),
                                          sd = stats::sd(df$RT_ERR))), 2)
    stat3$"95% +/-min" <- qnorm_fh_rf_95
  }

  if (missing(m4)) {
    stat4 <- data.frame("RMSE" = "NA", "Rsquared" = "NA",
                        "MAE" = "NA", "95% +/-min" = "NA")
    colnames(stat4) <- colnames(stat1)
    row.names(stat4) <- "model4"
  } else {
    if (isS4(m4)) {
      # RT prediction on test dataframe
      prd <- stats::predict(m4, th2o[, 2:ncolt])
      prd <- as.data.frame(prd)
      names(prd) <- c("RTP")
    } else {
      # RT prediction on test dataframe
      prd <- stats::predict(m4, tmtx[, 2:ncolt])
      prd <- data.frame(prd)
      names(prd) <- c("RTP")
    }

    rt_pred <- prd$RTP
    stat4 <- data.frame(round((caret::postResample(rt_obs, rt_pred)), 2))
    colnames(stat4) <- deparse(substitute(m4))
    stat4 <- as.data.frame(t(stat4))
    df <- data.frame(RT_ERR = (rt_obs - rt_pred))
    qnorm_fh_rf_95 <- round((stats::qnorm(0.95, mean = mean(df$RT_ERR),
                                          sd = stats::sd(df$RT_ERR))), 2)
    stat4$"95% +/-min" <- qnorm_fh_rf_95
  }

  if (missing(m5)) {
    stat5 <- data.frame("RMSE" = "NA", "Rsquared" = "NA",
                        "MAE" = "NA", "95% +/-min" = "NA")
    colnames(stat5) <- colnames(stat1)
    row.names(stat5) <- "model5"
  } else {
    if (isS4(m5)) {
      # RT prediction on test dataframe
      prd <- stats::predict(m5, th2o[, 2:ncolt])
      prd <- as.data.frame(prd)
      names(prd) <- c("RTP")
    } else {
      # RT prediction on test dataframe
      prd <- stats::predict(m5, tmtx[, 2:ncolt])
      prd <- data.frame(prd)
      names(prd) <- c("RTP")
    }

    rt_pred <- prd$RTP
    stat5 <- data.frame(round((caret::postResample(rt_obs, rt_pred)), 2))
    colnames(stat5) <- deparse(substitute(m5))
    stat5 <- as.data.frame(t(stat5))
    df <- data.frame(RT_ERR = (rt_obs - rt_pred))
    qnorm_fh_rf_95 <- round((stats::qnorm(0.95, mean = mean(df$RT_ERR),
                                          sd = stats::sd(df$RT_ERR))), 2)
    stat5$"95% +/-min" <- qnorm_fh_rf_95
  }

  if (missing(m6)) {
    stat6 <- data.frame("RMSE" = "NA", "Rsquared" = "NA",
                        "MAE" = "NA", "95% +/-min" = "NA")
    colnames(stat6) <- colnames(stat1)
    row.names(stat6) <- "model5"
  } else {
    if (isS4(m6)) {
      # RT prediction on test dataframe
      prd <- stats::predict(m6, th2o[, 2:ncolt])
      prd <- as.data.frame(prd)
      names(prd) <- c("RTP")
    } else {
      # RT prediction on test dataframe
      prd <- stats::predict(m6, tmtx[, 2:ncolt])
      prd <- data.frame(prd)
      names(prd) <- c("RTP")
    }

    rt_pred <- prd$RTP
    stat6 <- data.frame(round((caret::postResample(rt_obs, rt_pred)), 2))
    colnames(stat6) <- deparse(substitute(m6))
    stat6 <- as.data.frame(t(stat6))
    df <- data.frame(RT_ERR = (rt_obs - rt_pred))
    qnorm_fh_rf_95 <- round((stats::qnorm(0.95, mean = mean(df$RT_ERR),
                                          sd = stats::sd(df$RT_ERR))), 2)
    stat6$"95% +/-min" <- qnorm_fh_rf_95
  }

  statf <- rbind(stat1, stat2, stat3, stat4, stat5, stat6)
  statf <- statf[order(statf$RMSE), ]
  statf <- subset(statf, RMSE != "NA")

  return(statf)

}
