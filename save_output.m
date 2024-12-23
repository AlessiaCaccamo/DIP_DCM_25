function [state, options, optchanged] = save_output(options, state, flag) % Function to save fitness scores during MOGA execution
    global nsim;  % Use global variable to store the simulation number
    optchanged = false;

    if strcmp(flag, 'init')  % initialization flag is provided in main script
        best_scores = [];
        gens = [];
        save(['/emmy-noether/home/ac1376/Hybrid_PL_efficiency/Conv_standard_500_gen/fitness_over_generations_' num2str(nsim) '.mat'], 'best_scores', 'gens');
        return;
    end
    % Find the best score of this generation
    best_socf = min(state.Score);
    gen = state.Generation;

    if exist(['/emmy-noether/home/ac1376/Hybrid_PL_efficiency/Conv_standard_500_gen/fitness_over_generations_' num2str(nsim) '.mat'], 'file') == 2 % load existing data or create new variables
        load(['/emmy-noether/home/ac1376/Hybrid_PL_efficiency/Conv_standard_500_gen/fitness_over_generations_' num2str(nsim) '.mat'], 'best_scores', 'gens');
    else
        best_scores = [];
        gens = [];
    end

    best_scores = [best_scores; best_socf];
    gens = [gens; gen];
    
    save(['/emmy-noether/home/ac1376/Hybrid_PL_efficiency/Conv_standard_500_gen/fitness_over_generations_' num2str(nsim) '.mat'], 'best_scores', 'gens');
end

