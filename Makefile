PHONY: clean

clean:
	rm -f Generated_data/*
	rm -f Figures/*
	rm -f Models/*
	#rm -f report.pdf
	
refactored_data: Scripts/refactor_Y_SSC.R \
	Source_data/TCGA_Y_DWMC1.1_07082022.RData \
	Source_data/bailey_Y_DWMC1.1_07112022.RData
	Rscript Scripts/refactor_Y_SSC.R

ktsp_model: Scripts/ktsp.R \
	Source_data/melted_zach1125.RData \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData
	Rscript Scripts/ktsp.R $(MODEL_NUMBER)

rf_model: Scripts/rf.R \
	Source_data/TCGA_X_DWMC1.1_07082022.RData \
	Generated_data/TCGA_Y_DWMC1.1_07082022_refactor.RData \
	Source_data/bailey_X_DWMC1.1_07112022.RData \
	Generated_data/bailey_Y_DWMC1.1_07112022_refactor.RData \
	Models/model$(MODEL_NUMBER)_ktsp.RData
	Rscript Scripts/rf.R $(MODEL_NUMBER)

plr_model: Scripts/plr.R \
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
