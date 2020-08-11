function [vars] = roi_data_variance(roiData)
    vars = [];
    for i = 1:size(roiData, 2)
        col = roiData(:, i);
        vars = [vars, var(col)];
    end
    
    dif = diff(vars);
    
    
    figure('Name', 'Variances');
    x = 1:size(roiData,2);
    scatter(x, vars);
    
    figure('Name', 'Variance Diffs');
    x = 1:length(dif);
    scatter(x, dif);
    ylim([-1 1]);
end
