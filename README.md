# Retip
Retip (Retention Time prediction for metabolomics) github

author: "Paolo Bonini, Tobias Kind and Dinesh Barupal"


## Introduction

Retip is an R package useful to predict Retention Time in Liquid Chromatography. 
It use 5 different machine learning algorithms to built a stable, accurate and fast RT prediction model:

- Random Forest: a decision tree algorithms
- BRNN: Bayesian Regularized Neural Network
- XGBoost: an extreme Gradient Boosting for tree algorithms
- lightGBM: a gradient boosting framework that uses tree based learning algorithms.
- Keras: a high-level neural networks API for Tensorflow

Retip also includes world leader metabolomics database like: BMDB, ChEBI, DrugBank, ECMDB, FooDB, HMDB, KNApSAcK, PlantCyc, SMPDB, T3DB, UNPD, YMDB, STOFF


## Get started

In this tutorial you will learn how to convert your hundreds compounds RT library into thousand of interesting predicted molecules. 
The first question you probably have is: what do I need to get started?

You need a simple excel with at least 300 hundred compounds acquired in your chromatographic system with your custom method.

Just like this: 

```{r, echo=FALSE, results='asis'}
knitr::kable(head(HILIC,5))
```

I mean, simple is setting the excel with mandatory column to start with Retip; is not easy at all having more than 300 compounds annotated with retention time. This requires lot of time and investment. But if you are working in a big metabolomics lab you probably you have in your hands, and if you don’t... don’t worry about that. You can consider use the chromatographics methods you find in this work: FiehnHilic and Riken Plasma. Those method are fast and very generalist.You can easily set up in your lab buying few standards that are included in both library. Details of these amazing method in C18 and HILIC columns are included as pdf in Retip/inst/extdata. Look at that in your R folder.
The main concept of this tip is avoid the needing to build a new chromatographic method with hundreds of standards. Simply follow Isaac Newton suggestion in 1675: "If I have seen further it is by standing on the shoulders of Giants."
In this way I invite others “Giants” Lab to do the same as Riken and Fiehn: if you are interested in your chromatographic method be available in Retip, send to us an email.

So at this point you are ready to start this adventure.

## Set up Retip

First of all you have execute function prepare.wizard that is needed to activate the parallel computing to speed up models functions.

Then you have to import your custom excel file or use FiehnLab Hilic or Riken Plasma included library.

```{r, collapse = TRUE, comment = "#>",eval = FALSE}
library(Retip)

#>Starts parallel computing
prep.wizard()

#>import excel file with mandatory field

RP <- readxl::read_excel("Riken_PlaSMA_RP.xlsx", col_types = c("text", 
                                              "text", "text", "numeric"))

#> or use HILIC database included
HILIC <- HILIC

```


## Compute Chemical Descriptors with CDK

Now it's time to compute chemical descriptors with CDK a JAVA based open source project aimed at cheminformatics. 
Several core people around the Steinbeck group developed the code. According to Ohloh the development took 136 Person , several years and translated into several million dollars in development cost.
For you will be simple as type “getCD” .
Depending on your library length and your PC it will take few minutes to several hours. 
There is a counter to visualize the progress.
It’s possible that the return table have less compounds respect the one you have start with. This is because some of yours smile code is not well formatted or for some compounds CDK is not able to calculate chemical descriptors. It’s a pity but in real life happens that you have to leave behind even your favorite compound. If happens with most of compounds check SMILES. They must not have *c* minuscule. Don’t ask why, is a DDT (don’t do that).


```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> Calculate Chemical Descriptors from CDK
descs <- getCD(HILIC)

```

## Clean dataset

Some machine learning model didn’t like NA value, or low variance columns. 
So they are eliminated to improve model performance.
This is done in Retip function proc.data 

```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> Clean dataset from NA and low variance value
db_rt <- proc.data(descs)

```


## Plot ChemSpace

You have now created your library with chemical descriptors. 
It’s time to visualize your data and answer a two crucial question: 

- what do you want to predict? 
- Can I use my library to predict the whole Human Metabolome Database? Or PlantCyc?

The answer is not easy and pass trough another question: is the chemical space of my library large enough?
So we have created function chem.space to plot your indulged data into chemical reality. You can chose a target between several database^[BMDB, ChEBI, DrugBank, ECMDB, FooDB, HMDB, KNApSAcK, PlantCyc, SMPDB, T3DB, UNPD, YMDB, STOFF]. 
In green you will see your library, in blue the chosen target.

```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> still not working

```

```{r,echo=FALSE}

knitr::include_graphics("chemspace.jpeg")

```


## Center and scal - Optional - Warning

