function [newExpInfo] = add_solution_info(expInfoStruct, name, timing)
    %% Check if all inputs were given
    if nargin ~= 3
        throw(missing_inputs_error(nargin, 3));
    end
    
    %% Check if solution info is valid
    if ~ischar(name) || ~isnumeric(timing)
        throw(invalid_type_error({'name', 'timing'}, {'char', 'number'}));
    elseif timing < 1
        throw(range_error('timing', 1, nan));
    end
    
    try
        [~, ~, solutions] = read_exp_info_struct(expInfoStruct);
        solutions = [solutions; {name, timing}];
        newExpInfo = expInfoStruct;
        newExpInfo.solutions = sortrows(solutions, 2);
    catch err
        rethrow(err);
    end
end