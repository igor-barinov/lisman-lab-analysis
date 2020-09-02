function [tf] = is_raw_hz_file(fileStruct)    
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input struct has all fields
    if ~isfield(fileStruct, 'Aout')
        tf = false;
        return;
    end
    
    roiData = fileStruct.Aout;
    if ~isfield(roiData, 'red') || ~isfield(roiData, 'green') || ~isfield(roiData, 'timestr')
        tf = false;
        return;
    end
    
    tf = true;
end