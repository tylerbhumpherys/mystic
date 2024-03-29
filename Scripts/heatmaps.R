library(ComplexHeatmap)
library(RColorBrewer)
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
row_order <- unique(c(rbind(kTSP_model$TSPs[,1],kTSP_model$TSPs[,2])))
samples <- colnames(train_x)
metadata <- tcga_gencode$sampInfo
metadata_samples <- metadata[which(metadata$Tumor.Sample.ID %in% samples),]

ssc <- ifelse(train_y == 1,"basal-like","classical")
collison <- metadata_samples$cluster.Collisson.scaled
bailey <- metadata_samples$cluster.Bailey.scaled
moffitt <- metadata_samples$cluster.MT.unscaled.Mar19

moffitt[which(moffitt == "basal")] <- "basal-like"
bailey[which(bailey == "Squamous")] <- "squamous"
bailey[which(bailey == "Immunogenic")] <- "immunogenic"
bailey[which(bailey == "PancreaticProgenitor")] <- "pancreaticprogenitor"

m_top <- train_x[probes_mystic,]
m_top<- m_top[!row.names(m_top) %in% c("cg06033488.1"),]

col <- list(PurIST = c("basal-like" = "orange", "classical" = "blue"), 
            Collisson= c("QM"= "mediumorchid3", "classical"="lightblue",
                         "exocrine-like"="seagreen4"), 
            Bailey= c("ADEX"= "mediumpurple3", "immunogenic"="red",
                      "pancreaticprogenitor"="lightsteelblue2",
                      "squamous"="gold1"),
            Moffitt = c("basal-like" = "darkorange3", "classical" = "darkblue"),
            MYSTIC = c("classical"= "lightseagreen","basal-like"="deeppink4"))


column_order <- rev(order(MYSTIC))
ha <- HeatmapAnnotation(
  PurIST = ssc,
  Collisson = collison,
  Moffitt = moffitt,
  Bailey = bailey,
  MYSTIC = MYSTIC,
  col = col
)

coul <- colorRampPalette(brewer.pal(8, "PuOr"))(25)

# make TCGA clustered heatmap 
pdf_file <- paste("Figures/heatmap_TCGA_clustered_allsubtyping_model",
                  model_number,".pdf",sep="")
pdf(pdf_file, height = 5,width=7)
Heatmap(as.matrix(m_top),top_annotation = ha,show_column_names=F,
        show_row_names=T,name="M-value",clustering_distance_rows="euclidean",
        col=coul,column_order=column_order)
dev.off()
png_file <- paste("Figures/heatmap_TCGA_clustered_allsubtyping_model",
                  model_number,".png",sep="")
png(png_file)
Heatmap(as.matrix(m_top),top_annotation = ha,show_column_names=F,
        show_row_names=T,name="M-value",clustering_distance_rows="euclidean",
        col=coul,column_order=column_order)
dev.off()

# make TCGA ordered heatmap 
pdf_file <- paste("Figures/heatmap_TCGA_kTSP-orderd_allsubtyping_model",
                  model_number,".pdf",sep="")
pdf(pdf_file, height = 5,width=7)
Heatmap(as.matrix(m_top[,column_order]),top_annotation = ha,
        show_column_names=FALSE,show_row_names = TRUE,name="M-value" ,
        col=coul,row_order = row_order,column_order = column_order)
dev.off()
png_file <- paste("Figures/heatmap_TCGA_kTSP-orderd_allsubtyping_model",
                  model_number,".png",sep="")
png(png_file)
Heatmap(as.matrix(m_top[,column_order]),top_annotation = ha,
        show_column_names=FALSE,show_row_names = TRUE,name="M-value" ,
        col=coul,row_order = row_order,column_order = column_order)
dev.off()

# Bailey

beta2M <- function(x){
  log2(x/(1-x))
}
bailey_meth_cleaned <- beta_matrix_spec[,-1]
rownames(bailey_meth_cleaned) <- beta_matrix_spec$probe_id
m_value_matrix_bailey <- apply(bailey_meth_cleaned, 2, beta2M)
meta_data_bailey <- PACA_AU_seq_plus$sampInfo
specimens_to_use <- spec_info$icgc_specimen_id[which(spec_info$specimen_type %in% c("Primary tumour - solid tissue"))]
m_value_matrix_bailey_tumors <- m_value_matrix_bailey[,which(colnames(m_value_matrix_bailey) %in% specimens_to_use)]

donors <- as.vector(spec_info$icgc_donor_id[match(colnames(m_value_matrix_bailey_tumors),spec_info$icgc_specimen_id)])

