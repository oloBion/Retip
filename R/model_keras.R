#' Build Keras model
#' @export fit.keras
#' @param training A training dataset with calculated Chemical Descriptors
#' @param testing A testing dataset with calculated Chemical Descriptors
#' @return  Returns a trained model ready to predict
#' @examples
#' \donttest{
#' keras <- fit.keras(training,testing)}

fit.keras <- function(training,testing) {


  mae1 <- "uno"
  mae2 <- "due"
  mae3 <- "tre"
  loss <- "fantecavallore"

  ### Data Preparation


  train_data <- training
  test_data <- testing

  train_labels <- train_data$RT
  test_labels <- test_data$RT

  train_data$RT <- NULL
  train_data <- as.matrix(train_data)

  test_data$RT <- NULL
  test_data <- as.matrix(test_data)

  n_dense <- ncol(train_data)

  # training model with flags tuning parameters

  FLAGS <- flags(
    flag_integer("dense_units", n_dense),
    flag_numeric("dropout", 0.1),
    flag_integer("epochs", 10000),
    flag_integer("batch_size", 128),
    flag_numeric("dropout2", 0.2),
    flag_numeric("dropout3", 0.3),
    flag_numeric("learning_rate", 0.001)
  )


  input <- layer_input(shape = ncol(train_data))
  predictions <- input %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout) %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout) %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout) %>%
    layer_dense(units = 1)

  model1 <- keras_model(input, predictions) %>% compile(
    loss = 'mse',
    optimizer = optimizer_rmsprop(lr = FLAGS$learning_rate),
    metrics = c('mean_absolute_error')
  )



  print("Computing model1 Keras  ... Please wait ...")

  early_stop <- callback_early_stopping(monitor = "val_loss", patience = 50,restore_best_weights = TRUE)


  # Fit the model and store training stats
  history1 <- model1 %>% fit(
    train_data,
    train_labels,
    batch_size = FLAGS$batch_size,
    epochs = FLAGS$epochs,
    verbose = 0,
    validation_split = 0.2,
    callbacks = list(early_stop)
  )


  #Model 2

  predictions2 <- input %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout2) %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout2) %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout2) %>%
    layer_dense(units = 1)

  model2 <- keras_model(input, predictions2) %>% compile(
    loss = 'mse',
    optimizer = optimizer_rmsprop(lr = FLAGS$learning_rate),
    metrics = c('mean_absolute_error')
  )



  print("Computing model2 Keras  ... Please wait ...")



  # Fit the model and store training stats
  history2 <- model2 %>% fit(
    train_data,
    train_labels,
    batch_size = FLAGS$batch_size,
    epochs = FLAGS$epochs,
    verbose = 0,
    validation_split = 0.2,
    callbacks = list(early_stop)
  )

  #Model 3

  predictions3 <- input %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout3) %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout3) %>%
    layer_dense(units = FLAGS$dense_units, activation = 'selu') %>%
    layer_dropout(rate = FLAGS$dropout3) %>%
    layer_dense(units = 1)

  model3 <- keras_model(input, predictions3) %>% compile(
    loss = 'mse',
    optimizer = optimizer_rmsprop(lr = FLAGS$learning_rate),
    metrics = c('mean_absolute_error')
  )



  print("Computing model3 Keras  ... Please wait ...")



  # Fit the model and store training stats
  history3 <- model3 %>% fit(
    train_data,
    train_labels,
    batch_size = FLAGS$batch_size,
    epochs = FLAGS$epochs,
    verbose = 0,
    validation_split = 0.2,
    callbacks = early_stop
  )


  c(loss, mae1) %<-% (model1 %>% evaluate(test_data, test_labels, verbose = 0))
  c(loss, mae2) %<-% (model2 %>% evaluate(test_data, test_labels, verbose = 0))
  c(loss, mae3) %<-% (model3 %>% evaluate(test_data, test_labels, verbose = 0))
  print(paste0("Mean absolute 1 error on test set: ", sprintf("%.2f", mae1)))
  print(paste0("Mean absolute 2 error on test set: ", sprintf("%.2f", mae2)))
  print(paste0("Mean absolute 3 error on test set: ", sprintf("%.2f", mae3)))


  if (mae1 < mae2 & mae1 < mae3 ){
    print("Return Model 1")
    return(model1)
  } else if (mae2 < mae1 & mae2 < mae3 ) {
    print("Return Model 2")
    return(model2)
  } else {
    print("Return Model 3")
    return(model3)
  }

}
