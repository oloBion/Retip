![Retip Logo](/vignettes/Rerip_logo.png)




# Retip - Retention Time Prediction for metabolomics

Published 10 May 2020 in Analytical Chemistry [link](https://doi.org/10.1021/acs.analchem.9b05765)

Please cite: 

Retip: Retention Time Prediction for Compound Annotation in Untargeted Metabolomics
Paolo Bonini, Tobias Kind, Hiroshi Tsugawa, Dinesh Kumar Barupal, and Oliver Fiehn
Analytical Chemistry 2020 92 (11), 7515-7522 
DOI: 10.1021/acs.analchem.9b05765


Authors: [Paolo Bonini(2)](https://www.researchgate.net/profile/Paolo_Bonini2) , [Tobias Kind(1)](https://fiehnlab.ucdavis.edu/staff/kind), [Hiroshi Tsugawa(3)](https://www.researchgate.net/profile/Hiroshi_Tsugawa), [Dinesh Barupal(1)](https://fiehnlab.ucdavis.edu/component/contact/contact/11-members/14-wcmc/30) and [Oliver Fiehn(1)](https://fiehnlab.ucdavis.edu/staff/fiehn)

1. [FiehnLab](https://fiehnlab.ucdavis.edu/)
2. [NGAlab](https://www.researchgate.net/lab/NGALAB-Paolo-Bonini)
3. [Riken](http://prime.psc.riken.jp/)


## Introduction

Retip is an R package for predicting Retention Time (RT) for small molecules in a high pressure liquid chromatography (HPLC) Mass Spectrometry analysis. Retention time calculation can be useful in identifying unknowns and removing false positive annotations. 
It uses five different machine learning algorithms to built a stable, accurate and fast RT prediction model:

- Random Forest: a decision tree algorithms
- BRNN: Bayesian Regularized Neural Network
- XGBoost: an extreme Gradient Boosting for tree algorithms
- lightGBM: a gradient boosting framework that uses tree based learning algorithms.
- Keras: a high-level neural networks API for Tensorflow

Retip also includes useful biochemical databases like: BMDB, ChEBI, DrugBank, ECMDB, FooDB, HMDB, KNApSAcK, PlantCyc, SMPDB, T3DB, UNPD, YMDB and STOFF. 


## Get started

To use Retip, an user needs to prepare a compound retention time library in the format below. The input file needs compound Name, InChiKey, SMILES code and experimental retention time information for each compound. The input must be an MS Excel file. Retip will use this input file to build a the model and will predict retention times for other biochemical databases or an input query list of compounds. It is suggested that the file has at least 300 compounds to build a good retention time prediction model. 

Input file view :

| NAME                                         | InChIKey                    | SMILES                          | RT       |
|----------------------------------------------|-----------------------------|---------------------------------|----------|
| (2-oxo-2,3-dihydro-1H-indol-3-yl)acetic acid | ILGMGHZPXRDCCS-UHFFFAOYSA-N | C1=CC=C2C(=C1)C(C(=O)N2)CC(=O)O | 2.019083 |
| 1,1-Dimethyl-4-phenylpiperazinium            | WVHNHHJEHFWYHH-UHFFFAOYSA-N | CC1C(NC(CN1)C2=CC=CC=C2)C       | 2.60795  |
| 1,2-Cyclohexanediol                          | PFURGBBHAOXLIO-OLQVQODUSA-N | C1CC[C@@H]([C@@H](C1)O)O        | 4.87655  |
| 1,2-Cyclohexanedione                         | OILAIQUEIWYQPH-UHFFFAOYSA-N | C1CCC(=O)C(=O)C1                | 5.772267 |
| 1,3,7-Trimethyluric acid                     | BYXCFUMGEBZDDI-UHFFFAOYSA-N | CN1C2=C(NC1=O)N(C(=O)N(C2=O)C)C | 1.827733 |
| 1,3 Cyclohexanedione                         | HJSLFCCWAKVHIW-UHFFFAOYSA-N | C1CC(=O)CC(=O)C1                | 1.473133 |
| 1,4-Cyclohexanedicarboxylic acid             | PXGZQGDTEZPERC-UHFFFAOYSA-N | C1CC(CCC1C(=O)O)C(=O)O          | 1.560217 |

In  case, you want to avoid building a library from scratch, you can utilize publicly available libraries from Riken, Japan [PlaSMA](http://plasma.riken.jp/) and the West Coast Metabolomics Center UC Davis, USA [MoNA](http://mona.fiehnlab.ucdavis.edu/). Experimentation details for these two libraries are available here (link). We have already calculated retention time for several databases for these two experimental conditions. 

If you want your retention time library to be included in Retip, please contact the Retip team (pb@ngalab.com). 

## Retip installation
It is suggested that RStudio IDE is used to run Retip.

Download R and install (64 bit version Recommended):
[CRAN](https://cran.r-project.org/)

Download RStudio and install:
[RStudio](https://www.rstudio.com/products/rstudio/download/#download)

Download Java JDK and install:
[Java_JDK](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

Download Rtools and install:
[RTools](https://cran.rstudio.com/bin/windows/Rtools/)


Run these commands in RStudio console to install the Retip package. 

```{r}
install.packages("devtools")
devtools::install_github("Paolobnn/Retiplib")
devtools::install_github("Paolobnn/Retip")

library(keras)
install_keras()

```

To make the package fully works in R you need to install also:

1. LightGBM. We already know that is a very difficult to do it, and you have to find your way if you want to use this machine learning. Follow these instructions: 
[LightGBM](https://github.com/microsoft/LightGBM/tree/master/R-package)

If you can't install don't worry, you can use Xgboost, RandomForest and BRNN, that are installed together with Retip.


## Retip workflow functions

To run the Retip workflow for an input compound library, following functions need to be called in a sequence. 
1. prep.wizard
2. getCD
3. proc.data
4. chem.space
5. split training and testing
6. fit.model
7. p.model
8. get.score
9. RT.spell


## Set up Retip

First of all you have execute function prepare.wizard that is needed to activate the parallel computing to speed up models functions.

Then you have to import your custom excel file or use FiehnLab Hilic or Riken Plasma included library.

```{r}
library(Retip)

#>Starts parallel computing
prep.wizard()

# import excel file for training and testing data
RP2 <- readxl::read_excel("Plasma_positive.xlsx", sheet = "lib_2", col_types = c("text", 
                                                                              "text", "text", "numeric"))
# import excel file for external validation set
RP_ext <- readxl::read_excel("Plasma_positive.xlsx", sheet = "ext", col_types = c("text", 
                                                                                  "text", "text", "numeric"))

#> or use HILIC database included in Retip
HILIC <- HILIC

```

## Compute Chemical Descriptors with CDK

Now it's time to compute chemical descriptors with CDK a JAVA based open source project aimed at cheminformatics. 
Several core people around the Steinbeck group developed the code. According to Ohloh the development took 136 Person , several years and translated into several million dollars in development cost.
For you will be simple as type “getCD”.
Depending on your library length and your PC it will take few minutes to several hours. 
There is a counter to visualize the progress.
It’s possible that the return table have less compounds respect the one you have start with. This is because some of yours smile code is not well formatted or for some compounds CDK is not able to calculate chemical descriptors. It’s a pity but in real life happens that you have to leave behind even your favorite compound. If happens with most of compounds check SMILES, or better use Pubchem interchange service to get good working SMILES for your library. Remember: clean your SMILES from salts and metal containing compounds before starting Retip to avoid cavities. You can use for this purpose ChemAxon standardizer, for example.


```{r}

#> Calculate Chemical Descriptors from CDK
descs <- getCD(HILIC)

```

## Clean dataset

Some machine learning model didn’t like NA value, or low variance columns. 
So they are eliminated to improve model performance.
This is done in Retip function proc.data 

```{r}

#> Clean dataset from NA and low variance value
db_rt <- proc.data(descs)

```


## Plot ChemSpace

You have now created your library with chemical descriptors. 
It’s time to visualize your data and answer a two crucial question: 

- what do you want to predict? 
- Can I use my library to predict the whole Human Metabolome Database? Or PlantCyc?

The answer is not easy and pass trough another question: is the chemical space of my library large enough?
So we have created function chem.space to plot your indulged data into chemical reality. You can chose a target between several database (BMDB, ChEBI, DrugBank, ECMDB, FooDB, HMDB, KNApSAcK, PlantCyc, SMPDB, T3DB, UNPD, YMDB, STOFF). 
In green you will see your library, in blue the chosen target.

```{r}

#> Plot chem space, the first value is your library with Chemical descriptors calculated, 
#> the second one is your target that can be a included database 
#> or your favourite one that you have uploaded inside Retip

chem.space(db_rt,t="HMDB")

```

![Chemspace](/vignettes/chemspace.jpeg)


## Center and scale - Optional - Warning

Centering and scaling can be useful for Keras model, but can decrease performance of others models. 
Actually is a very delicate step that you have to pay a lot of attention. If you use this function you have to remember to include cesc option also when you are predicting your target database. If you don’t you will have a completely wrong prediction. 

Pay attention!


```{r}

#>################ Options center and scale data  ####################################

#> this option improves Keras model

preProc <- cesc(db_rt) #Build a model to use for center and scale a dataframe 
db_rt <- predict(preProc,db_rt) # use the above created model for center and scale dataframe

#> IMPORTANT : if you use this option remember to set cesc variable 
#> #########   into rt.spell and getRT.smile functions

#>#####################################################################################

```

## Training and Testing set-up

A very important step is to split in training and testing your data frame. 

Guide lines to build effective model explicitly specify:
"QSAR/QSPR model have to be properly validated using data which was not in the training set."

This is not new, is known from the Ancient Rome “divide et impera” (divide and conquer).

We can use caret function createdatapartition as follow:


```{r}

#> Split in training and testing using caret::createDataPartition
set.seed(101)
inTraining <- caret::createDataPartition(db_rt$XLogP, p = .8, list = FALSE)
training <- db_rt[ inTraining,]
testing  <- db_rt[-inTraining,]


```



## Building QSAR models:

Now is time to put your hands on Retip ALMA mater: Advanced Learning Machine Algorithms.

Our suggestion is to compute all of them . Each function have an integrated tuning function to find out best parameters on your own library.
Don't worry too much about over fitting because we have done 10 times fold cross validation.
Each model have his advantage or disadvantage, it's simply depends on your data the one that fit better. 
Have fun!

```{r}

#> Train Model

xgb <- fit.xgboost(training)

rf  <- fit.rf(training)

brnn <- fit.brnn(training)

keras <- fit.keras(training,testing)

lightgbm <- fit.lightgbm(training,testing)


```

OBS: if you are going to quit your R project and open again Lightgbm and Keras disappears and you have to compute it again...To avoid this problem you have to save yours models in this simple way:

```{r}

#> save an RF, XGBOOST, BRNN, LIGHTGBM models 
saveRDS(lightgbm, "light_plasma.rds")
#> load
light_plasma <- readRDS("light_plasma.rds")


#> save or load keras model
save_model_hdf5(keras1,filepath = "keras_HI")
#> load
keras_HI <- load_model_hdf5("keras_HI")


```



## Testing and plot models

Congratulations you have built your model!
Let’s see how much accurate it is.
First of all check the scores with function get.score. Returns:
- RMSE: root-mean-square error (the most important one)
- R2: coefficient of determination 
- MAE : Mean Absolute Error
- 95% +/- min: is the 95% confidence in minutes

The best model is always the first based on lower RMSE value.
You can check only one model or all of them (maximum 5) at same time.

```{r}

#> first you have to put the testing daframe and then the name of the models you have computed
stat <- get.score(testing,xgb,rf,brnn,keras,lightgbm)

```


You can also visualize model performance in a plot using function p.model with testing dataframe.

```{r}

#> first you have to put the testing daframe and then the name of the models you want to visualize. 
#> Last value is the title of the graphics.
p.model(testing, m=brnn,title = "  RIKEN PLASMA")

```

![error hilic](/vignettes/error_hilic.jpeg)
![predreal hilic](/vignettes/pred_real_hilic.jpeg)

You can do this for all your model and see the difference between them. You can also use training data or whole data to see how it change, even if the only really important is the testing one.


## Retention Time Prediction SPELL

This is the the final step. 
All the effort made before have been accomplished to compute the prediction on a whole database.

You have 3 options to make a prediction:
- for your personal database
- for downloaded mona.msp 
- for a Retip included database 

1. In the first case you have to import your excel with 3 mandatory columns NAME INCHKEY and SMILES, compute CD and then make the prediction. Just like this:


```{r}

#> import dataset

pathogen_box <- readxl::read_excel("pathogen_box_hilic_rt.xlsx", col_types = c("text", 
                                                               "text", "text"))
#> compute Chemical descriptors
pathogen_box_desc <- getCD(pathogen_box)

#> perform the RT spell
pathogen_box_pred <- RT.spell(training,pathogen_box_desc,model=keras)

```

2. In the second case you have to put your msp downloaded from Mona inside your project folder. First function is needed to extract information from msp and build input table. Then you have to compute CD, make the prediction and incorporate again inside msp. In this way the msp you have in your project folder is ready to be used for compound identification with MSMS and Retention time prediction.
Here an example:

```{r}


db_mona <- prep.mona(msp="MoNA-export-CASMI_2016.msp")

mona <- getCD(db_mona)

mona_rt3 <- RT.spell(training,mona,model=keras_HI)

addRT.mona(msp="MoNA-export-CASMI_2016.msp",mona_rt)

```

The last option is the easiest one. We have computed for you more than 300k compounds to save your time and more important save electricity (we love nature). 
You have just to chose a target database and a type of output: 

```{r}

#> example of all Retip included compounds predicted and exported to MSFINDER

all_pred <- RT.spell(training,target="ALL",model=keras,output="MSFINDER")
export_rtp <- RT.export(all_pred, program="MSFINDER",pol="pos")

```

YES, as you have seen you can chose from different output style of your prediction. Now we have available:
- "MSDIAL": identification with accurate Mass and RTP (RECOMMENDED) [get MSDIAL](http://prime.psc.riken.jp/compms/msdial/main.html)
- "MSFINDER": identification with accurate Mass, in silico fragmentation MS2 and RTP (RECOMMENDED) [get MSFINDER](http://prime.psc.riken.jp/compms/msfinder/main.html)
- "AGILENT": works with Mass Hunter software
- "THERMO"
- "WATERS"
- "SCIEX"

You have to chose the polarity you are working "pos" or "neg"

## Conclusions Remarks:

Remember these few tips:

- split your data into training and testing 80/20. And if you want to be cool use also an additional external dataset;
- Don’t cheat yourself doing cherry picking with testing molecules that are out-liner and putting in training data. Leave at it is, is better know the truth than lie to yourself;
- As you probably know R use set.seed when you have a random function. This is needed to get the same results when you do it again. There is a set seed before the split training/testing. If you modify you get a slightly different results in your models if the problematic compounds are inside training data. This is not a real cheat because is random driven ;-)
- Look at your smiles before import in Retip, if you have cavities in it will not work properly.

Remember Leonardo Da Vinci suggestion:
“I have been impressed with the urgency of doing. Knowing is not enough; we must apply. Being willing is not enough; we must do."

Retip born to helps you in identification in metabolomics workflow, it’s not an exhibition of knowledge. The success of this app is if helps in your work, in real world metabolomics experiments.
