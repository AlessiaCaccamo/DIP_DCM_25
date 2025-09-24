function [data,freq] =load_data(i)   % Load the dataset (EEG spectrum) to be modelled 
    load('your_data_file.mat'); 
    f=your_frequency_vector;
    if i == 1 % Load the power spectrum associated with condition 1
    data = log(your_psd_vector_condition1)'; % considering you want to compare spectra of two experimental conditions
    freq=f; % Frequency bins
    elseif i == 2
    data = log(your_psd_vector_condition2)'; % Load the power spectrum associated with condition 2
    freq=f; % Frequency bins (which are the same for both conditions)
    end 
