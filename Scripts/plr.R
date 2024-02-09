library(ncvreg)
library(caret)
source("Scripts/utils.R")

# get input arguments
args <- commandArgs(trailingOnly = TRUE)
model_number <- args[1]

# get dependencies
train_x <- loadRData("Source_data/TCGA_X_DWMC1.1_07082022.RData")
train_y <- loadRData("Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")
test_x <- loadRData("Source_data/bailey_X_DWMC1.1_07112022.RData")
test_y <- loadRData("Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData")
modell <- loadRData(paste0("Models/model", model_number, "_ktsp.RData"))

# apply the indicator function and add TSP pair names
TCGA_ind <- ind_fun(train_x,modell)
bailey_ind <- ind_fun(test_x,modell)
names <- gsub(",", "_", rownames(modell$TSPs))
rownames(TCGA_ind) <- names
rownames(bailey_ind) <- names

# specify range for alpha using training set data
alphas = c(0.001, 0.01, 0.05, 0.25, 0.5, 0.75, 0.9, 1)

# vector to hold cross validated PE
pe = rep(NA, length(alphas))

for(i in seq_along(alphas)){
  # fit model with alpha value
  cvfit <- suppressWarnings(cv.ncvreg(X = t(TCGA_ind), y = train_y,
                                      nfolds = length(train_y),
                                      family='binomial', alpha = alphas[i]))
  
  # get cross-validated prediction error on training set
  pe[i] = cvfit$pe[cvfit$min]
}

# rerun model with best alpha and save
cvfit_best <- cv.ncvreg(X = t(TCGA_ind), y = train_y, nfolds=100, 
                        family='binomial', alpha = alphas[which.min(pe)])

model_path <- paste0("Models/model", model_number, "_PLR.RData")
save(cvfit_best, file=model_path)
