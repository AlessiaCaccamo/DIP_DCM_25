% Alessia Caccamo, University of Exeter, September 2023
function plot_LFP_params(DCM_models, m) % Function to extract and plot the parameter estimates 
params_all=zeros(27,2,m); % Matrix of parameter sets consisting of 27 parameters, 2 experimental conditions/datasets, and m number of repeats
log_params_all=zeros(27,2,m); % Log scalings 
cov_all=zeros(27,2,m);

for i=1:2 % For each condition
for nsim=1:m 
DCM = DCM_models{i}{nsim};
param_values_pre(1) = DCM.Ep.R(1); % Reconstructed parameters
param_values_pre(2) = DCM.Ep.R(2) + log(2); 
param_values_pre(3) = DCM.Ep.T(1) + log(4) - log(1000);
param_values_pre(4) = DCM.Ep.T(2) + log(16) - log(1000); 
param_values_pre(5) = DCM.Ep.G + log(8);
param_values_pre(6) = DCM.Ep.H(1) + log(128); 
param_values_pre(7) = DCM.Ep.H(2) + log(128);
param_values_pre(8) = DCM.Ep.H(3) +  log(64);
param_values_pre(9) = DCM.Ep.H(4) + log(64);
param_values_pre(10) = DCM.Ep.H(5) + log(4);
param_values_pre(11) = DCM.Ep.A{1} + log(32);
param_values_pre(12) = DCM.Ep.A{2} + log(16);
param_values_pre(13) = DCM.Ep.A{3} + log(4);
param_values_pre(14) = DCM.Ep.D + log(2) - log(1000);
param_values_pre(15) = DCM.Ep.I + log(16) - log(1000);
param_values_pre(16) = DCM.Ep.a(1);
param_values_pre(17) = DCM.Ep.a(2);
param_values_pre(18) = DCM.Ep.b(1);
param_values_pre(19) = DCM.Ep.b(2);
param_values_pre(20) = DCM.Ep.c(1);
param_values_pre(21) = DCM.Ep.c(2);
param_values_pre(22) = DCM.Ep.d(1);
param_values_pre(23) = DCM.Ep.d(2);
param_values_pre(24) = DCM.Ep.d(3);
param_values_pre(25) = DCM.Ep.d(4);
param_values_pre(26) = DCM.Ep.f(1);
param_values_pre(27) = DCM.Ep.f(2);
params_all(:, i, nsim) = param_values_pre';

log_param_values_pre(1) = DCM.Ep.R(1); % Log scalings estimated by DCM
log_param_values_pre(2) = DCM.Ep.R(2); 
log_param_values_pre(3) = DCM.Ep.T(1);
log_param_values_pre(4) = DCM.Ep.T(2); 
log_param_values_pre(5) = DCM.Ep.G;
log_param_values_pre(6) = DCM.Ep.H(1); 
log_param_values_pre(7) = DCM.Ep.H(2);
log_param_values_pre(8) = DCM.Ep.H(3);
log_param_values_pre(9) = DCM.Ep.H(4);
log_param_values_pre(10) = DCM.Ep.H(5);
log_param_values_pre(11) = DCM.Ep.A{1};
log_param_values_pre(12) = DCM.Ep.A{2};
log_param_values_pre(13) = DCM.Ep.A{3};
log_param_values_pre(14) = DCM.Ep.D;
log_param_values_pre(15) = DCM.Ep.I;
log_param_values_pre(16) = DCM.Ep.a(1);
log_param_values_pre(17) = DCM.Ep.a(2);
log_param_values_pre(18) = DCM.Ep.b(1);
log_param_values_pre(19) = DCM.Ep.b(2);
log_param_values_pre(20) = DCM.Ep.c(1);
log_param_values_pre(21) = DCM.Ep.c(2);
log_param_values_pre(22) = DCM.Ep.d(1);
log_param_values_pre(23) = DCM.Ep.d(2);
log_param_values_pre(24) = DCM.Ep.d(3);
log_param_values_pre(25) = DCM.Ep.d(4);
log_param_values_pre(26) = DCM.Ep.f(1);
log_param_values_pre(27) = DCM.Ep.f(2);
log_params_all(:, i, nsim) = log_param_values_pre';

