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
            settingsMap = AppState.get_user_preferences();
    
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

            % Combine dna types and Combine solution info
            if openFile.type() == ROIFileType.Prepared()
                dnaType = dnaTypes{1}; %ROIUtils.combine_dna_types(dnaTypes);
                solutionInfo = allSolutions{1}; %ROIUtils.combine_solution_info(allSolutions);
            else
                dnaType = ROIUtils.combine_dna_types(dnaTypes);
                solutionInfo = ROIUtils.combine_solution_info(allSolutions);
            end

            % Validate solution info
            if openFile.has_exp_info() && ~ROIUtils.has_number_of_baseline_pts(solutionInfo)
                warndlg('This file has invalid experiment info. Please fix before loading');
                return;
            end
            
            % Check which data should be loaded based on user preferences
            if strcmp(settingsMap('green_is_int'), 'true')
                greenIsIntegral = true;
            else
                greenIsIntegral = false;
            end
            
            if strcmp(settingsMap('red_is_int'), 'true')
                redIsIntegral = true;
            else
                redIsIntegral = false;
            end

            % Get data values
            time = openFile.time();
            lifetime = openFile.lifetime();
            
            if greenIsIntegral
                green = openFile.green_integral();
            else
                green = openFile.green();
            end
            
            if redIsIntegral 
                red = openFile.red_integral();
            else
                red = openFile.red();
            end

            % Generate ROI data object
            switch openFile.type()
                case ROIFileType.Averaged
                    normLt = openFile.normalized_lifetime();
                    
                    if greenIsIntegral
                        normGreen = openFile.norm_green_integral();
                    else
                        normGreen = openFile.normalized_green();
                    end
                    
                    if redIsIntegral
                        normRed = openFile.norm_red_integral();
                    else
                        normRed = openFile.normalized_red();
                    end
                    
                    roiData = AverageTable(time, lifetime, normLt, green, normGreen, red, normRed, []);
                case ROIFileType.Prepared
                    roiData = ROITable(time, lifetime, green, red, openFile.is_integral());
                case ROIFileType.Raw
                    nROIs = openFile.roi_count();
                    isIntegral = false(1, nROIs + 1);
                    
                    if greenIsIntegral
                        isIntegral = [isIntegral, true(1, nROIs)];
                    else
                        isIntegral = [isIntegral, false(1, nROIs)];
                    end
                    
                    if redIsIntegral
                        isIntegral = [isIntegral, true(1, nROIs)];
                    else
                        isIntegral = [isIntegral, false(1, nROIs)];
                    end
                        
                    roiData = ROITable(time, lifetime, green, red, isIntegral);
                otherwise
                    roiData = ROITable(time, lifetime, green, red);
            end
            
            % Load any user preferences
            if openFile.has_preferences()
                plottingDefaults = openFile.plotting_defaults();
                if ~isempty(plottingDefaults)
                    AppState.set_plotting_defaults(plottingDefaults.('showLifetime'), ...
                                               plottingDefaults.('showGreenInt'), ...
                                               plottingDefaults.('showRedInt'), ...
                                               plottingDefaults.('showAnnots'));
                end
                
                defaultName = openFile.figure_defaults_profile();
                [figDefaultExists] = AppState.set_figure_default(defaultName);
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
            
            % Re-toggle normalization if necessary
            if strcmp(settingsMap('lt_is_norm'), 'true')
                ltIsNorm = true;
            else
                ltIsNorm = false;
            end
            
            
            if strcmp(settingsMap('green_is_norm'), 'true')
                greenIsNorm = true;
            else
                greenIsNorm = false;
            end
            
            if strcmp(settingsMap('red_is_norm'), 'true')
                redIsNorm = true;
            else
                redIsNorm = false;
            end
            
            if (ltIsNorm || greenIsNorm || redIsNorm) && ~GUI.values_are_normalized(handles)
                GUI.toggle_button(handles.('btnToggleNormVals'));
                GUI.toggle_menu(handles.('menuToggleNormVals'));
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
            settingsMap = AppState.get_user_preferences();

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
                        
                        
                        if saveData.green_is_integral()
                            enabledInt = ROIUtils.select(saveData.green_integral(), enabledROIs);
                        else
                            enabledInt = ROIUtils.select(saveData.green(), enabledROIs);
                        end
                        
                        if saveData.red_is_integral()
                            enabledRed = ROIUtils.select(saveData.red_integral(), enabledROIs);
                        else
                            enabledRed = ROIUtils.select(saveData.red(), enabledROIs);
                        end
                        
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
            
            % Save any user preferences
            userPreferences = struct;
            userPreferences.('figProfile') = settingsMap('plot_default');
            userPreferences.('showLifetime') = settingsMap('show_lifetime');
            userPreferences.('showGreenInt') = settingsMap('show_green_int');
            userPreferences.('showRedInt') = settingsMap('show_red_int');
            userPreferences.('showAnnots') = settingsMap('show_annotations');

            % Save file according to selected type
            switch typeIdx
                case 1
                    RawFile.save(savepath, saveData);
                case 2
                    PreparedFile.save(savepath, saveData, dnaType, solutions, userPreferences, saveData.is_integral());
                case 3
                    if openFile.type() == ROIFileType.Averaged()
                        optns = {'IsAveraged', 'true'};
                    else
                        optns = {};
                    end
                    
                    AveragedFile.save(savepath, saveData, ROIUtils.trim_dna_type(dnaType), solutions, userPreferences, optns{:});
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