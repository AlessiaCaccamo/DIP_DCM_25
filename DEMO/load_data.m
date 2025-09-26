function [data,freq] =load_data(i)   % Load the dataset (EEG spectrum) to be modelled 
    load('log_LEV_spectra.mat')
    if i == 1 % Load the power spectrum associated with condition 1
    data = data_psd_pre_LEV; % considering you want to compare spectra of two experimental conditions
    freq=f; % f is the vector of frequency bins
    elseif i == 2
    data = data_psd_post_LEV; % Load the power spectrum associated with condition 2
    freq=f; % Frequency bins (which are the same for both conditions)
    end 
