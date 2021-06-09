classdef AppState
    methods (Static)
        
        function logdlg(lastErr)
        %% --------------------------------------------------------------------------------------------------------
        % 'logdlg' Method
        %
        % Raises dialog describing given error. That error is then logged
        % in program's log file. If there is no log file, the given error 
        % is described in the console.
        % 
        % (IN) "lastErr": MException containing info about the last error raised
        %
        % Assumes program log file is named according to release program
        % version
        %
            try
                logFile = IOUtils.path_to_log(Analysis_1_2_Versions.release());
                errordlg(['An error occured. See log at ', logFile]);
                IOUtils.log_error(lastErr, logFile);
            catch
                errordlg('Could not log error. See console for details');
                error(getReport(lastErr));
            end
        end
        
        function [settingsMap] = get_user_preferences()
        %% --------------------------------------------------------------------------------------------------------
        % 'get_user_preferences' Method
        %
        % Reads preferences stored in program's .ini file into a map
        % structure. If no .ini file exists, a default one will be created
        %
        % (OUT) "settingsMap": Map structure containing
        %
        % Assumes program .ini file is named according to release program
        % version
        %
            version = Analysis_1_2_Versions.release();
            filename = [version, '_SETTINGS.ini'];
            [path, ~, ~] = fileparts(which(version));
            iniFile = fullfile(path, filename);

            % Create ini file if none exists
            fileID = fopen(iniFile, 'r');
            if fileID == -1
                settings = {'show_green_int', 'show_lifetime', 'show_red_int'};
                defaultValues = {'false', 'false', 'false'};
                IOUtils.create_ini_file(iniFile, settings, defaultValues);
            else
                fclose(fileID);
            end

            % Read ini file into map
            [settings, values] = IOUtils.read_ini_file(iniFile);
            settingsMap = containers.Map(settings, values);
            
            activeFigDefault = settingsMap('plot_default');
            figDefaultFile = [version, '_', activeFigDefault, '.ini'];
            iniFigDefault = fullfile(path, figDefaultFile);
            [figSettings, figValues] = IOUtils.read_ini_file(iniFigDefault);
            for i = 1:numel(figSettings)
                figSetting = figSettings{i};
                figVal = figValues{i};
                settingsMap(figSetting) = figVal;
            end
            
        end
        
        function set_open_files(handles, openFileObj)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_open_files' Method
        %
        % Updates which files are open by storing new file data
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to main figure in field 'mainFig'
        % (IN) "openFileObj": ROIFile containing new file data
        %
        % File data is stored in 'OPEN_FILE_OBJ' field of program's
        % appdata
        %
            setappdata(handles.('mainFig'), 'OPEN_FILE_OBJ', openFileObj);
        end
        
        function [openFileObj] = get_open_files(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'get_open_files' Method
        %
        % Gets file data from currently opened files
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to main figure in field 'mainFig'
        %  
        % (OUT) "openFileObj": ROIFile containing data of all open files
        %
        % Assumes that program's appdata has a previously created field
        % 'OPEN_FILE_OBJ'
        %
            openFileObj = getappdata(handles.('mainFig'), 'OPEN_FILE_OBJ');
        end
        
        function set_roi_data(handles, newROIData)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_roi_data' Method
        %
        % Updates which ROI data to display/modify by storing new ROI data
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to main figure in field 'mainFig'
        % (IN) "newROIData": ROIData containing new ROI data
        %
        % ROI data is stored in 'ROI_DATA' field of program's appdata
        %
            setappdata(handles.('mainFig'), 'ROI_DATA', newROIData);
        end
        
        function [roiData] = get_roi_data(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'get_roi_data' Method
        %
        % Gets ROI data that is currently being displayed/modified
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to main figure in field 'mainFig'
        %
        % (OUT) "roiData": ROIData containing current ROI data
        %
        % Assumes that program's appdata has previously created field
        % 'ROI_DATA'
        %
            roiData = getappdata(handles.('mainFig'), 'ROI_DATA');
        end

        function update_data_selection(handles, newSelection)
        %% ----------------------------------------------------------------------------------------------------------------
        % 'update_data_selection' Method
        %
        % Updates which ROI data is selected by storing new selection
        % indices
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to main figure in field 'mainFig'
        % (IN): "newSelection": matrix of indices where each row is a
        % selection in the form [<selected row>, <selected col>]
        %
        % Selected indices are stored 'DATA_SELECTION' field of program's appdata 
        %
            setappdata(handles.('mainFig'), 'DATA_SELECTION', newSelection);
        end
        
        function [selection] = get_data_selection(handles)
        %% ----------------------------------------------------------------------------------------------------------------
        % 'get_data_selection' Method
        %
        % Gets indices of currently selected data
        %
        % (IN) "handles": structure containing all program GUI data. Must
        % contain handle to main figure in field 'mainFig'
        %
        % (OUT) "selection": matrix of indices where each row is a
        % selection in the form [<selected row>, <selected col>]
        %
        % Assumes program's appdata has previously created field
        % 'DATA_SELECTION'
        %
            selection = getappdata(handles.('mainFig'), 'DATA_SELECTION');
        end
        
        
    end
end