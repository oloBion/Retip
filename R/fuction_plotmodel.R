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



p.model <- function(t, m, title = "title", crh_leght = 16) {
  if (isS4(m)) {
    # Test data
    ncolt <- ncol(t)

    # RT prediction on test dataframe
    prd <- stats::predict(m, h2o::as.h2o(t)[, 2:ncolt])
    prd <- as.data.frame(prd)
    names(prd) <- c("RTP")
  } else {
    # Test data
    t1 <- as.matrix(t)
    ncolt1 <- ncol(t1)

    # RT prediction on test dataframe
    prd <- stats::predict(m, t1[, 2:ncolt1])
    prd <- data.frame(prd)
    names(prd) <- c("RTP")
  }

  # Variables
  rt_obs <- t$RT
  rt_pred <- prd$RTP

  # RT observed, predicted and error df
  df <- data.frame(rt_obs, rt_pred, rt_obs - rt_pred)
  names(df) <- c("RT_obs", "RT_pred", "RT_ERR")
  # Regression obs - pred
  reg <- lm(data = df, formula = RT_obs ~ RT_pred)
  coeff <- coefficients(reg)
  # Stats
  res_rf_fh <- data.frame(round((caret::postResample(t$RT, prd$RTP)), 2))
  names(res_rf_fh) <- c("Stats")
  stats_table <- cbind(Stats = c("RMSE", "R2", "MAE"), res_rf_fh$Stats)
  stats_table <-
    gridExtra::tableGrob(stats_table, rows = NULL, cols = NULL,
                         theme = gridExtra::ttheme_minimal(
                            core = list(fg_params = list(hjust = 0, x = 0.1)),
                            base_colour = "#384049"))
  stats_table <-
    gtable::gtable_add_grob(stats_table,
                            grobs = grid::rectGrob(gp = grid::gpar(fill = NA,
                                                                   lwd = 2)),
                            t = 1, b = nrow(stats_table),
                            l = 1, r = ncol(stats_table))

  # Plot the line graphic
  lg <-
    ggplot2::ggplot(df, aes(RT_obs, RT_pred)) +
    ggplot2::geom_point(aes(RT_obs, RT_pred), colour = "#5E676F") +
    ggplot2::geom_abline(intercept = coeff[1], slope = coeff[2],
                         color = "#D02937") +
    ggplot2::labs(title = paste0("Predicted RT vs Real - ", title),
                  x = "Observed RT", y = "Predicted RT") +
    ggplot2::xlim(0, crh_leght) + ggplot2::ylim(0, crh_leght) +
    ggplot2::annotation_custom(stats_table, xmin = 1, xmax = 2,
                               ymin = crh_leght - 4, ymax = crh_leght - 1) +
    ggplot2::theme_classic() +
    ggplot2::theme(plot.title = element_text(color = "#384049",
                                              face = "bold", hjust = 0.5),
                    axis.line = element_line(colour = "#384049"),
                    axis.text = element_text(colour = "#384049"),
                    axis.title = element_text(colour = "#384049"))
  print(lg)

  # Plot histograms
  hg <-
    ggplot2::ggplot(df, ggplot2::aes(RT_ERR)) +
    ggplot2::geom_histogram(ggplot2::aes(y = after_stat(density)),
                            breaks = seq(-5, 5, by = .1),
                            colour = "#5E676F", fill = "#DDE0E3") +
    ggplot2::labs(title = paste0("Error distribution - ", title),
                  x = "RT error", y = "Density") +
    ggplot2::scale_color_manual(values = c("#092DF7","#D02937")) +
    ggplot2::stat_function(fun = stats::pnorm, ggplot2::aes(colour = "pnorm"),
                           args = list(mean = mean(df$RT_ERR),
                                       sd = stats::sd(df$RT_ERR))) +
    ggplot2::stat_function(fun = stats::dnorm, ggplot2::aes(colour = "dnorm"),
                           args = list(mean = mean(df$RT_ERR),
                                       sd = stats::sd(df$RT_ERR))) +
    ggplot2::theme_classic() +
    ggplot2::theme(plot.title = element_text(color = "#384049",
                                             face = "bold", hjust = 0.5),
                   axis.line = element_line(colour = "#384049"),
                   axis.text = element_text(colour = "#384049"),
                   axis.title = element_text(colour = "#384049"),
                   legend.text = element_text(colour = "#384049"),
                   legend.position = c(0.1, 0.9),
                   legend.title = element_blank())
  print(hg)

}
