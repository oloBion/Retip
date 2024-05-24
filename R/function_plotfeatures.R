#' Plot Feature Importance
#' @export p.model.features
#' @param model A trained model (XGBoost, BRNN, RF, Lightgbm or autoML)
#' @param mdl_type The type of model trained (xgb, brnn, rf, lightgbm, h2o)
#' @param h2o_number The index of the autoML model to plot
#' @return  Returns one plot of the selected model
#' @examples
#' \donttest{
#' p.model.features(model_xgb, xgb)}



p.model.features <- function(model, mdl_type, h2o_number = 1) {
  if (mdl_type == "h2o") {
    df <- t(h2o::h2o.varimp(model))
    mdl_name <- colnames(df)[h2o_number]
    df <- data.frame(df[, h2o_number])
    colnames(df) <- c("Value")
    df$Feature <- rownames(df)
    rownames(df) <- NULL
    df <- df[order(df$Value, decreasing = TRUE), ]
    df <- df[1:20, ]
  } else if (mdl_type == "lightgbm") {
    df <- lightgbm::lgb.importance(model)[, 1:2]
    colnames(df)[colnames(df) == "Gain"] <- "Value"
    df <- df[order(df$Value, decreasing = TRUE), ]
    df <- df[1:20, ]
    mdl_name <- "LightGBM"
  } else {
    df <- caret::varImp(model)[["importance"]]
    colnames(df) <- c("Value")
    df$Feature <- rownames(df)
    rownames(df) <- NULL
    df <- df[order(df$Value, decreasing = TRUE), ]
    df <- df[1:20, ]
    if (mdl_type == "xgb") {
      mdl_name <- "XGBoost"
    } else if (mdl_type == "rf") {
      mdl_name <- "Random Forest"
    } else if (mdl_type == "brnn") {
      mdl_name <- "BRNN"
    }
  }
  # Features plot
  ggplot2::ggplot(df, aes(x = reorder(Feature, Value), y = Value)) +
    ggplot2::geom_bar(stat = "identity", fill = "#D02937") + coord_flip() +
    ggplot2::labs(title = paste0(mdl_name, "\n Feature importance (top 20)")) +
    ggplot2::theme_classic() +
    ggplot2::theme(plot.title = element_text(color = "#384049", face = "bold",
                                             hjust = 0.5),
                   axis.line = element_line(colour = "#384049"),
                   axis.text = element_text(colour = "#384049"),
                   axis.title = element_blank())
}