donor_subtype_not_cell_line <- meta_data_bailey$icgc_donor_id[which(meta_data_bailey$specimen_type %in% c("Primary tumour - solid tissue"))]
testing_donors_bailey <- intersect(intersect(meta_data_bailey$icgc_donor_id[which((!(is.na(meta_data_bailey$SSC.subtype))))],donors),donor_subtype_not_cell_line)
testing_specs_bailey <- colnames(m_value_matrix_bailey_tumors)[which(donors %in% testing_donors_bailey)]
donors_vec <- as.vector(spec_info$icgc_donor_id[match(testing_specs_bailey,spec_info$icgc_specimen_id)])

types <- names(summary(spec_info$tumour_histological_type[which(spec_info$icgc_specimen_id %in% testing_specs_bailey)]))
typecounts <- as.vector(summary(spec_info$tumour_histological_type[which(spec_info$icgc_specimen_id %in% testing_specs_bailey)]))
# as.data.frame(cbind(types,typecounts))

# m_value_matrix_testingSamples_bailey <- m_value_matrix_bailey_tumors[,testing_specs_bailey]
bailey_chosen_metadata <- meta_data_bailey[match(donors_vec,meta_data_bailey$icgc_donor_id),]

samples <- colnames(test_x)
MYSTIC <- as.vector(ifelse(mystic_model$predicted == 1, "basal-like","classical"))

ssc <- ifelse(test_y == 1,"basal-like","classical")
collison <- bailey_chosen_metadata$cluster.Collisson.scaled
bailey <- bailey_chosen_metadata$cluster.Bailey.scaled
moffitt <- bailey_chosen_metadata$cluster.MT.unscaled.Mar19

moffitt[which(moffitt == "basal")] <- "basal-like"
bailey[which(bailey == "Squamous")] <- "squamous"
bailey[which(bailey == "Immunogenic")] <- "immunogenic"
bailey[which(bailey == "PancreaticProgenitor")] <- "pancreaticprogenitor"

m_top <- test_x[probes_mystic,]
m_top<- m_top[!row.names(m_top) %in% c("cg06033488.1"),]
col <- list(PurIST = c("basal-like" = "orange", "classical" = "blue"), Collisson= c("QM"= "mediumorchid3", "classical"="lightblue","exocrine-like"="seagreen4"), Bailey= c("ADEX"= "mediumpurple3", "immunogenic"="red","pancreaticprogenitor"="lightsteelblue2","squamous"="gold1"),Moffitt = c("basal-like" = "darkorange3", "classical" = "darkblue"), MYSTIC = c("classical"= "lightseagreen","basal-like"="deeppink4"))

column_order <- rev(order(MYSTIC))
ha <- HeatmapAnnotation(
  PurIST = ssc,
  Collisson = collison,
  Moffitt = moffitt,
  Bailey = bailey,
  MYSTIC = MYSTIC,
  col = col
)

coul <- colorRampPalette(brewer.pal(8, "PuOr"))(25)
pdf_file <- paste("Figures/heatmap_bailey_clustered_mystic_allsubtyping_model",model_number,".pdf",sep="")
pdf(pdf_file, height = 5,width=7)
Heatmap(as.matrix(m_top),top_annotation = ha,show_column_names=FALSE,show_row_names = TRUE,name="M-value" ,clustering_distance_rows = "euclidean" ,col=coul,column_order=column_order)
dev.off()
png_file <- paste("Figures/heatmap_bailey_clustered_mystic_allsubtyping_model",model_number,".png",sep="")
png(png_file)
Heatmap(as.matrix(m_top),top_annotation = ha,show_column_names=FALSE,show_row_names = TRUE,name="M-value" ,clustering_distance_rows = "euclidean" ,col=coul,column_order=column_order)
dev.off()

# side_annotation <- rowAnnotation(
#   PurIST = ssc,
#   Collisson = collison,
#   Moffitt = moffitt,
#   Bailey = bailey,
#   MYSTIC = MYSTIC,
#   col = col
# )

pdf_file <- paste("Figures/heatmap_bailey_kTSP-orderd_mystic_allsubtyping_model",model_number,".pdf",sep="")
pdf(pdf_file, height = 5,width=7)
Heatmap(as.matrix(m_top[,column_order]),top_annotation = ha,show_column_names=FALSE,show_row_names = TRUE,name="M-value" ,col=coul,row_order = row_order,column_order = column_order)
dev.off()
png_file <- paste("Figures/heatmap_bailey_kTSP-orderd_mystic_allsubtyping_model",model_number,".png",sep="")
png(png_file)
Heatmap(as.matrix(m_top[,column_order]),top_annotation = ha,show_column_names=FALSE,show_row_names = TRUE,name="M-value" ,col=coul,row_order = row_order,column_order = column_order)
dev.off()