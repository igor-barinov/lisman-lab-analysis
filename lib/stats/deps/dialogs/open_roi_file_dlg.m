% 'open_roi_file_dlg' Dialog Function
%   Opens a dialog letting the user select 'ROI' files
%
% NO INPUTS
% 
% OUTPUTS
% -------
% <fileCount>, number: The number of files that were successfully read
% <filepaths>, char or cell: The paths to files that were selected.
%                            If a single file was selected, the path 
%                            will be a string. If multiple files were
%                            selected, the paths will be a cell array of
%                            strings
% <fileDataStructs>, struct array: Structs containing the data of the selected files. 
%                                  Structs are in the 'file_data' format
%
% See also
%   'read_multiple_roi_files'
%   'read_roi_file'
%
function [fileCount, filepaths, fileDataStructs] = open_roi_file_dlg()
    filepaths = [];
    fileCount = 0;
    fileDataStructs = struct;
    
    %% Open the dialog
    [filename, path] = uigetfile('MultiSelect', 'on');
    
    %% Check if a file was selected
    if ~isequal(filename, 0) && ~isequal(path, 0)
        %% Get the filepaths and file count
        filepaths = fullfile(path, filename);
        if iscell(filepaths)
            fileCount = length(filepaths);
        else
            fileCount = 1;
        end
        
        %% Try reading the file(s)
        try
            if fileCount > 1
                [fileDataStructs] = read_multiple_roi_files(filepaths);
            else
                [fileDataStructs] = read_roi_file(filepaths);
            end
        catch err
            rethrow(err);
        end
    end
end