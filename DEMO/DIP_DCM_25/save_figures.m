function save_figures % Save the generated figures
for j = 1:3
    figure(j)
    exportgraphics(gcf,['Figure',num2str(j),'.pdf'])
end

