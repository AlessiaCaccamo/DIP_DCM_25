% Alessia Caccamo, University of Exeter, 2025
%function DIP_Pipeline(total_num, select_num) 
    % MODEL_PIPELINE Executes the DIP-DCM modeling pipeline for the LFP NMM with given parameter bounds.
    % INPUTS:
    % total_num   - Total number of GA explorations (e.g., 1000).
    % select_num  - Number of selected priors (e.g., 400).
    % This function allows modelling of two datasets representing experimental conditions to be
    % compared. 


    % Ensure spm12 is in this DIP_Pipeline_DEMO folder
    set_paths; % Script that adds paths to the folders containing files for loading the data and running the model 
    total_num=1;
    select_num=1;
    DIP_Pipeline(total_num, select_num) % Run DIP-DCM
    DIP_plots_Pipeline(total_num, select_num) % make plots 

