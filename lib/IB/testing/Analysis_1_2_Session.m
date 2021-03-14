classdef Analysis_1_2_Session
    properties
        version
        instance
        startTime
    end
    
    methods
        %% --------------------------------------------------------------------------------------------------------
        % 'Analysis_1_2_Diagnostic' Constructor
        %
        function [this] = Analysis_1_2_Session(version)
            startCmd = ['this.instance = ', version];
            evalc(startCmd);
            
            this.version = version;
            this.startTime = datenum(clock());
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'duration' Method
        %
        function duration(obj)
            currentTime = datenum(clock());
            [~, ~, ~, hours, mins, sec] = datevec(currentTime - obj.startTime);
            fprintf('%d hours, %d minutes, and %g seconds elapsed\n', hours, mins, sec);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'print_session_logs' Method
        %
        function print_session_logs(obj)
            logFile = IOUtils.path_to_log(obj.version);
            [allLogs] = IOUtils.read_log(logFile);
            
            numDisplayed = 0;
            for i = 1:size(allLogs,1)
                logTimestamp = allLogs{i, 1};
                logText = allLogs{i, 2};
                if datenum(logTimestamp) > obj.startTime
                    fprintf('Logged at %s:\n%s', logTimestamp, logText);
                    numDisplayed = numDisplayed + 1;
                end
            end
            
            if numDisplayed == 0
                fprintf('There are no logs to print for the current session\n');
            end
        end
                
        %% --------------------------------------------------------------------------------------------------------
        % 'print_open_files' Method
        %
        function print_open_files(obj)
            getterCmd = ['openFiles = ', obj.version, '(''get_open_files'', guidata(obj.instance))'];
            evalc(getterCmd);
            
            if isempty(openFiles)
                fprintf('No files are open\n');
            else
                % Gather properties
                fileType = openFiles.type();
                srcFiles = openFiles.source_files();
                expNames = openFiles.experiment_names();
                nFiles = openFiles.file_count();
                roiCounts = openFiles.file_roi_counts();
                
                % File type, name, and count
                fprintf('File Type: ''%s''\n', ROIFileType.as_string(fileType));
                fprintf('Files opened: ''%d''\n', nFiles);
                for i = 1:numel(srcFiles)
                    fprintf('\tFile %d: ''%s''\n', i, srcFiles{i});
                end
                
                % Experiment names
                fprintf('\tExperiments:\n\t');
                for i = 1:numel(expNames)
                    fprintf(' ''%s''', expNames{i});
                end
                fprintf('\n');
                
                % ROI Counts
                fprintf('\tROI Counts:\n\t');
                for i = 1:numel(roiCounts)
                    fprintf(' ''%d''', roiCounts(i));
                end
                fprintf('\n');
                
                hasExpInfo = openFiles.has_exp_info();
                if hasExpInfo
                    dnaTypes = openFiles.dna_types();
                    solutions = openFiles.solution_info();
                    
                    % DNA Types
                    fprintf('\tDNA Types:\n\t');
                    for i = 1:numel(dnaTypes)
                        fprintf(' ''%s''', dnaTypes{i});
                    end
                    fprintf('\n');
                    
                    % Solutions
                    for i = 1:numel(solutions)
                        fprintf('\tSolution Table %d:\n', i);
                        table = solutions{i};
                        for j = 1:size(table,1)
                            fprintf('\t ''%d'' ''%s''\n', table{j, 2}, table{j, 1});
                        end
                    end
                else
                    % No exp info
                    fprintf('\tThis file does not have experiment info\n');
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'print_open_files' Method
        %
        function print_roi_data(obj, customBaseline)
            getterCmd = ['roiData = ', obj.version, '(''get_roi_data'', guidata(obj.instance))'];
            evalc(getterCmd);
            
            if isempty(roiData)
                fprintf('No ROI data is loaded\n');
            else
                % Gather properties, some using custom # of baseline pts
                roiCount = roiData.roi_count();
                ptCounts = roiData.point_counts();
                labels = roiData.roi_labels();
                time = roiData.time();
                adjTime = roiData.adjusted_time(customBaseline);
                lt = roiData.lifetime();
                normLt = roiData.normalized_lifetime(customBaseline);
                green = roiData.green();
                normGreen = roiData.normalized_green(customBaseline);
                red = roiData.red();
                normRed = roiData.normalized_red(customBaseline);

                % Counts
                fprintf('Using %d baseline pts...\n', customBaseline);
                fprintf('ROI Count: ''%d''\n', roiCount);
                fprintf('# of Data Points:\n');
                for i = 1:numel(ptCounts)
                    fprintf(' ''%d''', ptCounts(i));
                end
                fprintf('\n');
                
                % Labels
                fprintf('Data Labels:\n');
                for i = 1:numel(labels)
                    fprintf(' ''%s''', labels{i});
                end
                fprintf('\n\n');
                
                % Time
                format('shortG');
                fprintf('Unadjusted Time:\n');
                for i = 1:numel(time)
                    fprintf(' ''%f''', time(i));
                end
                fprintf('\n');
                fprintf('Adjusted Time:\n');
                for i = 1:numel(adjTime)
                    fprintf(' ''%f''', adjTime(i));
                end
                fprintf('\n\n');
                
                % Lifetime
                if ROIUtils.data_exists(lt)
                    for i = 1:size(lt, 2)
                        fprintf('Lifetime %d:\n', i);
                        for j = 1:size(lt, 1)
                            fprintf(' ''%f''', lt(j, i));
                        end
                        fprintf('\n');
                    end
                    fprintf('\n');
                else
                    fprintf('No lifetime data\n');
                end
                
                % Norm Lifetime
                if ROIUtils.data_exists(normLt)
                    for i = 1:size(normLt, 2)
                        fprintf('Normalized Lifetime %d:\n', i);
                        for j = 1:size(normLt, 1)
                            fprintf(' ''%f''', normLt(j, i));
                        end
                        fprintf('\n');
                    end
                    fprintf('\n');
                else
                    fprintf('No normalized lifetime data\n');
                end
                
                % Green Int
                if ROIUtils.data_exists(green)
                    for i = 1:size(green, 2)
                        fprintf('Green Intensity %d:\n', i);
                        for j = 1:size(green, 1)
                            fprintf(' ''%f''', green(j, i));
                        end
                        fprintf('\n');
                    end
                    fprintf('\n');
                else
                    fprintf('No green intensity data\n');
                end
                
                % Norm Green Int
                if ROIUtils.data_exists(normGreen)
                    for i = 1:size(normGreen, 2)
                        fprintf('Normalized Green Intensity %d:\n', i);
                        for j = 1:size(normGreen, 1)
                            fprintf(' ''%f''', normGreen(j, i));
                        end
                        fprintf('\n');
                    end
                    fprintf('\n');
                else
                    fprintf('No normalized green intensity data\n');
                end
                
                % Red Int
                if ROIUtils.data_exists(red)
                    for i = 1:size(red, 2)
                        fprintf('Red Intensity %d:\n', i);
                        for j = 1:size(red, 1)
                            fprintf(' ''%f''', red(j, i));
                        end
                        fprintf('\n');
                    end
                    fprintf('\n');
                else
                    fprintf('No red intensity data\n');
                end
                
                % Norm Red Int
                if ROIUtils.data_exists(normRed)
                    for i = 1:size(normRed, 2)
                        fprintf('Normalized Red Intensity %d:\n', i);
                        for j = 1:size(normRed, 1)
                            fprintf(' ''%f''', normRed(j, i));
                        end
                        fprintf('\n');
                    end
                    fprintf('\n');
                else
                    fprintf('No normalized red intensity data\n');
                end
            
            end
            
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'print_experiment_info' Method
        %
        function print_experiment_info(obj)
            dnaTypeCmd = ['dnaType = ', obj.version, '(''get_dna_type'', guidata(obj.instance))'];
            solutionCmd = ['solutions = ', obj.version, '(''get_solution_info'', guidata(obj.instance))'];
            evalc(dnaTypeCmd);
            evalc(solutionCmd);
            
            % DNA Type
            if isempty(dnaType)
                fprintf('No DNA type present\n');
            else
                fprintf('DNA Type (Combined): ''%s''\n', dnaType);
                
                [allDNA] = ROIUtils.split_dna_type(dnaType);
                fprintf('DNA Type (Split):\n');
                for i = 1:numel(allDNA)
                    fprintf(' ''%s''', allDNA{i});
                end
                fprintf('\n');
            end
            fprintf('\n');
            
            % Solutions
            if isempty(solutions)
                fprintf('No solutions present\n');
            else
                fprintf('Solution Info (Combined):\n');
                for i = 1:size(solutions,1)
                    fprintf(' ''%d'' ''%s''\n', solutions{i, 2}, solutions{i, 1});
                end
                
                [allSolutions] = ROIUtils.split_solution_info(solutions);
                for i = 1:numel(allSolutions)
                    fprintf('Solution Info (Split %d):\n', i);
                    table = allSolutions{i};
                    for j = 1:size(table, 1)
                        fprintf(' ''%d'' ''%s''\n', table{j, 2}, table{j, 1});
                    end
                end
                
                if ROIUtils.has_number_of_baseline_pts(solutions)
                    fprintf('# of Baseline Points: ''%d''\n', ROIUtils.number_of_baseline_pts(solutions));
                else
                    fprintf('Cannot deduce # of baseline points\n');
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'print_data_state' Method
        %
        function print_data_state(obj)
            adjTimeCmd = ['isAdj = ', obj.version, '(''time_is_adjusted'', guidata(obj.instance))'];
            normValsCmd = ['isNorm = ', obj.version, '(''values_are_normalized'', guidata(obj.instance))'];
            enabledROIsCmd = ['enabledROIs = ', obj.version, '(''get_enabled_rois'', guidata(obj.instance))'];
            evalc(adjTimeCmd);
            evalc(normValsCmd);
            evalc(enabledROIsCmd);
            
            for i = 1:numel(enabledROIs)
                if enabledROIs(i)
                    fprintf('ROI %d: ''enabled''\n', i);
                else
                    fprintf('ROI %d: ''disabled''\n', i);
                end
            end
            
            if isAdj
                fprintf('Time: ''adjusted''\n');
            else
                fprintf('Time: ''unadjusted''\n');
            end
            
            if isNorm
                fprintf('ROIs: ''normalized''\n');
            else
                fprintf('ROIs: ''non-normalized''\n');
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'print_ui_status' Method
        %
        function print_ui_status(obj)
            handles = guidata(obj.instance);
            
            % File Menu
            fprintf('File Menu:\n');
            fileMenu = allchild(handles.('menuFile'));
            while ~isempty(fileMenu)
                hdl = fileMenu(1);
                fileMenu = fileMenu(2:end);
                fprintf('\t''%s'': enabled = ''%s''\n', ...
                        get(hdl, 'Tag'), ...
                        get(hdl, 'Enable'));
                hdlChildren = allchild(hdl);
                if ~isempty(hdlChildren)
                    fileMenu = [fileMenu; allchild(hdl)];
                end
            end
            fprintf('\n');
            
            % Data Menu
            fprintf('Data Menu:\n');
            dataMenu = allchild(handles.('menuData'));
            while ~isempty(dataMenu)
                hdl = dataMenu(1);
                dataMenu = dataMenu(2:end);
                fprintf('\t''%s'': enabled = ''%s'', toggled = ''%s''\n', ...
                        get(hdl, 'Tag'), ...
                        get(hdl, 'Enable'), ...
                        get(hdl, 'Checked'));
                    
                hdlChildren = allchild(hdl);
                if ~isempty(hdlChildren)
                    dataMenu = [dataMenu; allchild(hdl)];
                end
            end
            fprintf('\n');
            
            % Plot Menu
            fprintf('Plot Menu:\n');
            plotMenu = allchild(handles.('menuPlot'));
            while ~isempty(plotMenu)
                hdl = plotMenu(1);
                plotMenu = plotMenu(2:end);
                fprintf('\t''%s'': enabled = ''%s'', toggled = ''%s''\n', ...
                        get(hdl, 'Tag'), ...
                        get(hdl, 'Enable'), ...
                        get(hdl, 'Checked'));
                    
                hdlChildren = allchild(hdl);
                if ~isempty(hdlChildren)
                    plotMenu = [plotMenu; allchild(hdl)];
                end
            end
            fprintf('\n');
            
            % Tools Menu
            fprintf('Tools Menu:\n');
            toolsMenu = allchild(handles.('menuTools'));
            while ~isempty(toolsMenu)
                hdl = toolsMenu(1);
                toolsMenu = toolsMenu(2:end);
                fprintf('\t''%s'': enabled = ''%s''\n', ...
                        get(hdl, 'Tag'), ...
                        get(hdl, 'Enable'));
                    
                hdlChildren = allchild(hdl);
                if ~isempty(hdlChildren)
                    toolsMenu = [toolsMenu; allchild(hdl)];
                end
            end
            fprintf('\n');
            
            % Info Panel
            fprintf('Information Panel:\n');
            infoPanel = allchild(handles.('panelInfo'));
            while ~isempty(infoPanel)
                hdl = infoPanel(1);
                infoPanel = infoPanel(2:end);
                fprintf('\t''%s'': enabled = ''%s''\n', ...
                        get(hdl, 'Tag'), ...
                        get(hdl, 'Enable'));
                    
                hdlChildren = allchild(hdl);
                if ~isempty(hdlChildren)
                    infoPanel = [infoPanel; allchild(hdl)];
                end
            end
            fprintf('\n');
        end
    end
end