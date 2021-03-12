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
        end
        
        function set_open_files(handles, openFileObj)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_open_files' Method
        %
        % Updates which files are open by storing new file data
        %
        % (IN) "handles": structure containing all program GUI data
        % (IN) "openFileObj": ROIFile containing new file data
        %
        % File data is stored in 'OPEN_FILE_OBJ' field of program's appdata
        %
            setappdata(handles.('mainFig'), 'OPEN_FILE_OBJ', openFileObj);
        end
        
        function [openFileObj] = get_open_files(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_open_files' Method
        %
        % Gets file data from currently opened files
        %
        % (IN) "handles": structure containing all program GUI data
        %  
        % (OUT) "openFileObj": ROIFile containing data of all open files
        %
        % Assumes that program's appdata has a previously created field
        % 'OPEN_FILE_OBJ'
        %
            openFileObj = getappdata(handles.('mainFig'), 'OPEN_FILE_OBJ');
        end
    end
end