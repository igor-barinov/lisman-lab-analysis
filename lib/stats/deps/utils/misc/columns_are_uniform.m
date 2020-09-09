% 'columns_are_uniform' Function
%   Checks if matrices within a cell array are the same length
%
% INPUTS
% ------
% <columns>, 1 x N cell: Contains matrices to be compared
%
% OUTPUTS
% -------
% <tf>, logical: True if all matrices are the same length, false otherwise
%
% EXCEPTONS
% ---------
% 'missing_inputs_error' if <columns> was not given
% 'invalid_type_error' if <columns> is not a cell with size [1 N]
%
function [tf] = columns_are_uniform(columns)
    %% Verify that a 1 X n cell was given
    if nargin ~= 1
       throw(missing_inputs_error(nargin, 1));
    end
    
    if ~isa(columns, 'cell') || size(columns, 1) ~= 1
        throw(invalid_type_error({'columns'}, {'1 X n cell'}));
    end
    
    %% Compare the lengths of cell contents
    lengths = cellfun('length', columns);
    maxLen = max(lengths);
    minLen = min(lengths);
    if maxLen == minLen
        tf = true;
    else
        tf = false;
    end
end