%% GUIDE Methods --------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% Entry Point - DO NOT EDIT
%
%      ANALYSIS_1_2_IB_031221, by itself, creates a new ANALYSIS_1_2_IB_031221 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_031221 returns the handle to a new ANALYSIS_1_2_IB_031221 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_031221('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_031221.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_031221('Property','Value',...) creates a new ANALYSIS_1_2_IB_031221 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_031221_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_031221_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
function varargout = analysis_1_2_IB_031221(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_031221_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_031221_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


%% ----------------------------------------------------------------------------------------------------------------
% Opening Method
%
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysis_1_2_IB_031221 (see VARARGIN)
%
function analysis_1_2_IB_031221_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for analysis_1_2_IB_031221
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set initial program state
GUIUtils.update_ui_access(handles, ROIFileType.None);


%% ----------------------------------------------------------------------------------------------------------------
% Output Method
%
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
function varargout = analysis_1_2_IB_031221_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure

varargout{1} = handles.output;


    

%% GUI Utiltity Methods -------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

    
%% GUI Init Methods -----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------
function inputDNAType_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputSolBase_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputNumBase_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%% File Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'menuOpen' Callback
%
function menuOpen_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
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
    
    % Combine dna types
    dnaType = ROIUtils.combine_dna_types(dnaTypes);
    % Combine solution info
    solutionInfo = ROIUtils.combine_solution_info(allSolutions);
    
    % Validate solution info
    if openFile.has_exp_info() && ~ROIUtils.has_number_of_baseline_pts(solutionInfo)
        warndlg('This file has invalid experiment info. Please fix before loading');
        return;
    end
    
    % Get data values
    time = openFile.time();
    lifetime = openFile.lifetime();
    int = openFile.green();
    red = openFile.red();
    
    % Generate ROI data object
    switch openFile.type()
        case ROIFileType.Averaged
            normLt = openFile.normalized_lifetime();
            normInt = openFile.normalized_green();
            normRed = openFile.normalized_red();
            roiData = AverageTable(time, lifetime, normLt, int, normInt, red, normRed);
        otherwise
            roiData = ROITable(time, lifetime, int, red);
    end
    
    % Update program state
    AppState.set_open_files(handles, openFile);
    AppState.set_roi_data(handles, roiData);
    
    % Update UI
    GUIUtils.update_win_title(handles);
    GUIUtils.update_ui_access(handles, openFile.type());
    handles = GUIUtils.update_toggle_menu(handles, openFile.roi_count());
    GUIUtils.update_dna_type(handles, dnaType);
    GUIUtils.update_solution_info(handles, solutionInfo);
    
    % Disable info-dependent controls if necessary
    if ~openFile.has_exp_info()
        if GUIUtils.time_is_adjusted(handles)
            GUIUtils.toggle_button(handles.('btnToggleAdjustedTime'));
        end
        if GUIUtils.values_are_normalized(handles)
            GUIUtils.toggle_button(handles.('btnToggleNormVals'));
            GUIUtils.toggle_menu(handles.('menuToggleNormVals'));
        end
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            GUIUtils.toggle_menu(handles.('menuShowAnnots'));
        end
    end
    
    % Update data table
    GUIUtils.update_data_table(handles);         % <-- Updated last because of controls modifying disp
    
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuSave' Callback
%
function menuSave_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    openFile = AppState.get_open_files(handles);
    saveData = AppState.get_roi_data(handles);
    dnaType = GUIUtils.get_dna_type(handles);
    solutions = GUIUtils.get_solution_info(handles);
    enabledROIs = GUIUtils.get_enabled_rois(handles);

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
                enabledInt = ROIUtils.select(saveData.green(), enabledROIs);
                enabledRed = ROIUtils.select(saveData.red(), enabledROIs);
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
    
    % Save file according to selected type
    switch typeIdx
        case 1
            RawFile.save(savepath, saveData);
        case 2
            PreparedFile.save(savepath, saveData, dnaType, solutions);
        case 3
            AveragedFile.save(savepath, saveData, ROIUtils.trim_dna_type(dnaType), solutions);
        otherwise
            warndlg('Cannot save the file under this type');
    end
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuClose' Callback
%
function menuClose_Callback(hObject, ~, ~)
try
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
        GUIUtils.update_data_table(handles);
        GUIUtils.update_dna_type(handles, []);
        GUIUtils.update_solution_info(handles, {});
        GUIUtils.update_ui_access(handles, ROIFileType.None);
        GUIUtils.update_win_title(handles);
    end
catch err
    AppState.logdlg(err);
end




%% Data Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Selection Callback
%
function dataTable_CellSelectionCallback(hObject, eventdata, ~)
try
    handles = guidata(hObject);
    
    % Update program state
    AppState.update_data_selection(handles, eventdata.Indices);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Edit Callback 
%
function dataTable_CellEditCallback(hObject, eventdata, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    roiData = get_adjusted_data(handles);

    % Update only on valid data
    if ~isnan(eventdata.NewData)
        roiData(eventdata.Indices) = eventdata.NewData;
    end
    GUIUtils.update_data_table(roiData);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuFix' Callback
%
function menuFix_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = AppState.get_roi_data(handles);
    enabledROIs = GUIUtils.get_enabled_rois(handles);
    
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
                    GUIUtils.toggle_menu(hMenu);
                end
            end
        end
    end
    
    
    % Update program state
    AppState.set_roi_data(handles, roiData);
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleAdjustedTime' Callback
%
function btnToggleAdjustedTime_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    solutions = GUIUtils.get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        GUIUtils.toggle_button(hObject);
        return;
    end

    % Update the data table
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleNormVals' Callback
%
function btnToggleNormVals_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    solutions = GUIUtils.get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        GUIUtils.toggle_button(hObject);
        return;
    end

    % Update the corresponding menu item
    GUIUtils.toggle_menu(handles.('menuToggleNormVals'));

    % Update the data table
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuToggleNormVals' Callback
%
function menuToggleNormVals_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    solutions = GUIUtils.get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        GUIUtils.toggle_button(hObject);
        return;
    end

    % Update the corresponding button item
    GUIUtils.toggle_button(handles.('btnToggleNormVals'));

    % Update the data table
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'toggleROI' Callback
%
function toggleROI_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    GUIUtils.toggle_menu(hObject);
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableAllROI' Callback
%
function menuEnableAllROI_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = AppState.get_roi_data(handles);
    
    % Enable any disabled ROIs
    for i = 1:roiData.roi_count()
        tagStr = ['menuToggleROI', num2str(i)];
        hMenu = handles.(tagStr);
        
        if ~GUIUtils.menu_is_toggled(hMenu)
            GUIUtils.toggle_menu(hMenu);
        end
    end
    
    % Update Table
    GUIUtils.update_data_table(handles);
    
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableSelectedROI' Callback
%
function menuEnableSelectedROI_Callback(hObject, ~, ~)
try
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
        needsToggle = (enabledROIs(i) && ~GUIUtils.menu_is_toggled(hMenu)) || (~enabledROIs(i) && GUIUtils.menu_is_toggled(hMenu));

        if needsToggle
            GUIUtils.toggle_menu(hMenu);
        end
    end
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnEnableROI' Callback
%
function btnEnableROI_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    menuEnableSelectedROI_Callback(handles.('menuEnableSelectedROI'), [], handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowAbove' Callback
%
function menuAddRowAbove_Callback(hObject, ~, ~)
try
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
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowBelow' Callback
%
function menuAddRowBelow_Callback(hObject, ~, ~)
try
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
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuZeroRow' Callback
%
function menuZeroRow_Callback(hObject, ~, ~)
try
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
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuDeleteRow' Callback 
%
function menuDeleteRow_Callback(hObject, ~, ~)
try
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
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end




%% Plot Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAll' Callback
%
function menuPlotAll_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    openFile = AppState.get_open_files(handles);
    roiData = AppState.get_roi_data(handles);
    roiCount = roiData.roi_count();
    
    % Check if at least one plot is enabled
    isLifetimePlot = GUIUtils.menu_is_toggled(handles.('menuShowLifetime'));
    isIntPlot = GUIUtils.menu_is_toggled(handles.('menuShowGreen'));
    isRedPlot = GUIUtils.menu_is_toggled(handles.('menuShowRed'));
    if ~(isLifetimePlot || isIntPlot || isRedPlot)
        warndlg('Please enable at least one of the plotting options');
        return;
    end
    
    % Get appropriate ROIs
    if GUIUtils.values_are_normalized(handles)
        solutions = GUIUtils.get_solution_info(handles);
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
        GUIUtils.toggle_menu(handles.('menuShowLifetime'));
        return;
    end
    if isIntPlot && ~ROIUtils.data_exists(int)
        warndlg('There is no green intensity data to plot');
        GUIUtils.toggle_menu(handles.('menuShowGreen'));
        return;
    end
    if isRedPlot && ~ROIUtils.data_exists(red)
        warndlg('There is no red intensity data to plot');
        GUIUtils.toggle_menu(handles.('menuShowRed'));
        return;
    end
    
    % Get appropriate time values
    if GUIUtils.time_is_adjusted(handles)
        solutions = GUIUtils.get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        time = roiData.adjusted_time(nBaselinePts); 
    else
        time = roiData.time(); 
    end
    
    % Get which ROIs are enabled
    enabledROIs = GUIUtils.get_enabled_rois(handles);
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
            allDNA = ROIUtils.split_dna_type(GUIUtils.get_dna_type(handles));
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
            solutionInfo = ROIUtils.split_solution_info(allSolutions);
            ROIUtils.plot_annotations(gca, time, solutionInfo);
        end
        
        ROIUtils.set_x_limits(time);
    end
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotSelected' Callback
%
function menuPlotSelected_Callback(hObject, ~, ~)
try
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
    isLifetimePlot = GUIUtils.menu_is_toggled(handles.('menuShowLifetime'));
    isIntPlot = GUIUtils.menu_is_toggled(handles.('menuShowGreen'));
    isRedPlot = GUIUtils.menu_is_toggled(handles.('menuShowRed'));
    if ~(isLifetimePlot || isIntPlot || isRedPlot)
        warndlg('Please enable at least one of the plotting options');
        return;
    end
    
    % Get which ROIs are selected and enabled
    enabledROIs = GUIUtils.get_enabled_rois(handles);
    selectedROIs = roiData.select_rois(selection) & enabledROIs;
    
    % Check that a valid selection was made
    if ~any(selectedROIs)
        warndlg('Make sure all selected ROIs are enabled and that non-time values were selected');
        return;
    end
    
    % Get appropriate selected ROI values
    if GUIUtils.values_are_normalized(handles)
        solutions = GUIUtils.get_solution_info(handles);
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
        GUIUtils.toggle_menu(handles.('menuShowLifetime'));
        return;
    end
    if isIntPlot && ~ROIUtils.data_exists(int)
        warndlg('There is no green intensity data to plot');
        GUIUtils.toggle_menu(handles.('menuShowGreen'));
        return;
    end
    if isRedPlot && ~ROIUtils.data_exists(red)
        warndlg('There is no red intensity data to plot');
        GUIUtils.toggle_menu(handles.('menuShowRed'));
        return;
    end
    
    % Get appropriate time values
    if GUIUtils.time_is_adjusted(handles)
        solutions = GUIUtils.get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        time = roiData.adjusted_time(nBaselinePts); 
    else
        time = roiData.time(); 
    end
    
    
    % Generate legend
    switch openFile.type()
        case ROIFileType.Averaged
            % Get the dna type and roi count of each source file
            allDNA = ROIUtils.split_dna_type(GUIUtils.get_dna_type(handles));
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
            solutionInfo = ROIUtils.split_solution_info(allSolutions);
            ROIUtils.plot_annotations(gca, time, solutionInfo);
        end
        
        ROIUtils.set_x_limits(time);
    end
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAvg' Callback
%
function menuPlotAvg_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    openFile = AppState.get_open_files(handles);
    roiData = AppState.get_roi_data(handles);
    
    % Check if at least one plot is enabled
    isLifetimePlot = GUIUtils.menu_is_toggled(handles.('menuShowLifetime'));
    isIntPlot = GUIUtils.menu_is_toggled(handles.('menuShowGreen'));
    isRedPlot = GUIUtils.menu_is_toggled(handles.('menuShowRed'));
    if ~(isLifetimePlot || isIntPlot || isRedPlot)
        warndlg('Please enable at least one of the plotting options');
        return;
    end
    
    % Get appropriate ROIs
    if GUIUtils.values_are_normalized(handles)
        solutions = GUIUtils.get_solution_info(handles);
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
        GUIUtils.toggle_menu(handles.('menuShowLifetime'));
        return;
    end
    if isIntPlot && ~ROIUtils.data_exists(int)
        warndlg('There is no green intensity data to plot');
        GUIUtils.toggle_menu(handles.('menuShowGreen'));
        return;
    end
    if isRedPlot && ~ROIUtils.data_exists(red)
        warndlg('There is no red intensity data to plot');
        GUIUtils.toggle_menu(handles.('menuShowRed'));
        return;
    end
    
    % Get appropriate time values
    if GUIUtils.time_is_adjusted(handles)
        solutions = GUIUtils.get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        time = roiData.adjusted_time(nBaselinePts); 
    else
        time = roiData.time(); 
    end
    
    % Check if at least one ROI is enabled
    enabledROIs = GUIUtils.get_enabled_rois(handles);    
    if ~any(enabledROIs)
        warndlg('Please enable at least one ROI');
        return;
    end
    
    % Generate legend
    allDNA = { ROIUtils.trim_dna_type(GUIUtils.get_dna_type(handles)) }; % ROIUtils.split_dna_type(GUIUtils.get_dna_type(handles));
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
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
        if GUIUtils.menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = GUIUtils.get_solution_info(handles);
            solutionInfo = ROIUtils.split_solution_info(allSolutions);
            ROIUtils.plot_annotations(gca, time, solutionInfo);
        end
        
        ROIUtils.set_x_limits(time);
    end
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowAnnots' Callback
%
function menuShowAnnots_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    dnaType = GUIUtils.get_dna_type(handles);
    solutions = GUIUtils.get_solution_info(handles);
    
    % Check if we have enough info for annotations
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with unique timings before enabling annotations');
        return;
    elseif isempty(dnaType)
        warndlg('Please enter the DNA type before enabling annotations');
        return;
    else
        GUIUtils.toggle_menu(hObject);
    end
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowLifetime' Callback
%
function menuShowLifetime_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = AppState.get_roi_data(handles);
    
    % Check if there are lifetime values to plot
    if GUIUtils.menu_is_toggled(hObject) || ROIUtils.data_exists(roiData.lifetime())
        GUIUtils.toggle_menu(hObject);
    else
        warndlg('This file has no lifetime intensity data to plot');
        return;
    end
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowGreen' Callback 
%
function menuShowGreen_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = AppState.get_roi_data(handles);
    
    % Check if there are int values to plot
    if GUIUtils.menu_is_toggled(hObject) || ROIUtils.data_exists(roiData.green())
        GUIUtils.toggle_menu(hObject);
    else
        warndlg('This file has no green intensity data to plot');
        return;
    end
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowRed' Callback 
%
function menuShowRed_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = AppState.get_roi_data(handles);
    
    % Check if there are red values to plot
    if GUIUtils.menu_is_toggled(hObject) || ROIUtils.data_exists(roiData.red())
        GUIUtils.toggle_menu(hObject);
    else
        warndlg('This file has no red intensity data to plot');
        return;
    end
catch err
    AppState.logdlg(err);
end




%% Experiment Info Methods ----------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'btnAddSolution' Callback
%
function btnAddSolution_Callback(hObject, ~, ~)
try
    % Get the current program state
    handles = guidata(hObject);
    roiData = AppState.get_roi_data(handles);
    pointCount = max(roiData.point_counts());
    currentSolutions = GUIUtils.get_solution_info(handles);

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
    GUIUtils.update_solution_info(handles, newSolutions);
    
    % Update UI
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnRemoveSolution' Callback
%
function btnRemoveSolution_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    solutions = GUIUtils.get_solution_info(handles);
    
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
    GUIUtils.update_solution_info(handles, solutions);
    
    % Update UI
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'solutionTable' Cell Edit Callback
%
function solutionTable_CellEditCallback(hObject, eventdata, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = AppState.get_roi_data(handles);
    pointCount = max(roiData.point_counts());
    solutions = GUIUtils.get_solution_info(handles);

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
    GUIUtils.update_solution_info(handles, solutions);

    % Check if # of baseline pts is available
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        % Toggle off adj. time and norm. values if necessary
        if GUIUtils.time_is_adjusted(handles)
            GUIUtils.toggle_button(handles.('btnToggleAdjustedTime'));
        end
        if GUIUtils.values_are_normalized(handles)
            GUIUtils.toggle_button(handles.('btnToggleNormVals'));
            GUIUtils.toggle_menu(handles.('menuToggleNormVals'));
        end
    end

    % Update table
    GUIUtils.update_data_table(handles);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnImportInfo' Callback
%
function btnImportInfo_Callback(hObject, ~, ~)
try
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
        GUIUtils.update_dna_type(handles, newDNAType);
    end
    if ~isempty(newSolutions)
        GUIUtils.update_solution_info(handles, newSolutions);
    end
catch err
    AppState.logdlg(err);
end




%% Tools Menu Methods ---------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

function menuPreferences_Callback(~, ~, ~)
uiwait(analysis_1_2_user_options);
function menuSPC_Callback(~, ~, ~)
spc_drawInit;
function menuImstack_Callback(~, ~, ~)
h_imstack;
function menuStatsIB_Callback(~, ~, ~)
version = Stats_IB_Versions.release();
evalc(version);
function menuFLIMage_Callback(~, ~, ~)
failed = system('start FLIMage');
if failed
    warndlg('Could not open FLIMage. Make sure FLIMage is in your ''PATH'' environment variable');
end

%% MISC -----------------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------
function menuFile_Callback(~, ~, ~)
function menuData_Callback(~, ~, ~)
function menuToggle_Callback(~, ~, ~)
function menuToggleROI_Callback(~, ~, ~)
function menuRow_Callback(~, ~, ~)
function inputDNAType_Callback(~, ~, ~)
function inputSolBase_Callback(~, ~, ~)
function inputNumBase_Callback(~, ~, ~)
function menuPlot_Callback(~, ~, ~)
function menuTools_Callback(~, ~, ~) 
%#ok<*DEFNU>