Centering and scaling can be useful for Keras model, but can decrease performance of others models. 
Actually is a very delicate step that you have to pay a lot of attention. If you use this function you have to remember to include cesc option also when you are predicting your target database. If you don’t you will have a completely wrong prediction. 

Pay attention!


```{r, collapse = TRUE, comment = "#>",eval = FALSE}

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


```{r, collapse = TRUE, comment = "#>",eval = FALSE}

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

```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> Train Model

xgb <- fit.xgboost(training)

rf  <- fit.rf(training)

brnn <- fit.brnn(training)

keras <- fit.keras(training,testing)

lightgbm <- fit.lightgbm(training,testing)


```

OBS: if you are going to quit your R project and open again Lightgbm and Keras disappears and you have to compute it again...To avoid this problem you have to save yours models in this simple way:

```{r, collapse = TRUE, comment = "#>",eval = FALSE}

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

```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> first you have to put the testing daframe and then the name of the models you have computed
stat <- get.score(testing,xgb,rf,brnn,keras,lightgbm)

```


You can also visualize model performance in a plot using function p.model with testing dataframe.

```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> first you have to put the testing daframe and then the name of the models you want to visualize. 
#> Last value is the title of the graphics.
p.model(testing, m=brnn,title = "  RIKEN PLASMA")

```

```{r,echo=FALSE}

knitr::include_graphics("error_hilic.jpeg")
knitr::include_graphics("pred_real_hilic.jpeg")

```


You can do this for all your model and see the difference between them. You can also use training data or whole data to see how it change, even if the only really important is the testing one.


## Retention Time Prediction SPELL

This is the the final step. 
All the effort made before have been accomplished to compute the prediction on a whole database.

You have 3 options to make a prediction:
- for your personal database
- for downloaded mona.msp 
- for a Retip included database 

1) In the first case you have to import your excel with 3 mandatory columns NAME INCHKEY and SMILES, compute CD and then make the prediction. Just like this:


```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> import dataset

pathogen_box <- readxl::read_excel("pathogen_box_hilic_rt.xlsx", col_types = c("text", 
                                                               "text", "text"))
#> compute Chemical descriptors
pathogen_box_desc <- getCD(pathogen_box)

#> perform the RT spell
pathogen_box_pred <- RT.spell(training,pathogen_box_desc,model=keras)

```

2) In the second case you have to put your msp downloaded from Mona inside your project folder. First function is needed to extract information from msp and build input table. Then you have to compute CD, make the prediction and incorporate again inside msp. In this way the msp you have in your project folder is ready to be used for compound identification with MSMS and Retention time prediction.
Here an example:

```{r, collapse = TRUE, comment = "#>",eval = FALSE}


db_mona <- prep.mona(msp="MoNA-export-CASMI_2016.msp")

mona <- getCD(db_mona)

mona_rt3 <- RT.spell(training,mona,model=keras_HI)

addRT.mona(msp="MoNA-export-CASMI_2016.msp",mona_rt)

```

The last option is the easiest one. We have computed for you more than 300k compounds to save your time and more important save electricity (we love nature). 
You have just to chose a target database and a type of output: 

```{r, collapse = TRUE, comment = "#>",eval = FALSE}

#> example of Human Metabolome database predicted STILL NOT WORKING!!!!

hmdb_pred <- RT.spell(training,target="HMBD",model=keras,output="MSFINDER")


```

YES, as you have seen you can chose from different output style of your prediction. Now we have available:
- "MSDIAL": identification with accurate Mass and RTP (RECOMANDED)
- "MSFINDER": identification with accurate Mass, in silico fragmentation MS2 and RTP (RECOMANDED)
- "AGILENT": works with Mass Hunter software
- "THERMO"
- "WATERS"
- "SCIEX"


## Conclusions Remarks:

Remember these few tips:

- split your data into training and testing 80/20. And if you want to be as cool as Tobias&Dinesh use also an additional external dataset;
- Don’t cheat yourself doing cherry picking with testing molecules that are out-liner and putting in training data. Leave at it is, is better know the truth than lie to yourself;
- As you probably know R use set.seed when you have a random function. This is needed to get the same results when you do it again. There is a set seed before the split training/testing. If you modify you get a slightly different results in your models if the problematic compounds are inside training data. This is not a real cheat because is random driven but please don’t tell to Tobias...
- Look at your smiles before import in Retip, if you have cavities will not work properly.

Remember Leonardo Da Vinci suggestion:
“I have been impressed with the urgency of doing. Knowing is not enough; we must apply. Being willing is not enough; we must do."

Retip born to helps you in identification in metabolomics workflow, it’s not an exhibition of knowledge. The success of this app is helps in your work, in real word metabolomics experiments.

