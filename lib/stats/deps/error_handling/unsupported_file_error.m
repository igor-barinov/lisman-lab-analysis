% 'unsupported_file_error' Exception
%   Error raised when file data cannot be read
%
% INPUTS
% ------
% <filepath>, char: Path to the file that caused the error
%
function [ME] = unsupported_file_error(filepath)
    [~, file, ext] = fileparts(filepath);
    ME = MException('MATLAB:UnsupportedFile', ['File ''', file, ext, ''' is unsupported.']);
end