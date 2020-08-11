function [tf] = is_raw_cz_struct(inputStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input has field 'roiData'
    if ~isfield(inputStruct, 'roiData')
        tf = false;
        return;
    end
    
    %% Check if 'roiData' has fields 'time', 'tau_m', 'mean_int', and 'red_mean'
    roiData = inputStruct.roiData;
    if ~isfield(roiData, 'time') || ...
       ~isfield(roiData, 'tau_m') || ...
       ~isfield(roiData, 'mean_int') || ...
       ~isfield(roiData, 'red_mean')
        tf = false;
        return;
    end
    
    tf = true;
end