PHONY: clean

clean:
	rm -f Generated_data/*
	rm -f Figures/*
	rm -f Models/*
	rm -f report.pdf
	
directories: Scripts/ensure_directory.R
	Rscript Scripts/ensure_directory.R

Generated_data/%_Y_DWMC1.1_07082022_refactor.RData: Scripts/refactor_Y_SSC.R \
	Source_data/TCGA_Y_DWMC1.1_07082022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022.RData
	Rscript Scripts/refactor_Y_SSC.R

Models/model$(MODEL_NUMBER)_ktsp.RData: Scripts/ktsp.R \
	Source_data/melted_zach1125.RData \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData
	Rscript Scripts/ktsp.R $(MODEL_NUMBER)

Models/model$(MODEL_NUMBER)_RF.RData: Scripts/rf.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model$(MODEL_NUMBER)_ktsp.RData
	Rscript Scripts/rf.R $(MODEL_NUMBER)

Models/model$(MODEL_NUMBER)_PLR.RData: Scripts/plr.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model$(MODEL_NUMBER)_ktsp.RData
	Rscript Scripts/plr.R $(MODEL_NUMBER)
	
heatmap_figures: Scripts/heatmaps.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model$(MODEL_NUMBER)_ktsp.RData \
	Models/model$(MODEL_NUMBER)_RF.RData
	Rscript Scripts/heatmaps.R $(MODEL_NUMBER)

survival_figures: Scripts/survival.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Source_data/PACA_AU_seq_plus04202021.RData \
	Source_data/BaileyMethylationBetaMatrix_Specimen02042022.RData \
	Source_data/TCGA_PAAD_clean_w150_06162022.rds \
	Source_data/specimen.tsv \
	Models/model$(MODEL_NUMBER)_ktsp.RData \
	Models/model$(MODEL_NUMBER)_RF.RData
	Rscript Scripts/survival.R $(MODEL_NUMBER)
	
report.pdf: Scripts/report.R \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model1_ktsp.RData Models/model2_ktsp.RData \
	Models/model3_ktsp.RData Models/model4_ktsp.RData \
	Models/model1_RF.RData Models/model2_RF.RData \
	Models/model3_RF.RData Models/model4_RF.RData \
	Models/model1_PLR.RData Models/model2_PLR.RData \
	Models/model3_PLR.RData Models/model4_PLR.RData 
	Rscript Scripts/report.R
