install.packages('rJava', repos='http://cran.rstudio.com/')
install.packages('remotes', repos='http://cran.rstudio.com/')

library(remotes)
install_version('callr', version='3.4.3')
install_version('devtools', version='2.3.0', upgrade="never")

install_version('caret', version='6.0-81')
install_version('ggplot2', version='3.1.0')
install_version('rcdk', version='3.4.7.1')
install_version('doParallel', version='1.0.14')
install_version('stringi', version='1.4.3')
install_version('xgboost', version='0.82.1')
install_version('brnn', version='0.7')
install_version('randomForest', version='4.6-14')
install_version('keras', version='2.3.0.0')

reticulate::install_miniconda()
keras::install_keras(tensorflow = "2.2.0", method="conda")

devtools::install_github('Paolobnn/Retiplib')
devtools::install_github('Paolobnn/Retip@v0.5.4', upgrade="never")
