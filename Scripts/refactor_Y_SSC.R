load("/proj/jjyehlab/users/tylerben/mystic/Source_data/TCGA_Y_DWMC1.1_07082022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/bailey_Y_DWMC1.1_07112022.RData")

Y_SSC <- relevel(Y_SSC,ref = "0")
save(Y_SSC, file="/proj/jjyehlab/users/tylerben/mystic/Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")
bailey_Y_SSC <- relevel(bailey_Y_SSC,ref = "0")
save(bailey_Y_SSC, file="/proj/jjyehlab/users/tylerben/mystic/Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData")