% 'read_avg_old_file' Function
%   Reads data from a file following the 'avg_old' format
%
% INPUTS
% ------
% <filepath>, char: Path to the file to be read
%
% OUTPUTS
% -------
% <avgData>, struct: Will contain averages in the 'avg_data' struct format
% <expInfo>, struct: Will contain experiment info in the 'exp_info' struct format
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <filepath> was not given
% 'file_open_error' if file could not be opened
% 'invalid_struct_error' if file data does not follow 'avg_old_file' format
% 
% See also
%   'is_avg_old_file'
%   'avg_old_file_format'
%
function [avgData, expInfo] = read_avg_old_file(filepath)
    avgData = struct;
    expInfo = struct;
    
    %% Check if we have an input
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Try loading the file
    try
        inputFile = load(filepath);
    catch
        throw(file_open_error(filepath));
    end
    
    %% Verfiy that file is in old AVG format
    if ~is_avg_old_file(inputFile)
        throw(invalid_struct_error(inputFile, avg_old_file_format()));
    end
    
    %% Read averages
    averages = inputFile.averages;
    avgData.lifetime = struct;
    avgData.lifetime.avg = [averages.tauAvg, averages.tauSte];
    avgData.lifetime.normAvg = [averages.tauNormAvg, averages.tauNormSte];
    
    avgData.int = struct;
    avgData.int.avg = [averages.intAvg, averages.intSte];
    avgData.int.normAvg = [averages.intNormAvg, averages.intNormSte];
    
    avgData.red = struct;
    avgData.red.avg = [averages.redAvg, averages.redSte];
    avgData.red.normAvg = [averages.redNormAvg, averages.redNormSte];
    
    %% Read time data into 'avgData.time'
    avgData.time = inputFile.time;
    
    %% Read experiment info into 'expInfo'
    expInfo.numROI = inputFile.numROI;
    expInfo.dnaType = inputFile.dnaType;
    expInfo.solutions = inputFile.solutions;
end