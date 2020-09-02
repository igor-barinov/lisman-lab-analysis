function [avgData] = average_roi_data(roiDataStruct, numBasePts)
    avgData = struct;
    
    %% Check if both inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    try
        %% Get all values and data counts
        [numROI, ~, hasLifetime] = roi_data_count(roiDataStruct);
        [~, time, int, red, lifetime] = read_roi_data_struct(roiDataStruct);
        [normRoiData] = normalize_roi_data(roiDataStruct, numBasePts);
        [~, ~, normInt, normRed, normLifetime] = read_roi_data_struct(normRoiData);
        
        %% Get 'int' averages
        intAvg = nanmean(int, 2);
        intSte = nanstd(int, 0, 2) / sqrt(numROI);
        normIntAvg = nanmean(normInt, 2);
        normIntSte = nanstd(normInt, 0, 2) / sqrt(numROI);
        
        %% Get 'red' averages
        redAvg = nanmean(red, 2);
        redSte = nanstd(red, 0, 2) / sqrt(numROI);
        normRedAvg = nanmean(normRed, 2);
        normRedSte = nanstd(normRed, 0, 2) / sqrt(numROI);
        
        %% Get 'lifetime' averages
        if hasLifetime
            ltAvg = nanmean(lifetime, 2);
            ltSte = nanstd(lifetime, 0, 2) / sqrt(numROI);
            normLtAvg = nanmean(normLifetime, 2);
            normLtSte = nanstd(normLifetime, 0, 2) / sqrt(numROI);
        end
        
        %% Build struct
        avgData.time = time;
        
        avgData.int = struct;
        avgData.int.avg = [intAvg, intSte];
        avgData.int.normAvg = [normIntAvg, normIntSte];
        
        avgData.red = struct;
        avgData.red.avg = [redAvg, redSte];
        avgData.red.normAvg = [normRedAvg, normRedSte];
        
        if hasLifetime
            avgData.lifetime = struct;
            avgData.lifetime.avg = [ltAvg, ltSte];
            avgData.lifetime.normAvg = [normLtAvg, normLtSte];
        end
    catch err
        rethrow(err);
    end
end