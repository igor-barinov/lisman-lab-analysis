% 'file_open_error' Exception
%   Error to be raised when a file could not be opened
%
% INPUTS
% ------
% <filepath>, char: Path to file that caused error
%
function [ME] = file_open_error(filepath)
    ME = MException('MATLAB:FileOpen', ['Could not open file at ''', filepath, '''.']);
end