classdef PreferencesApp
    methods (Static)
        
        function logdlg(lastErr)
        %% --------------------------------------------------------------------------------------------------------
        % 'logdlg' Method
        %
            try
                version = Analysis_1_2_Versions.release();
                scriptFilePath = which(version);
                [path, ~, ~] = fileparts(scriptFilePath);
                logFile = [version, '_LOG.txt'];
                filepath = fullfile(path, logFile);

                errordlg(['An error occured. See log at ', filepath]);
                IOUtils.log_error(lastErr, filepath);
            catch
                errordlg('Could not log error. See console for details');
                error(getReport(lastErr));
            end
        end
        
        function [filepath] = settings_filepath()
        %% --------------------------------------------------------------------------------------------------------
        % 'settings_filepath' Method
        %
            version = Analysis_1_2_Versions.release();
            [path, ~, ~] = fileparts(which(version));
            filename = [version, '_SETTINGS.ini'];
            filepath = fullfile(path, filename);
        end
        
        function [filepath] = figure_default_filepath(defaultName)
        %% --------------------------------------------------------------------------------------------------------
        % 'figure_default_filepath' Method
        %
            version = Analysis_1_2_Versions.release();
            [path, ~, ~] = fileparts(which(version));
            filename = [version, '_', defaultName, '.ini'];
            filepath = fullfile(path, filename);
        end
        
        function [settings, values] = initial_figure_settings()
        %% --------------------------------------------------------------------------------------------------------
        % 'initial_figure_settings' Method
        %
            figureTypes = {'lt', 'green', 'red'};
            figureSettings = {'x', 'y', 'h', 'w', 'x_min', 'x_max', 'y_min', 'y_max'};

            settings = {};
            values = {};
            for i = 1:numel(figureTypes)
                figType = figureTypes{i};
                for j = 1:numel(figureSettings)
                    figSetting = figureSettings{j};
                    settings{end+1} = [figType, '_', figSetting];
                    values{end+1} = '0';
                end
            end
        end
        
        function set_settings_map(handles, newSettingsMap)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_settings_map' Method
        %
            setappdata(handles.('mainFig'), 'SETTINGS_MAP', newSettingsMap);
        end
        
        function [settingsMap] = get_settings_map(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'get_settings_map' Method
        %
            settingsMap = getappdata(handles.('mainFig'), 'SETTINGS_MAP');
        end
        
        function update_gui(handles)
            settingsMap = PreferencesApp.get_settings_map(handles);
            guiFields = fieldnames(handles);

            for i = 1:numel(guiFields)
                hGUI = handles.(guiFields{i});

                if isKey(settingsMap, guiFields{i})
                    setting = guiFields{i};
                    value = settingsMap(setting);

                    if strcmp(value, 'true')
                        set(hGUI, 'Value', 1);
                    elseif strcmp(value, 'false')
                        set(hGUI, 'Value', 0);
                    else
                        set(hGUI, 'String', value);
                    end
                end
            end

            hFigDefsList = handles.('savedDefsList');
            savedDefaults = {};
            possibleDefaults = keys(settingsMap);
            for i = 1:numel(possibleDefaults)
                val = settingsMap(possibleDefaults{i});
                if strcmp(val, 'saved')
                    savedDefaults{end+1} = possibleDefaults{i};
                end
            end

            activeDefault = settingsMap('plot_default');
            selection = find(contains(savedDefaults, activeDefault));

            set(hFigDefsList, 'String', savedDefaults);
            set(hFigDefsList, 'Value', selection);
        end
        
        function btnSaveChanges(hObject)
            % Get program state
            handles = guidata(hObject);
            settingsMap = PreferencesApp.get_settings_map(handles);

            % Save figure defaults
            [figSettings, figValues] = PreferencesApp.initial_figure_settings();
            for i = 1:numel(figSettings)
                figValues{i} = settingsMap(figSettings{i});
            end

            activeDefault = settingsMap('plot_default');
            iniFigureDefault = PreferencesApp.figure_default_filepath(activeDefault);

            IOUtils.create_ini_file(iniFigureDefault, figSettings, figValues);

            % Save all other settings
            remove(settingsMap, figSettings);
            newSettings = keys(settingsMap);
            newValues = values(settingsMap, newSettings);
            iniFile = PreferencesApp.settings_filepath();
            IOUtils.create_ini_file(iniFile, newSettings, newValues);

            % Close the window
            close(handles.('mainFig'));
        end
    end
end