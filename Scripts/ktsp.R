library(switchBox)
source("Scripts/utils.R")

# get input arguments
args <- commandArgs(trailingOnly = TRUE)
model_number <- args[1]

# get dependencies
candidate_sites <- loadRData("Source_data/melted_zach1125.RData")
train_x <- loadRData("Source_data/TCGA_X_DWMC1.1_07082022.RData")
train_y <- loadRData("Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")
targets <- c(unique(candidate_sites$Target),2,9,11,15)
site_name <- c("cg01273330","cg10687219","cg23902076","cg26155983","cg07809176",
               "cg10581876","cg11198596","cg00571809","cg06033488","cg25393429",
               "cg03234072","cg25337513","cg20390052","cg14144352","cg17574812",
               "cg01847206","cg10648543","cg22420514","cg18011760","cg15732079",
               "cg04578010", "cg19029214", "cg26387848","cg03513893")

# choose candidate sites
remove <- c("cg23902076","cg26155983","cg10581876","cg06033488","cg25393429")
if (model_number %in% c("1","2","3")){
  if (model_number %in% c("1","2")){
    include <- c(T,T,T,T,T,T,T,T,T,T,T,T,F,T,T,T,T,T,T,T,T,T,F,F)
    target_sites <- data.frame(cbind(targets,site_name,include))
  } else if (model_number == "3") {
    include <- c(T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T)
    target_sites <- data.frame(cbind(targets,site_name,include))
    target_sites <- target_sites[!(target_sites$site_name %in% remove), ]
  }
  chosen_probes <- target_sites$site_name[which(target_sites$include=="TRUE")]
  train_X_SSC <- as.matrix(train_x[chosen_probes,])
} else if (model_number == "4"){
  train_X_SSC <- as.matrix(train_x[!(rownames(train_x) %in% remove),])
}

# apply kTSP algorithm and save
dj <- ifelse(model_number == "1", FALSE, TRUE)
maxr <- ifelse(model_number == "4",25,10)
ktsp_model <- SWAP.Train.KTSP(inputMat=train_X_SSC,phenoGroup=train_y,
                              classes = c("1","0"),FilterFunc=NULL,
                              krange=c(1:maxr),disjoint=dj)
model_path <- paste0("Models/model", model_number, "_ktsp.RData")
save(ktsp_model, file = model_path)
