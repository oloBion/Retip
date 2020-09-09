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
    
Input: *compounds.tsv* is a table with columns *Name, InChIKey, SMILES, RT*

Output: *descriptors.feather*, table of RDKIT chemical descriptors, to be used as input to the other tools

### Train Keras model

    trainKeras.R descriptors.feather model.hdf5 
    
Input: *descriptors.feather* -- set of the descriptors and RTs, as produced by chemdesc.R
Output: *model.hdf5* -- trained model

### Apply the Keras model to a single SMILES

    spell.R descriptors.feather model.hdf5 input.tsv output.tsv

Inputs:*descriptors.feather* -- the same file that was used to train Keras; *model.hdf5* -- output of trainKeras.R, 
*SMILES* the formula
Output: output.tsv (with predictions)

## Testing data

In *galaxy/examples/*: 
- *compounds.tsv*: converted from original *examples/Plasma_positive.xlsx*, 494 records, takes some time to process
- *compounds-small.tsv*: first 80 lines of the original example, just few minutes test run
- *compounds-tiny.tsv*: just few lines, 

----

## Quickstart (original)

```
conda install conda-build
conda build --R <version-of-R> .
conda install -c conda-forge --use-local r-retip 
```