cov=diag(DCM.Cp); 
cov_values_pre(1) = cov(1);  
cov_values_pre(2) = cov(2);
cov_values_pre(3) = cov(3);
cov_values_pre(4) = cov(4);
cov_values_pre(5) = cov(5);
cov_values_pre(6) = cov(6);
cov_values_pre(7) = cov(7); 
cov_values_pre(8) = cov(8);
cov_values_pre(9) = cov(9);
cov_values_pre(10) = cov(10);
cov_values_pre(11) = cov(11);
cov_values_pre(12) = cov(12);
cov_values_pre(13) = cov(13);
cov_values_pre(14) = cov(15);
cov_values_pre(15) = cov(16);
cov_values_pre(16) = cov(34);
cov_values_pre(17) = cov(35);
cov_values_pre(18) = cov(36);
cov_values_pre(19) = cov(37);
cov_values_pre(20) = cov(38);
cov_values_pre(21) = cov(39);
cov_values_pre(22) = cov(40);
cov_values_pre(23) = cov(41);
cov_values_pre(24) = cov(42);
cov_values_pre(25) = cov(43);
cov_values_pre(26) = cov(44);
cov_values_pre(27) = cov(45);
cov_all(:, i, nsim) = cov_values_pre';
 
end
end

paramsvec = {'R1','R2','Te','Ti','He', 'G1', 'G2', 'G3', 'G4', 'G5','A1','A2','A3','De','Di','a1','a2','b1','b2','c1','c2','d1','d2','d3','d4','f1','f2'};

figure; % Plot the lognormal distributions (using the reparameterised values)
for ii = 1:15
muvec_pre = params_all(ii, 1, :);
varvec_pre = cov_all(ii, 1, :);
muvec_post = params_all(ii, 2, :);
varvec_post = cov_all(ii, 2, :);
x = linspace(exp(min(muvec_pre) - 1.5*sqrt(max(varvec_pre))), exp(max(muvec_pre) + 1.5*sqrt(max(varvec_pre))), 1000); % The x values for plotting the lognormal distributions are generated with a logarithmic scale
x_post = linspace(exp(min(muvec_post) - 1.5*sqrt(max(varvec_post))), exp(max(muvec_post) + 1.5*sqrt(max(varvec_post))), 1000);
subplot(3,5,ii);
hold on;
total_density_pre = zeros(size(x));
total_density_post = zeros(size(x));
for i = 1:length(muvec_pre)
    mu_pre = muvec_pre(i);
    sigma_pre = sqrt(varvec_pre(i)); % Standard deviation
    pdf_pre = (1./(x.*sigma_pre * sqrt(2 * pi))) .* exp(-(log(x) - mu_pre).^2 / (2*sigma_pre^2));% pdf of current distribution
    total_density_pre = total_density_pre + (pdf_pre/length(muvec_pre)); % each pdf contributes 1/totalN (weighted) to the overall sum, which adds up to 1. 
    mu_post = muvec_post(i);
    sigma_post = sqrt(varvec_post(i)); % Standard deviation 
    pdf_post = (1./(x_post.*sigma_post * sqrt(2 * pi))) .* exp(-(log(x_post) - mu_post).^2 / (2*sigma_post^2));% pdf of current distribution
    total_density_post = total_density_post + (pdf_post/length(muvec_pre));
