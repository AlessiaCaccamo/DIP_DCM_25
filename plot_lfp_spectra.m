% Plot model and data spectra

function [model_1_all, model_2_all] = plot_lfp_spectra(DCM_models, m)
figure;
for i = 1:2
[data_psd, freq_bins] = load_data(i);
if i == 1
group_color = [0, 0, 1]; % Blue for dataset 1
spread_color = [0.5, 0.5, 1]; % Lighter blue for spread
else
group_color = [1, 0, 0]; % Red for dataset 2
spread_color = [1, 0.5, 0.5]; % Lighter red for spread
end
model_matrix = zeros(length(freq_bins), m);
for nsim = 1:m
DCM = DCM_models{i}{nsim};
model = spm_csd_mtf(DCM.Ep, DCM.M, DCM.xU);
model_matrix(:, nsim) = real(model{1});
end 
if i == 1
model_1_all = model_matrix;
else
model_2_all = model_matrix;
end
mean_model = mean(model_matrix, 2);
std_model = std(model_matrix, 0, 2); % Standard deviation across simulations
num = m; % Number of simulations
ci_upper = mean_model + (std_model / sqrt(num)) * 1.96;
ci_lower = mean_model - (std_model / sqrt(num)) * 1.96; 
plot(freq_bins, mean_model, 'Color', group_color, ...
     'LineWidth', 1.5, ...
     'DisplayName', sprintf('Hybrid %s', ternary(i == 1, 'Ctl', 'Scz')));
hold on;
fill([freq_bins; flipud(freq_bins)], ...
             [ci_upper; flipud(ci_lower)], ...
             spread_color, 'FaceAlpha', 0.2, 'EdgeColor', 'none', ...
             'DisplayName', sprintf('95%% CI %s', ternary(i == 1, 'Ctl', 'Scz')));
hold on;
plot(freq_bins, data_psd, '--', 'Color', group_color, 'LineWidth', 1.5, ...
    'DisplayName', sprintf('Data %s', ternary(i == 1, 'Ctl', 'Scz')));
hold on;
end
xlabel('Frequency (Hz)');
ylabel('Log PSD');
legend('show');
end
% function for conditional
function out = ternary(condition, trueText, falseText)
if condition
   out = trueText;
else
   out = falseText;
end
end

 
