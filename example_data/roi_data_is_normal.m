function [ks, ad, jb, lillie] = roi_data_is_normal(roiData, enablePlots)
    ks = [];
    ad = [];
    jb = [];
    lillie = [];
    for i = 1:size(roiData,2)
        col = roiData(:, i);
        % h: 0-> Data is normal, 1-> Data is not normal
        [hKS,p] = kstest(col);
        ks = [ks, p];
        [hAD,p] = adtest(col);
        ad = [ad, p];
        [hJB,p] = jbtest(col);
        jb = [jb, p];
        [hL,p] = lillietest(col);
        lillie = [lillie, p];
        
        isN = false;
        if ~hKS
            title = 'KS';
            isN = true;
        else
            title = '';
        end
        
        if ~hAD 
            isN = true;
            title = [title, ' & AD'];
        end
        if ~hJB
            isN = true;
            title = [title, ' & JB'];
        end
        if ~hL
            isN = true;
            title = [title, ' & Lillie'];
        end
        
        if isN && enablePlots
            figure('Name', title);
            histogram(col, 10);
        end
    end
    
    x = 1:size(roiData,2);
    yLimits = [0, 0.5];
    lineX = [0.13, 0.9];
    lineY = [0.19, 0.19];
    
    figure('Name', 'Kolmogorov-Smirnov');
    scatter(x, ks);
    annotation('line', lineX, lineY);
    ylim(yLimits);
    
    figure('Name', 'Anderson-Darling');
    scatter(x, ad);
    annotation('line', lineX, lineY);
    ylim(yLimits);
    
    figure('Name', 'Jarque-Bera');
    scatter(x, jb);
    annotation('line', lineX, lineY);
    ylim(yLimits);
    
    figure('Name', 'Lilliefors');
    scatter(x, lillie);
    annotation('line', lineX, lineY);
    ylim(yLimits);
end