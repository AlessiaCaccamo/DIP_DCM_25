% LFP model MOGA

function out=run_lfp_MOGA(data,freq,nsim) %(jobid,nsim)
%rng('shuffle'); % ensure random number generation is seeded differently at each execution.
%addpath(genpath('.'));
%rng(nsim*jobid);

npop=650;

pop = npop;
%save_output([], [], 'init'); % Resets the best_scores and gens variables
%at each sim number, and saves the new ones to a file named according to
%the simulation number. Uncomment if fitness scores need to be saved and
%set global nsim

MOGA_lfp_params; % Set parameter bounds
paramstoest=1:27;
npars_est = length(paramstoest);

ff = @(x) fitness_MOGA_spm_lfp(x, paramsvec, data, paramstoest,freq); % Fitness function

npop =650; % Number of parameter sets in the population

MOGA_lfp_params_lhc; % Generate LHC
pop=p1;
scores1 = [];
% Calculate inital pop. scores
for ii=1:size(pop,1)
    %ii
    scores1(ii,:) = ff(pop(ii,:));
end
scores2=scores1;

% Set ga options
options1 = optimoptions('gamultiobj','UseParallel', ...
    true,'PopulationSize', size(pop,1));%, 'PlotFcn',@gaplotscoresm @gaplotdistnace or 'PlotFcn',@gaplotscorediversity);
options1.CrossoverFcn = @crossoverscattered; % Apply crossover function
% options1.CrossoverFcn = @crossovertwopoint;
% options1.MutationFcn=@mutationadaptfeasible; % Change as needed

options2 = options1;
% add to save output from each generation
% options2.OutputFcn = @outputFun_mg;
%options2.OutputFcn = @outputFun_count;
%options2.OutputFcn = @save_output; % save best score at each generation. Function called save_output
options2.MaxTime = 60*60*8; % maximum GA time
options2.Display = 'iter';
options2.InitialPopulationMatrix=pop;
options2.InitialScoresMatrix=scores2;   
options2.MaxStallGenerations = 150; % stopping criterion, if the GA runs and the fitness score does not improve for 100 consecutive generations, it will stop at the 100th generation with the same fitness score. 
options2.MaxGenerations = 150; % total number of generations
options2.FunctionTolerance = 1e-10; % decrease this to consider smaller changes as fitness improvement
%options2.PlotFcn = @plot_mg;
options2.PlotFcn = create_plot_mg(data, freq);

tic;  % Start timing
% Run multi-objective optimisation
[x,fval,exitflag,output,population,scores] = gamultiobj(ff, npars_est, [],[],[],[], lb(paramstoest),ub(paramstoest),[], options2);

runtime = toc; % Stop timing

out = {x,fval,exitflag,output,population,scores, runtime};
%save(['MOGA_LFP_' num2str(nsim) '.mat'], 'out');
end 



