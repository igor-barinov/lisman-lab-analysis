function [files, folders] = files_and_folders_in(path)
    allFiles = dir(path);
    filesAreDir = [allFiles.isdir];
    fileStructs = allFiles(~filesAreDir);
    folderStructs = allFiles(filesAreDir);
    folderStructs(ismember( {folderStructs.name}, {'.', '..'} )) = []; % Remove '.' and '..' folders
    
    % Append root path to results
    files = {};
    folders = {};
    for i = 1:numel(fileStructs)
        files{end+1} = fullfile(path, fileStructs(i).name);
    end
    for i = 1:numel(folderStructs)
        folders{end+1} = sprintf('%s\\%s', path, folderStructs(i).name);
    end
end