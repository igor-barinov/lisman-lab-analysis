classdef GUICallbacks
    methods (Static)
        function dataTable_select(hObject, eventdata)
        %% --------------------------------------------------------------------------------------------------------
        % 'dataTable' Cell Select Callback
        %
        % Updates which ROI data is selected when table cell is selected
        %
        % (IN) "hObject": handle to 'dataTable'
        % (IN) "eventdata": structure containg UI event data
        %
            handles = guidata(hObject);
    
            % Update program state
            AppState.update_data_selection(handles, eventdata.Indices);
        end
        
        function dataTable_edit(hObject, eventdata)
        %% --------------------------------------------------------------------------------------------------------
        % 'dataTable' Cell Edit Callback
        %
        % Updates ROI data when table cell is editted
        %
        % (IN) "hObject": handle to 'dataTable'
        % (IN) "eventdata": structure containg UI event data
        %
            handles = guidata(hObject);
    
            % Get current program state
            roiData = get_adjusted_data(handles);

            % Update only on valid data
            if ~isnan(eventdata.NewData)
                roiData(eventdata.Indices) = eventdata.NewData;
            end
            GUI.update_data_table(roiData);
        end
        
        function menuToggleROI(hObject, ~)
            GUI.try_callback(@DataMenu.toggle_roi, hObject);
        end
        
        function btnToggleAdjustedTime(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnToggleAdjustedTime' Callback
        %
        % Toggles time adjustment on or off
        %
        % (IN) "hObject": handle to 'btnToggleAdjustedTime'
        %
            % Get current program state
            handles = guidata(hObject);
            % solutions = GUI.get_solution_info(handles);
            % GUI.toggle_button(hObject);

            % Update the data table
            GUI.update_data_table(handles);
        end
        
        function btnToggleNormVals(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnToggleNormVals' Callback
        %
        % Toggles value normalization on or off
        %
        % (IN) "hObject": handle to 'btnToggleNormVals'
        %
            % Get current program state
            handles = guidata(hObject);
            % solutions = GUI.get_solution_info(handles);

            %GUI.toggle_button(hObject);
            % Update the corresponding menu item
            GUI.toggle_menu(handles.('menuToggleNormVals'));

            % Update the data table
            GUI.update_data_table(handles);
        end
        
        function btnEnableROI(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnEnableROI' Callback
        %
        % Enables the selected ROIs
        %
        % (IN) "hObject": handle to 'btnEnableROI'
        %
            handles = guidata(hObject);
            DataMenu.enable_selected_roi(handles.('menuEnableSelectedROI'));
        end
        
        function btnAddSolution(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnAddSolution' Callback
        %
        % Raises dialog letting user add a solution to the solution table
        %
        % (IN) "hObject": handle to 'btnAddSolution'
        %
            % Get the current program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);
            pointCount = max(roiData.point_counts());
            currentSolutions = GUI.get_solution_info(handles);
            settingsMap = AppState.get_user_preferences();

            % Get solution info from user
            addSolPrompt = {'Enter solution name:', 'Enter when solution starts (# of points):'};
            dimensions = [1 50];
            userInput = inputdlg(addSolPrompt, 'Add Solution', dimensions);
            if isempty(userInput)
                return;
            end
            solutionName = userInput{1};
            solutionTiming = userInput{2};

            % Check if all data was given
            if isempty(solutionName)
                warndlg('Please enter the solution name');
                return;
            elseif isempty(solutionTiming)
                warndlg('Please enter the solution timing');
                return;
            end

            % Check if the timing was valid
            solutionTiming = str2double(solutionTiming);
            if isnan(solutionTiming)
                warndlg('Please enter a number for the solution timing');
                return;
            elseif solutionTiming < 1 || solutionTiming > pointCount
                warndlg(['The solution timing must be from 1 to ', num2str(pointCount)]);
                return;
            end

            % Add the new info
            newSolutions = [currentSolutions; {solutionName, solutionTiming}];
            newSolutions = sortrows(newSolutions, 2);

            % Update the program state
            GUI.update_solution_info(handles, newSolutions);

            % Update UI
            GUI.update_data_table(handles);
        end
        
        function btnRemoveSolution(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnRemoveSolution' Callback
        %
        % Raises dialog letting user remove solutions from the solution table
        %
        % (IN) "hObject": handle to 'btnRemoveSolution'
        %
            handles = guidata(hObject);
    
            % Get current program state
            solutions = GUI.get_solution_info(handles);

            % Check if there is anything to remove
            if isempty(solutions)
                warndlg('There are no solutions to remove');
                return;
            end

            % Let user choose which solution to remove
            options = solutions(:, 1);
            promptStr = 'Select a solution to remove.';
            [optionIdx, optionWasChosen] = listdlg('Name', 'Remove Solution', ...
                                                   'PromptString', promptStr, ...
                                                   'ListString', options, ...
                                                   'ListSize', [300 150]);
            if ~optionWasChosen
                return;
            end

            % Remove the selected solutions
            solutions(optionIdx, :) = [];

            % Update the program state
            GUI.update_solution_info(handles, solutions);

            % Update UI
            GUI.update_data_table(handles);
        end
        
        function solutionTable_edit(hObject, eventdata)
        %% --------------------------------------------------------------------------------------------------------
        % 'solutionTable' Cell Edit Callback
        %
        % Updates solution info when table cell is editted
        %
        % (IN) "hObject": handle to 'solutionTable'
        % (IN) "eventdata": structure containg UI event data
        %
            % Get current program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);
            pointCount = max(roiData.point_counts());
            solutions = GUI.get_solution_info(handles);

            % Determine which data is being changed
            row = eventdata.Indices(1);
            column = eventdata.Indices(2);
            isNewTiming = (column == 2);
            oldValue = eventdata.PreviousData;
            newValue = eventdata.NewData;

            % Check if new data was entered
            if isempty(newValue)
                choice = questdlg(['Would you like to remove solution #', num2str(row), '?'], ...
                                      'Remove Solution', ...
                                      'Yes', 'No', ...
                                      'No');
                if strcmp(choice, 'Yes')
                    % Remove the solution
                    solutions(row, :) = [];
                else
                    % Revert to old data and return
                    solutions{row, column} = oldValue;
                end
            else
                if isNewTiming
                    % Check if new timing is valid, reverting if necessary
                    if isnan(newValue)
                        warndlg('Please enter a number for the solution timing');
                        solutions{row, column} = oldValue;
                    elseif newValue < 1 || newValue > pointCount
                        warndlg(['Please enter a timing from 1 to ', num2str(pointCount)]);
                        solutions{row, column} = oldValue;
                    else
                        % Update the solution timing
                        solutions{row, column} = newValue;
                        solutions = sortrows(solutions, 2);
                    end
                else
                    % Update the solution name
                    solutions{row, column} = newValue;
                end
            end

            % Update the program state
            GUI.update_solution_info(handles, solutions);

            % Check if # of baseline pts is available
            if ~ROIUtils.has_number_of_baseline_pts(solutions)
                % Toggle off adj. time and norm. values if necessary
                if GUI.time_is_adjusted(handles)
                    GUI.toggle_button(handles.('btnToggleAdjustedTime'));
                end
                if GUI.values_are_normalized(handles)
                    GUI.toggle_button(handles.('btnToggleNormVals'));
                    GUI.toggle_menu(handles.('menuToggleNormVals'));
                end
            end

            % Update table
            GUI.update_data_table(handles);
        end
        
        function btnChooseBaseline(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnChooseBaseline' Callback
        %
        % TODO: open dialog to let user choose which solution is baseline
        %
            handles = guidata(hObject);
        end
        
        function btnImportInfo(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnImportInfo' Callback
        %
        % Raises dialog letting user import experiment information from an
        % ROI file or a Microsoft Word file
        %
        % (IN) "hObject": handle to 'btnImportInfo'
        %
            % Get current program state
            handles = guidata(hObject);

            % Let user choose file
            fileFilter = {'*.docx', 'Experiment Notes'; ...
                          '*.mat', 'ROI Files'};
            [file, path, filterIdx] = uigetfile(fileFilter);
            if isequal(file, 0) || isequal(path, 0) || isequal(filterIdx, 0)
                return;
            end

            filePath = fullfile(path, file);
            switch filterIdx
                case 1
                    % Show status due to processing time
                    statusdlg = waitbar(0, 'Reading Word Doc...');

                    % Try getting info from Word file
                    [notes] = IOUtils.read_word_file(filePath);
                    [newDNAType, newSolutions] = ROIUtils.exp_info_from_notes(notes);
                    waitbar(1, statusdlg, 'Done');

                    % Show results
                    solutionsFound = size(newSolutions, 1);
                    if isempty(newDNAType)
                        statusMsg = ['The DNA type could not be found, and ', num2str(solutionsFound), ' solutions were found. '];
                    else
                        statusMsg = ['The DNA type was found, and ', num2str(solutionsFound), ' solutions were found. '];
                    end

                    % Let user choose to open notes in a dialog
                    choice = questdlg([statusMsg, 'Would you like to see the full notes?'], 'Import Results', ...
                                      'Yes', 'No', ...
                                      'No');
                    % Close loading bar
                    close(statusdlg);

                    if strcmp(choice, 'Yes')
                        dlgStyle = struct('Interpreter', 'tex', ...
                                          'WindowStyle', 'non-modal');
                        dlgContent = ['\fontsize{14}', notes];
                        msgbox(dlgContent, dlgStyle);
                    end
                case 2
                    % Get the type of file chosen
                    filepaths = { filePath };
                    if PreparedFile.follows_format(filepaths)
                        infoFile = PreparedFile(filepaths);
                    elseif AveragedFile.follows_format(filepaths)
                        infoFile = AveragedFile(filepaths);
                    else
                        infoFile = RawFile();
                    end

                    if infoFile.has_exp_info()
                        allDNA = infoFile.dna_types();
                        allSolutions = infoFile.solution_info();

                        newDNAType = allDNA{1};
                        newSolutions = allSolutions{1};
                    else
                        warndlg('This file does not have experiment info');
                        return;
                    end
            end


            % Update program state
            if ~isempty(newDNAType)
                GUI.update_dna_type(handles, newDNAType);
            end
            if ~isempty(newSolutions)
                GUI.update_solution_info(handles, newSolutions);
            end
            
            % Toggle Adjusted Time
            GUI.toggle_button(handles.('btnToggleAdjustedTime'));
            GUICallbacks.btnToggleAdjustedTime(handles.('btnToggleAdjustedTime'));
        end
    end
end