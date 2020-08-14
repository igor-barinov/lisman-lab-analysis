%% GUIDE Methods --------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% Entry Point - DO NOT EDIT
%
%      ANALYSIS_1_2_IB_081420, by itself, creates a new ANALYSIS_1_2_IB_081420 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_081420 returns the handle to a new ANALYSIS_1_2_IB_081420 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_081420('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_081420.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_081420('Property','Value',...) creates a new ANALYSIS_1_2_IB_081420 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_081420_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_081420_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
function varargout = analysis_1_2_IB_081420(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_081420_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_081420_OutputFcn, ...
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
% varargin   command line arguments to analysis_1_2_IB_081420 (see VARARGIN)
%
function analysis_1_2_IB_081420_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for analysis_1_2_IB_081420
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set initial program state
update_ui_access(handles, ROIFileType.None);


%% ----------------------------------------------------------------------------------------------------------------
% Output Method
%
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
function varargout = analysis_1_2_IB_081420_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure

varargout{1} = handles.output;


    
    
%% App State Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'script_version' Method
%
function [str] = script_version()
str = 'analysis_1_2_IB_081420';


%% ----------------------------------------------------------------------------------------------------------------
% 'logdlg' Method
%
function logdlg(lastErr)
% Try making/adding to log
try
    version = script_version();
    scriptFilePath = which(version);
    [path, ~, ~] = fileparts(scriptFilePath);
    logFile = [version, '_LOG.txt'];
    filepath = fullfile(path, logFile);

    errordlg(['An error occured. See log at ', filepath]);
    log_error(lastErr, filepath);
catch
    errordlg('Could not log error. See console for details');
    error(getReport(lastErr));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'set_open_files' Method
%
function set_open_files(handles, openFileObj)
setappdata(handles.('mainFig'), 'OPEN_FILE_OBJ', openFileObj);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_open_files' Method
%
function [openFileObj] = get_open_files(handles)
openFileObj = getappdata(handles.('mainFig'), 'OPEN_FILE_OBJ');


%% ----------------------------------------------------------------------------------------------------------------
% 'set_roi_data' Method
%
function set_roi_data(handles, newROIData)
setappdata(handles.('mainFig'), 'ROI_DATA', newROIData);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_roi_data' Method
%
function [roiData] = get_roi_data(handles)
roiData = getappdata(handles.('mainFig'), 'ROI_DATA');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_data_selection' Method
%
function update_data_selection(handles, newSelection)
setappdata(handles.('mainFig'), 'DATA_SELECTION', newSelection);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_data_selection' Method
%
function [selection] = get_data_selection(handles)
selection = getappdata(handles.('mainFig'), 'DATA_SELECTION');




%% GUI Utiltity Methods -------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'set_ui_access' Method
%
function set_ui_access(handle, enabled, childrenEnabled, ignoreParent)
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


%% ----------------------------------------------------------------------------------------------------------------
% 'ui_is_enabled' Method
%
function [tf] = ui_is_enabled(handle)
try
    enableState = get(handle, 'Enable');
    tf = strcmp(enableState, 'on');
catch
    tf = false;
end


%% ----------------------------------------------------------------------------------------------------------------
% 'toggle_menu' Method
%
function toggle_menu(handle)
if menu_is_toggled(handle)
    set(handle, 'Checked', 'off');
else
    set(handle, 'Checked', 'on');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menu_is_toggled' Method
%
function [tf] = menu_is_toggled(handle)
enableState = get(handle, 'Checked');
tf = strcmp(enableState, 'on');


%% ----------------------------------------------------------------------------------------------------------------
% 'toggle_button' Method
%
function toggle_button(handle)
btnState = button_is_toggled(handle);
set(handle, 'Value', ~btnState);


%% ----------------------------------------------------------------------------------------------------------------
% 'button_is_toggled' Method
%
function [tf] = button_is_toggled(handle)
tf = get(handle, 'Value');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_ui_access' Method
%
function update_ui_access(handles, fileType)
% Enable everything
set_ui_access(handles.('panelInfo'), true, true, true);     % Info panel
set_ui_access(handles.('dataTable'), true, true, false);    % Data table
set_ui_access(handles.('menuFile'), true, true, false);     % File -> *
set_ui_access(handles.('menuData'), true, true, false);     % Data -> *
set_ui_access(handles.('menuRow'), true, true, false);      % Data -> Row -> *
set_ui_access(handles.('menuToggle'), true, true, false);   % Data -> Toggle -> *
set_ui_access(handles.('menuPlot'), true, true, false);     % Plot -> *
set_ui_access(handles.('menuTools'), true, true, false);    % Tools -> *

switch fileType        
    case ROIFileType.Averaged
        % Disable info inputs
        set_ui_access(handles.('panelInfo'), true, false, true);
        set_ui_access(handles.('btnToggleNormVals'), true, true, false);
        set_ui_access(handles.('btnEnableROI'), true, true, false);
        % And data editting
        set_ui_access(handles.('menuFix'), false, false, false);
        set_ui_access(handles.('menuRow'), false, false, false);
        % And average plotting
        set_ui_access(handles.('menuPlotAvg'), false, false, false);
    case ROIFileType.Prepared
        % Permanently toggle adjusted time
        if ~time_is_adjusted(handles)
            toggle_button(handles.('btnToggleAdjustedTime'));
        end
        set_ui_access(handles.('btnToggleAdjustedTime'), false, false, false);
    case ROIFileType.None    
        % Toggle controls off if neccessary
        if time_is_adjusted(handles)
            toggle_button(handles.('btnToggleAdjustedTime'));
        end
        if values_are_normalized(handles)
            toggle_button(handles.('btnToggleNormVals'));
            toggle_button(handles.('menuToggleNormVals'));
        end
        
        
        % Disable everything 
        set_ui_access(handles.('panelInfo'), false, false, true);   % Info panel
        set_ui_access(handles.('dataTable'), false, false, false);  % Data table
        set_ui_access(handles.('menuData'), false, false, false);   % Data -> *
        set_ui_access(handles.('menuPlot'), false, false, false);   % Plot -> *
        % Except file open
        set_ui_access(handles.('menuFile'), true, true, false);
        set_ui_access(handles.('menuSave'), false, false, false);
        set_ui_access(handles.('menuClose'), false, false, false);
        % And tools
        set_ui_access(handles.('menuTools'), true, true, false);
end

%% ----------------------------------------------------------------------------------------------------------------
% 'update_win_title' Method
%
function update_win_title(handles)
% Get program state
openFile = get_open_files(handles);

title = script_version();
if ~isempty(openFile)
    srcFiles = openFile.source_files();
    [~, firstFile, ext] = fileparts(srcFiles{1});
    title = [title, ' - ', firstFile, ext];
end

set(handles.('mainFig'), 'Name', title);





%% ----------------------------------------------------------------------------------------------------------------
% 'time_is_adjusted' Method
%
function [tf] = time_is_adjusted(handles)
tf = get(handles.('btnToggleAdjustedTime'), 'Value');


%% ----------------------------------------------------------------------------------------------------------------
% 'time_is_adjusted' Method
%
function [tf] = values_are_normalized(handles)
tf = get(handles.('btnToggleNormVals'), 'Value');


%% ----------------------------------------------------------------------------------------------------------------
% 'get_enabled_rois' Method
%
function [tf] = get_enabled_rois(handles)
[roiData] = get_roi_data(handles);
roiCount = roiData.roi_count();

tf = false(1, roiCount);
for i = 1:roiCount
    tagStr = ['menuToggleROI', num2str(i)];
    tf(i) = menu_is_toggled(handles.(tagStr));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'update_data_table' Method
%
function update_data_table(handles)
% Get new program state
newTableData = get_roi_data(handles);

% Just clear table if necessary
if isempty(newTableData)
    set(handles.('dataTable'), 'Data', []);
    set(handles.('dataTable'), 'ColumnName', {});
    return;
end

% Adjust time if necessary
if time_is_adjusted(handles)
    solutions = get_solution_info(handles);
    numBasePts = ROIUtils.number_of_baseline_pts(solutions);
    time = newTableData.adjusted_time(numBasePts);
else
    time = newTableData.time();
end

% Get values and normalize if necessary
if values_are_normalized(handles)
    solutions = get_solution_info(handles);
    numBasePts = ROIUtils.number_of_baseline_pts(solutions);
    lifetime = newTableData.normalized_lifetime(numBasePts);
    int = newTableData.normalized_green(numBasePts);
    red = newTableData.normalized_red(numBasePts);
else
    lifetime = newTableData.lifetime();
    int = newTableData.green();
    red = newTableData.red();
end

% Enable/Disable ROIs if necessary
enabledROIs = get_enabled_rois(handles);
lifetime = ROIUtils.enable(lifetime, enabledROIs);
int = ROIUtils.enable(int, enabledROIs);
red = ROIUtils.enable(red, enabledROIs);

set(handles.('dataTable'), 'Data', [time, lifetime, int, red]);
set(handles.('dataTable'), 'ColumnName', newTableData.roi_labels());


%% ----------------------------------------------------------------------------------------------------------------
% 'update_dna_type' Method
%
function update_dna_type(handles, newDNAType)
set(handles.('inputDNAType'), 'String', newDNAType);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_dna_type' Method
%
function [dnaType] = get_dna_type(handles)
dnaType = get(handles.('inputDNAType'), 'String');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_solution_info' Method
%
function update_solution_info(handles, newSolutionInfo)
set(handles.('solutionTable'), 'Data', newSolutionInfo);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_solution_info' Method
%
function [solutions] = get_solution_info(handles)
solutions = get(handles.('solutionTable'), 'Data');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_toggle_menu' Method
%
function [newHandles] = update_toggle_menu(handles, newROICount)
newHandles = handles;
MENU_DATA_ID = double('toggleROI');

currentMenuItems = findall(handles.('menuToggleROI'), 'UserData', MENU_DATA_ID);
delete(currentMenuItems);

for i = 1:newROICount
    tagStr = ['menuToggleROI', num2str(i)];
    hMenu = uimenu(handles.('menuToggleROI'), ...
                   'Text', ['ROI #', num2str(i)], ...
                   'Checked', 'on', ...
                   'Tag', tagStr, ...
                   'UserData', MENU_DATA_ID, ...
                   'Callback', {@toggleROI_Callback, handles});
    newHandles.(tagStr) = hMenu;
end
guidata(handles.('mainFig'), newHandles);


    
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
        warndlg('Please select files of the same type');
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
    set_open_files(handles, openFile);
    set_roi_data(handles, roiData);
    
    % Update UI
    update_win_title(handles);
    update_ui_access(handles, openFile.type());
    handles = update_toggle_menu(handles, openFile.roi_count());
    update_dna_type(handles, dnaType);
    update_solution_info(handles, solutionInfo);
    
    % Disable info-dependent controls if necessary
    if ~openFile.has_exp_info()
        if time_is_adjusted(handles)
            toggle_button(handles.('btnToggleAdjustedTime'));
        end
        if values_are_normalized(handles)
            toggle_button(handles.('btnToggleNormVals'));
            toggle_menu(handles.('menuToggleNormVals'));
        end
        if menu_is_toggled(handles.('menuShowAnnots'))
            toggle_menu(handles.('menuShowAnnots'));
        end
    end
    
    % Update data table
    update_data_table(handles);         % <-- Updated last because of controls modifying disp
    
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuSave' Callback
%
function menuSave_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    openFile = get_open_files(handles);
    saveData = get_roi_data(handles);
    dnaType = get_dna_type(handles);
    solutions = get_solution_info(handles);
    enabledROIs = get_enabled_rois(handles);

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
                saveData = saveData.set_lifetime(ROIUtils.enable(saveData.lifetime(), enabledROIs));
                saveData = saveData.set_green(ROIUtils.enable(saveData.green(), enabledROIs));
                saveData = saveData.set_red(ROIUtils.enable(saveData.red(), enabledROIs));
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
            AveragedFile.save(savepath, saveData, dnaType, solutions);
        otherwise
            warndlg('Cannot save the file under this type');
    end
catch err
    logdlg(err);
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
        set_open_files(handles, []);
        set_roi_data(handles, []);
        
        % Update UI
        update_data_table(handles);
        update_dna_type(handles, []);
        update_solution_info(handles, {});
        update_ui_access(handles, ROIFileType.None);
        update_win_title(handles);
    end
catch err
    logdlg(err);
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
    update_data_selection(handles, eventdata.Indices);
catch err
    logdlg(err);
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
    update_data_table(roiData);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuFix' Callback
%
function menuFix_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    enabledROIs = get_enabled_rois(handles);
    
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
                    toggle_menu(hMenu);
                end
            end
        end
    end
    
    
    % Update program state
    set_roi_data(handles, roiData);
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleAdjustedTime' Callback
%
function btnToggleAdjustedTime_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    solutions = get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        toggle_button(hObject);
        return;
    end

    % Update the data table
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleNormVals' Callback
%
function btnToggleNormVals_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    solutions = get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        toggle_button(hObject);
        return;
    end

    % Update the corresponding menu item
    toggle_menu(handles.('menuToggleNormVals'));

    % Update the data table
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuToggleNormVals' Callback
%
function menuToggleNormVals_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    solutions = get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        toggle_button(hObject);
        return;
    end

    % Update the corresponding button item
    toggle_button(handles.('btnToggleNormVals'));

    % Update the data table
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'toggleROI' Callback
%
function toggleROI_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    toggle_menu(hObject);
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableAllROI' Callback
%
function menuEnableAllROI_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    
    % Enable any disabled ROIs
    for i = 1:roiData.roi_count()
        tagStr = ['menuToggleROI', num2str(i)];
        hMenu = handles.(tagStr);
        
        if ~menu_is_toggled(hMenu)
            toggle_menu(hMenu);
        end
    end
    
    % Update Table
    update_data_table(handles);
    
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableSelectedROI' Callback
%
function menuEnableSelectedROI_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    openFile = get_open_files(handles);
    roiData = get_roi_data(handles);
    roiCount = roiData.roi_count();
    selection = get_data_selection(handles);

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
        needsToggle = (enabledROIs(i) && ~menu_is_toggled(hMenu)) || (~enabledROIs(i) && menu_is_toggled(hMenu));

        if needsToggle
            toggle_menu(hMenu);
        end
    end
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnEnableROI' Callback
%
function btnEnableROI_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    menuEnableSelectedROI_Callback(handles.('menuEnableSelectedROI'), [], handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowAbove' Callback
%
function menuAddRowAbove_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    tableSelection = get_data_selection(handles);

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
    set_roi_data(handles, roiData);
    
    % Update table
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowBelow' Callback
%
function menuAddRowBelow_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    tableSelection = get_data_selection(handles);

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
    set_roi_data(handles, roiData);
    
    % Update table
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuZeroRow' Callback
%
function menuZeroRow_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    tableSelection = get_data_selection(handles);

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
    set_roi_data(handles, roiData);
    
    % Update table
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuDeleteRow' Callback 
%
function menuDeleteRow_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    tableSelection = get_data_selection(handles);

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

    set_roi_data(handles, roiData);
    
    % Update table
    update_data_table(handles);
catch err
    logdlg(err);
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
    openFile = get_open_files(handles);
    roiData = get_roi_data(handles);
    roiCount = roiData.roi_count();
    
    % Check if at least one plot is enabled
    isLifetimePlot = menu_is_toggled(handles.('menuShowLifetime'));
    isIntPlot = menu_is_toggled(handles.('menuShowGreen'));
    isRedPlot = menu_is_toggled(handles.('menuShowRed'));
    if ~(isLifetimePlot || isIntPlot || isRedPlot)
        warndlg('Please enable at least one of the plotting options');
        return;
    end
    
    % Get appropriate ROIs
    if values_are_normalized(handles)
        solutions = get_solution_info(handles);
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
        toggle_menu(handles.('menuShowLifetime'));
        return;
    end
    if isIntPlot && ~ROIUtils.data_exists(int)
        warndlg('There is no green intensity data to plot');
        toggle_menu(handles.('menuShowGreen'));
        return;
    end
    if isRedPlot && ~ROIUtils.data_exists(red)
        warndlg('There is no red intensity data to plot');
        toggle_menu(handles.('menuShowRed'));
        return;
    end
    
    % Get appropriate time values
    if time_is_adjusted(handles)
        solutions = get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        time = roiData.adjusted_time(nBaselinePts); 
    else
        time = roiData.time(); 
    end
    
    % Get which ROIs are enabled
    enabledROIs = get_enabled_rois(handles);
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
            allDNA = ROIUtils.split_dna_type(get_dna_type(handles));
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
        ylabel('Lifetime');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
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
        ylabel('Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
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
        ylabel('Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
            solutionInfo = ROIUtils.split_solution_info(allSolutions);
            ROIUtils.plot_annotations(gca, time, solutionInfo);
        end
        
        ROIUtils.set_x_limits(time);
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotSelected' Callback
%
function menuPlotSelected_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    openFile = get_open_files(handles);
    roiData = get_roi_data(handles);
    
    % Check if a selection was made
    selection = get_data_selection(handles);
    if isempty(selection)
        warndlg('Please select a column or cell');
        return;
    end
    
    % Check if at least one plot is enabled
    isLifetimePlot = menu_is_toggled(handles.('menuShowLifetime'));
    isIntPlot = menu_is_toggled(handles.('menuShowGreen'));
    isRedPlot = menu_is_toggled(handles.('menuShowRed'));
    if ~(isLifetimePlot || isIntPlot || isRedPlot)
        warndlg('Please enable at least one of the plotting options');
        return;
    end
    
    % Get which ROIs are selected and enabled
    enabledROIs = get_enabled_rois(handles);
    selectedROIs = roiData.select_rois(selection) & enabledROIs;
    selectedIndices = find(selectedROIs);
    
    % Check that a valid selection was made
    if ~any(selectedROIs)
        warndlg('Make sure all selected ROIs are enabled and that non-time values were selected');
        return;
    end
    
    % Get appropriate selected ROI values
    if values_are_normalized(handles)
        solutions = get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        
        lifetime = roiData.normalized_lifetime(nBaselinePts);
        int = roiData.normalized_green(nBaselinePts);
        red = roiData.normalized_red(nBaselinePts);
    else
        lifetime = roiData.lifetime();
        int = roiData.green();
        red = roiData.red();
    end
    
    % Get appropriate time values
    if time_is_adjusted(handles)
        solutions = get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        time = roiData.adjusted_time(nBaselinePts); 
    else
        time = roiData.time(); 
    end
    
    
    % Generate legend
    switch openFile.type()
        case ROIFileType.Averaged
            % Get the dna type and roi count of each source file
            allDNA = ROIUtils.split_dna_type(get_dna_type(handles));
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
                averages = lifetime(:, 2*selectedIndices - 1);
                errors = lifetime(:, 2*selectedIndices);
                
                ROIUtils.plot_averages(time, averages, errors);
            otherwise
                values = lifetime(:, selectedIndices);
                ROIUtils.plot_values(time, values);
                
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Lifetime');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
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
                averages = int(:, 2*selectedIndices - 1);
                errors = int(:, 2*selectedIndices);
                
                ROIUtils.plot_averages(time, averages, errors);
            otherwise
                values = int(:, selectedIndices);
                ROIUtils.plot_values(time, values);
                
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
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
                averages = red(:, 2*selectedIndices - 1);
                errors = red(:, 2*selectedIndices);
                
                ROIUtils.plot_averages(time, averages, errors);
            otherwise
                values = red(:, selectedIndices);
                ROIUtils.plot_values(time, values);
                
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
            solutionInfo = ROIUtils.split_solution_info(allSolutions);
            ROIUtils.plot_annotations(gca, time, solutionInfo);
        end
        
        ROIUtils.set_x_limits(time);
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAvg' Callback
%
function menuPlotAvg_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    openFile = get_open_files(handles);
    roiData = get_roi_data(handles);
    
    % Check if at least one plot is enabled
    isLifetimePlot = menu_is_toggled(handles.('menuShowLifetime'));
    isIntPlot = menu_is_toggled(handles.('menuShowGreen'));
    isRedPlot = menu_is_toggled(handles.('menuShowRed'));
    if ~(isLifetimePlot || isIntPlot || isRedPlot)
        warndlg('Please enable at least one of the plotting options');
        return;
    end
    
    % Get appropriate ROIs
    if values_are_normalized(handles)
        solutions = get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        
        lifetime = roiData.normalized_lifetime(nBaselinePts);
        int = roiData.normalized_green(nBaselinePts);
        red = roiData.normalized_red(nBaselinePts);
    else
        lifetime = roiData.lifetime();
        int = roiData.green();
        red = roiData.red();
    end
    
    % Get appropriate time values
    if time_is_adjusted(handles)
        solutions = get_solution_info(handles);
        nBaselinePts = ROIUtils.number_of_baseline_pts(solutions);
        time = roiData.adjusted_time(nBaselinePts); 
    else
        time = roiData.time(); 
    end
    
    % Check if at least one ROI is enabled
    enabledROIs = get_enabled_rois(handles);    
    if ~any(enabledROIs)
        warndlg('Please enable at least one ROI');
        return;
    end
    
    % Generate legend
    allDNA = ROIUtils.split_dna_type(get_dna_type(handles));
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
        ylabel('Lifetime');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
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
        ylabel('Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
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
        ylabel('Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        % Plot annotations if necessary
        if menu_is_toggled(handles.('menuShowAnnots'))
            allSolutions = get_solution_info(handles);
            solutionInfo = ROIUtils.split_solution_info(allSolutions);
            ROIUtils.plot_annotations(gca, time, solutionInfo);
        end
        
        ROIUtils.set_x_limits(time);
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowAnnots' Callback
%
function menuShowAnnots_Callback(hObject, ~, ~)
try
    % Get current program state
    handles = guidata(hObject);
    dnaType = get_dna_type(handles);
    solutions = get_solution_info(handles);
    
    % Check if we have enough info for annotations
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with unique timings before enabling annotations');
        return;
    elseif isempty(dnaType)
        warndlg('Please enter the DNA type before enabling annotations');
        return;
    else
        toggle_menu(hObject);
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowLifetime' Callback
%
function menuShowLifetime_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    
    % Check if there are lifetime values to plot
    if ROIUtils.data_exists(roiData.lifetime())
        toggle_menu(hObject);
    else
        warndlg('This file has no lifetime intensity data to plot');
        return;
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowGreen' Callback 
%
function menuShowGreen_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    
    % Check if there are int values to plot
    if ROIUtils.data_exists(roiData.green())
        toggle_menu(hObject);
    else
        warndlg('This file has no green intensity data to plot');
        return;
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowRed' Callback 
%
function menuShowRed_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    
    % Check if there are red values to plot
    if ROIUtils.data_exists(roiData.red())
        toggle_menu(hObject);
    else
        warndlg('This file has no red intensity data to plot');
        return;
    end
catch err
    logdlg(err);
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
    roiData = get_roi_data(handles);
    pointCount = max(roiData.point_counts());
    currentSolutions = get_solution_info(handles);

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
    update_solution_info(handles, newSolutions);
    
    % Update UI
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnRemoveSolution' Callback
%
function btnRemoveSolution_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    solutions = get_solution_info(handles);
    
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
    update_solution_info(handles, solutions);
    
    % Update UI
    update_data_table(handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'solutionTable' Cell Edit Callback
%
function solutionTable_CellEditCallback(hObject, eventdata, ~)
try
    % Get current program state
    handles = guidata(hObject);
    roiData = get_roi_data(handles);
    pointCount = max(roiData.point_counts());
    solutions = get_solution_info(handles);

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
    update_solution_info(handles, solutions);

    % Check if # of baseline pts is available
    if ~ROIUtils.has_number_of_baseline_pts(solutions)
        % Toggle off adj. time and norm. values if necessary
        if time_is_adjusted(handles)
            toggle_button(handles.('btnToggleAdjustedTime'));
        end
        if values_are_normalized(handles)
            toggle_button(handles.('btnToggleNormVals'));
            toggle_menu(handles.('menuToggleNormVals'));
        end
    end

    % Update table
    update_data_table(handles);
catch err
    logdlg(err);
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
            [notes, newDNAType, newSolutions] = info_of_word_file(filePath);
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
        update_dna_type(handles, newDNAType);
    end
    if ~isempty(newSolutions)
        update_solution_info(handles, newSolutions);
    end
catch err
    logdlg(err);
end




%% Tools Menu Methods ---------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

function menuSPC_Callback(~, ~, ~)
spc_drawInit;
function menuImstack_Callback(~, ~, ~)
h_imstack;
function menuStatsIB_Callback(~, ~, ~)
stats_IB_061020
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
