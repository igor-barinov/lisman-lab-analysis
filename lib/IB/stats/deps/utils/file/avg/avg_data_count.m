function [numROI, numPts, hasLifetime] = avg_data_count(avgDataStruct)
    %% Check if an 'avg_data' struct was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    if ~is_avg_data_struct(avgDataStruct)
        throw(invalid_struct_error(avgDataStruct, avg_data_struct_format()));
    end
    
    %% Get the data counts
    numROI = size(avgDataStruct.int.avg, 2) / 2;
    numPts = length(avgDataStruct.time);
    hasLifetime = isfield(avgDataStruct, 'lifetime');
end