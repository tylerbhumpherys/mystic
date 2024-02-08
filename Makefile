PHONY: clean

clean:
	rm -f Generated_data/*
	rm -f Figures/*
	rm -f Models/*
	#rm -f report.pdf
	
Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData: Scripts/refactor_Y_SSC.R \
	Source_data/TCGA_Y_DWMC1.1_07082022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022.RData
	Rscript Scripts/refactor_Y_SSC.R

Models/model1_ktsp.RData: Scripts/model1_ktsp.R \
	Source_data/melted_zach1125.RData \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData
	Rscript Scripts/model1_ktsp.R

Models/model2_ktsp.RData: Scripts/model2_ktsp.R \
	Source_data/melted_zach1125.RData \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData
	Rscript Scripts/model2_ktsp.R
	
Models/model3_ktsp.RData: Scripts/model3_ktsp.R \
	Source_data/melted_zach1125.RData \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData
	Rscript Scripts/model3_ktsp.R
	
Models/model4_ktsp.RData: Scripts/model4_ktsp.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData
	Rscript Scripts/model4_ktsp.R

Models/model1_RF.RData: Scripts/model1_RF.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model1_ktsp.RData
	Rscript Scripts/model1_RF.R

Models/model2_RF.RData: Scripts/model2_RF.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model2_ktsp.RData
	Rscript Scripts/model2_RF.R
	
Models/model3_RF.RData: Scripts/model3_RF.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model3_ktsp.RData
	Rscript Scripts/model3_RF.R

Models/model4_RF.RData: Scripts/model4_RF.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model4_ktsp.RData
	Rscript Scripts/model4_RF.R

Models/model1_PLR.RData: Scripts/model1_PLR.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model1_ktsp.RData
	Rscript Scripts/model1_PLR.R

Models/model2_PLR.RData: Scripts/model2_PLR.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model2_ktsp.RData
	Rscript Scripts/model2_PLR.R
	
Models/model3_PLR.RData: Scripts/model3_PLR.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model3_ktsp.RData
	Rscript Scripts/model3_PLR.R

Models/model4_PLR.RData: Scripts/model4_PLR.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model4_ktsp.RData
	Rscript Scripts/model4_PLR.R
	
Figures/model1_heatmaps.pdf: Scripts/model1_heatmaps.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model1_ktsp.RData \
	Models/model1_RF.RData
	Rscript Scripts/model1_heatmaps.R
	
Figures/model2_heatmaps.pdf: Scripts/model2_heatmaps.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model2_ktsp.RData \
	Models/model2_RF.RData
	Rscript Scripts/model2_heatmaps.R
	
Figures/model3_heatmaps.pdf: Scripts/model3_heatmaps.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model3_ktsp.RData \
	Models/model3_RF.RData
	Rscript Scripts/model3_heatmaps.R
	
Figures/model4_heatmaps.pdf: Scripts/model4_heatmaps.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model4_ktsp.RData \
	Models/model4_RF.RData
	Rscript Scripts/model4_heatmaps.R
	
Figures/model1_survival.pdf: Scripts/model1_survival.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model1_ktsp.RData \
	Models/model1_RF.RData
	Rscript Scripts/model1_survival.R
	
Figures/model2_survival.pdf: Scripts/model2_survival.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model2_ktsp.RData \
	Models/model2_RF.RData
	Rscript Scripts/model2_survival.R

Figures/model3_survival.pdf: Scripts/model3_survival.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model3_ktsp.RData \
	Models/model3_RF.RData
	Rscript Scripts/model3_survival.R

Figures/model4_survival.pdf: Scripts/model4_survival.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Source_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model4_ktsp.RData \
	Models/model4_RF.RData
	Rscript Scripts/model4_survival.R
