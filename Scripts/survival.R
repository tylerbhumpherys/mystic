library(survival)
library(survminer)
source("Scripts/utils.R")

# get input arguments
args <- commandArgs(trailingOnly = TRUE)
model_number <- args[1]

# get dependencies
train_x <- loadRData("Source_data/TCGA_X_DWMC1.1_07082022.RData")
train_y <- loadRData("Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData")
test_x <- loadRData("Source_data/bailey_X_DWMC1.1_07112022.RData")
test_y <- loadRData("Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData")
PACA_AU_seq_plus <- loadRData("Source_data/PACA_AU_seq_plus04202021.RData")
bms <- "Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData"
beta_matrix_spec <- loadRData(bms)
tcga_gencode <- readRDS("Source_data/TCGA_PAAD_clean_w150_06162022.rds")
spec_info <- read.table("Source_data/specimen.tsv", sep = "\t", header = TRUE)
kTSP_model <- loadRData(paste0("Models/model", model_number, "_ktsp.RData"))
mystic_model <- loadRData(paste0("Models/model", model_number, "_RF.RData"))

probes_mystic <- c(kTSP_model$TSPs[,1],kTSP_model$TSPs[,2])
MYSTIC <- as.vector(ifelse(mystic_model$fitted == 1, "basal-like","classical"))
metadata <- tcga_gencode$sampInfo
samples <- colnames(train_x)
metadata_samples <- metadata[which((metadata$Tumor.Sample.ID %in% samples)&(!(metadata$survival_months=="NaN"))),]

metadata_samples$mystic_fit <- mystic_model$fitted[match(metadata_samples$Tumor.Sample.ID,samples)]

rDataName <- "TCGA_PAAD"
#dataSet <- Load_data(rDataName)
dataSet <- metadata_samples
survDat <- data.frame(ID = dataSet$Tumor.Sample.ID,
                      time = as.numeric(dataSet$Follow.up.days/30),
                      status = as.character(dataSet$Censored.1yes.0no),
                      Collisson = dataSet$mRNA.Collisson.clusters.All.150.Samples.1classical.2exocrine.3QM,
                      Bailey = dataSet$mRNA.Bailey.Clusters.All.150.Samples.1squamous.2immunogenic.3progenitor.4ADEX,
                      Moffitt = dataSet$cluster.MT.unscaled.Mar19,
                      SSC = dataSet$ssc,
                      whiteList = as.character(dataSet$tumor.classifier.training),
                      stringsAsFactors = FALSE)
#survDat <- cbind(survDat,dataSet$decoderWeights)
survDat$status[survDat$status == "NaN"] <- NA
survDat$status <- as.character(survDat$status)
survDat$status[survDat$status == 1] <- "yes"
survDat$status[survDat$status == 0] <- "no"
survDat$status[survDat$status == "yes"] <- 0
survDat$status[survDat$status == "no"] <- 1
survDat$status <- as.numeric(survDat$status)
survDat$Collisson <- c("classical","exocrine","QM")[as.factor(survDat$Collisson)]
survDat$Bailey <- c("squamous","immunogenic","progenitor","ADEX")[as.factor(survDat$Bailey)]
#sampSub <- which(dataSet$sampInfo$Clinical.pathologic.M %in% c("M0","MX"))
whiteList <- which(survDat$whiteList=="FALSE")
survDat$whiteList[whiteList] <- "TRUE"
survDat$whiteList[-whiteList] <- "FALSE"
#survDat <- survDat[sampSub,]
survDat$mystic_fit <- metadata_samples$mystic_fit
km <- with(survDat, Surv(time,status))
# Plot_survival(survDat,km,rDataName)

pdf_file <- paste("Figures/survivalCurve_TCGA_model",model_number,".pdf",sep="")
pdf(pdf_file, height = 5,width=7)

p = coxph(km ~ mystic_fit, data = survDat)
bic = round(BIC(p),3)
hr <- round(1/summary(p)$coefficients[2],3)
km_fit <- survfit(km ~ mystic_fit, data = survDat, type = "kaplan-meier")
plot <- ggsurvplot(km_fit, conf.int = F, pval = T,
                   legend.labs=c("Basal-like","Classical"),
                   legend.title="",break.time.by = 12,
                   palette = c("orange","blue"),
                   xlab = "Time (months)", risk.table = T,
                   title = paste("TCGA_PAAD - MYSTIC (BIC=",
                                 bic,")",
                                 "\nB vs C HR=",hr,sep=""))
