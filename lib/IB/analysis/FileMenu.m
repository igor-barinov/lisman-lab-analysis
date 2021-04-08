classdef FileMenu
    methods (Static)
        function open(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'File -> Open' Callback
        %
        % Raises a dialog allowing the user to open new files. If new files
        % are selected, new ROI data and any experiment info is loaded.
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            handles = guidata(hObject);
    
            % Get file paths and store them in a cell
            fileFilter = {'*.mat', 'MATLAB ROI Files (*.mat)'; ...
                          '*.csv', 'FLIMage ROI Files (*.csv)'};

            [file, path] = uigetfile(fileFilter, 'Multiselect', 'on');
            if isequal(file, 0) || isequal(path, 0)
                return;
            end
            filepaths = fullfile(path, file);
            if ~iscell(filepaths)
                filepaths = { filepaths };
            end

            % Move to chosen directory
            cd(path);

            % Construct a file object based on the file format
            if all(AveragedFile.follows_format(filepaths))
                openFile = AveragedFile(filepaths);
            elseif all(FLIMageFile.follows_format(filepaths))
                openFile = FLIMageFile(filepaths);
            elseif all(PreparedFile.follows_format(filepaths))
                % Prepared files have raw data as well, need user to choose
                dataChoice = questdlg('This file has raw and prepared ROI data. Which would you like to load?', ...
                                  'Select ROI Data', ...
                                  'Raw', 'Prepared', 'Cancel', ...
                                  'Cancel');

                switch dataChoice
                    case 'Raw'
                        openFile = RawFile(filepaths);
                    case 'Prepared'
                        openFile = PreparedFile(filepaths);
                    otherwise
                        return;
                end
            elseif all(RawFile.follows_format(filepaths))           % <-- Raw is checked after prep since prep can be raw
                openFile = RawFile(filepaths);
            else
                warndlg('The selected files are not supported or are not of the same type.');
                return;
            end

            % Get experiment info
            dnaTypes = openFile.dna_types();
            allSolutions = openFile.solution_info();

            % Check if dna types are same for prepared files
            if openFile.type() == ROIFileType.Prepared
                uniqueDNA = unique(dnaTypes);
                if numel(uniqueDNA) > 1
                    % Let user choose to keep files with different DNA types
                    options = cell(size(filepaths));
                    for i = 1:numel(filepaths)
                        [~, filename, ~] = fileparts(filepaths{i});
                        options{i} = [filename, ': ''', dnaTypes{i}, ''''];
                    end
                    promptStr = {'The files selected have different DNA types.', 'Please select the files you want to load.'};
                    [optionIdx, fileWasSelected] = listdlg('Name', 'File Conflict', ...
                                                           'PromptString', promptStr, ...
                                                           'ListString', options, ...
                                                           'ListSize', [300 300]);
                    if ~fileWasSelected
                        return;
                    end

                    openFile = PreparedFile(filepaths(optionIdx));

                    % Use only unique dna types
                    dnaTypes = unique(openFile.dna_types());
                end
            end

            % Combine dna types
            dnaType = ROIUtils.combine_dna_types(dnaTypes);
            % Combine solution info
            solutionInfo = ROIUtils.combine_solution_info(allSolutions);

            % Validate solution info
            if openFile.has_exp_info() && ~ROIUtils.has_number_of_baseline_pts(solutionInfo)
                warndlg('This file has invalid experiment info. Please fix before loading');
                return;
            end

            % Get data values
            time = openFile.time();
            lifetime = openFile.lifetime();
            int = openFile.green();
            red = openFile.red();

            % Generate ROI data object
            switch openFile.type()
                case ROIFileType.Averaged
                    normLt = openFile.normalized_lifetime();
                    normInt = openFile.normalized_green();
                    normRed = openFile.normalized_red();
                    roiData = AverageTable(time, lifetime, normLt, int, normInt, red, normRed);
                otherwise
                    roiData = ROITable(time, lifetime, int, red);
            end

            % Update program state
            AppState.set_open_files(handles, openFile);
            AppState.set_roi_data(handles, roiData);

            % Update UI
            GUI.update_win_title(handles);
            GUI.update_ui_access(handles, openFile.type());
            handles = GUI.update_toggle_menu(handles, openFile.roi_count());
            GUI.update_dna_type(handles, dnaType);
            GUI.update_solution_info(handles, solutionInfo);

            % Disable info-dependent controls if necessary
            if ~openFile.has_exp_info()
                if GUI.time_is_adjusted(handles)
                    GUI.toggle_button(handles.('btnToggleAdjustedTime'));
                end
                if GUI.values_are_normalized(handles)
                    GUI.toggle_button(handles.('btnToggleNormVals'));
                    GUI.toggle_menu(handles.('menuToggleNormVals'));
                end
                %if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    %GUI.toggle_menu(handles.('menuShowAnnots'));
                %end
            end

            % Update data table
            GUI.update_data_table(handles);         % <-- Updated last because of controls modifying disp
        end
        
        function save(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'File -> Save' Callback
        %
        % Raises a dialog allowing the user to save changes in the
        % workspace. Files can be saved as the same file type or a
        % different file type.
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get program state
            handles = guidata(hObject);
            openFile = AppState.get_open_files(handles);
            saveData = AppState.get_roi_data(handles);
            dnaType = GUI.get_dna_type(handles);
            solutions = GUI.get_solution_info(handles);
            enabledROIs = GUI.get_enabled_rois(handles);

            % Check if we have all data
            if isempty(dnaType)
                warndlg('Please enter a DNA Type before saving');
                return;
            end
            if ~ROIUtils.has_number_of_baseline_pts(solutions)
                warndlg('Please enter at least 2 solutions with different timings before saving');
                return;
            end    

            % Let user choose to not save disabled ROIs
            if ~all(enabledROIs)
                choice = questdlg('Some of the ROIs have been disabled. Would you like to save these ROIs?', ...
                                  'Save Disabled ROIs', ...
                                  'Yes', 'No', 'Cancel', ...
                                  'Cancel');
                switch choice
                    case 'No'
                        % Leave only enabled ROIs
                        enabledLt = ROIUtils.select(saveData.lifetime(), enabledROIs);
                        enabledInt = ROIUtils.select(saveData.green(), enabledROIs);
                        enabledRed = ROIUtils.select(saveData.red(), enabledROIs);
                        saveData = ROITable(saveData.time(), enabledLt, enabledInt, enabledRed);
                    case 'Cancel'
                        return;
                end
            end

            % Let the user select the filepath and file type
            expNames = openFile.experiment_names();
            defaultFileName = expNames{1};

            fileFilter = {'*.mat', 'Raw ROI Files (*.mat)'; ...
                          '*.mat', 'Prepared ROI Files (*.mat)'; ...
                          '*.mat', 'Averaged ROI Files (*.mat)'};
            [file, path, typeIdx] = uiputfile(fileFilter, 'Save ROI File', defaultFileName);
            if isequal(file, 0) || isequal(path, 0) || isequal(typeIdx, 0)
                return;
            end
            savepath = fullfile(path, file);

            % Save file according to selected type
            switch typeIdx
                case 1
                    RawFile.save(savepath, saveData);
                case 2
                    PreparedFile.save(savepath, saveData, dnaType, solutions);
                case 3
                    AveragedFile.save(savepath, saveData, ROIUtils.trim_dna_type(dnaType), solutions);
                otherwise
                    warndlg('Cannot save the file under this type');
            end
        end
        
        function close(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'File -> Close' Callback
        %
        % Closes file in workspace with user confirmation. After closing a
        % file, all loaded data is cleared.
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            handles = guidata(hObject);
    
            % Get confirmation from user
            choice = questdlg('Are you sure you want to close this file?', ...
                              'Confirmation', ...
                              'Yes', 'No', ...
                              'No');
            if strcmp(choice, 'Yes')
                % Update program state
                AppState.set_open_files(handles, []);
                AppState.set_roi_data(handles, []);

                % Update UI
                GUI.update_data_table(handles);
                GUI.update_dna_type(handles, []);
                GUI.update_solution_info(handles, {});
                GUI.update_ui_access(handles, ROIFileType.None);
                GUI.update_win_title(handles);
            end
        end
    end
end