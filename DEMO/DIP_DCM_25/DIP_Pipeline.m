% Alessia Caccamo, University of Exeter, January 2024
function DIP_Pipeline(total_num, select_num) 
    % MODEL_PIPELINE Executes the DIP-DCM modeling pipeline for the LFP NMM with given parameter bounds.
    % INPUTS:
    % total_num   - Total number of GA explorations (e.g., 1000).
    % select_num  - Number of selected priors (e.g., 400).
    % This function allows modelling of two datasets representing experimental conditions to be
    % compared. 
    %__________________________________________________________________________
    % Copyright (C) 2025 University of Exeter, Alessia Caccamo
    GA_params_matrices = cell(1, 2); % GA parameter matrices for two datasets
    DCM_totals = cell(1, 2); % Store DCM structures for two datasets in the cell array
    out_totals = cell(1, 2); % Store GA output structures for two datasets in the cell array
    for i=1:2 % for each dataset
    [data_psd,freq_bins]=load_data(i);  % Load the row vector data_psd and row vector freq_bins 
    out_total=cell(total_num,1); % GA output for each repeat (defined by total_num), for each dataset
    for nsim=1:total_num % Run or load GA results for each repeat
    out=run_lfp_MOGA(data_psd,freq_bins,nsim); % This function allows to run MOGA here, otherwise run on the server and load the files as follows.
    save(['GA_LFP_dataset_' num2str(i) '_nsim_' num2str(nsim) '.mat'], 'out'); 
    out_total{nsim}=out; % Store outputs associated with each repeat in out_total cell array
    end
    out_totals{i} = out_total; % Store all outputs for both datasets in the cell array out_totals
    GA_params_matrices{i} = save_dcm_priors(out_totals{i}, data_psd,freq_bins,total_num, select_num); % Store MOGA-generated parameters, for each repeat and each dataset in the cell array MOGA_params_matrices. This generates DCM priors based on selected, optimal parameter regions. 
    %save(['GA_priors_hybrid_dataset_' num2str(i) '.mat'], 'GA_params_matrices', 'similar_sim_numbers', 'psd_m_all');
    DCM_total=cell(1,select_num); % DCM structures for each selected GA prior.
    for nsim=1:select_num 
    DCM=run_lfp_hybrid(GA_params_matrices{i},nsim,data_psd,freq_bins); % Run a DCM for each of the selected priors. 
    save(['DCM_LFP_dataset_' num2str(i) '_nsim_' num2str(nsim) '.mat'], 'DCM');
    end 
end

% make plots via DIP_plots_pipeline.m

