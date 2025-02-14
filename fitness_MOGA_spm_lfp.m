% PhD Mathematics and Statistics, Thesis Chapter 1, Alessia Caccamo, University of Exeter, January 2024
function fitall = fitness_MOGA_spm_lfp(param_values, paramsvec, data, paramstoest,freq)
warning('off', 'signal:finddelay:noSignificantCorrelationScalar');
MOGA_lfp_params;
paramsinput = paramsvec;
paramsinput(paramstoest) = param_values;
M.pE = param_values; % Set parameters in the M structure to run for SPM
psd_m = generate_spectrum(param_values, freq); % Generate the model spectrum based on the current parameter values
fitobj1 = sqrt(mean((psd_m(15:108) - data(15:108)).^2)); % The objective based on frequencies of interest
fitobj2 = sqrt(mean((psd_m(57:115) - data(57:115)).^2));
if isnan(fitobj1) % If NaN, assign high fitness value
   fit1 = 100;
   fit2=100;
else    
fit1 = fitobj1;
fit2 = fitobj2;
end
fitall = [fit1, fit2];
end
