function [sortedSolutions] = sort_solution_info(solutions)
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    elseif ~is_solution_info(solutions)
        throw(invalid_type_error({'solutions'}, {'n x 2 cell: [char, number]'}));
    end
    
    sortedSolutions = sortrows(solutions, 2);
end