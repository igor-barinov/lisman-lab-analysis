function [combinedAvgData] = combine_avg_data_structs(avgDataStructs)
    combinedAvgData = struct;
    
    %% Check if a non-empty input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    structCount = numel(avgDataStructs);
    if structCount < 1
        throw(empty_array_error('avgDataStructs'));
    end
    
    try
        maxTime = [];
        allIntAvg = {};
        allIntSte = {};
        allNormIntAvg = {};
        allNormIntSte = {};
        allRedAvg = {};
        allRedSte = {};
        allNormRedAvg = {};
        allNormRedSte = {};
        allLtAvg = {};
        allLtSte = {};
        allNormLtAvg = {};
        allNormLtSte = {};
        
        maxNumPts = 0;
        for i = 1:structCount
            [~, numPts, hasLifetime] = avg_data_count(avgDataStructs(i));
            [~, time, ~, ~, ~] = read_avg_data_struct(avgDataStructs(i));
            
            [allIntAvg{end+1}, allIntSte{end+1}, allNormIntAvg{end+1}, allNormIntSte{end+1}] = avg_data_by_type(avgDataStructs(i), 'int');
            [allRedAvg{end+1}, allRedSte{end+1}, allNormRedAvg{end+1}, allNormRedSte{end+1}] = avg_data_by_type(avgDataStructs(i), 'red');
            if hasLifetime
                [allLtAvg{end+1}, allLtSte{end+1}, allNormLtAvg{end+1}, allNormLtSte{end+1}] = avg_data_by_type(avgDataStructs(i), 'lifetime');
            end
            
            if numPts > maxNumPts
                maxNumPts = numPts;
                maxTime = time;
            end
        end
        
        [allIntAvg] = columns_to_matrix(allIntAvg, maxNumPts);
        [allIntSte] = columns_to_matrix(allIntSte, maxNumPts);
        [allNormIntAvg] = columns_to_matrix(allNormIntAvg, maxNumPts);
        [allNormIntSte] = columns_to_matrix(allNormIntSte, maxNumPts);
        
        [allRedAvg] = columns_to_matrix(allRedAvg, maxNumPts);
        [allRedSte] = columns_to_matrix(allRedSte, maxNumPts);
        [allNormRedAvg] = columns_to_matrix(allNormRedAvg, maxNumPts);
        [allNormRedSte] = columns_to_matrix(allNormRedSte, maxNumPts);
        
        [allLtAvg] = columns_to_matrix(allLtAvg, maxNumPts);
        [allLtSte] = columns_to_matrix(allLtSte, maxNumPts);
        [allNormLtAvg] = columns_to_matrix(allNormLtAvg, maxNumPts);
        [allNormLtSte] = columns_to_matrix(allNormLtSte, maxNumPts);
        
        combinedAvgData.time = maxTime;
        
        combinedAvgData.int = struct;
        combinedAvgData.int.avg = [allIntAvg, allIntSte];
        combinedAvgData.int.normAvg = [allNormIntAvg, allNormIntSte];
        
        combinedAvgData.red = struct;
        combinedAvgData.red.avg = [allRedAvg, allRedSte];
        combinedAvgData.red.normAvg = [allNormRedAvg, allNormRedSte];
        
        if ~isempty(allLtAvg)
            combinedAvgData.lifetime = struct;
            combinedAvgData.lifetime.avg = [allLtAvg, allLtSte];
            combinedAvgData.lifetime.normAvg = [allNormLtAvg, allNormLtSte];
        end
    catch err
        rethrow(err);
    end
    
    
end