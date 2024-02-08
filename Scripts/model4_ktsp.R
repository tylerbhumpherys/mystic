library(switchBox)
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/TCGA_X_DWMC1.1_07082022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")

remove <- c("cg23902076","cg26155983","cg10581876","cg06033488","cg25393429")
x_filt <- X_SSC[!(rownames(X_SSC) %in% remove), ]
Train_X_SSC <- as.matrix(x_filt)
Train_Y_SSC <- Y_SSC

kTSP_12212022 <- SWAP.Train.KTSP(inputMat=Train_X_SSC, phenoGroup=Train_Y_SSC,classes = c("1","0"), FilterFunc=NULL, krange=c(1:10),disjoint=T)
save(kTSP_12212022, file = "/proj/jjyehlab/users/tylerben/mystic/Models/model4_ktsp.RData")

