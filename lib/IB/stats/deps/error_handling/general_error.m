% 'general_error' Exception
%   Error to be raised when specific logic/computation has failed
%
% INPUTS
% ------
% <vars>, cell: Cell array of variable names that caused an error
% <details>, char: Message describing the error
%
function [ME] = general_error(vars, details)
    varList = cellstr_to_formatted_str(vars, '<', '>', ' ');
    formattedMsg = ['Error occured handling variable(s) ', varList, '. Cause: ', details];
    ME = MException('MATLAB:General', formattedMsg);
end