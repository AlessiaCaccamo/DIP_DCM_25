function [data,freq] =load_data(i)   % Load the dataset (EEG spectrum) to be modelled 
    load('Spectra_all_subj_norm_final.mat'); % 'average_spectrum', 'average_spectrum_patient', 'f', 'f_patient', 'mas_control', 'mas_patient');
    indx=find(f<=85); % Select the frequency range of interest
    mas_control=mas_control(indx);
    f=f(indx);
    indx_patient=find(f_patient<=85);
    mas_patient=mas_patient(indx_patient);
    f_patient=f_patient(indx_patient);
    if i == 1 % Load the power spectrum associated with condition 1
    data = log(mas_control)';
    freq=f; % Frequency bins
    elseif i == 2
    data = log(mas_patient)'; % Load the power spectrum associated with condition 2
    freq=f_patient; % Frequency bins (which are the same for both conditions)
    end 