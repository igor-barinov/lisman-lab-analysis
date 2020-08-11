function [tf] = is_roi_data_struct(inputStruct)
    %% Check if input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input has fields 'time', int', and 'red'
    if ~isfield(inputStruct, 'time') || ~isfield(inputStruct, 'int') || ~isfield(inputStruct, 'red')
        tf = false;
    end
    
    %% Check if input's fields are all numeric
    if ~isnumeric(inputStruct.time) || ~isnumeric(inputStruct.int) || ~isnumeric(inputStruct.red)
        tf = false;
    end
    
    tf = true;
end