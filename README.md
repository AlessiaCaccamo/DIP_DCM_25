# DIP-DCM toolbox

## Getting started
## Prerequisites
The spm12 toolbox is required, please download it from https://www.fil.ion.ucl.ac.uk/spm/ 
## Downloading
Download the folder
Add spm12 to the DEMO folder and unzip it to run the demo.
Run DEMO.m script.

## Run your own analysis
1) load_data.m allows you to load your own data. Assign a column vector representing the power spectrum you want to model to the `data' variable, and assign the corresponding column vector of frequency bins to the variable `f'. If you want to model a non log-transformed spectrum, use the default spm_csd_mtf.m function from the spm12 toolbox rather than the one provided here.
2) Edit the fitness functions fitobj1 and fitobj2 in the fitness_MOGA_spm_lfp function based on the power spectral frequencies of interest (ensuring the length matches the one of your data). 
3) Use DIP_Pipeline function to run the genetic algorithm followed by dynamic causal modelling and save outputs.
4) Use DIP_plots_Pipeline.m to plot model psd, parameter distributions and parameter effects.

To use this approach with a different model architecture, please contact a.caccamo@exeter.ac.uk.

Alessia Caccamo, University of Exeter, January 2024.
