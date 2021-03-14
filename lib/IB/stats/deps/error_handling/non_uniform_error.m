% 'non_uniform_error' Exception
%   Error raised when variables do not have the same length
%
% INPUTS
% ------
% <vars>, cell: Contains names of variables that caused the error
%
function [ME] = non_uniform_error(vars)
    varList = cellstr_to_formatted_str(vars, '<', '>', ' ');
    formattedMsg = ['Variables ', varList, ' do not have uniform length.'];
    ME = MException('MATLAB:NonUniform', formattedMsg);
end