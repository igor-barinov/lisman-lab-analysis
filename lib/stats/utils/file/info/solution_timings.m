function [varargout] = solution_timings(solutions)
    %% Check if valid 'solutions' were given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    elseif ~iscell(solutions) || size(solutions, 2) ~= 2
        throw(invalid_type_error({'solutions'}, {'n x 2 cell'}));
    end
    
    %% Check if there are enough solutions
    if size(solutions, 1) < nargout
        throw(invalid_size_error('solutions', [nargout, 2]));
    end
    
    %% Get the solution timings
    for i = 1:nargout
        varargout{i} = solutions{i, 2};
    end

end