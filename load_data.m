function [data,freq] =load_data(i)   % Load the dataset (EEG spectrum) to be modelled 
    load('Spectra_all_subj_norm_final.mat'); % 'average_spectrum', 'average_spectrum_patient', 'f', 'f_patient', 'mas_control', 'mas_patient');
    f=your_frequency_vector;
    if i == 1 % Load the power spectrum associated with condition 1
    data = log(your_psd_vector_condition1)'; % considering you want to compare spectra of two experimental conditions
    freq=f; % Frequency bins
    elseif i == 2
    data = log(your_psd_vector_condition2)'; % Load the power spectrum associated with condition 2
    freq=f; % Frequency bins (which are the same for both conditions)
    end 
