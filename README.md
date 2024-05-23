# Retip - Retention Time prediction for metabolomics

[Paolo Bonini](https://www.researchgate.net/profile/Paolo-Bonini-2), [Tobias Kind](https://fiehnlab.ucdavis.edu/staff/kind), [Hiroshi Tsugawa](https://www.researchgate.net/profile/Hiroshi-Tsugawa), [Dinesh Barupal](https://fiehnlab.ucdavis.edu/component/contact/contact/11-members/14-wcmc/30), [Oliver Fiehn](https://fiehnlab.ucdavis.edu/staff/fiehn)

Published 10 May 2020 in [Analytical Chemistry](https://pubs.acs.org/doi/10.1021/acs.analchem.9b05765)

Please cite:

> Retip: Retention Time Prediction for Compound Annotation in Untargeted Metabolomics Paolo Bonini, Tobias Kind, Hiroshi Tsugawa, Dinesh Kumar Barupal, and Oliver Fiehn Analytical Chemistry 2020 92 (11), 7515-7522 DOI: 10.1021/acs.analchem.9b05765

## Introduction

**Retip** is an R package for predicting Retention Time (RT) for small molecules in a high pressure liquid chromatography (HPLC) Mass Spectrometry analysis. Retention time calculation can be useful in identifying unknowns and removing false positive annotations. It uses five different machine learning algorithms to built a stable, accurate and fast RT prediction model:

-   **Random Forest:** a decision tree algorithms.
-   **BRNN:** Bayesian Regularized Neural Network.
-   **XGBoost:** an extreme Gradient Boosting for tree algorithms.
-   **lightGBM:** a gradient boosting framework that uses tree based learning algorithms.
-   **Keras:** a high-level neural networks API for Tensorflow.

**Retip** also includes useful biochemical databases like: BMDB, ChEBI, DrugBank, ECMDB, FooDB, HMDB, KNApSAcK, PlantCyc, SMPDB, T3DB, UNPD, YMDB and STOFF.

## Retip installation

Retip 0.5.5 requires R 4.4.0 and it is recommended to use RStudio IDE to run it.

1.  Download and install R from the [CRAN](https://cran.r-project.org/) (64 bit version recommended)
2.  Download and install [RStudio](https://posit.co/download/rstudio-desktop/#download)
3.  Download and install [Java JDK](https://www.oracle.com/java/technologies/downloads/#java8)
4.  Download and install [Rtools](https://cran.rstudio.com/bin/windows/Rtools/) (Windows)
5.  Run the following command block to install all required packages, as well as the Retip packages and Retip library.

```{r}
install.packages('rJava', repos='http://cran.rstudio.com/')

install.packages('devtools', version='2.4.5', repos='http://cran.rstudio.com/')
install.packages('caret', version='6.0-94', repos='http://cran.rstudio.com/')
install.packages('ggplot2', version='3.5.1', repos='http://cran.rstudio.com/')
install.packages('rcdk', version='3.8.1', repos='http://cran.rstudio.com/')
install.packages('rcdklibs', version='2.9', repos='http://cran.rstudio.com/')
install.packages('doParallel', version='1.0.17', repos='http://cran.rstudio.com/')
install.packages('stringi', version='1.8.4', repos='http://cran.rstudio.com/')
install.packages('lattice', version='0.22-5', repos='http://cran.rstudio.com/')
install.packages('xgboost', version='1.7.7.1', repos='http://cran.rstudio.com/')
install.packages('brnn', version='0.9.3', repos='http://cran.rstudio.com/')
install.packages('h2o', version='3.44.0.3')
install.packages('gtable', version='0.3.5', repos='http://cran.rstudio.com/')
install.packages('grid', version='4.4.0', repos='http://cran.rstudio.com/')
install.packages('gridExtra', version='2.3', repos='http://cran.rstudio.com/')

devtools::install_github('Paolobnn/Retiplib')
devtools::install_github('Paolobnn/Retip')
```

:warning: It is not possible to install Retip in conda enviroment because `rJava` requires NVIDIA drivers.

## Usage

You will find a tutorial in the [**Retip app**](https://www.retip.app/) as well as in the examples folder of the [**GitHub repository**](https://github.com/PaoloBnn/Retip/tree/master?tab=readme-ov-file).
