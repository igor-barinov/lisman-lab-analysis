function [newExpInfo] = remove_solution_info(expInfoStruct, solutionIndices)
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    if isempty(solutionIndices)
        throw(empty_array_error('solutions'));
    elseif iscell(solutionIndices) && ischar(solutionIndices{1})
        nameIndices = true;
    elseif isnumeric(solutionIndices)
        nameIndices = false;
    else
        throw(invalid_type_error({'solutions'}, {'matrix or cell array of strings'}));
    end
    
    try
        [~, ~, solutions] = read_exp_info_struct(expInfoStruct);
        if nameIndices
            solNames = solutions(:, 1);
            solutionIndices = ismember(solNames, solutionIndices);
        elseif min(solutionIndices) < 1 || max(solutionIndices) > size(solutions, 1)
            throw(range_error('solutionIndices', 1, size(solutions, 1)));
        end
        
        solutions(solutionIndices, :) = [];
        newExpInfo = expInfoStruct;
        newExpInfo.solutions = solutions;
    catch err
        rethrow(err);
    end
end