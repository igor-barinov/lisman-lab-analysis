function [numROI, dnaType, solutions] = read_exp_info_struct(expInfoStruct)    
    %% Check if we have an input
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Verify that input is an 'exp_info' struct
    if ~is_exp_info_struct(expInfoStruct)
        throw(invalid_struct_error(expInfoStruct, exp_info_struct_format()));
    end
    
    %% Read data
    numROI = expInfoStruct.numROI;
    dnaType = expInfoStruct.dnaType;
    solutions = expInfoStruct.solutions;
    
    %% Verify that data has the correct type
    if ~(isa(numROI, 'numeric') && isa(dnaType, 'char') && isa(solutions, 'cell'))
        throw(invalid_type_error({'numROI', 'dnaType', 'solutions'}, {'numeric', 'char', 'cell'}));
    end
end