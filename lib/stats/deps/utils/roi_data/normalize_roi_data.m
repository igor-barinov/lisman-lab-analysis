function [normalizedRoiData] = normalize_roi_data(roiDataStruct, numBasePts)
    normalizedRoiData = struct;
    %% Check if both inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    
    try
        %% Get ROI data counts and values
        [numROI, numPts, hasLifetime] = roi_data_count(roiDataStruct);
        [~, time, int, red, lifetime] = read_roi_data_struct(roiDataStruct);
        
        %% Check if the # of baseline points is valid
        if numBasePts < 1 || numBasePts > numPts
            throw(range_error('numBasePts', 1, numPts));
        end
        
        % k = # base pts / ( sum(data[1 -> baseline] )
        normalizedInt = {};
        normalizedRed = {};
        normalizedLt = {};
        
        for i = 1:numROI
            data = int(:, i);
            k = numBasePts / sum(data(1:numBasePts));
            normalizedInt{end+1} = k * data;
            
            data = red(:, i);
            k = numBasePts / sum(data(1:numBasePts));
            normalizedRed{end+1} = k * data;
            
            if hasLifetime
                data = lifetime(:, i);
                k = numBasePts / sum(data(1:numBasePts));
                normalizedLt{end+1} = k * data;
            end
        end
        
        normalizedRoiData.time = time;
        [normalizedRoiData.int] = columns_to_matrix(normalizedInt, numPts);
        [normalizedRoiData.red] = columns_to_matrix(normalizedRed, numPts);
        if ~isempty(normalizedLt)
            [normalizedRoiData.lifetime] = columns_to_matrix(normalizedLt, numPts);
        end        
    catch err
        rethrow(err);
    end
end