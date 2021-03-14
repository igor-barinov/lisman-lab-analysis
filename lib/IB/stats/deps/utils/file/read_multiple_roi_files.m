% 'read_multiple_roi_files' Function
%   Reads ROI files and returns and array of structs with the file data
%
% INPUTS
% ------
% <filepaths>, cell: Contains paths to files to be read
%
% OUTPUTS
% -------
% <fileDataStructs>, struct array: Will contain structs with data in the 'file_data' format.
%                                  Excludes data from files that could not be read
%
% EXCEPTIONS
% ----------
% Warning if a file could not be read
% 'missing_inputs_error' if <filepaths> was not given
% 'empty_array_error' if <filepaths> was empty
% 'general_error' if no file could be read
% 
function [fileDataStructs] = read_multiple_roi_files(filepaths)
    fileDataStructs = [];
    
    %% Check if an input was given
    if nargin ~= 1
       throw(missing_inputs_error(nargin, 1));
    end
    

    %% Check if we have at least one filepath
    fileCount = numel(filepaths);
    if fileCount < 1
        throw(empty_array_error('filepaths'));
    end
    
    %% Read each file, trying to determine the type each time
    for i = 1:fileCount
        try
            [nextFileData] = read_roi_file(filepaths{i});
            fileDataStructs = [fileDataStructs, nextFileData];
        catch err
            warning('off', 'backtrace');
            warning(err.message);
        end
    end
    
    %% If no structs were created, there was an error
    if isempty(fileDataStructs)
        throw(general_error({'fileDataStructs'}, 'Could not read files'));
    end
end