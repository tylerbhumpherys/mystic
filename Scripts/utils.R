# function to build a needed missing directory
ensure_directory <- function(directory){
  if(!dir.exists(directory)){
    dir.create(directory);
  }
}

# function to load RData object from "fileName"
loadRData <- function(fileName){
  load(fileName)
  get(ls()[ls() != "fileName"])
}

# indicator function for TSPs
ind_fun = function(train_sub, classifier){
  indmat = matrix(-1, ncol(train_sub), nrow(classifier$TSPs))
  for(i in 1:nrow(classifier$TSPs)){
    p1 = which(rownames(train_sub) == classifier$TSPs[i,1])
    p2 = which(rownames(train_sub) == classifier$TSPs[i,2])
    indmat[,i] = (train_sub[p1,] > train_sub[p2,])^2
  }
  indmat = t(indmat)
  colnames(indmat) = colnames(train_sub)
  return(indmat)
}