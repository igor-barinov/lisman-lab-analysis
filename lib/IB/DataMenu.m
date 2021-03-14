classdef DataMenu
    methods (Static)
        function fix(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Fix' Callback
        %
        % Attempts to fix values within the ROI data. Any 0s or NaNs are
        % replaced with adjacent values or averaged values.
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);
            enabledROIs = GUI.get_enabled_rois(handles);

            % Get ROI data values
            roiCount = roiData.roi_count();
            time = roiData.time();
            lifetime = roiData.lifetime();
            int = roiData.green();
            red = roiData.red();

            % Fix time values
            [timeWasFixed, fixedTime] = ROIUtils.fix_time(time);
            if timeWasFixed
                roiData = roiData.set_time(fixedTime);
            end

            % Fix ROI values
            [tauWasFixed, fixedTau] = ROIUtils.fix(lifetime);
            [intWasFixed, fixedInt] = ROIUtils.fix(int);
            [redWasFixed, fixedRed] = ROIUtils.fix(red);

            % Non-existent data is counted as fixed
            tauWasFixed = tauWasFixed | ~ROIUtils.data_exists(lifetime);
            intWasFixed = intWasFixed | ~ROIUtils.data_exists(int);
            redWasFixed = redWasFixed | ~ROIUtils.data_exists(red);

            % Check if ROIs were fixed
            if any(tauWasFixed)
                lifetime(:, tauWasFixed) = fixedTau(:, tauWasFixed);
                roiData = roiData.set_lifetime(lifetime);
            end
            if any(intWasFixed)
                int(:, intWasFixed) = fixedInt(:, intWasFixed);
                roiData = roiData.set_green(int);
            end
            if any(redWasFixed)
                red(:, redWasFixed) = fixedRed(:, redWasFixed);
                roiData = roiData.set_red(red);
            end

            if timeWasFixed && all(tauWasFixed) && all(intWasFixed) && all(redWasFixed)
                msgbox('All values were fixed successfully');
            else
                % Let user decide to disable bad ROIs
                choice = questdlg('There was an issue fixing some ROIs. Would you like to disable those ROIs?', ...
                                  'Disable Bad ROIs', ...
                                  'Yes', 'No', ...
                                  'Yes');
                if strcmp(choice, 'Yes')
                    roiWasFixed = tauWasFixed & intWasFixed & redWasFixed;
                    for i = 1:roiCount
                        if ~roiWasFixed(i) && enabledROIs(i)
                            tagStr = ['menuToggleROI', num2str(i)];
                            hMenu = handles.(tagStr);
                            GUI.toggle_menu(hMenu);
                        end
                    end
                end
            end


            % Update program state
            AppState.set_roi_data(handles, roiData);
            GUI.update_data_table(handles);
        end
        
        function toggle_norm_vals(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Toggle -> Normalized Values' Callback
        %
        % Toggles value normalization on or off
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            solutions = GUI.get_solution_info(handles);

            % Check if we can get the # of base pts
            if ~ROIUtils.has_number_of_baseline_pts(solutions)
                warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
                GUI.toggle_button(hObject);
                return;
            end

            % Update the corresponding button item
            GUI.toggle_button(handles.('btnToggleNormVals'));

            % Update the data table
            GUI.update_data_table(handles);
        end
        
        function toggle_roi(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Toggle -> ROI -> *' Callback
        %
        % Enables/disables the selected ROI
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            handles = guidata(hObject);
    
            GUI.toggle_menu(hObject);
            GUI.update_data_table(handles);
        end
        
        function enable_all_roi(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Toggle -> ROI -> Enable All' Callback
        %
        % Enables all ROIs
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);

            % Enable any disabled ROIs
            for i = 1:roiData.roi_count()
                tagStr = ['menuToggleROI', num2str(i)];
                hMenu = handles.(tagStr);

                if ~GUI.menu_is_toggled(hMenu)
                    GUI.toggle_menu(hMenu);
                end
            end

            % Update Table
            GUI.update_data_table(handles);
        end
        
        function enable_selected_roi(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Toggle -> ROI -> Enable Selected' Callback
        %
        % Enables only selected ROIs
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            openFile = AppState.get_open_files(handles);
            roiData = AppState.get_roi_data(handles);
            roiCount = roiData.roi_count();
            selection = AppState.get_data_selection(handles);

            % Check if there is a selection
            if isempty(selection)
                warndlg('Please select a column or cell');
                return;
            end

            % Get the unique non-time columns selected
            columns = unique(selection(:, 2));
            columns(columns == 1) = [];

            % Check if any columns remain
            if isempty(columns)
                warndlg('Please select a column or cell without time data');
                return;
            end

            % Get the data offsets
            switch openFile.type()
                case ROIFileType.Averaged
                    tauOffset = 2;
                    intOffset = tauOffset + 2*roiCount;
                    redOffset = intOffset + 2*roiCount;
                otherwise
                    tauOffset = 2;
                    intOffset = tauOffset + roiCount;
                    redOffset = intOffset + roiCount;
            end

            % Enable the corresponding ROIs
            enabledROIs = false(1, roiCount);
            for i = 1:numel(columns)
                col = columns(i);
                if col >= redOffset
                    roi = col - redOffset + 1;
                elseif col >= intOffset
                    roi = col - intOffset + 1;
                elseif col >= tauOffset
                    roi = col - tauOffset + 1;
                end

                if openFile.type() == ROIFileType.Averaged
                    roi = (roi + (1 - mod(col, 2))) / 2;
                end

                enabledROIs(roi) = true;
            end

            % Update UI
            for i = 1:roiCount
                menuTag = ['menuToggleROI', num2str(i)];
                hMenu = handles.(menuTag);
                needsToggle = (enabledROIs(i) && ~GUI.menu_is_toggled(hMenu)) || (~enabledROIs(i) && GUI.menu_is_toggled(hMenu));

                if needsToggle
                    GUI.toggle_menu(hMenu);
                end
            end
            GUI.update_data_table(handles);
        end
        
        function add_row_above(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Add Row Above' Callback
        %
        % Inserts a row of ROI data above the selected row
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);
            tableSelection = AppState.get_data_selection(handles);

            % Check if a single row was selected
            if isempty(tableSelection)
                warndlg('Please select a row or cell');
                return;
            elseif size(tableSelection, 1) > 1
                warndlg('Please select only 1 row or cell');
                return;
            end
            rowIdx = tableSelection(1);

            % Get current ROIs and time
            time = roiData.time();
            lifetime = roiData.lifetime();
            int = roiData.green();
            red = roiData.red();

            % Add zeroed-row above selection
            newRow = zeros(1, roiData.roi_count());
            newTime = [time(1:rowIdx-1); 0; time(rowIdx:end)];
            newLifetime = [lifetime(1:rowIdx-1, :); newRow; lifetime(rowIdx:end, :)];
            newInt = [int(1:rowIdx-1, :); newRow; int(rowIdx:end, :)];
            newRed = [red(1:rowIdx-1, :); newRow; red(rowIdx:end, :)];

            % Update program state
            roiData = roiData.set_time(newTime);
            roiData = roiData.set_lifetime(newLifetime);
            roiData = roiData.set_green(newInt);
            roiData = roiData.set_red(newRed);
            AppState.set_roi_data(handles, roiData);

            % Update table
            GUI.update_data_table(handles);
        end
        
        function add_row_below(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Add Row Below' Callback
        %
        % Inserts a row of ROI data below the selected row
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);
            tableSelection = AppState.get_data_selection(handles);

            % Check if a single row was selected
            if isempty(tableSelection)
                warndlg('Please select a row or cell');
                return;
            elseif size(tableSelection, 1) > 1
                warndlg('Please select only 1 row or cell');
                return;
            end
            rowIdx = tableSelection(1);

            % Get current ROIs and time
            time = roiData.time();
            lifetime = roiData.lifetime();
            int = roiData.green();
            red = roiData.red();

            % Add zeroed-row below selection
            newRow = zeros(1, roiData.roi_count());
            newTime = [time(1:rowIdx); 0; time(rowIdx+1:end)];
            newLifetime = [lifetime(1:rowIdx, :); newRow; lifetime(rowIdx+1:end, :)];
            newInt = [int(1:rowIdx, :); newRow; int(rowIdx+1:end, :)];
            newRed = [red(1:rowIdx, :); newRow; red(rowIdx+1:end, :)];

            % Update program state
            roiData = roiData.set_time(newTime);
            roiData = roiData.set_lifetime(newLifetime);
            roiData = roiData.set_green(newInt);
            roiData = roiData.set_red(newRed);
            AppState.set_roi_data(handles, roiData);

            % Update table
            GUI.update_data_table(handles);
        end
        
        function zero_row(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Zero Row' Callback
        %
        % Converts all values in selected row to zeroes
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);
            tableSelection = AppState.get_data_selection(handles);

            % Check if a single row was selected
            if isempty(tableSelection)
                warndlg('Please select a row or cell');
                return;
            elseif size(tableSelection, 1) > 1
                warndlg('Please select only 1 row or cell');
                return;
            end
            rowIdx = tableSelection(1);

            % Get current ROIs and time
            time = roiData.time();
            lifetime = roiData.lifetime();
            int = roiData.green();
            red = roiData.red();

            % Zero selected row
            newRow = zeros(1, roiData.roi_count());
            time(rowIdx) = 0;
            lifetime(rowIdx, :) = newRow;
            int(rowIdx, :) = newRow;
            red(rowIdx, :) = newRow;

            % Update program state
            roiData = roiData.set_time(time);
            roiData = roiData.set_lifetime(lifetime);
            roiData = roiData.set_green(int);
            roiData = roiData.set_red(red);
            AppState.set_roi_data(handles, roiData);

            % Update table
            GUI.update_data_table(handles);
        end
        
        function delete_row(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Data -> Delete Row' Callback
        %
        % Removes the selected row from the ROI data
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);
            tableSelection = AppState.get_data_selection(handles);

            % Check if a single row was selected
            if isempty(tableSelection)
                warndlg('Please select a row or cell');
                return;
            elseif size(tableSelection, 1) > 1
                warndlg('Please select only 1 row or cell');
                return;
            end
            rowIdx = tableSelection(1);

            % Get current ROIs and time
            time = roiData.time();
            lifetime = roiData.lifetime();
            int = roiData.green();
            red = roiData.red();

            % Let user choose to keep time values
            choice = questdlg('Would you like to keep the time values?', ...
                              'Delete Row', ...
                              'Yes', 'No', 'Cancel', ...
                              'Cancel');
            switch choice
                case 'Yes'
                    time = time(1:end-1);
                case 'No'
                    time(rowIdx) = [];
                otherwise
                    return;
            end

            lifetime(rowIdx, :) = [];
            int(rowIdx, :) = [];
            red(rowIdx, :) = [];

            % Update program state
            roiData = roiData.set_time(time);
            roiData = roiData.set_lifetime(lifetime);
            roiData = roiData.set_green(int);
            roiData = roiData.set_red(red);

            AppState.set_roi_data(handles, roiData);

            % Update table
            GUI.update_data_table(handles);
        end
    end
end