![Retip Logo](/examples/retip_logo.png)

# Retip - Retention Time prediction for metabolomics

[Paolo Bonini](https://www.researchgate.net/profile/Paolo-Bonini-2)<sup>2</sup>, [Tobias Kind](https://fiehnlab.ucdavis.edu/staff/kind)<sup>1</sup>, [Hiroshi Tsugawa](https://www.researchgate.net/profile/Hiroshi-Tsugawa)<sup>3</sup>, [Dinesh Barupal](https://fiehnlab.ucdavis.edu/component/contact/contact/11-members/14-wcmc/30)<sup>1</sup>, [Oliver Fiehn](https://fiehnlab.ucdavis.edu/staff/fiehn)<sup>1</sup>

<sup>1</sup>[FiehnLab](https://fiehnlab.ucdavis.edu/), <sup>2</sup>[NGAlab](https://www.researchgate.net/lab/NGALAB-Paolo-Bonini), <sup>3</sup>[Riken](http://prime.psc.riken.jp/)

Published 10 May 2020 in [Analytical Chemistry](https://pubs.acs.org/doi/10.1021/acs.analchem.9b05765)

Please cite:

> Retip: Retention Time Prediction for Compound Annotation in Untargeted Metabolomics Paolo Bonini, Tobias Kind, Hiroshi Tsugawa, Dinesh Kumar Barupal, and Oliver Fiehn Analytical Chemistry 2020 92 (11), 7515-7522 DOI: 10.1021/acs.analchem.9b05765

Retip 2.0 was updated and released in June 2024 by [oloBion](https://www.olobion.ai/).

## Introduction

**Retip** is a tool for predicting Retention Time (RT) for small molecules in a high pressure liquid chromatography (HPLC) Mass Spectrometry analysis, available as both an [**R package**](https://github.com/olobion/Retip/tree/master) and a [**Python package**](https://github.com/oloBion/pyRetip/tree/master). Retention time calculation can be useful in identifying unknowns and removing false positive annotations. The [**R package**](https://github.com/olobion/Retip/tree/master) uses six different machine learning algorithms to built a stable, accurate and fast RT prediction model:

-   **Random Forest:** a decision tree algorithms.
-   **BRNN:** Bayesian Regularized Neural Network.
-   **XGBoost:** an extreme Gradient Boosting for tree algorithms.
-   **lightGBM:** a gradient boosting framework that uses tree based learning algorithms.
-   **Keras:** a high-level neural networks API for Tensorflow.
-   **H2O autoML:** an automatic machine learning tool.

**Retip** also includes useful biochemical databases like: HMDB, KNApSAcK, ChEBI, DrugBank, SMPDB, YMDB, T3DB, FooDB, NANPDB, STOFF, BMDB, LipidMAPS, Urine, Saliva, Feces, ECMDB, CSF, Serum, PubChem.1, PlantCyc, UNPD, BLEXP, NPA and COCONUT.

## Retip installation

Retip 2.0 requires R 4.4.0 and it is recommended to use RStudio IDE to run it.

1.  Download and install R from the [CRAN](https://cran.r-project.org/) (64 bit version recommended)
2.  Download and install [RStudio](https://posit.co/download/rstudio-desktop/#download)
3.  Download and install [Java JDK](https://www.oracle.com/java/technologies/downloads/#java8)

Run the following command lines to install Java in Ubuntu.

```{bash}
sudo apt update
sudo apt install default-jre
sudo apt install default-jdk
sudo R CMD javareconf
```

It is also possible that `r-cran-rjava` needs to be installed.

4.  Download and install [Rtools](https://cran.rstudio.com/bin/windows/Rtools/) (Windows)
5.  Download and install [python3](https://www.python.org/downloads/) (required to use Keras model)

Run the following command line to install `python` with R.

```{r}
reticulate::install_python(version = 3.10)
```

6.  Run the following command block to install all required packages, as well as the Retip packages and Retip library.

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
install.packages('randomForest', version='4.7-1.1', repos='http://cran.rstudio.com/')
install.packages('xgboost', version='1.7.7.1', repos='http://cran.rstudio.com/')
install.packages('brnn', version='0.9.3', repos='http://cran.rstudio.com/')
install.packages('lightgbm', version='4.3.0', repos='http://cran.rstudio.com/')
install.packages('h2o', version='3.44.0.3')
install.packages('gtable', version='0.3.5', repos='http://cran.rstudio.com/')
install.packages('grid', version='4.4.0', repos='http://cran.rstudio.com/')
install.packages('gridExtra', version='2.3', repos='http://cran.rstudio.com/')
install.packages('reticulate', version='1.37', repos='http://cran.rstudio.com/')

devtools::install_github('olobion/Retiplib')
devtools::install_github('olobion/Retip')
```

:warning: It is not possible to install Retip in conda enviroment because `rJava` requires NVIDIA drivers.

## Usage

You will find a tutorial in the [**Retip app**](https://www.retip.app/) as well as in the examples folder of the [**GitHub repository**](https://github.com/olobion/Retip/tree/master?tab=readme-ov-file).
