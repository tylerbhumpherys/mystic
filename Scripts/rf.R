library(rtemis)
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

# build RF model and save
mystic2 <- s_Ranger(x=t(TCGA_ind), y=train_y, x.test=t(bailey_ind), 
                    y.test=test_y, n.trees = 10000, ipw = TRUE, 
                    ipw.case.weights =TRUE, ipw.class.weights = FALSE, 
                    print.plot = TRUE, verbose=TRUE, probability = TRUE, 
                    autotune = TRUE, importance = "impurity")

model_path <- paste0("Models/model", model_number, "_RF.RData")
save(mystic2, file=model_path)
