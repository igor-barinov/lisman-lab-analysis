function [combinedExpInfo] = combine_exp_info_structs(expInfoStructs)
    combinedExpInfo = struct;
    
    %% Check if there is at least one struct
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    nStructs = numel(expInfoStructs);
    if nStructs < 1
        throw(empty_array_error('expInfoStructs'));
    end
    
    %% Verify that the inputs are 'exp_info' structs
    if ~is_exp_info_struct(expInfoStructs)
        throw(invalid_struct_error(expInfoStructs, exp_info_struct_format()));
    end
    
    %% Combine the struct values into corresponding cells
    roiCounts = cell(1, nStructs);
    dnaTypes = cell(1, nStructs);
    solutions = cell(1, nStructs);
    for i = 1:nStructs
        roiCounts{i} = expInfoStructs(i).numROI;
        dnaTypes{i} = expInfoStructs(i).dnaType;
        solutions{i} = expInfoStructs(i).solutions;
    end
    
    %% Store the cells in a new 'exp_info' struct
    combinedExpInfo.numROI = roiCounts;
    combinedExpInfo.dnaType = dnaTypes;
    combinedExpInfo.solutions = solutions;
end