plot

#dev.off()
#plot

km_fit

png_file <- paste("Figures/survivalCurve_TCGA_model",model_number,".png",sep="")
png(png_file)

p = coxph(km ~ mystic_fit, data = survDat)
bic = round(BIC(p),3)
hr <- round(1/summary(p)$coefficients[2],3)
km_fit <- survfit(km ~ mystic_fit, data = survDat, type = "kaplan-meier")
plot <- ggsurvplot(km_fit, conf.int = F, pval = T,
                   legend.labs=c("Basal-like","Classical"),
                   legend.title="",break.time.by = 12,
                   palette = c("orange","blue"),
                   xlab = "Time (months)", risk.table = T,
                   title = paste("TCGA_PAAD - MYSTIC (BIC=",
                                 bic,")",
                                 "\nB vs C HR=",hr,sep=""))
plot

#dev.off()
#plot

km_fit

samples <- colnames(test_x)
MYSTIC <- as.vector(ifelse(mystic_model$predicted == 1, "basal-like","classical"))

beta2M <- function(x){
  log2(x/(1-x))
}
bailey_meth_cleaned <- beta_matrix_spec[,-1]
rownames(bailey_meth_cleaned) <- beta_matrix_spec$probe_id
m_value_matrix_bailey <- beta2M(bailey_meth_cleaned)

meta_data_bailey <- PACA_AU_seq_plus$sampInfo

specimens_to_use <- spec_info$icgc_specimen_id[which(spec_info$specimen_type %in% c("Primary tumour - solid tissue"))]
m_value_matrix_bailey_tumors <- m_value_matrix_bailey[,which(colnames(m_value_matrix_bailey) %in% specimens_to_use)]

donors <- as.vector(spec_info$icgc_donor_id[match(colnames(m_value_matrix_bailey_tumors),spec_info$icgc_specimen_id)])

donor_subtype_not_cell_line <- meta_data_bailey$icgc_donor_id[which(meta_data_bailey$specimen_type %in% c("Primary tumour - solid tissue"))]
testing_donors_bailey <- intersect(intersect(meta_data_bailey$icgc_donor_id[which((!(is.na(meta_data_bailey$SSC.subtype))))],donors),donor_subtype_not_cell_line)
testing_specs_bailey <- colnames(m_value_matrix_bailey_tumors)[which(donors %in% testing_donors_bailey)]
donors_vec <- as.vector(spec_info$icgc_donor_id[match(testing_specs_bailey,spec_info$icgc_specimen_id)])

bailey_table <- as.data.frame(testing_specs_bailey)
colnames(bailey_table) <- "MethylationSpecimenID"
bailey_table$DonorID <- as.vector(spec_info$icgc_donor_id[match(bailey_table$MethylationSpecimenID,spec_info$icgc_specimen_id)])
bailey_table$PurIST <- meta_data_bailey$SSC.subtype[match(bailey_table$DonorID,meta_data_bailey$icgc_donor_id)]
bailey_table$BasalProb <- meta_data_bailey$SSC.basal.prob[match(bailey_table$DonorID,meta_data_bailey$icgc_donor_id)]
bailey_table$Sex <- meta_data_bailey$Gender[match(bailey_table$DonorID,meta_data_bailey$icgc_donor_id)]
bailey_table$time <- meta_data_bailey$survival_months[match(bailey_table$DonorID,meta_data_bailey$icgc_donor_id)]
bailey_table$censored <- meta_data_bailey$censored[match(bailey_table$DonorID,meta_data_bailey$icgc_donor_id)]

all.equal(bailey_table$MethylationSpecimenID,colnames(test_x))
all.equal(bailey_table$DonorID,donors_vec)
#bailey_RF_0015_ktsp_perf <- summary(rf_0015_196_ktsp_20)

bailey_table$MYSTIC <- ifelse(as.vector(mystic_model$predicted)== "1","Basal","Classical")
bailey_table$MYSTIC_prob <- mystic_model$predicted.prob
bailey_table$survival_months <-meta_data_bailey$survival_months[match(bailey_table$DonorID,meta_data_bailey$icgc_donor_id)]

bailey_table_surv <- bailey_table[which(!(is.na(bailey_table$survival_months))),]

