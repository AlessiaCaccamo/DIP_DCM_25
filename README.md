Alessia Caccamo, University of Exeter, January 2024.
Run DEMO
run from a directory containing the spm12 toolbox and the DIP_DCM_25 toolbox

To run your own analysis:
1) Add the psd vectors you want to model and the corresponding frequency vector to load_data.m.
2) Modify set_paths.m accordingly.
3) Edit the Genetic algorithm function ... base on your frequencies of interest. 
4) Use DIP_Pipeline function to run the genetic algorithm followed by dynamic causal modelling and save posterior parameters.
5) Use DIP_plots_Pipeline.m to plot model psd and parameter effects.

