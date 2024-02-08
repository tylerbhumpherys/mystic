library(switchBox)
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/melted_zach1125.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Source_data/TCGA_X_DWMC1.1_07082022.RData")
load("/proj/jjyehlab/users/tylerben/mystic/Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")
targets <- c(unique(melted_zach1125$Target), 2,9,11,15)
probeID <- c("cg01273330",
             "cg10687219",
             "cg23902076",
             "cg26155983",
             "cg07809176",
             "cg10581876",
             "cg11198596",
             "cg00571809",
             "cg06033488",
             "cg25393429",
             "cg03234072",
             "cg25337513",
             "cg20390052",
             "cg14144352",
             "cg17574812",
             "cg01847206",
             "cg10648543",
             "cg22420514",
             "cg18011760",
             "cg15732079",
             "cg04578010", "cg19029214", "cg26387848","cg03513893"
)

targetmeth <- c("basal",
                "basal",
                "classical",
                "basal",
                "basal",
                "basal",
                "basal",
                "basal",
                "basal",
                "basal",
                "basal",
                "classical",
                "classical",
                "classical",
                "classical",
                "classical",
                "classical",
                "classical",
                "classical",
                "classical",
                "classical","classical","classical","classical"
)

include <- c(T,T,T,T,T,T,T,T,T,T,T,T,F,T,T,T,T,T,T,T,T,T,F,F)
target_sites <- data.frame(cbind(targets,probeID,targetmeth,include))
chosen_probes <- target_sites$probeID[which(target_sites$include=="TRUE")]
Train_X_SSC <- as.matrix(X_SSC[chosen_probes,])
Train_Y_SSC <- Y_SSC

kTSP_01042023_model2 <- SWAP.Train.KTSP(inputMat=Train_X_SSC, phenoGroup=Train_Y_SSC,classes = c("1","0"), FilterFunc=NULL, krange=c(1:10),disjoint=F)
save(kTSP_01042023_model2, file = "/proj/jjyehlab/users/tylerben/mystic/Models/model1_ktsp.RData")

