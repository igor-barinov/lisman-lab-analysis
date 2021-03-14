classdef PlotMenu
    methods (Static)
        function plot_all(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Plot -> All' Callback
        %
        % Plots all selected plots, all ROI data, and selected annotations
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            openFile = AppState.get_open_files(handles);
            roiData = AppState.get_roi_data(handles);
            roiCount = roiData.roi_count();

            % Check if at least one plot is enabled
            isLifetimePlot = GUI.menu_is_toggled(handles.('menuShowLifetime'));
            isIntPlot = GUI.menu_is_toggled(handles.('menuShowGreen'));
            isRedPlot = GUI.menu_is_toggled(handles.('menuShowRed'));
            if ~(isLifetimePlot || isIntPlot || isRedPlot)
                warndlg('Please enable at least one of the plotting options');
                return;
            end

            % Get appropriate ROIs
            if GUI.values_are_normalized(handles)
                solutions = GUI.get_solution_info(handles);
                nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);

                lifetime = roiData.normalized_lifetime(nBaselinePts);
                int = roiData.normalized_green(nBaselinePts);
                red = roiData.normalized_red(nBaselinePts);
            else
                lifetime = roiData.lifetime();
                int = roiData.green();
                red = roiData.red();
            end

            % Check if necessary data exists
            if isLifetimePlot && ~ROIUtils.data_exists(lifetime)
                warndlg('There is no lifetime data to plot');
                GUI.toggle_menu(handles.('menuShowLifetime'));
                return;
            end
            if isIntPlot && ~ROIUtils.data_exists(int)
                warndlg('There is no green intensity data to plot');
                GUI.toggle_menu(handles.('menuShowGreen'));
                return;
            end
            if isRedPlot && ~ROIUtils.data_exists(red)
                warndlg('There is no red intensity data to plot');
                GUI.toggle_menu(handles.('menuShowRed'));
                return;
            end

            % Get appropriate time values
            if GUI.time_is_adjusted(handles)
                solutions = GUI.get_solution_info(handles);
                nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
                time = roiData.adjusted_time(nBaselinePts); 
            else
                time = roiData.time(); 
            end

            % Get which ROIs are enabled
            enabledROIs = GUI.get_enabled_rois(handles);
            enabledIndices = find(enabledROIs);

            % Check if at least one ROI is enabled
            if ~any(enabledROIs)
                warndlg('Please enable at least one ROI');
                return;
            end

            % Generate legend
            switch openFile.type()
                case ROIFileType.Averaged
                    % Get the dna type and roi count of each source file
                    allDNA = ROIUtils.split_dna_type(GUI.get_dna_type(handles));
                    roiCounts = openFile.file_roi_counts();

                    legendEntries = ROIUtils.averages_legend(allDNA, roiCounts);
                otherwise
                    legendEntries = ROIUtils.values_legend(roiCount);
            end

            % Generate title
            expNames = openFile.experiment_names();
            titleStr = '';
            for i = 1:numel(expNames)
                titleStr = [titleStr, expNames{i}];
                if i < numel(expNames)
                    titleStr = [titleStr, ' | '];
                end
            end

            % Remove disabled ROIs from legend
            legendEntries = legendEntries(enabledROIs);

            % Plot lifetime if necessary
            if isLifetimePlot

                figure('Name', 'Lifetime Over Time');
                switch openFile.type()
                    case ROIFileType.Averaged
                        averages = lifetime(:, 2*enabledIndices - 1);
                        errors = lifetime(:, 2*enabledIndices);

                        ROIUtils.plot_averages(time, averages, errors);
                    otherwise
                        values = lifetime(:, enabledIndices);
                        ROIUtils.plot_values(time, values);

                end

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Lifetime (Ch #1)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end

            % Plot intensity if necessary
            if isIntPlot

                figure('Name', 'Green Int. Over Time');
                switch openFile.type()
                    case ROIFileType.Averaged
                        averages = int(:, 2*enabledIndices - 1);
                        errors = int(:, 2*enabledIndices);

                        ROIUtils.plot_averages(time, averages, errors);
                    otherwise
                        values = int(:, enabledIndices);
                        ROIUtils.plot_values(time, values);

                end

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Mean Intensity (Ch #1)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end

            % Plot red if necessary
            if isRedPlot

                figure('Name', 'Red Int. Over Time');
                switch openFile.type()  
                    case ROIFileType.Averaged
                        averages = red(:, 2*enabledIndices - 1);
                        errors = red(:, 2*enabledIndices);

                        ROIUtils.plot_averages(time, averages, errors);
                    otherwise
                        values = red(:, enabledIndices);
                        ROIUtils.plot_values(time, values);

                end

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Mean Intensity (Ch #2)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end
        end
        
        function plot_selected(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Plot -> Selected' Callback
        %
        % Plots all selected plots, only selected ROI data, and selected annotations
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            openFile = AppState.get_open_files(handles);
            roiData = AppState.get_roi_data(handles);

            % Check if a selection was made
            selection = AppState.get_data_selection(handles);
            if isempty(selection)
                warndlg('Please select a column or cell');
                return;
            end

            % Check if at least one plot is enabled
            isLifetimePlot = GUI.menu_is_toggled(handles.('menuShowLifetime'));
            isIntPlot = GUI.menu_is_toggled(handles.('menuShowGreen'));
            isRedPlot = GUI.menu_is_toggled(handles.('menuShowRed'));
            if ~(isLifetimePlot || isIntPlot || isRedPlot)
                warndlg('Please enable at least one of the plotting options');
                return;
            end

            % Get which ROIs are selected and enabled
            enabledROIs = GUI.get_enabled_rois(handles);
            selectedROIs = roiData.select_rois(selection) & enabledROIs;

            % Check that a valid selection was made
            if ~any(selectedROIs)
                warndlg('Make sure all selected ROIs are enabled and that non-time values were selected');
                return;
            end

            % Get appropriate selected ROI values
            if GUI.values_are_normalized(handles)
                solutions = GUI.get_solution_info(handles);
                nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);

                lifetime = roiData.normalized_lifetime(nBaselinePts);
                int = roiData.normalized_green(nBaselinePts);
                red = roiData.normalized_red(nBaselinePts);
            else
                lifetime = roiData.lifetime();
                int = roiData.green();
                red = roiData.red();
            end

            % Check if necessary data exists
            if isLifetimePlot && ~ROIUtils.data_exists(lifetime)
                warndlg('There is no lifetime data to plot');
                GUI.toggle_menu(handles.('menuShowLifetime'));
                return;
            end
            if isIntPlot && ~ROIUtils.data_exists(int)
                warndlg('There is no green intensity data to plot');
                GUI.toggle_menu(handles.('menuShowGreen'));
                return;
            end
            if isRedPlot && ~ROIUtils.data_exists(red)
                warndlg('There is no red intensity data to plot');
                GUI.toggle_menu(handles.('menuShowRed'));
                return;
            end

            % Get appropriate time values
            if GUI.time_is_adjusted(handles)
                solutions = GUI.get_solution_info(handles);
                nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
                time = roiData.adjusted_time(nBaselinePts); 
            else
                time = roiData.time(); 
            end


            % Generate legend
            switch openFile.type()
                case ROIFileType.Averaged
                    % Get the dna type and roi count of each source file
                    allDNA = ROIUtils.split_dna_type(GUI.get_dna_type(handles));
                    roiCounts = openFile.file_roi_counts();

                    legendEntries = ROIUtils.averages_legend(allDNA, roiCounts);
                otherwise
                    legendEntries = ROIUtils.values_legend(roiData.roi_count());
            end

            % Generate title
            expNames = openFile.experiment_names();
            titleStr = '';
            for i = 1:numel(expNames)
                titleStr = [titleStr, expNames{i}];
                if i < numel(expNames)
                    titleStr = [titleStr, ' | '];
                end
            end

            % Remove disabled ROIs from legend
            legendEntries = legendEntries(selectedROIs);

            % Plot lifetime if necessary
            if isLifetimePlot

                figure('Name', 'Lifetime Over Time');
                switch openFile.type()
                    case ROIFileType.Averaged
                        lifetime = ROIUtils.select_averages(lifetime, selectedROIs);
                        averages = lifetime(:, 1);
                        errors = lifetime(:, 2);

                        ROIUtils.plot_averages(time, averages, errors);
                    otherwise
                        values = ROIUtils.select(lifetime, selectedROIs);
                        ROIUtils.plot_values(time, values);

                end

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Lifetime (Ch #1)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end

            % Plot intensity if necessary
            if isIntPlot

                figure('Name', 'Green Int. Over Time');
                switch openFile.type()
                    case ROIFileType.Averaged
                        int = ROIUtils.select_averages(int, selectedROIs);
                        averages = int(:, 1);
                        errors = int(:, 2);

                        ROIUtils.plot_averages(time, averages, errors);
                    otherwise
                        values = ROIUtils.select(int, selectedROIs);
                        ROIUtils.plot_values(time, values);

                end

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Mean Intensity (Ch #1)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end

            % Plot red if necessary
            if isRedPlot

                figure('Name', 'Red Int. Over Time');
                switch openFile.type()
                    case ROIFileType.Averaged
                        red = ROIUtils.select_averages(red, selectedROIs);
                        averages = red(:, 1);
                        errors = red(:, 2);

                        ROIUtils.plot_averages(time, averages, errors);
                    otherwise
                        values = ROIUtils.select(red, selectedROIs);
                        ROIUtils.plot_values(time, values);

                end

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Mean Intensity (Ch #1)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end
        end
        
        function plot_averages(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Plot -> Averages' Callback
        %
        % Plots all selected plots, using averaged ROI data, and selected annotations
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            openFile = AppState.get_open_files(handles);
            roiData = AppState.get_roi_data(handles);

            % Check if at least one plot is enabled
            isLifetimePlot = GUI.menu_is_toggled(handles.('menuShowLifetime'));
            isIntPlot = GUI.menu_is_toggled(handles.('menuShowGreen'));
            isRedPlot = GUI.menu_is_toggled(handles.('menuShowRed'));
            if ~(isLifetimePlot || isIntPlot || isRedPlot)
                warndlg('Please enable at least one of the plotting options');
                return;
            end

            % Get appropriate ROIs
            if GUI.values_are_normalized(handles)
                solutions = GUI.get_solution_info(handles);
                nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);

                lifetime = roiData.normalized_lifetime(nBaselinePts);
                int = roiData.normalized_green(nBaselinePts);
                red = roiData.normalized_red(nBaselinePts);
            else
                lifetime = roiData.lifetime();
                int = roiData.green();
                red = roiData.red();
            end

            % Check if necessary data exists
            if isLifetimePlot && ~ROIUtils.data_exists(lifetime)
                warndlg('There is no lifetime data to plot');
                GUI.toggle_menu(handles.('menuShowLifetime'));
                return;
            end
            if isIntPlot && ~ROIUtils.data_exists(int)
                warndlg('There is no green intensity data to plot');
                GUI.toggle_menu(handles.('menuShowGreen'));
                return;
            end
            if isRedPlot && ~ROIUtils.data_exists(red)
                warndlg('There is no red intensity data to plot');
                GUI.toggle_menu(handles.('menuShowRed'));
                return;
            end

            % Get appropriate time values
            if GUI.time_is_adjusted(handles)
                solutions = GUI.get_solution_info(handles);
                nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
                time = roiData.adjusted_time(nBaselinePts); 
            else
                time = roiData.time(); 
            end

            % Check if at least one ROI is enabled
            enabledROIs = GUI.get_enabled_rois(handles);    
            if ~any(enabledROIs)
                warndlg('Please enable at least one ROI');
                return;
            end

            % Generate legend
            allDNA = { ROIUtils.trim_dna_type(GUI.get_dna_type(handles)) }; % ROIUtils.split_dna_type(GUI.get_dna_type(handles));
            roiCounts = numel(find(enabledROIs));
            legendEntries = ROIUtils.averages_legend(allDNA, roiCounts);

            % Generate title
            expNames = openFile.experiment_names();
            titleStr = '';
            for i = 1:numel(expNames)
                titleStr = [titleStr, expNames{i}];
                if i < numel(expNames)
                    titleStr = [titleStr, ' | '];
                end
            end

            % Plot lifetime if necessary
            if isLifetimePlot

                figure('Name', 'Lifetime Over Time');
                [averages, errors] = ROIUtils.average(lifetime(:, enabledROIs));
                ROIUtils.plot_averages(time, averages, errors);

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Lifetime (Ch #1)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end

            % Plot intensity if necessary
            if isIntPlot

                figure('Name', 'Green Int. Over Time');
                [averages, errors] = ROIUtils.average(int(:, enabledROIs));
                ROIUtils.plot_averages(time, averages, errors);

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Mean Intensity (Ch #1)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end

            % Plot red if necessary
            if isRedPlot

                figure('Name', 'Red Int. Over Time');
                [averages, errors] = ROIUtils.average(red(:, enabledROIs));
                ROIUtils.plot_averages(time, averages, errors);

                title(titleStr, 'Interpreter', 'none');
                xlabel('Time');
                ylabel('Mean Intensity (Ch #2)');
                legend(legendEntries);
                legend('boxoff');

                % Plot annotations if necessary
                if GUI.menu_is_toggled(handles.('menuShowAnnots'))
                    allSolutions = GUI.get_solution_info(handles);
                    solutionInfo = ROIUtils.split_solution_info(allSolutions);
                    ROIUtils.plot_annotations(gca, time, solutionInfo);
                end

                ROIUtils.set_x_limits(time);
            end
        end
        
        function show_annotations(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Plot -> Show Annotations' Callback
        %
        % Toggles whether annotations are shown or not
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get current program state
            handles = guidata(hObject);
            dnaType = GUI.get_dna_type(handles);
            solutions = GUI.get_solution_info(handles);

            % Check if we have enough info for annotations
            if ~ROIUtils.has_number_of_baseline_pts(solutions)
                warndlg('Please enter at least 2 solutions with unique timings before enabling annotations');
                return;
            elseif isempty(dnaType)
                warndlg('Please enter the DNA type before enabling annotations');
                return;
            else
                GUI.toggle_menu(hObject);
            end
        end
        
        function show_lifetime(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Plot -> Show Lifetime' Callback
        %
        % Toggles whether lifetime data is plotted or not
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);

            % Check if there are lifetime values to plot
            if GUI.menu_is_toggled(hObject) || ROIUtils.data_exists(roiData.lifetime())
                GUI.toggle_menu(hObject);
            else
                warndlg('This file has no lifetime intensity data to plot');
                return;
            end
        end
        
        function show_green(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Plot -> Show Green Intensity' Callback
        %
        % Toggles whether green intensity data is plotted or not
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);

            % Check if there are int values to plot
            if GUI.menu_is_toggled(hObject) || ROIUtils.data_exists(roiData.green())
                GUI.toggle_menu(hObject);
            else
                warndlg('This file has no green intensity data to plot');
                return;
            end
        end
        
        function show_red(hObject)
        %% --------------------------------------------------------------------------------------------------------
        % 'Plot -> Show Red Intensity' Callback
        %
        % Toggles whether red intensity data is plotted or not
        %
        % (IN) "hObject": handle to UI element that initiated callback
        %
            % Get program state
            handles = guidata(hObject);
            roiData = AppState.get_roi_data(handles);

            % Check if there are red values to plot
            if GUI.menu_is_toggled(hObject) || ROIUtils.data_exists(roiData.red())
                GUI.toggle_menu(hObject);
            else
                warndlg('This file has no red intensity data to plot');
                return;
            end
        end
        
    end
end