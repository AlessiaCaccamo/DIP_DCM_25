% Alessia Caccamo, University of Exeter, January 2024
function DIP_plots_Pipeline(total_num, select_num) 
    % MODEL_PIPELINE Executes the DIP-DCM modeling pipeline for the LFP NMM with given parameter bounds.
    % INPUTS:
    % total_num   - Total number of GA explorations (e.g., 1000).
    % select_num  - Number of selected priors (e.g., 400).
    % This function allows modelling of two datasets representing experimental conditions to be
    % compared. 
    set_paths; % Script that adds paths to the folders containing files for loading the data and running the model 
    GA_params_matrices = cell(1, 2); % GA parameter matrices for two datasets
    DCM_totals = cell(1, 2); % Store DCM structures for two datasets in the cell array
    out_totals = cell(1, 2); % Store GA output structures for two datasets in the cell array
    figure;
    for i=1:2 % for each dataset
    [data_psd,freq_bins]=load_data(i);  % Load the row vector data_psd and row vector freq_bins 
    out_total=cell(total_num,1); % GA output for each repeat (defined by total_num), for each dataset
    for nsim=1:total_num % Run or load GA results for each repeat
    load(['GA_LFP_dataset_' num2str(i) '_nsim_' num2str(nsim) '.mat']); 
    out_total{nsim}=out; % Store outputs associated with each repeat in out_total cell array
    end
    out_totals{i} = out_total; % Store all outputs for both datasets in the cell array out_totals
    GA_params_matrices{i} = save_dcm_priors(out_totals{i}, data_psd,freq_bins,total_num, select_num); % Store MOGA-generated parameters, for each repeat and each dataset in the cell array MOGA_params_matrices. This generates DCM priors based on selected, optimal parameter regions. 
    DCM_total=cell(1,select_num); % DCM structures for each selected GA prior.
    for nsim=1:select_num 
    if i==1
    load(['DCM_LFP_dataset_' num2str(i) '_nsim_' num2str(nsim) '.mat']);
    else
    if i==2
    load(['DCM_LFP_dataset_' num2str(i) '_nsim_' num2str(nsim) '.mat']);
    end
    DCM_total{nsim}=DCM; % Store the DCM structure for each prior into the cell array DCM_total
    end
    DCM_totals{i} = DCM_total; % Store DCM for the two datasets into DCM_totals
    end 
    [model_1_all, model_2_all]=plot_lfp_spectra(DCM_totals, select_num); % Plot model spectra aginst the data using the DCM-generated posterior parameter sets
    save('DIP_LFP_model.mat', 'model_1_all', 'model_2_all');
    plot_LFP_params(DCM_totals, select_num); % Plot the parameter distributions and the inferences between the two datasets. 
    %save_figures % Save the generated figures. 
    end 
end


