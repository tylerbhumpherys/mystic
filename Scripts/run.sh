#!/bin/bash

make directories
for i in {1..4}; do
  make heatmap_figures MODEL_NUMBER=$i
  make survival_figures MODEL_NUMBER=$i
  make Models/model${i}_PLR.RData MODEL_NUMBER=$i
done
make report.pdf