#!/bin/bash

source /root/.local/share/r-miniconda/bin/activate r-reticulate

script=$1
shift

echo run: $script: "$@"
exec Rscript /Retip/$script "$@"
