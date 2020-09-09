% 'invalid_size_error' Exception
%   Error raised when an argument has invalid dimensions
% 
% INPUTS
% ------
% <argName>, char: Name of argument that caused the error
% <expectedSize>, 1 x 2 matrix: Expected dimensions. Must be 2-dimensional
%
function [ME] = invalid_size_error(argName, expectedSize)
    sizeStr = [num2str(expectedSize(1)), ' x ', num2str(expectedSize(2))];
    formattedMsg = ['Size of <', argName, '> is invalid. Expected size: ', sizeStr, '.'];
    ME = MException('MATLAB:InvalidSize', formattedMsg);
end