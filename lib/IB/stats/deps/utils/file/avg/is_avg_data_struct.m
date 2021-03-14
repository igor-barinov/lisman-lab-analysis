function [tf] = is_avg_data_struct(inputStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input has fields 'time', 'int', and 'red'
    if ~isfield(inputStruct, 'time') || ~isfield(inputStruct, 'int') || ~isfield(inputStruct, 'red')
        tf = false;
        return;
    end
    
    %% Check if 'int' averages exist
    if ~isfield(inputStruct.int, 'avg') || ~isfield(inputStruct.int, 'normAvg')
        tf = false;
        return;
    end
    %% Check if 'red' averages exist
    if ~isfield(inputStruct.red, 'avg') || ~isfield(inputStruct.red, 'normAvg')
        tf = false;
        return;
    end
    %% Check if 'lifetime' averages exist
    if isfield(inputStruct, 'lifetime')
        if ~isfield(inputStruct.lifetime, 'avg') || ~isfield(inputStruct.lifetime, 'normAvg')
            tf = false;
            return;
        end
    end
    
    tf = true;
end