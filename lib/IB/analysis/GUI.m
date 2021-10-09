classdef GUI
    methods (Static)
        function try_callback(callback, varargin)
            try
                callback(varargin{:});
            catch err
                AppState.logdlg(err);
            end
        end
        
        function close(handle)
            handles = guidata(handle);
            if isempty(handles)
                delete(handle);
                return;
            end
            
            [allFigures] = AppState.get_open_figures(handles);
            if isempty(allFigures)
                delete(handle);
                return;
            end
            
            answer = questdlg('Would you like to close all open figures?', 'Close Figures?');
            if isempty(answer)
                return;
            end
            
            if strcmp(answer, 'Yes')
                AppState.close_open_figures(handles);
            end
            
            if ~strcmp(answer, 'Cancel')
                delete(handle);
            end
        end
        
        function set_ui_access(handle, enabled, childrenEnabled, ignoreParent)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_ui_access' Method
        %
        % Changes whether a given UI element and/or its children are enabled or disabled
        %
        % (IN) "handle": handle to a UI element
        % (IN) "enabled": true if the UI element should be enabled, false
        % otherwise
        % (IN) "childrenEnabled": true if all children of the element
        % should be enabled, false otherwise
        % (IN) "ignoreParent": true if only children of the element should
        % be updated, false otherwise
        %
            if ~ignoreParent && enabled
                set(handle, 'Enable', 'on');
            elseif ~ignoreParent && ~enabled
                set(handle, 'Enable', 'off');
            end

            hChildren = findall(handle, '-property', 'Enable');
            if childrenEnabled
                set(hChildren, 'Enable', 'on');
            else
                set(hChildren, 'Enable', 'off');
            end
        end
        
        function [tf] = ui_is_enabled(handle)
        %% --------------------------------------------------------------------------------------------------------
        % 'ui_is_enabled' Method
        %
        % Checks if a given UI element is enabled or not
        %
        % (IN) "handle": handle to a UI element
        % 
        % (OUT) "tf" true if the element is enabled, false otherwise
        %
        try
            enableState = get(handle, 'Enable');
            tf = strcmp(enableState, 'on');
        catch
            tf = false;
        end
        end
        
        function toggle_menu(handle)
        %% --------------------------------------------------------------------------------------------------------
        % 'toggle_menu' Method
        %
        % Checks a menu if unchecked and vice versa
        %
        % (IN) "handle": handle to a toggle-able menu
        %
            if GUI.menu_is_toggled(handle)
                set(handle, 'Checked', 'off');
            else
                set(handle, 'Checked', 'on');
            end
        end
        
        function [tf] = menu_is_toggled(handle)
        %% --------------------------------------------------------------------------------------------------------
        % 'menu_is_toggled' Method
        %
        % Checks if a menu is checked on or off
        %
        % (IN) "handle": handle to a toggle-able menu
        %
        % (OUT) "tf": true if the menu is checked on, false otherwise
        %
            enableState = get(handle, 'Checked');
            tf = strcmp(enableState, 'on');
        end
        
        function [tf] = box_is_checked(handle)
            tf = get(handle, 'Value');
        end
        
        function toggle_button(handle)
        %% --------------------------------------------------------------------------------------------------------
        % 'toggle_button' Method
        %
        % Toggles a button on or off
        %
        % (IN) "handle": handle to a toggle button
        %
            btnState = GUI.button_is_toggled(handle);
            set(handle, 'Value', ~btnState);
        end
        
        function [tf] = button_is_toggled(handle)
        %% --------------------------------------------------------------------------------------------------------
        % 'button_is_toggled' Method
        %
        % Checks if a given button is toggled on or off
        %
        % (IN) "handle": handle to toggle button
        %
        % (OUT) "tf": true if button is toggled on, false otherwise
        %
            tf = get(handle, 'Value');
        end
        
        function update_ui_access(handles, fileType)
        %% --------------------------------------------------------------------------------------------------------
        % 'update_ui_access' Method
        %
        % Enables/disables multiple UI elements based on the type of file
        % opened
        %
        % (IN) "handles": structure containing all program GUI data
        % (IN) "fileType": ROIFileType describing the type of file that is opened
        %
            % Enable everything
            GUI.set_ui_access(handles.('panelInfo'), true, true, true);     % Info panel
            GUI.set_ui_access(handles.('dataTable'), true, true, false);    % Data table
            GUI.set_ui_access(handles.('menuFile'), true, true, false);     % File -> *
            GUI.set_ui_access(handles.('menuData'), true, true, false);     % Data -> *
            GUI.set_ui_access(handles.('menuRow'), true, true, false);      % Data -> Row -> *
            GUI.set_ui_access(handles.('menuToggle'), true, true, false);   % Data -> Toggle -> *
            GUI.set_ui_access(handles.('menuPlot'), true, true, false);     % Plot -> *
            GUI.set_ui_access(handles.('menuTools'), true, true, false);    % Tools -> *
            

            switch fileType        
                case ROIFileType.Averaged
                    % Disable info inputs
                    GUI.set_ui_access(handles.('panelInfo'), true, false, true);
                    GUI.set_ui_access(handles.('btnToggleNormVals'), true, true, false);
                    GUI.set_ui_access(handles.('btnEnableROI'), true, true, false);
                    % And data editting
                    GUI.set_ui_access(handles.('menuFix'), false, false, false);
                    GUI.set_ui_access(handles.('menuRow'), false, false, false);
                    % And average plotting
                    GUI.set_ui_access(handles.('menuPlotAvg'), false, false, false);
                case ROIFileType.Prepared
                    % Permanently toggle adjusted time
                    if ~GUI.time_is_adjusted(handles)
                        GUI.toggle_button(handles.('btnToggleAdjustedTime'));
                    end
                    GUI.set_ui_access(handles.('btnToggleAdjustedTime'), false, false, false);
                case ROIFileType.None    
                    % Toggle controls off if neccessary
                    if GUI.time_is_adjusted(handles)
                        GUI.toggle_button(handles.('btnToggleAdjustedTime'));
                    end
                    if GUI.values_are_normalized(handles)
                        GUI.toggle_button(handles.('btnToggleNormVals'));
                        GUI.toggle_menu(handles.('menuToggleNormVals'));
                    end


                    % Disable everything 
                    GUI.set_ui_access(handles.('panelInfo'), false, false, true);   % Info panel
                    GUI.set_ui_access(handles.('dataTable'), false, false, false);  % Data table
                    GUI.set_ui_access(handles.('menuData'), false, false, false);   % Data -> *
                    GUI.set_ui_access(handles.('menuPlot'), false, false, false);   % Plot -> *
                    % Except file open
                    GUI.set_ui_access(handles.('menuFile'), true, true, false);
                    GUI.set_ui_access(handles.('menuSave'), false, false, false);
                    GUI.set_ui_access(handles.('menuClose'), false, false, false);
                    % And tools
                    GUI.set_ui_access(handles.('menuTools'), true, true, false);
            end

            GUI.update_plotting_options(handles);
        end
        
        function update_win_title(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'update_win_title' Method
        %
        % Updates the window title based on the open file
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to main figure in field 'mainFig'
        %
            % Get program state
            openFile = AppState.get_open_files(handles);

            title = Analysis_1_2_Versions.release();
            if ~isempty(openFile)
                srcFiles = openFile.source_files();
                [~, firstFile, ext] = fileparts(srcFiles{1});
                title = [title, ' - ', firstFile, ext];
            end

            set(handles.('mainFig'), 'Name', title);
        end
        
        function [tf] = time_is_adjusted(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'time_is_adjusted' Method
        %
        % Checks if time adjustment setting is on or off
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to toggle button in field 'btnToggleAdjustedTime'
        %
        % (OUT) "tf": true if time adjustment setting is on, false
        % otherwise
        %
            tf = get(handles.('btnToggleAdjustedTime'), 'Value');
        end
        
        function [tf] = values_are_normalized(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'values_are_normalized' Method
        %
        % Checks if value normalization setting is on or off
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to toggle button in field 'btnToggleNormVals'
        %
        % (OUT) "tf": true if value normalization setting is on, false
        % otherwise
        %
            tf = get(handles.('btnToggleNormVals'), 'Value');
        end
        
        function [tf] = get_enabled_rois(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'get_enabled_rois' Method
        %
        % Checks which ROIs are enabled or disabled
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to toggle-able menu in fields 'menuToggleROI1' ... 'menuToggleROIN' 
        %
        % (OUT) "tf": Vector of booleans. Each is true if the ROI at that
        % index is enabled, and is false otherwise
        %
            [roiData] = AppState.get_roi_data(handles);
            roiCount = roiData.roi_count();

            tf = false(1, roiCount);
            for i = 1:roiCount
                tagStr = ['menuToggleROI', num2str(i)];
                tf(i) = GUI.menu_is_toggled(handles.(tagStr));
            end
        end
        
        function update_data_table(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'update_data_table' Method
        %
        % Updates values in table UI based on current ROI data
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to table in field 'dataTable'
        %
            % Get new program state
            openFiles = AppState.get_open_files(handles);
            newTableData = AppState.get_roi_data(handles);

            % Just clear table if necessary
            if isempty(newTableData)
                set(handles.('dataTable'), 'Data', []);
                set(handles.('dataTable'), 'ColumnName', {});
                return;
            end

            % Adjust time if necessary
            if GUI.time_is_adjusted(handles)
                solutions = GUI.get_solution_info(handles);
                if ROIUtils.has_number_of_baseline_pts(solutions)
                    numBasePts = ROIUtils.number_of_baseline_pts(solutions);
                else
                    numBasePts = 1;
                end
                
                time = newTableData.adjusted_time(numBasePts);
            else
                time = newTableData.time();
            end

            % Get values and normalize if necessary
            if GUI.values_are_normalized(handles)
                solutions = GUI.get_solution_info(handles);
                if ROIUtils.has_number_of_baseline_pts(solutions)
                    numBasePts = ROIUtils.number_of_baseline_pts(solutions);
                else
                    numBasePts = 1;
                end
                
                
                lifetime = newTableData.normalized_lifetime(numBasePts);
                int = newTableData.normalized_green(numBasePts);
                red = newTableData.normalized_red(numBasePts);
            else
                lifetime = newTableData.lifetime();
                int = newTableData.green();
                red = newTableData.red();
            end

            % Enable/Disable ROIs if necessary
            enabledROIs = GUI.get_enabled_rois(handles);
            if openFiles.type() == ROIFileType.Averaged
                lifetime = ROIUtils.enable_averages(lifetime, enabledROIs);
                int = ROIUtils.enable_averages(int, enabledROIs);
                red = ROIUtils.enable_averages(red, enabledROIs);
            else
                lifetime = ROIUtils.enable(lifetime, enabledROIs);
                int = ROIUtils.enable(int, enabledROIs);
                red = ROIUtils.enable(red, enabledROIs);
            end


            set(handles.('dataTable'), 'Data', [time, lifetime, int, red]);
            set(handles.('dataTable'), 'ColumnName', newTableData.roi_labels());
        end
        
        function update_dna_type(handles, newDNAType)
        %% --------------------------------------------------------------------------------------------------------
        % 'update_dna_type' Method
        %
        % Updates displayed DNA type with a new given DNA type
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to a text input in field 'inputDNAType'
        % (IN) "newDNAType": string describing new DNA type
        %
            set(handles.('inputDNAType'), 'String', newDNAType);
        end
        
        function [dnaType] = get_dna_type(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'get_dna_type' Method
        %
        % Gets the DNA type that the user input
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to a text input in field 'inputDNAType'
        %
        % (OUT) "dnaType": string describing the input DNA type
        %
            dnaType = get(handles.('inputDNAType'), 'String');
        end
        
        function update_solution_info(handles, newSolutionInfo)
        %% --------------------------------------------------------------------------------------------------------
        % 'update_solution_info' Method
        %
        % Updates the displayed solution info with the given new solution
        % info
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to a table in field 'solutionTable'
        % (IN) "newSolutionInfo": cell containing new solution info where
        % each row is the pair {<solution name>, <solution timing>}
        %
            set(handles.('solutionTable'), 'Data', newSolutionInfo);
        end
        
        function [solutions] = get_solution_info(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'get_solution_info' Method
        %
        % Gets the solution info that the user input
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to a table in field 'solutionTable'
        %
        % (OUT) "solutions": cell containing solution info that the user
        % input. Cell is a collection of rows where each row is the pair {<solution name>, <solution timing>}
        %
            solutions = get(handles.('solutionTable'), 'Data');
        end
        
        function [newHandles] = update_toggle_menu(handles, newROICount)
        %% --------------------------------------------------------------------------------------------------------
        % 'update_toggle_menu' Method
        %
        % Updates the number of menu items under the ROI toggle menu according
        % to the new given ROI count
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to a menu in fields 'menuToggleROI'
        % (IN) "newROICount": number representing the new number of ROIs
        %
        % Newly created menu items have the tag 'menuToggleROI<roi #>' and
        % unique values in the 'UserData' field
        %
            newHandles = handles;
            MENU_DATA_ID = double('toggleROI');

            currentMenuItems = findall(handles.('menuToggleROI'), 'UserData', MENU_DATA_ID);
            delete(currentMenuItems);

            for i = 1:newROICount
                tagStr = ['menuToggleROI', num2str(i)];
                callbackFn = @GUICallbacks.menuToggleROI;
                hMenu = uimenu(handles.('menuToggleROI'), ...
                               'Text', ['ROI #', num2str(i)], ...
                               'Checked', 'on', ...
                               'Tag', tagStr, ...
                               'UserData', MENU_DATA_ID, ...
                               'Callback', callbackFn);
                newHandles.(tagStr) = hMenu;
            end
            guidata(handles.('mainFig'), newHandles);
        end
        
        function update_plotting_options(handles)
            % Disable all plotting options
            if GUI.menu_is_toggled(handles.('menuShowLifetime'))
                GUI.toggle_menu(handles.('menuShowLifetime'));
            end
            if GUI.menu_is_toggled(handles.('menuShowGreen'))
                GUI.toggle_menu(handles.('menuShowGreen'));
            end
            if GUI.menu_is_toggled(handles.('menuShowRed'))
                GUI.toggle_menu(handles.('menuShowRed'));
            end
            if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                GUI.toggle_menu(handles.('menuShowAnnots'));
            end
            
            % Change plotting options based on preferences
            [settingsMap] = AppState.get_user_preferences();
            if isempty(settingsMap)
                warndlg('Could not load all user preferences');
            else
                showLifetime = settingsMap('show_lifetime');
                showGreen = settingsMap('show_green_int');
                showRed = settingsMap('show_red_int');
                showAnnotations = settingsMap('show_annotations');

                if strcmp(showLifetime, 'true')
                    GUI.toggle_menu(handles.('menuShowLifetime'));
                end
                if strcmp(showGreen, 'true')
                    GUI.toggle_menu(handles.('menuShowGreen'));
                end
                if strcmp(showRed, 'true')
                    GUI.toggle_menu(handles.('menuShowRed'));
                end
                if strcmp(showAnnotations, 'true')
                    GUI.toggle_menu(handles.('menuShowAnnots'));
                end
            end
        end
        
    end
end