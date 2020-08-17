function analysis_1_2_IB_test(version)
    
    %% Choose directory with all test data
    fprintf('Choose directory with experiment folders...');
    path = uigetdir();
    fprintf('\tdone\n\n');
    
    %% Find all possible experiment files
    cd(path);
    [~, pathFolders] = files_and_folders_in(path);
    
    possibleMatFiles = {};
    for i = 1:numel(pathFolders)
        expFolder = pathFolders{i};
        fprintf('Finding files in ''%s'':\n', expFolder);
        
        dirQueue = {expFolder};
        while ~isempty(dirQueue)
            rootDir = dirQueue{1};
            dirQueue = dirQueue(2:end);
            [files, folders] = files_and_folders_in(rootDir);
            for j = 1:numel(files)
                [~,name, ext] = fileparts(files{j});
                if strcmp(ext, '.mat')
                    fprintf('\tAdded ''%s'' as possibility\n', [name,ext]);
                    possibleMatFiles{end+1} = files{j};
                end
            end            
            
            for j = 1:numel(folders)
                dirQueue = [dirQueue, folders];
            end
        end
        fprintf('\n');
    end
    
    %% Setup output folder
    fprintf('Collected %d possible experiment files. Choosing output folder...', numel(possibleMatFiles));
    outputPath = uigetdir();
    fprintf('\tdone\n\n');
    
    %% Start program
    fprintf('Starting %s...', version);
    try
        [~, hInst] = evalc(version);
        fprintf('\tdone\n\n');
    catch
        fprintf('\tfailed\n\n');
        return;
    end
    
    %% Go through each file
    for i = 1:numel(possibleMatFiles)
        currentFile = possibleMatFiles{i};
        
        fprintf('File #%d: ''%s'':', i, currentFile);
        
        %% Try opening the file
        try
            handles = guidata(hInst);
            openFileCmd = sprintf('%s(''menuOpen_Callback'', handles.menuOpen, [])', version);
            evalc(openFileCmd);
        catch
        end
    end
end