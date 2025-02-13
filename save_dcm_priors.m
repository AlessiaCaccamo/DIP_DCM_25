% Alessia Caccamo, University of Exeter, September 2023
function MOGA_params_matrix=save_dcm_priors(out_total,data,freq, n, m) % out_total is 1000x1 containing out structures
% Select priors for DCM based on the optimal regions of parameter space
% identified by MOGA
RMSE_MOGA=zeros(1,m); 
for nsim = 1:n
    out=out_total{nsim};
    x0 = zeros(1,13);
    U=0;
    p = out{1}; % Parameters
    s = out{2}; % Fitness values
    out2=out{2};
    out2_1=out2(:,1); % Objective function 1
    out2_2=out2(:,2); % Objective function 2
    out2_1 = (out2_1 - min(out2_1)) ./ (max(out2_1) - min(out2_1)); % Normalise the fitness values
    out2_2 = (out2_2 - min(out2_2)) ./ (max(out2_2) - min(out2_2)); % Normalise the fitness values
    fit_data=[out2_1,out2_2];
    distances = sqrt(sum(fit_data.^2, 2)); % Euclidean distanceto determine the trade-off between objectives
    [~, min_idx] = min(distances);
    param_values = p(min_idx, :);    % Extract parameter values for which the distance is minimal
    all_sim_log_params(:, nsim) = param_values';
    psd_m = generate_spectrum(param_values, freq); % Generate spectra based on the selected parameters
    psd_m_all(:, nsim) = psd_m;
    RMSE_MOGA(1,nsim) = sqrt(mean((data - psd_m_all(:,nsim)).^2)); % Calculate the error between model and data for all MOGA repeats
end
[~, indices] = mink(RMSE_MOGA, m); % Select m optimal parameter sets
similar_sim_numbers = indices;
MOGA_params_matrix=all_sim_log_params(:,similar_sim_numbers');

