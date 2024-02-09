#!/bin/bash

#SBATCH --job-name=runall

#SBATCH --output=runall.log

#SBATCH --mem=14G
#SBATCH -p general
#SBATCH -t 0-02:00:00

make Figures/model1_heatmaps.pdf
make Figures/model2_heatmaps.pdf
make Figures/model3_heatmaps.pdf
make Figures/model4_heatmaps.pdf
make Figures/model1_survival.pdf
make Figures/model2_survival.pdf
make Figures/model3_survival.pdf
make Figures/model4_survival.pdf
make Models/model1_PLR.RData
make Models/model2_PLR.RData
make Models/model3_PLR.RData
make Models/model4_PLR.RData