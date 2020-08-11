% 'length_without_nans' Function
%   Counts the number of values in a matrix that are not NaNs
%
% INPUTS
% ------
% <input>, matrix: Contains values to be counted
%
% OUTPUTS
% -------
% <count>, number: Number of values that are not NaNs
% 
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <input> was not given
% 'invalid_type_error' if <input> is not a matrix
%
function [count] = length_without_nans(input)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input is valid
    if ~isnumeric(input)
        throw(invalid_type_error({'input'}, {'matrix'}));
    end
    
    nanCount = numel(find(isnan(input)));
    count = numel(input) - nanCount;
end