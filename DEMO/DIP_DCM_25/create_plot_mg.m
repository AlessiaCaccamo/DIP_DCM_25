function plotFcnHandle = create_plot_mg(data, freq) % Return a function handle to be used as the PlotFcn in the gamultobj function
    plotFcnHandle = @plot_mg; 
    function state = plot_mg(~, state, flag)
    if strcmp(flag, 'iter') || strcmp(flag, 'done')
    p = state.Population; % Population
    s = state.Score; % Score
    sed = vecnorm(s'); % Find the best tradeoff
    ind = find(sed == min(sed), 1);
    param_values = p(ind, :); % parameters associated with the minimum score
    psd_m = generate_spectrum(param_values, freq); % Generate spectrum for the current parameters
    plot(freq, psd_m, 'b');
    hold on;
    plot(freq, data, 'k');
    hold off;
    legend({'Model', 'Data'});
    drawnow; % Ensure the plot updates
    end
    end
end