end
plot(x, total_density_pre, 'b', 'LineWidth', 2); 
plot(x_post, total_density_post, 'r', 'LineWidth', 2); 
xlabel('Parameter Value');
ylabel('Density');
paramsvec = {'R1','R2','Te','Ti','He', 'G1', 'G2', 'G3', 'G4', 'G5','A1','A2','A3','De','Di','a1','a2','b1','b2','c1','c2','d1','d2','d3','d4','f1','f2'};
title(paramsvec{ii})
hold off;
end
legend('Ctl', 'Scz');


for ii = 1:15 % Use the log-scalings to calculate Cohen's d effects size between parameters of the 2 datasets
muvec_pre = log_params_all(ii, 1, :);
varvec_pre = cov_all(ii, 1, :);
muvec_post = log_params_all(ii, 2, :);
varvec_post = cov_all(ii, 2, :);
x = linspace(min(muvec_pre) - 3*sqrt(max(varvec_pre)), max(muvec_pre) + 3*sqrt(max(varvec_pre)), 1000); % for working with normal distributions, parameters are in their normal, linear scale
total_density_pre = zeros(size(x));
total_density_post = zeros(size(x));
for i = 1:length(muvec_pre)
    mu_pre = muvec_pre(i);
    sigma_pre = sqrt(varvec_pre(i)); 
    mu_post = muvec_post(i);
    sigma_post = sqrt(varvec_post(i));
    pdf_pre = (1/(sigma_pre * sqrt(2 * pi))) * exp(-0.5 * ((x - mu_pre) / sigma_pre).^2);% pdf of current distribution
    pdf_post = (1/(sigma_post * sqrt(2 * pi))) * exp(-0.5 * ((x - mu_post) / sigma_post).^2);% pdf of current distribution
    total_density_pre = total_density_pre + (pdf_pre/length(muvec_pre)); % each pdf contributes 1/totalN (weighted) to the overall sum, which adds up to 1. 
    total_density_post = total_density_post + (pdf_post/length(muvec_pre));
end
cumulative_density_pre = cumsum(total_density_pre);
cumulative_density_pre = cumulative_density_pre / cumulative_density_pre(end); % Normalise CDF
cumulative_density_post = cumsum(total_density_post);
cumulative_density_post = cumulative_density_post / cumulative_density_post(end); % Normalise CDF
random_samples_pre = zeros(1e5, 1); 
random_samples_post = zeros(1e5, 1);
for n = 1:1e5
    rand_num = rand(); % Generate uniform random number
    random_samples_pre(n) = x(find(cumulative_density_pre >= rand_num, 1, 'first')); % Inverse transform sampling
    random_samples_post(n) = x(find(cumulative_density_post >= rand_num, 1, 'first'));
end
d(ii)=(mean(random_samples_post) - mean(random_samples_pre))/sqrt((var(random_samples_post)+var(random_samples_pre))/2);
xlabel('Parameter Value');
ylabel('Density');
paramsvec = {'R1','R2','Te','Ti','He', 'G1', 'G2', 'G3', 'G4', 'G5','A1','A2','A3','De','Di','a1','a2','b1','b2','c1','c2','d1','d2','d3','d4','f1','f2'};
title(paramsvec{ii})
hold off;
end
legend('Ctl', 'Scz');

%save('inferences_hybrid_ctl_scz_150_gen.mat', 'd');

colors = jet(10);  % Colormap
desaturation_factor = 0.5; 
neutral_color = [0.5, 0.5, 0.5]; 
colors = (1 - desaturation_factor) * colors + desaturation_factor * neutral_color;
figure; % Plot the inferences
subplot(2, 3, 4);
bar(1:15, d, 'FaceColor', colors(1,:));
hold on;
xticks(1:15);
xticklabels(paramsvec);
xlabel('Parameter');
ylabel("Cohen's d (Post-Pre)");
title('Placebo Hybrid');
yline(0.2, 'r--');
yline(0.5, 'k--');
yline(0.8, 'k--');
yline(-0.2, 'r--');
yline(-0.5, 'k--');
yline(-0.8, 'k--');

end





