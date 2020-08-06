## Purpose

This is a fork of https://github.com/PaoloBnn/Retip to wrap Retip to be used from Galaxy

## Build

    docker build -t CONTAINER/NAME:TAG .
    
Downloads https://github.com/PaoloBnn/Retiplib, picks Retip code from here, adds all necessary dependencies and builds everything in a container.

Bioconda build is planned, not working yet

## Usage

Helper scripts galaxy/*.R invoke the library, they are intended to be executed with Rscript in the cotainer, wrapped in Galaxy tools.

For testing etc., standalone invocation is:

    $ cd /where/your/data/are
    $ docker run -u $(id -u) -w /work -v $PWD:/work CONTAINER/NAME:TAG SCRIPT.R ARGS ...

### Compute chemical descriptors

    chemdesc.R compounds.tsv descriptors.feather
    
Input: compounds.tsv is a table with columns Name, InChIKey, SMILES, RT

Output: table of RDKIT chemical descriptors, to be used as input to the other tools

### Train Keras model

    trainKeras.R descr-train.feather model.hdf5 
    
Input: descr-train.feather -- set of the descriptors and RTs, as produced by chemdesc.R

### Apply the Keras model to a single SMILES

    oneSmiles.R descr-train.feather model.hdf5 SMILES

Inputs: descr-train.feather -- the same file that was used to train Keras; model.hdf5 -- output of tranKeras.R

----

## Quickstart (original)

```
conda install conda-build
conda build --R <version-of-R> .
conda install -c conda-forge --use-local r-retip 
```
