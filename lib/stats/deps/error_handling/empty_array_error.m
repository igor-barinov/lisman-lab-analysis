% 'empty_array_error' Exception
%   An error to be raised when an array argument is empty
%
% INPUTS
% ------
% <argName>, char: Name of argument that caused the error
%
function [ME] = empty_array_error(argName)
    ME = MException('MATLAB:EmptyArray', 'Array <%s> cannot be empty', argName');
end