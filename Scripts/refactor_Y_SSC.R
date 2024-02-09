source("Scripts/utils.R")

# get dependencies
train_y <- loadRData("Source_data/TCGA_Y_DWMC1.1_07082022.RData")
test_y <- loadRData("Source_data/bailey_Y_DWMC1.1_07112022.RData")

# relevel the factors and save
train_y <- relevel(train_y,ref = "0")
save(train_y, file="Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")
test_y <- relevel(test_y,ref = "0")
save(test_y, file="Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData")