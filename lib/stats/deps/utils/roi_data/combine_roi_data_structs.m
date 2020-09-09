function [combinedRoiData] = combine_roi_data_structs(roiDataStructs)
    combinedRoiData = struct;
    
    %% Check if we have at least 1 'roiData' struct
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    nStructs = numel(roiDataStructs);
    if nStructs < 1
        throw(empty_array_error('roiDataStructs'));
    end 
    
    %% Combine the struct values into a cell, keeping track of the maximum # of pts
    timeVals = [];
    intVals = {};
    redVals = {};
    lifetimeVals = {};
    maxNumPts = 0;
    for i = 1:numel(roiDataStructs)
        try
            [hasLifetime, time, int, red, lifetime] = read_roi_data_struct(roiDataStructs(i));
        catch err
            rethrow(err);
        end
        
        %% Use the time values with the most data pts
        if length(time) > maxNumPts
            maxNumPts = length(time);
            timeVals = time;
        end

        %% Add each ROI to the value cells
        numROI = size(int, 2);
        for roi = 1:numROI
            intVals{end+1} = int(:, roi);
            redVals{end+1} = red(:, roi);

            if hasLifetime
                lifetimeVals{end+1} = lifetime(:, roi);
            else
                lifetimeVals{end+1} = nan;
            end
        end
    end
    
    %% Convert the value cells to matrices and store them in a single 'roiData' struct
    try
        combinedRoiData.time = timeVals;
        [combinedRoiData.int] = columns_to_matrix(intVals, maxNumPts);
        [combinedRoiData.red] = columns_to_matrix(redVals, maxNumPts);
        [combinedRoiData.lifetime] = columns_to_matrix(lifetimeVals, maxNumPts);
    catch err
        rethrow(err);
    end
end