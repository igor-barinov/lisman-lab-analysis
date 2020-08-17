function analysis_1_2_IB_test(version)
    
    %% Choose directory with all test data
    fprintf('Choose directory with experiment folders...');
    path = uigetdir();
    fprintf('\tdone\n\n');
    
    %% Find all possible experiment files
    cd(path);
    [~, pathFolders] = files_and_folders_in(path);
    
    matFileGroups = {};
    for i = 1:numel(pathFolders)
        expFolder = pathFolders{i};
        fprintf('Finding files in ''%s'':\n', expFolder);
        
        dirQueue = {expFolder};
        while ~isempty(dirQueue)
            rootDir = dirQueue{1};
            dirQueue = dirQueue(2:end);
            [files, folders] = files_and_folders_in(rootDir);
            matFiles = {};
            for j = 1:numel(files)
                [~,name, ext] = fileparts(files{j});
                if strcmp(ext, '.mat')
                    fprintf('\tAdded ''%s'' as possibility\n', [name,ext]);
                    matFiles{end+1} = files{j};
                end
            end 
            matFileGroups{end+1} = matFiles;
            
            for j = 1:numel(folders)
                dirQueue = [dirQueue, folders];
            end
        end
        fprintf('\n');
    end
    
    %% Setup output folder
    fprintf('Collected %d possible experiment file groups. Choosing output folder...', numel(matFileGroups));
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
    for i = 1:numel(matFileGroups)
        expFiles = matFileGroups{i};
        
        fprintf('Group #%d:\n', i);
        
        %% Try opening the file
        try
            handles = guidata(hInst);
            openFileCmd = sprintf('%s(''menuOpen_Callback'', handles.menuOpen, expFiles, [])', version);
            evalc(openFileCmd);
        catch err
        end
        
        fprintf('\n');
    end
end