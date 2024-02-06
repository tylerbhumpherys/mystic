library(ncvreg)
library(caret)
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/TCGA_X_DWMC1.1_07082022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/TCGA_Y_DWMC1.1_07082022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/bailey_X_DWMC1.1_07112022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/bailey_Y_DWMC1.1_07112022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Models/model4_ktsp.RData")

# modell <- kTSP_01042023_model2
modell <- kTSP_12212022

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

cvfit <- cv.ncvreg(X = t(TCGA_ind), y = Y_SSC, nfolds = 100, family='binomial', 
                   alpha=0.5)

preds <- predict(object=cvfit, X=t(bailey_ind), type="response",
                 lambda=cvfit$lambda.min)
calls_basal <- factor(ifelse(preds>0.5,1,0), levels = c(1,0))

cf <- confusionMatrix(calls_basal, bailey_Y_SSC, positive = "1")
cf
save(cvfit, file="/proj/jjyehlab/users/tylerben/mystic/Models/model4_PLR.RData")
