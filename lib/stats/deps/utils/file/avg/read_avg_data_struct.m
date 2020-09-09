function [hasLifetime, time, int, red, lifetime] = read_avg_data_struct(avgDataStruct)
    lifetime = struct;
    
    %% Verify that an 'avg_data' struct was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    if ~is_avg_data_struct(avgDataStruct)
        throw(invalid_struct_error(avgDataStruct, avg_data_struct_format()));
    end
    
    %% Load 'time', 'int', and 'red' data
    time = avgDataStruct.time;
    int = avgDataStruct.int;
    red = avgDataStruct.red;
    
    %% Load 'lifetime' data if available
    if isfield(avgDataStruct, 'lifetime')
        hasLifetime = true;
        lifetime = avgDataStruct.lifetime;
    else
        hasLifetime = false;
    end
end