#types <- names(summary(spec_info$tumour_histological_type[which(spec_info$icgc_specimen_id %in% testing_specs_bailey)]))
#typecounts <- as.vector(summary(spec_info$tumour_histological_type[which(spec_info$icgc_specimen_id %in% testing_specs_bailey)]))
#as.data.frame(cbind(types,typecounts))

# down-select our m-value matrix to include only the training samples
#m_value_matrix_testingSamples_bailey <- m_value_matrix_bailey_tumors[,testing_specs_bailey]

# get subtype annotation
# construct subtype vectors
#bailey_SSC <- meta_data_bailey$SSC.subtype[match(donors_vec,meta_data_bailey$icgc_donor_id)]

#bailey_subtype_basal_SSC <- as.factor(ifelse(bailey_SSC == "Basal",1,0))
# bailey_testing_samples <- meta_data_bailey[match(donors_vec,meta_data_bailey$icgc_donor_id),]

bailey_table_surv$status <- meta_data_bailey$Status[match(as.vector(bailey_table_surv$DonorID),as.vector(meta_data_bailey$icgc_donor_id))]
bailey_table_surv_status <- bailey_table_surv[which((bailey_table_surv$status == "Deceased - Of Disease")| (bailey_table_surv$status == "Alive - With Disease") | (bailey_table_surv$status == "Alive - Without Disease")) ,]
bailey_table_surv$statusCode <- ifelse(bailey_table_surv$status == "Deceased - Of Disease", 2, 1)

rDataName <- "Bailey"
#dataSet <- Load_data(rDataName)
dataSet <- bailey_table_surv
survDat <- data.frame(ID = dataSet$MethylationSpecimenID,
                      time = dataSet$time,
                      status = as.character(dataSet$censored),
                      SSC = dataSet$PurIST,
                      stringsAsFactors = FALSE)
#survDat <- cbind(survDat,dataSet$decoderWeights)
survDat$status[which(survDat$status == "censor")] <- 0
survDat$status[which(survDat$status == "death")] <- 1
survDat$status <- as.numeric(survDat$status)
#survDat$Collisson <- c("classical","exocrine","QM")[as.factor(survDat$Collisson)]
#survDat$Bailey <- c("squamous","immunogenic","progenitor","ADEX")[as.factor(survDat$Bailey)]
#sampSub <- which(dataSet$sampInfo$Clinical.pathologic.M %in% c("M0","MX"))
#whiteList <- which(survDat$whiteList=="FALSE")
#survDat$whiteList[whiteList] <- "TRUE"
#survDat$whiteList[-whiteList] <- "FALSE"
#survDat <- survDat[sampSub,]
survDat$MYSTIC <- bailey_table_surv$MYSTIC
survDat$PurIST <- bailey_table_surv$PurIST
km <- with(survDat, Surv(time,status))
#Plot_survival(survDat,km,rDataName)

pdf_file <- paste("Figures/survivalCurve_Bailey_model",model_number,".pdf",sep="")
pdf(pdf_file, height = 5,width=7)

p = coxph(km ~ MYSTIC, data = survDat)
bic = round(BIC(p),3)
hr <- round(1/summary(p)$coefficients[2],3)
km_fit <- survfit(km ~ MYSTIC, data = survDat, type = "kaplan-meier")
plot <- ggsurvplot(km_fit, conf.int = F, pval = T,
                   legend.labs=c("Basal-like","Classical"),
                   legend.title="",break.time.by = 12,
                   palette = c("orange","blue"),
                   xlab = "Time (months)", risk.table = T,
                   title = paste("Bailey - MYSTIC (BIC=",
                                 bic,")",
                                 "\nB vs C HR=",hr,sep=""))
plot
#dev.off()
#plot

km_fit

png_file <- paste("Figures/survivalCurve_Bailey_model",model_number,".png",sep="")
png(png_file)

p = coxph(km ~ MYSTIC, data = survDat)
bic = round(BIC(p),3)
hr <- round(1/summary(p)$coefficients[2],3)
km_fit <- survfit(km ~ MYSTIC, data = survDat, type = "kaplan-meier")
plot <- ggsurvplot(km_fit, conf.int = F, pval = T,
                   legend.labs=c("Basal-like","Classical"),
                   legend.title="",break.time.by = 12,
                   palette = c("orange","blue"),
                   xlab = "Time (months)", risk.table = T,
                   title = paste("Bailey - MYSTIC (BIC=",
                                 bic,")",
                                 "\nB vs C HR=",hr,sep=""))
plot
#dev.off()
#plot

km_fit