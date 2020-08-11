function [numROI, numPts, hasLifetime] = roi_data_count(roiDataStruct)    
    %% Verify that a 'roi_data' struct was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    if ~is_roi_data_struct(roiDataStruct)
        throw(invalid_struct_error(roiDataStruct, roi_data_struct_format()));
    end
    
    %% Get the data counts
    numROI = size(roiDataStruct.int, 2);
    numPts = length(roiDataStruct.time);
    if isfield(roiDataStruct, 'lifetime')
        hasLifetime = true;
    else
        hasLifetime = false;
    end
end