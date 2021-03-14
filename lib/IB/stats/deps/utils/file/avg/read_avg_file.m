% 'read_avg_file' Function
%   Reads data from a file following the 'avg' format
%
% INPUTS
% ------
% <filepath>, char: Path to the file to be read
% 
% OUTPUTS
% -------
% <avgData>, struct: Will contain the averages in the 'avg_data' struct format
% <expInfo>, struct: Will contain the experiment info in the 'exp_info' struct format
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <filepath> was not given
% 'file_open_error' if file could not be opened
% 'invalid_struct_error' if file data does not follow 'avg_file' format
%
% See also
%   'is_avg_file'
%   'avg_file_format'
%
function [avgData, expInfo] = read_avg_file(filepath)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Try loading the file
    try
        inputFile = load(filepath);
    catch
        throw(file_open_error(filepath));
    end
    
    %% Verify that the file is in the current AVG format
    if ~is_avg_file(inputFile)
        throw(invalid_struct_error(inputFile, avg_file_format()));
    end
    
    %% Read averages and info
    avgData = inputFile.avgData;
    expInfo = inputFile.info;
end