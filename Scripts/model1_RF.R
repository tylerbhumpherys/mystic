library(rtemis)
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/TCGA_X_DWMC1.1_07082022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/bailey_X_DWMC1.1_07112022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Models/model1_ktsp.RData")

modell <- kTSP_01042023_model2
# modell <- kTSP_12212022

ind_fun = function(train_sub, classifier){
  indmat = matrix(-1, ncol(train_sub), nrow(classifier$TSPs))
  for(i in 1:nrow(classifier$TSPs)){
    p1 = which(rownames(train_sub) == classifier$TSPs[i,1])
    p2 = which(rownames(train_sub) == classifier$TSPs[i,2])
    indmat[,i] = (train_sub[p1,] > train_sub[p2,])^2
  }
  indmat = t(indmat)
  #rownames(indmat) = apply(classifier$TSPs, 1, paste)
  colnames(indmat) = colnames(train_sub)
  return(indmat)
}

names <- c("p1","p2","p3","p4","p5","p6","p7","p8","p9","p10")[1:nrow(modell$TSPs)]

TCGA_ind <- ind_fun(X_SSC,modell)
bailey_ind <- ind_fun(bailey_X_SSC,modell)

rownames(TCGA_ind) <- names
rownames(bailey_ind)<- names

mystic2 <- s_Ranger(x=t(TCGA_ind), y=Y_SSC, x.test=t(bailey_ind), y.test=bailey_Y_SSC, n.trees = 10000, ipw = TRUE, ipw.case.weights =TRUE, ipw.class.weights = FALSE,  print.plot = TRUE, verbose=TRUE, probability = TRUE)

save(mystic2, file="/proj/jjyehlab/users/tylerben/mystic/Models/model1_RF.RData")
