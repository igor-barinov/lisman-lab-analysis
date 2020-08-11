function [hasLifetime, time, int, red, lifetime] = read_roi_data_struct(roiDataStruct)
    lifetime = [];
    
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Verify that at least time, int, and red data exist
    if ~(isfield(roiDataStruct, 'time') && ...
        isfield(roiDataStruct, 'int') && ...
        isfield(roiDataStruct, 'red'))
        throw(invalid_struct_error(roiDataStruct, roi_data_struct_format()));
    end
    
    %% Get all data except lifetime
    time = roiDataStruct.time;
    int = roiDataStruct.int;
    red = roiDataStruct.red;
    
    %% Try reading lifetime
    if isfield(roiDataStruct, 'lifetime')
        lifetime = roiDataStruct.lifetime;
        hasLifetime = true;
    else
        hasLifetime = false;
    end
end