function [tf] = is_exp_info_struct(inputStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input has fields 'numROI', 'dnaType', and 'solutions'
    if ~isfield(inputStruct, 'numROI') || ~isfield(inputStruct, 'dnaType') || ~isfield(inputStruct, 'solutions')
        tf = false;
        return;
    end
    
    tf = true;
end