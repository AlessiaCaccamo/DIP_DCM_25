function model_Pipeline(total_num, select_num) % 1000 total, 400 selected. I've used 5 and 5 as a trial
    % MODEL_PIPELINE Executes the LFP modeling pipeline with given parameters.
    %
    % INPUTS:
    % total_num   - Total number of simulations to process (e.g., 1000).
    % select_num  - Number of selected simulations for analysis (e.g., 400).
    % save_folder - Folder path to save outputs (optional). If not specified, uses the current directory.
    %
    % OUTPUTS:
    % Saves generated models, parameters, and plots as files in the current folder
    % clc
    % close all
    % clearvars
     % data_folder = ''; % Specify folder for saving
    % cd(data_folder);
    % This function allows modelling of two datasets representing experimental conditions being
    % compared. 
    % December 2024
    set_paths; % Script that adds paths to the folders containing files for loading the data and running the model 
    MOGA_params_matrices = cell(1, 2); % MOGA parameter matrices for two datasets
    DCM_totals = cell(1, 2); % Store DCM structures for two datasets in the cell array
    out_totals = cell(1, 2); % Store MOGA output structures for two datasets in the cell array
    for i=1:2 % for each dataset
    [data_psd,freq_bins]=load_data(i);  % Load the row vector data_psd and row vector freq_bins 
    out_total=cell(total_num,1); % MOGA output for each repeat (defined by total_num), for each dataset
    for nsim=1:total_num % Run or load MOGA results for each repeat
    %out=run_lfp_MOGA(data_psd,freq_bins,nsim); % This function allows to run MOGA here, otherwise run on the server and load the files as follows.
    load(['MOGA_LFP_dataset_' num2str(i) '_nsim_' num2str(nsim) '.mat'], 'out'); 
    out_total{nsim}=out; % Store outputs associated with each repeat in out_total cell array
    end
    out_totals{i} = out_total; % Store all outputs for both datasets in the cell array out_totals
    MOGA_params_matrices{i} = save_dcm_priors(out_totals{i}, data_psd,freq_bins,total_num, select_num); % Store MOGA-generated parameters, for each repeat and each dataset in the cell array MOGA_params_matrices. This generates DCM priors based on selected, optimal parameter regions. 
    %save(['MOGA_priors_hybrid_dataset_' num2str(i) '.mat'], 'MOGA_params_matrices', 'similar_sim_numbers', 'psd_m_all');
    DCM_total=cell(1,select_num); % DCM structures for each selected MOGA prior.
    for nsim=1:select_num 
    DCM=run_lfp_hybrid(MOGA_params_matrices{i},nsim,data_psd,freq_bins); % Run a DCM for each of the selected priors. 
    %DCM.name = ['Grand_LFP_dataset_' num2str(i) '_nsim_' num2str(nsim) '_' DCM.name];
    %save(DCM.name, 'DCM', spm_get_defaults('mat.format'));
    DCM_total{nsim}=DCM; % Store the DCM structure for each prior into the cell array DCM_total
    end
    DCM_totals{i} = DCM_total; % Store DCM for the two datasets into DCM_totals
    end 
    [model_1_all, model_2_all]=plot_lfp_spectra(DCM_totals, select_num); % Plot model spectra aginst the data using the DCM-generated posterior parameter sets
    %save('Hybrid_LFP_model.mat', 'model_1_all', 'model_2_all');
    plot_LFP_params(DCM_totals, select_num); % Plot the parameter distributions and the inferences between the two datasets. 
    save_figures % Save the generated figures. 
end 


