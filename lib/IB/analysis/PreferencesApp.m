classdef PreferencesApp
    methods (Static)
        
        function startup(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'startup' Method
        %
        % Initializes .ini files and GUI before raising application
        %
        % (IN) "handles": structure containing all program GUI data
        %
            iniFile = PreferencesApp.settings_filepath();
            [settings, values] = IOUtils.read_ini_file(iniFile);
            settingsMap = containers.Map(settings, values);

            % Load saved figure defaults
            figDefaultName = settingsMap('plot_default');
            figDefaultFile = PreferencesApp.figure_default_filepath(figDefaultName);

            [figSettings, figValues] = IOUtils.read_ini_file(figDefaultFile);

            allSettings = [settings, figSettings];
            allValues = [values, figValues];
            settingsMap = containers.Map(allSettings, allValues);

            PreferencesApp.set_settings_map(handles, settingsMap);
            PreferencesApp.set_edit_status(handles, false);
            PreferencesApp.update_gui(handles);
        end
        
        function logdlg(lastErr)
        %% --------------------------------------------------------------------------------------------------------
        % 'logdlg' Method
        %
        % Handles an error by warning the user and logging details to a text file
        %
        % (IN) "lastErr": MException describing error details
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
        
        function [filepath] = settings_template_filepath()
            [path, ~, ~] = fileparts(which(version));
            path = [path, '\config\'];
            filename = 'template.ini';
            filepath = fullfile(path, filename);
        end
        
        function [filepath] = settings_filepath()
        %% --------------------------------------------------------------------------------------------------------
        % 'settings_filepath' Method
        %
        % Returns the path to the .ini file containing all user preferences data
        %
        % (OUT) "filepath": string describing the relevant filepath. Assumes that the
        %                   settings filename is in the format "analysis_1_2_XXXXXX_SETTINGS.ini"
        %
            version = Analysis_1_2_Versions.release();
            [path, ~, ~] = fileparts(which(version));
            path = [path, '\config\'];
            filename = [version, '_SETTINGS.ini'];
            filepath = fullfile(path, filename);
        end
        
        function [filepath] = figure_default_filepath(defaultName)
        %% --------------------------------------------------------------------------------------------------------
        % 'figure_default_filepath' Method
        %
        % Returns the path to the .ini file containing the saved figure defaults
        %
        % (IN) "defaultName": string describing the name of the default for which to query the filepath
        %
        % (OUT) "filepath": string describing the relevant filepath. Assumes that filename
        %                   follows the format "analysis_1_2_XXXXXX_<defaultName>.ini"
        %
            version = Analysis_1_2_Versions.release();
            [path, ~, ~] = fileparts(which(version));
            path = [path, '\config\'];
            filename = [version, '_', defaultName, '.ini'];
            filepath = fullfile(path, filename);
        end
        
        function [tf] = figure_default_exists(defaultName)
            iniFile = PreferencesApp.figure_default_filepath(defaultName);
            [settings, values] = IOUtils.read_ini_file(iniFile);
            tf = ~isempty(settings) && ~isempty(values);
        end
        
        function [settings, values] = initial_figure_settings()
        %% --------------------------------------------------------------------------------------------------------
        % 'initial_figure_settings' Method
        %
        % Returns the setting options for figures and their default values
        %
        % (OUT) "settings": A cell of strings describing each option name
        % (OUT) "values": A cell of strings describing each option's default value
        %
            figureTypes = {'lt', 'green', 'red'};
            figureSettings = {'x', 'y', 'h', 'w', 'x_min', 'x_max', 'y_min', 'y_max', 'is_norm'};
            figureValues = {'100', '100', '300', '400', '-inf', 'inf', '-inf', 'inf', 'false'};

            settings = {};
            values = {};
            for i = 1:numel(figureTypes)
                figType = figureTypes{i};
                for j = 1:numel(figureSettings)
                    figSetting = figureSettings{j};
                    settings{end+1} = [figType, '_', figSetting];
                    values{end+1} = figureValues{j};
                end
            end
            
            % Additonal misc settings
            settings{end+1} = 'green_is_int';
            values{end+1} = 'false';
            settings{end+1} = 'red_is_int';
            values{end+1} = 'false';
        end
        
        function [settings, values] = initial_plotting_settings()
            settings = {'show_lifetime', 'show_green_int', 'show_red_int', 'show_annotations'};
            values = {'true', 'true', 'true', 'true'};
        end
        
        function set_settings_map(handles, newSettingsMap)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_settings_map' Method
        %
        % Updates the stored map of setting options and values to the given map
        %
        % (IN) "handles": Structure containing all GUI data. Must have a field named "mainFig".
        % (IN) "newSettingsMap": A containers.Map of strings keys to string values
        %                        describing the new setting options and values
        %
            setappdata(handles.('mainFig'), 'SETTINGS_MAP', newSettingsMap);
        end
        
        function [settingsMap] = get_settings_map(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'get_settings_map' Method
        %
            settingsMap = getappdata(handles.('mainFig'), 'SETTINGS_MAP');
        end
        
        function set_edit_status(handles, tf)
            setappdata(handles.('mainFig'), 'EDIT_STATUS', tf);
        end
        
        function [tf] = get_edit_status(handles)
            tf = getappdata(handles.('mainFig'), 'EDIT_STATUS');
        end
        
        function update_gui(handles)
        %% --------------------------------------------------------------------------------------------------------
        % 'update_gui' Method
        %
        % Refreshes the GUI appearance according to the current program state
        %
        % (IN) "handles": struct containing all of the program's GUI data
        %
            settingsMap = PreferencesApp.get_settings_map(handles);
            isEditting = PreferencesApp.get_edit_status(handles);
            guiFields = fieldnames(handles);

            if isEditting
                enableGUI = 'on';
            else
                enableGUI = 'off';
            end
            

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
                    
                    set(hGUI, 'Enable', enableGUI);
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
            if isempty(selection)
                selection = 1;
            end

            set(hFigDefsList, 'String', savedDefaults);
            set(hFigDefsList, 'Value', selection);
        end
        
        function btnSaveChanges(handle)
        %% --------------------------------------------------------------------------------------------------------
        % 'btnSaveChanges' Callback
        % 
        % Save's the changes the user made to their preferences by writing to .ini files
        %
        % (IN) "handle": handle to 'btnSaveChanges'
        %
            % Get program state
            handles = guidata(handle);
            settingsMap = PreferencesApp.get_settings_map(handles);
            isEditting = PreferencesApp.get_edit_status(handles);
            
            if ~isEditting
                return;
            end
            PreferencesApp.set_edit_status(handles, false);
            

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
            
            % Re-add figure settings to map
            for i = 1:numel(figSettings)
                 settingsMap(figSettings{i}) = figValues{i};
            end

            % Update GUI
            PreferencesApp.update_gui(handles);
        end
        
        function checkBoxSetting(handle, settingName)
            % Get program state
            handles = guidata(handle);
            settingsMap = PreferencesApp.get_settings_map(handles);

            % Change the appropriate setting
            if GUI.box_is_checked(handle)
                settingsMap(settingName) = 'true';
            else
                settingsMap(settingName) = 'false';
            end

            PreferencesApp.set_settings_map(handles, settingsMap);
        end

        function textInputSetting(handle, settingName)
            % Get Program State
            handles = guidata(handle);
            settingsMap = PreferencesApp.get_settings_map(handles);
            
            % Get User Input
            input = get(handle, 'String');
            if iscell(input)
                input = input{1};
            end

            % Update Settings
            settingsMap(settingName) = input;

            PreferencesApp.set_settings_map(handles, settingsMap);
        end
        
        function savedDefsList(handle)
            % Get program state
            handles = guidata(handle);
            settingsMap = PreferencesApp.get_settings_map(handles);

            % Get list of defaults and current selection
            savedDefaults = get(handle, 'String');
            selection = get(handle, 'Value');

            % Load file corresponding to selected default
            selectedDefault = savedDefaults{selection};
            iniSelected = PreferencesApp.figure_default_filepath(selectedDefault);
            [figSettings, figValues] = IOUtils.read_ini_file(iniSelected);

            for i = 1:numel(figSettings)
                setting = figSettings{i};
                value = figValues{i};

                settingsMap(setting) = value;
            end
            settingsMap('plot_default') = selectedDefault;

            PreferencesApp.set_settings_map(handles, settingsMap);
            PreferencesApp.update_gui(handles);
        end
        
        function btnAddDefault(handle)
            % Get program state
            handles = guidata(handle);
            settingsMap = PreferencesApp.get_settings_map(handles);
            hFigDefsList = handles.('savedDefsList');

            % Raise dialog to get new default's name
            dlg = struct;
            dlg.prompt = {'Enter name for the new default: '};
            dlg.title = 'New Figure Default';
            dlg.dims = [1, 30];

            userInput = inputdlg(dlg.prompt, dlg.title, dlg.dims);
            if isempty(userInput)
                return;
            end

            newDefaultName = userInput{1};
            savedDefaults = get(hFigDefsList, 'String');

            if any(contains(savedDefaults, newDefaultName))
                warndlg('Please enter a default that does not already exist');
                return;
            end

            % Raise dialog to choose which default will be used as a template

            dlg.options = {'Name', 'Choose Template', ...
                           'SelectionMode', 'single', ...
                           'OKString', 'Use This as Template', ...
                           'ListSize', [300, 100]};
                       
            [templateIdx, isOK] = listdlg('ListString', savedDefaults, dlg.options{:});
            if ~isOK
                return;
            end
            
            % Load template
            templateDefault = savedDefaults{templateIdx};
            templateFile = PreferencesApp.figure_default_filepath(templateDefault);
            [figSettings, initialFigValues] = IOUtils.read_ini_file(templateFile);
            
            % Save into new default file
            defaultFile = PreferencesApp.figure_default_filepath(newDefaultName);
            IOUtils.create_ini_file(defaultFile, figSettings, initialFigValues);

            for i = 1:numel(figSettings)
                setting = figSettings{i};
                value = initialFigValues{i};
                settingsMap(setting) = value;
            end

            settingsMap(newDefaultName) = 'saved';
            settingsMap('plot_default') = newDefaultName;

            % Update program state
            PreferencesApp.set_settings_map(handles, settingsMap);
            PreferencesApp.update_gui(handles);
        end
        
        function btnRemoveDefault(handle)
            % Get program state
            handles = guidata(handle);
            settingsMap = PreferencesApp.get_settings_map(handles);
            hFigDefsList = handles.('savedDefsList');
            savedDefaults = get(hFigDefsList, 'String');
            
            if isempty(savedDefaults)
                warndlg('There are no defaults to remove');
                return;
            end
            
            % Let user choose which default to remove
            dlg.options = {'Name', 'Remove Figure Default', ...
                           'SelectionMode', 'single', ...
                           'OKString', 'Remove', ...
                           'ListSize', [300, 100]};
            [defaultIdx, isOK] = listdlg('ListString', savedDefaults, dlg.options{:});
            if ~isOK
                return;
            end
            
            % Remove chosen default
            removedDefault = savedDefaults{defaultIdx};
            defaultFile = PreferencesApp.figure_default_filepath(removedDefault);
            delete(defaultFile);
            savedDefaults(defaultIdx) = [];
            
            % Update active default
            activeDefault = savedDefaults{1};
            settingsMap('plot_default') = activeDefault;
            remove(settingsMap, { removedDefault });
            
            % Update program state
            PreferencesApp.set_settings_map(handles, settingsMap);
            PreferencesApp.update_gui(handles);
        end
       
        function btnEditDefault(handle)
            handles = guidata(handle);
            
            isEditting = PreferencesApp.get_edit_status(handles);
            if ~isEditting
                PreferencesApp.set_edit_status(handles, true);
                PreferencesApp.update_gui(handles);
            end
        end
    end
end