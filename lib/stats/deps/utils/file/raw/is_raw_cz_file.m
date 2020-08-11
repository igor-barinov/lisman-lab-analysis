function [tf] = is_raw_cz_file(expName, fileStruct)    
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Check that ROI data exists
    if ~isfield(fileStruct, expName)
        tf = false;
        return;
    end
    
    %% Verfiy ROI data
    roiData = getfield(fileStruct, expName);
    try
        tf = is_raw_cz_struct(roiData);
    catch err
        rethrow(err);
    end
end