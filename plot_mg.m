function state = plot_mg(~,state,flag, data, freq) % Function to plot the model against the data at each generation
    p= state.Population;
    s= state.Score;
    sed = vecnorm(s'); % Find the best tradeoff
    ind = find(sed==min(sed),1);
    param_values = p(ind,:);
    psd_m = generate_spectrum(param_values, freq);
    psd_m_pre_current1=psd_m;
    temp = s(:,1);
    ind = find(temp==min(temp));
    param_values = p(ind,:);
    psd_m = generate_spectrum(param_values, freq);
    psd_m_pre_current2=psd_m;
	plot(freq,psd_m_pre_current1, 'b')
    hold on
    plot(freq,data, 'k')
    hold off
    legend({'ed','data'})
end
