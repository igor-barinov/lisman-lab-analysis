function [path, files] = multiple_fileparts(filepaths)
    %% Check if valid filepaths were given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    elseif ~iscell(filepaths) || size(filepaths, 1) ~= 1 || size(filepaths, 2) < 1
        throw(invalid_type_error({'filepaths'}, {'1 x n cell'}));
    end
    
    %% Get the parts of the first file
    files = {};
    [path, files{end+1}, ~] =  fileparts(filepaths{1});
    
    %% Get the parts of the remaining files, checking if the path is common
    for i = 2:numel(filepaths)
        [nextPath, files{end+1}, ~] = fileparts(filepaths{i});
        if ~strcmp(nextPath, path)
            throw(general_error({'filepaths'}, 'Files must share a common path'));
        end
    end
end