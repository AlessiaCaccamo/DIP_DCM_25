Alessia Caccamo, University of Exeter, January 2024.
run from a directory containing the spm12 toolbox and the DIP_DCM_25 toolbox
1) Add the psd vectors you want to model and the corresponding frequency vector to load_data.m.
2) Modify set_paths.m accordingly.
3) Use DIP_Pipeline function to run the genetic algorithm followed by dynamic causal modelling and save posterior parameters.
4) Use DIP_plots_Pipeline.m to plot model psd and parameter effects.
