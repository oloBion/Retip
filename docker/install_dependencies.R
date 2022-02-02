install.packages('rJava', repos='http://cran.rstudio.com/')

install.packages('devtools', version='2.3.0', repos='http://cran.rstudio.com/')
install.packages('caret', version='6.0-81', repos='http://cran.rstudio.com/')
install.packages('ggplot2', version='3.1.0', repos='http://cran.rstudio.com/')
install.packages('rcdk', version='3.4.7.1', repos='http://cran.rstudio.com/')
install.packages('doParallel', version='1.0.14', repos='http://cran.rstudio.com/')
install.packages('keras', version='2.2.4.9', repos='http://cran.rstudio.com/')
install.packages('stringi', version='1.4.3', repos='http://cran.rstudio.com/')
install.packages('xgboost', version='0.82.1', repos='http://cran.rstudio.com/')
install.packages('brnn', version='0.7', repos='http://cran.rstudio.com/')
install.packages('randomForest', version='4.6-14', repos='http://cran.rstudio.com/')

library(keras)
install_keras()

devtools::install_github('Paolobnn/Retiplib')
devtools::install_github('Paolobnn/Retip')

