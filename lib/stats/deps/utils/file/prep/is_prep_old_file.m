function [tf] = is_prep_old_file(expName, fileStruct)    
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Check if the raw ROI data exists
    if ~isfield(fileStruct, expName)
        tf = false;
        return;
    end
    %% Verify the raw ROI data
    czStruct = getfield(fileStruct, expName);
    if ~is_raw_cz_struct(czStruct)
        tf = false;
        return;
    end
    
    %% Check if the prepared ROI data exists
    if ~isfield(fileStruct, 'prepData')
        tf = false;
        return;
    end
    prepData = fileStruct.prepData;
    %% Verify the prepared ROI data
    if ~isfield(prepData, 'alladj')
        tf = false;
        return;
    end
    
    %% Check if experiment info exists
    if ~isfield(prepData, 'numROI') || ...
        ~isfield(prepData, 'numBase') || ...
        ~isfield(prepData, 'dnaType') || ...
        ~isfield(prepData, 'solBase') || ...
        ~isfield(prepData, 'solutions')
        tf = false;
        return;
    end
    
    tf = true;
end