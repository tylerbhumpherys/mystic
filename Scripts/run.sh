#!/bin/bash

#SBATCH --job-name=runall

#SBATCH --output=runall.log

#SBATCH --mem=14G
#SBATCH -p general
#SBATCH -t 0-01:00:00

make directories
for i in {1..4}; do
  make heatmap_figures MODEL_NUMBER=$i
  make survival_figures MODEL_NUMBER=$i
  make Models/model${i}_PLR.RData MODEL_NUMBER=$i
done
make report.pdf
