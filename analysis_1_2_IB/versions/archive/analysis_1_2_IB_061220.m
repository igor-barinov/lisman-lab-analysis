%% GUIDE Methods --------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% Entry Point - DO NOT EDIT
%
%      ANALYSIS_1_2_IB_061220, by itself, creates a new ANALYSIS_1_2_IB_061220 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_061220 returns the handle to a new ANALYSIS_1_2_IB_061220 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_061220('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_061220.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_061220('Property','Value',...) creates a new ANALYSIS_1_2_IB_061220 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_061220_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_061220_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
function varargout = analysis_1_2_IB_061220(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_061220_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_061220_OutputFcn, ...
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
% varargin   command line arguments to analysis_1_2_IB_061220 (see VARARGIN)
%
function analysis_1_2_IB_061220_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for analysis_1_2_IB_061220
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
function varargout = analysis_1_2_IB_061220_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure

varargout{1} = handles.output;


    
    
%% App State Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'logdlg' Method
%
function logdlg(error)
scriptFilePath = which('analysis_1_2_IB_061220');
[path, ~, ~] = fileparts(scriptFilePath);
logFile = 'analysis_1_2_IB_061220_LOG.txt';
filepath = fullfile(path, logFile);

errordlg(['An error occured. See log at ', filepath]);
log_error(error, filepath);


%% ----------------------------------------------------------------------------------------------------------------
% 'update_source_files' Method
%
function update_source_files(handles, newSourceFiles, newFileType)
setappdata(handles.mainFig, 'SRC_FILES', newSourceFiles);
setappdata(handles.mainFig, 'FILE_TYPE', newFileType);


%% ----------------------------------------------------------------------------------------------------------------
% 'update_adjusted_data' Method
%
function update_adjusted_data(handles, newAdjData)
setappdata(handles.mainFig, 'ADJ_DATA', newAdjData);


%% ----------------------------------------------------------------------------------------------------------------
% 'update_data_selection' Method
%
function update_data_selection(handles, newSelection)
setappdata(handles.mainFig, 'DATA_SELECTION', newSelection);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_source_files' Method
%
function [srcFiles, fileType] = get_source_files(handles)
srcFiles = getappdata(handles.mainFig, 'SRC_FILES');
fileType = getappdata(handles.mainFig, 'FILE_TYPE');


%% ----------------------------------------------------------------------------------------------------------------
% 'get_adjusted_data' Method
%
function [adjData] = get_adjusted_data(handles)
adjData = getappdata(handles.mainFig, 'ADJ_DATA');


%% ----------------------------------------------------------------------------------------------------------------
% 'get_data_selection' Method
%
function [selection] = get_data_selection(handles)
selection = getappdata(handles.mainFig, 'DATA_SELECTION');




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
set_ui_access(handles.panelInfo, true, true, true);     % Info panel
set_ui_access(handles.dataTable, true, true, false);    % Data table
set_ui_access(handles.menuFile, true, true, false);     % File -> *
set_ui_access(handles.menuData, true, true, false);     % Data -> *
set_ui_access(handles.menuRow, true, true, false);      % Data -> Row -> *
set_ui_access(handles.menuToggle, true, true, false);   % Data -> Toggle -> *
set_ui_access(handles.menuPlot, true, true, false);     % Plot -> *
set_ui_access(handles.menuTools, true, true, false);    % Tools -> *

switch fileType        
    case ROIFileType.Averaged
        % Disable info inputs
        set_ui_access(handles.panelInfo, true, false, true);
        set_ui_access(handles.btnToggleNormVals, true, true, false);
        set_ui_access(handles.btnEnableROI, true, true, false);
        % And data editting
        set_ui_access(handles.menuFix, false, false, false);
        set_ui_access(handles.menuRow, false, false, false);
        % And average plotting
        set_ui_access(handles.menuPlotAvg, false, false, false);
    case ROIFileType.Prepared
        % Permanently toggle adjusted time
        if ~time_is_adjusted(handles)
            toggle_button(handles.btnToggleAdjustedTime);
        end
        set_ui_access(handles.btnToggleAdjustedTime, false, false, false);
    case ROIFileType.None
        % Disable everything 
        set_ui_access(handles.panelInfo, false, false, true);   % Info panel
        set_ui_access(handles.dataTable, false, false, false);  % Data table
        set_ui_access(handles.menuData, false, false, false);   % Data -> *
        set_ui_access(handles.menuPlot, false, false, false);   % Plot -> *
        % Except file open
        set_ui_access(handles.menuFile, true, true, false);
        set_ui_access(handles.menuSave, false, false, false);
        set_ui_access(handles.menuClose, false, false, false);
        % And tools
        set_ui_access(handles.menuTools, true, true, false);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'time_is_adjusted' Method
%
function [tf] = time_is_adjusted(handles)
tf = get(handles.btnToggleAdjustedTime, 'Value');


%% ----------------------------------------------------------------------------------------------------------------
% 'time_is_adjusted' Method
%
function [tf] = values_are_normalized(handles)
tf = get(handles.btnToggleNormVals, 'Value');


%% ----------------------------------------------------------------------------------------------------------------
% 'time_is_adjusted' Method
%
function [tf] = roi_is_enabled(handles, roi)
tagStr = ['menuToggleROI', num2str(roi)];
hMenu = handles.(tagStr);
tf = menu_is_toggled(hMenu);


%% ----------------------------------------------------------------------------------------------------------------
% 'update_data_table' Method
%
function update_data_table(handles, newData, newLabels)
% Get current program state
[srcFiles, fileType] = get_source_files(handles);
currentData = get_adjusted_data(handles);

% Determine what needs to be updated
if nargin == 3
    lblsAreNew = true;
    dataIsNew = true;
elseif nargin == 2
    lblsAreNew = false;
    dataIsNew = true;
else
    lblsAreNew = false;
    dataIsNew = false;
end

% Determine which data to use
if dataIsNew
    tableData = newData;
else
    tableData = currentData;
end
if lblsAreNew
    tableLabels = newLabels;    
else
    tableLabels = get(handles.dataTable, 'ColumnName');
end

% Adjust time if necessary
if time_is_adjusted(handles)
    solutions = get_solution_info(handles);
    numBasePts = get_number_of_baseline_pts(solutions);
    
    switch fileType
        case ROIFileType.Prepared
            currentTime = tableData(:, 1);
            tableData(:, 1) = currentTime - currentTime(numBasePts);
        otherwise
            tableData(:, 1) = adjust_time_values(tableData(:, 1), numBasePts);
    end
end

% Normalize values if necessary
if values_are_normalized(handles)
    solutions = get_solution_info(handles);
    numBasePts = get_number_of_baseline_pts(solutions);
    switch fileType
        case ROIFileType.Averaged
            [tableData, tableLabels] = table_from_averaged_roi_files(srcFiles, true);
        otherwise
            tableData(:, 2:end) = normalize_roi_values(tableData(:, 2:end), numBasePts);
    end
    
end

% Enable/Disable ROIs
roiCount = get_roi_count(tableData, fileType);
tauVals = get_tau_values(tableData, fileType);
intVals = get_intensity_values(tableData, fileType);
redVals = get_red_values(tableData, fileType);
for i = 1:roiCount
    menuTag = ['menuToggleROI', num2str(i)];
    hMenu = handles.(menuTag);
    
    if ~menu_is_toggled(hMenu)
        switch fileType
            case ROIFileType.Averaged
                disabledIndices = 2*i - 1 : 2*i;
            otherwise
                disabledIndices = i;
        end
        tauVals(:, disabledIndices) = disable_roi_values(tauVals(:, disabledIndices));
        intVals(:, disabledIndices) = disable_roi_values(intVals(:, disabledIndices));
        redVals(:, disabledIndices) = disable_roi_values(redVals(:, disabledIndices));
    end
end

tableData = [tableData(:, 1), tauVals, intVals, redVals];

set(handles.dataTable, 'Data', tableData);
set(handles.dataTable, 'ColumnName', tableLabels);


%% ----------------------------------------------------------------------------------------------------------------
% 'update_dna_type' Method
%
function update_dna_type(handles, newDNAType)
set(handles.inputDNAType, 'String', newDNAType);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_dna_type' Method
%
function [dnaType] = get_dna_type(handles)
dnaType = get(handles.inputDNAType, 'String');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_solution_info' Method
%
function update_solution_info(handles, newSolutionInfo)
set(handles.solutionTable, 'Data', newSolutionInfo);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_solution_info' Method
%
function [solutions] = get_solution_info(handles)
solutions = get(handles.solutionTable, 'Data');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_toggle_menu' Method
%
function [newHandles] = update_toggle_menu(handles, newROICount)
newHandles = handles;
MENU_DATA_ID = double('toggleROI');

currentMenuItems = findall(handles.menuToggleROI, 'UserData', MENU_DATA_ID);
delete(currentMenuItems);

for i = 1:newROICount
    tagStr = ['menuToggleROI', num2str(i)];
    hMenu = uimenu(handles.menuToggleROI, ...
                   'Text', ['ROI #', num2str(i)], ...
                   'Checked', 'on', ...
                   'Tag', tagStr, ...
                   'UserData', MENU_DATA_ID, ...
                   'Callback', {@toggleROI_Callback, handles});
    newHandles.(tagStr) = hMenu;
end
guidata(handles.mainFig, newHandles);


    
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
    [file, path] = uigetfile('*.mat', 'Multiselect', 'on');
    if isequal(file, 0) || isequal(path, 0)
        return;
    end
    filepaths = fullfile(path, file);
    if ~iscell(filepaths)
        filepaths = { filepaths };
    end

    % Get file types and make sure they are the same
    allFileTypes = get_roi_file_type(filepaths);
    for i = 1:numel(allFileTypes)-1
        if allFileTypes{i} ~= allFileTypes{i+1}
            warndlg('Please select files of the same type (raw, prepared, or averaged)');
            return;
        end
    end
    fileType = allFileTypes{1};

    % Get data depending on the file type
    if fileType == ROIFileType.Raw
        % Raw files only have ROI data
        hasInfo = false;
        [tableData, tableLabels] = table_from_raw_roi_files(filepaths);

    elseif fileType == ROIFileType.Prepared
        % Prepared files have raw data as well, need user to choose
        dataChoice = questdlg('This file has raw and prepared ROI data. Which would you like to load?', ...
                          'Select ROI Data', ...
                          'Raw', 'Prepared', 'Cancel', ...
                          'Cancel');
        switch dataChoice
            case 'Raw'
                % Load only ROI data
                hasInfo = false;
                [tableData, tableLabels] = table_from_raw_roi_files(filepaths);
                fileType = ROIFileType.Raw;

            case 'Prepared'
                % Load ROI data and experiment info
                hasInfo = true;
                [dnaTypes] = dna_types_of_prepared_files(filepaths);
                
                % Check if DNA types are the same
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
                    
                    filepaths = filepaths(optionIdx);
                    [dnaTypes] = dna_types_of_prepared_files(filepaths);
                end
                dnaTypes = unique(dnaTypes);
                
                [tableData, tableLabels] = table_from_prepared_roi_files(filepaths);
                [solutionInfo] = solution_info_of_prepared_files(filepaths);
            otherwise
                return;
        end

    elseif fileType == ROIFileType.Averaged
        % Averaged files have both ROI data and experiment info
        hasInfo = true;
        [tableData, tableLabels] = table_from_averaged_roi_files(filepaths, false);
        [dnaTypes] = dna_types_of_averaged_files(filepaths);
        [solutionInfo] = solution_info_of_averaged_files(filepaths);

    elseif fileType == ROIFileType.None
        % The file is not supported
        warndlg('The files selected are not supported');
        return;

    else
        % There was an error if we got here
        errordlg('There was an error determining the file type');
        return;
    end

    % Validate and combine experiment info
    if hasInfo
        dnaType = merge_dna_types(dnaTypes);
        solutions = merge_solution_info(solutionInfo);
        
        if ~has_number_of_baseline_pts(solutions)
            warndlg('This file was saved with invalid experiment information. Fix this information before opening');
            return;
        end
    end


    % Update program state
    update_source_files(handles, filepaths, fileType);
    update_adjusted_data(handles, tableData);

    % Update UI
    update_ui_access(handles, fileType);
    newROICount = get_roi_count(tableData, fileType);
    handles = update_toggle_menu(handles, newROICount);
    
    if hasInfo
        update_dna_type(handles, dnaType);
        update_solution_info(handles, solutions);
    else
        update_dna_type(handles, '');
        update_solution_info(handles, {});
        
        % Disabled modifiers if no info is available
        if time_is_adjusted(handles)
            toggle_button(handles.btnToggleAdjustedTime);
        end
        if values_are_normalized(handles)
            toggle_button(handles.btnToggleNormVals);
            toggle_menu(handles.menuToggleNormVals);
        end
    end
    
    update_data_table(handles, tableData, tableLabels);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuSave' Callback
%
function menuSave_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    [srcFiles, fileType] = get_source_files(handles);
    adjData = get_adjusted_data(handles);
    roiCount = get_roi_count(adjData, fileType);
    dnaType = get_dna_type(handles);
    solutions = get_solution_info(handles);

    % Check if we have all data
    if isempty(dnaType)
        warndlg('Please enter a DNA Type before saving');
        return;
    end
    if ~has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings before saving');
        return;
    end
    
    % Check which ROIs are disabled
    disabledROIs = false(1, roiCount);
    for i = 1:roiCount
        disabledROIs(i) = ~roi_is_enabled(handles, i);
    end
    
    % Let user choose to not save disabled ROIs
    if any(disabledROIs)
        choice = questdlg('Some of the ROIs have been disabled. Would you like to save these ROIs?', ...
                          'Save Disabled ROIs', ...
                          'Yes', 'No', 'Cancel', ...
                          'Cancel');
        switch choice
            case 'No'
                disabledCols = find(disabledROIs) + 1;
                disabledCols = [disabledCols, disabledCols + roiCount, disabledCols + 2*roiCount];
                adjData(:, disabledCols) = [];
            case 'Cancel'
                return;
        end
    end

    % Let the user select the filepath and file type
    fileFilter = {'*.mat', 'Prepared ROI Files (*.mat)'; '*.mat', 'Averaged ROI Files (*.mat)'};
    [file, path, typeIdx] = uiputfile(fileFilter);
    if isequal(file, 0) || isequal(path, 0) || isequal(typeIdx, 0)
        return;
    end

    % Save file according to selected type
    switch typeIdx
        case 1
            [rawData] = data_from_raw_roi_files(srcFiles);
            save_prepared_roi_file(rawData, adjData, dnaType, solutions, fullfile(path, file));
        case 2
            save_averaged_roi_file(srcFiles, adjData, dnaType, solutions, fullfile(path, file));
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
        emptyDataTable = [];
        emptyLabels = {};
        emptySolutionTable = {};

        % Update program state
        update_source_files(handles, {}, ROIFileType.None);
        update_adjusted_data(handles, emptyDataTable);
        update_data_table(handles, emptyDataTable, emptyLabels);
        update_dna_type(handles, []);
        update_solution_info(handles, emptySolutionTable);
        update_ui_access(handles, ROIFileType.None);
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
    handles = guidata(hObject);
    
    % Get current program state
    [~, fileType] = get_source_files(handles);
    roiData = get_adjusted_data(handles);
    roiCount = get_roi_count(roiData, fileType);
    pointCount = size(roiData, 1);
    
    % Track what was fixed
    timeWasFixed = true;
    roiWasFixed = true(1, roiCount);
    
    % Find issues in time data: zero or NaNs
    timeData = roiData(:, 1);
    badTimeValues = ismember(timeData, [0, NaN]);
    if any(badTimeValues)
        % Check if issues can be fixed
        goodIndices = find(~badTimeValues);
        if length(goodIndices) < 2
            timeWasFixed = false;
        else
            % time = (t(i') - t(i)) * (idx - i) + t(i)
            startTime = timeData(goodIndices(1));
            timeDiff = (timeData(goodIndices(2)) - timeData(goodIndices(1))) / (goodIndices(2) - goodIndices(1));
            
            badIndices = find(badTimeValues);
            fixedTime = timeDiff * (badIndices - goodIndices(1)) + startTime;
            timeData(badIndices) = fixedTime;
            roiData(:, 1) = timeData;
        end
    end
    
    % Find issues in ROIs: zero or NaNs
    tauData = get_tau_values(roiData, fileType);
    intData = get_intensity_values(roiData, fileType);
    redData = get_red_values(roiData, fileType);
    for i = 1:roiCount
       ROI = [tauData(:, i), intData(:, i), redData(:, i)];
       badROIValues = ismember(ROI, [0, NaN]);
       if any(badROIValues)
           badIndices = find(badROIValues);
           for j = 1:numel(badIndices)
               % Get indices of the current and adjacent rows
               [badRow, badColumn] = ind2sub(size(ROI), badIndices(j));
               if badRow == 1
                   prevIdx = -1;
                   nextIdx = sub2ind(size(ROI), badRow+1, badColumn);
               elseif badRow == pointCount
                   prevIdx = sub2ind(size(ROI), badRow-1, badColumn);
                   nextIdx = -1;
               else
                   prevIdx = sub2ind(size(ROI), badRow-1, badColumn);
                   nextIdx = sub2ind(size(ROI), badRow+1, badColumn);
               end
               
               % Only fix if the adjacent row is good
               prevRowIsGood = ~ismember(prevIdx, badIndices);
               nextRowIsGood = ~ismember(nextIdx, badIndices);
               if badRow == 1 && nextRowIsGood
                   ROI(badRow, badColumn) = ROI(nextIdx);
               elseif badRow == pointCount && prevRowIsGood
                   ROI(badRow, badColumn) = ROI(prevIdx);
               elseif prevRowIsGood && nextRowIsGood
                   ROI(badRow, badColumn) = (ROI(prevIdx) + ROI(nextIdx)) / 2;
               else
                   roiWasFixed(i) = false;
               end
           end
           
           % Update ROI values
           roiIndices = [1+i, 1+roiCount+i, 1+2*roiCount+i];
           roiData(:, roiIndices) = ROI;
       end
    end
    
    if timeWasFixed && all(roiWasFixed)
        msgbox('All values were fixed successfully');
    else
        % Let user decide to disable bad ROIs
        choice = questdlg('There was an issue fixing some ROIs. Would you like to disable those ROIs?', ...
                          'Disable Bad ROIs', ...
                          'Yes', 'No', ...
                          'Yes');
        if strcmp(choice, 'Yes')
            for i = 1:roiCount
                if ~roiWasFixed(i) && roi_is_enabled(handles, i)
                    tagStr = ['menuToggleROI', num2str(i)];
                    hMenu = handles.(tagStr);
                    toggle_menu(hMenu);
                end
            end
        end
    end
    
    
    % Update program state
    update_adjusted_data(handles, roiData);
    update_data_table(handles, roiData);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleAdjustedTime' Callback
%
function btnToggleAdjustedTime_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    solutions = get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~has_number_of_baseline_pts(solutions)
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
    handles = guidata(hObject);
    
    % Get current program state
    solutions = get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        toggle_button(hObject);
        return;
    end

    % Update the corresponding menu item
    toggle_menu(handles.menuToggleNormVals);

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
    handles = guidata(hObject);
    
    % Get current program state
    solutions = get_solution_info(handles);

    % Check if we can get the # of base pts
    if ~has_number_of_baseline_pts(solutions)
        warndlg('Please enter at least 2 solutions with different timings to set the number of baseline points');
        toggle_button(hObject);
        return;
    end

    % Update the corresponding button item
    toggle_button(handles.btnToggleNormVals);

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
    handles = guidata(hObject);
    
    % Get current program state
    [~, fileType] = get_source_files(handles);
    roiData = get_adjusted_data(handles);
    roiCount = get_roi_count(roiData, fileType);
    
    % Enable any disabled ROIs
    for i = 1:roiCount
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
    handles = guidata(hObject);
    
    % Get current program state
    [~, fileType] = get_source_files(handles);
    roiData = get_adjusted_data(handles);
    roiCount = get_roi_count(roiData, fileType);
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
    switch fileType
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
        
        if fileType == ROIFileType.Averaged
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
    
    menuEnableSelectedROI_Callback(handles.menuEnableSelectedROI, [], handles);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowAbove' Callback
%
function menuAddRowAbove_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    roiData = get_adjusted_data(handles);
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

    % Add zeroed-row above selection
    columnCount = size(roiData, 2);
    newRow = zeros(1, columnCount);
    adjData = [roiData(1:rowIdx-1, :); newRow; roiData(rowIdx:end, :)];

    % Update program state
    update_adjusted_data(handles, adjData)
    update_data_table(handles, adjData);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowBelow' Callback
%
function menuAddRowBelow_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    roiData = get_adjusted_data(handles);
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

    % Add zeroed-row below selection
    columnCount = size(roiData, 2);
    newRow = zeros(1, columnCount);
    adjData = [roiData(1:rowIdx, :); newRow; roiData(rowIdx+1:end, :)];

    % Update program state
    update_adjusted_data(handles, adjData)
    update_data_table(handles, adjData);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuZeroRow' Callback
%
function menuZeroRow_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    roiData = get_adjusted_data(handles);
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

    % Zero selected row
    columnCount = size(roiData, 2);
    newRow = zeros(1, columnCount);
    adjData = roiData;
    adjData(rowIdx, :) = newRow;

    % Update program state
    update_adjusted_data(handles, adjData)
    update_data_table(handles, adjData);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuDeleteRow' Callback 
%
function menuDeleteRow_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    roiData = get_adjusted_data(handles);
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

    % Let user choose to keep time values
    choice = questdlg('Would you like to keep the time values?', ...
                      'Delete Row', ...
                      'Yes', 'No', 'Cancel', ...
                      'Cancel');
    switch choice
        case 'Yes'
            % Delete only non-time values
            timeData = roiData(1:end-1, 1);
            adjData = roiData(:, 2:end);
            adjData(rowIdx, :) = [];
            adjData = [timeData, adjData];
        case 'No'
            % Delete entire selected row
            adjData = roiData;
            adjData(rowIdx, :) = [];
        otherwise
            return;
    end

    % Update program state
    update_adjusted_data(handles, adjData)
    update_data_table(handles, adjData);
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
    handles = guidata(hObject);
    
    % Get current program state
    [srcFiles, fileType] = get_source_files(handles);
    roiData = get(handles.dataTable, 'Data');
    roiCount = get_roi_count(roiData, fileType);
    timeData = roiData(:, 1);
    
    % Get which ROIs are enabled
    enabledROIs = false(1, roiCount);
    for i = 1:roiCount
        enabledROIs(i) = roi_is_enabled(handles, i);
    end
    
    % Check if at least one ROI is enabled
    if ~any(enabledROIs)
        warndlg('Please enable at least one ROI');
        return;
    end
    
    % Generate legend
    switch fileType
        case ROIFileType.Averaged
            % Get the dna type and roi count of each source file
            dnaTypes = split_dna_type(get_dna_type(handles));
            srcData = data_from_averaged_roi_file(srcFiles);
            roiCounts = cell(1, numel(srcData));
            for i = 1:numel(srcData)
                roiCounts{i} = srcData(i).numROI;
            end
            
            legendEntries = legend_for_roi_averages(dnaTypes, roiCounts);
        otherwise
            legendEntries = legend_for_roi_values(roiCount);
    end
    
    % Generate title
    switch fileType
        case ROIFileType.Raw
            expNames = exp_names_from_raw_roi_files(srcFiles);
        case ROIFileType.Prepared
            expNames = exp_names_from_prepared_roi_files(srcFiles);
        case ROIFileType.Averaged
            expNames = exp_names_from_averaged_roi_files(srcFiles);
    end
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
    if menu_is_toggled(handles.menuShowLifetime)
        tauData = get_tau_values(roiData, fileType);
        figure('Name', 'Lifetime Over Time');
        
        if fileType == ROIFileType.Averaged
            roiIndices = find(enabledROIs);
            avgData = tauData(:, 2*roiIndices - 1);
            steData = tauData(:, 2*roiIndices);
            plot_roi_averages(timeData, avgData, steData);
        else
            tauData = tauData(:, enabledROIs);
            plot_roi_values(timeData, tauData);
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Lifetime');
        legend(legendEntries);
        legend('boxoff');
        title(titleStr, 'Interpreter', 'none');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
    
    % Plot intensity if necessary
    if menu_is_toggled(handles.menuShowGreen)
        intData = get_intensity_values(roiData, fileType);
        figure('Name', 'Green Intensity Over Time');
        
        if fileType == ROIFileType.Averaged
            roiIndices = find(enabledROIs);
            avgData = intData(:, 2*roiIndices - 1);
            steData = intData(:, 2*roiIndices);
            plot_roi_averages(timeData, avgData, steData);
        else
            intData = intData(:, enabledROIs);
            plot_roi_values(timeData, intData);
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Green Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
    
    % Plot red if necessary
    if menu_is_toggled(handles.menuShowRed)
        redData = get_red_values(roiData, fileType);
        figure('Name', 'Red Intensity Over Time');
        
        if fileType == ROIFileType.Averaged
            roiIndices = find(enabledROIs);
            avgData = redData(:, 2*roiIndices - 1);
            steData = redData(:, 2*roiIndices);
            plot_roi_averages(timeData, avgData, steData);
        else
            redData = redData(:, enabledROIs);
            plot_roi_values(timeData, redData);
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Red Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotSelected' Callback
%
function menuPlotSelected_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    [srcFiles, fileType] = get_source_files(handles);
    roiData = get(handles.dataTable, 'Data');
    roiCount = get_roi_count(roiData, fileType);
    timeData = roiData(:, 1);
    
    % Check if a selection was made
    selection = get_data_selection(handles);
    if isempty(selection)
        warndlg('Please select a column or cell');
        return;
    end
    
    % Check that non-time values were selected
    columns = unique(selection(:, 2));
    columns(columns == 1) = [];
    if isempty(columns)
        warndlg('Please select non-time values');
        return;
    end
    
    
    % Get the data offsets
    switch fileType
        case ROIFileType.Averaged
            tauOffset = 2;
            intOffset = tauOffset + 2*roiCount;
            redOffset = intOffset + 2*roiCount;
        otherwise
            tauOffset = 2;
            intOffset = tauOffset + roiCount;
            redOffset = intOffset + roiCount;
    end
    
    % Get which ROIs are enabled and selected
    selectedROIs = false(1, roiCount);
    for i = 1:numel(columns)
        col = columns(i);
        if col >= redOffset
            roi = col - redOffset + 1;
        elseif col >= intOffset
            roi = col - intOffset + 1;
        elseif col >= tauOffset
            roi = col - tauOffset + 1;
        end
        
        if fileType == ROIFileType.Averaged
            roi = (roi + (1 - mod(col, 2))) / 2;
        end

        selectedROIs(roi) = roi_is_enabled(handles, roi);
    end
    
    % Check if at least one of the selected ROIs is enabled
    if ~any(selectedROIs)
        warndlg('Please enable the selected ROIs');
        return;
    end
    
    % Generate legend
    switch fileType
        case ROIFileType.Averaged
            % Get the dna type and roi count of each source file
            dnaTypes = split_dna_type(get_dna_type(handles));
            srcData = data_from_averaged_roi_file(srcFiles);
            roiCounts = cell(1, numel(srcData));
            for i = 1:numel(srcData)
                roiCounts{i} = srcData(i).numROI;
            end
            
            legendEntries = legend_for_roi_averages(dnaTypes, roiCounts);
        otherwise
            legendEntries = legend_for_roi_values(roiCount);
    end
    
    % Generate title
    switch fileType
        case ROIFileType.Raw
            expNames = exp_names_from_raw_roi_files(srcFiles);
        case ROIFileType.Prepared
            expNames = exp_names_from_prepared_roi_files(srcFiles);
        case ROIFileType.Averaged
            expNames = exp_names_from_averaged_roi_files(srcFiles);
    end
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
    if menu_is_toggled(handles.menuShowLifetime)
        tauData = get_tau_values(roiData, fileType);
        figure('Name', 'Lifetime Over Time');
        
        if fileType == ROIFileType.Averaged
            roiIndices = find(selectedROIs);
            avgData = tauData(:, 2*roiIndices - 1);
            steData = tauData(:, 2*roiIndices);
            plot_roi_averages(timeData, avgData, steData);
        else
            tauData = tauData(:, selectedROIs);
            plot_roi_values(timeData, tauData);
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Lifetime');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
    
    % Plot intensity if necessary
    if menu_is_toggled(handles.menuShowGreen)
        intData = get_intensity_values(roiData, fileType);
        figure('Name', 'Green Intensity Over Time');
        
        if fileType == ROIFileType.Averaged
            roiIndices = find(selectedROIs);
            avgData = intData(:, 2*roiIndices - 1);
            steData = intData(:, 2*roiIndices);
            plot_roi_averages(timeData, avgData, steData);
        else
            intData = intData(:, selectedROIs);
            plot_roi_values(timeData, intData);
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Green Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
    
    % Plot red if necessary
    if menu_is_toggled(handles.menuShowRed)
        redData = get_red_values(roiData, fileType);
        figure('Name', 'Red Intensity Over Time');
        
        if fileType == ROIFileType.Averaged
            roiIndices = find(selectedROIs);
            avgData = redData(:, 2*roiIndices - 1);
            steData = redData(:, 2*roiIndices);
            plot_roi_averages(timeData, avgData, steData);
        else
            redData = redData(:, selectedROIs);
            plot_roi_values(timeData, redData);
        end
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Red Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAvg' Callback
%
function menuPlotAvg_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    [~, fileType] = get_source_files(handles);
    roiData = get(handles.dataTable, 'Data');
    roiCount = get_roi_count(roiData, fileType);
    timeData = roiData(:, 1);
    
    % Get which ROIs are enabled
    enabledROIs = false(1, roiCount);
    for i = 1:roiCount
        enabledROIs(i) = roi_is_enabled(handles, i);
    end
    
    % Check if at least one ROI is enabled
    if ~any(enabledROIs)
        warndlg('Please enable at least one ROI');
        return;
    end
    
    % Generate legend
    dnaType = get_dna_type(handles);
    if isempty(dnaType)
        dnaTypes = {''};
    else
        dnaTypes = { dnaType };
    end
    roiCounts = { roiCount };
    legendEntries = legend_for_roi_averages(dnaTypes, roiCounts);
    
    % Generate title
    switch fileType
        case ROIFileType.Raw
            expNames = exp_names_from_raw_roi_files(srcFiles);
        case ROIFileType.Prepared
            expNames = exp_names_from_prepared_roi_files(srcFiles);
        case ROIFileType.Averaged
            expNames = exp_names_from_averaged_roi_files(srcFiles);
    end
    titleStr = '';
    for i = 1:numel(expNames)
        titleStr = [titleStr, expNames{i}];
        if i < numel(expNames)
            titleStr = [titleStr, ' | '];
        end
    end
    
    % Plot lifetime if necessary
    if menu_is_toggled(handles.menuShowLifetime)
        tauData = get_tau_values(roiData, fileType);
        figure('Name', 'Lifetime Over Time');
        
        tauData = tauData(:, enabledROIs);
        [avgData, steData] = average_roi_values(tauData);
        plot_roi_averages(timeData, avgData, steData);
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Lifetime');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
    
    % Plot intensity if necessary
    if menu_is_toggled(handles.menuShowGreen)
        intData = get_intensity_values(roiData, fileType);
        figure('Name', 'Green Intensity Over Time');
        
        intData = intData(:, enabledROIs);
        [avgData, steData] = average_roi_values(intData);
        plot_roi_averages(timeData, avgData, steData);
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Green Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
    
    % Plot red if necessary
    if menu_is_toggled(handles.menuShowRed)
        redData = get_red_values(roiData, fileType);
        figure('Name', 'Red Intensity Over Time');
        
        redData = redData(:, enabledROIs);
        [avgData, steData] = average_roi_values(redData);
        plot_roi_averages(timeData, avgData, steData);
        
        title(titleStr, 'Interpreter', 'none');
        xlabel('Time');
        ylabel('Red Intensity');
        legend(legendEntries);
        legend('boxoff');
        
        if menu_is_toggled(handles.menuShowAnnots)
            solutions = get_solution_info(handles);
            plot_annotations(gca, timeData, solutions);
        end
    end
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowAnnots' Callback
%
function menuShowAnnots_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    % Get current program state
    dnaType = get_dna_type(handles);
    solutions = get_solution_info(handles);
    
    % Check if we have enough info for annotations
    if size(solutions, 1) < 2
        warndlg('Please enter at least 2 solutions before enabling annotations');
        return;
    elseif isempty(dnaType)
        warndlg('Please enter the DNA type before enabling annotations');
        return;
    end
    
    toggle_menu(hObject);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowLifetime' Callback
%
function menuShowLifetime_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    toggle_menu(hObject);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowGreen' Callback 
%
function menuShowGreen_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    toggle_menu(hObject);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowRed' Callback 
%
function menuShowRed_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    
    toggle_menu(hObject);
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
    handles = guidata(hObject);
    
    % Get the current program state
    roiData = get_adjusted_data(handles);
    pointCount = size(roiData, 1);
    currentSolutions = get_solution_info(handles);

    % Get solution info from user
    addSolPrompt = {'Enter solution name:', 'Enter solution timing (# of points):'};
    dimensions = [1 40];
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
    handles = guidata(hObject);
    
    % Get current program state
    roiData = get_adjusted_data(handles);
    pointCount = size(roiData, 1);
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
    if ~has_number_of_baseline_pts(solutions)
        % Toggle off adj. time and norm. values if necessary
        if time_is_adjusted(handles)
            toggle_button(handles.btnToggleAdjustedTime);
        end
        if values_are_normalized(handles)
            toggle_button(handles.btnToggleNormVals);
            toggle_menu(handles.menuToggleNormVals);
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
    handles = guidata(hObject);
    
    % Get current program state
    dnaType = get_dna_type(handles);
    solutions = get_solution_info(handles);
    
    % Let user choose Word file
    [file, path] = uigetfile('*.docx');
    if isequal(file, 0) || isequal(path, 0)
        return;
    end
    
    % Load the document
    wordClient = actxserver('Word.Application');
    wordDoc = wordClient.Documents.Open(fullfile(path, file));
    notes = wordDoc.Content.Text;
    wordDoc.Close();
    wordClient.Quit();
    uniformNotes = lower(notes);
    
    % Keep track of what was found
    newDNAType = '';
    newSolutions = {};
    
    % Find the DNA type
    % Format: ... NOMMDDYYX [dnaType] cells are ...
    startPattern = 'no';
    endPattern = 'cells are';
    
    startIdx = strfind(uniformNotes, startPattern);
    if ~isempty(startIdx)
        endIdx = strfind(uniformNotes, endPattern);
        endIdx = endIdx(endIdx > startIdx(1));
        if ~isempty(endIdx)
            dnaIdx = startIdx(1) + length('nommddyyx');
            newDNAType = notes(dnaIdx : endIdx(1)-1);
        end
    end
    
    % Find baseline solutions
    % Format: ... Start with [baseSolution] (...
    startPattern = 'start with';
    endPattern = '(';
    
    startIdx = strfind(uniformNotes, startPattern);
    if ~isempty(startIdx)
        endIdx = strfind(uniformNotes, endPattern);
        endIdx = endIdx(endIdx > startIdx(1));
        if ~isempty(endIdx)
            solutionIdx = startIdx(1) + length(startPattern);
            solutionName = strtrim(notes(solutionIdx : endIdx-1));
            newSolutions = [newSolutions; {solutionName, 1}];
        end
    end
    
    % Find remaining solutions
    % Format: ... After img[timing] start [solution]. ...
    timingStartPtrn = 'after img';
    timingEndPtrn = 'start';
    nameEndPtrn = '.';
    
    % Find first pattern: '... After img[timing] ...'
    timingStartIndices = strfind(uniformNotes, timingStartPtrn);
    if ~isempty(timingStartIndices)
        % Find second pattern: ' ... start ...'
        timingEndIndices = strfind(uniformNotes, timingEndPtrn);
        timingEndIndices = timingEndIndices(timingEndIndices > timingStartIndices(1));
        
        if ~isempty(timingEndIndices)
            % Find third pattern: ' ... [solution]. ...'
            nameEndIndices = strfind(uniformNotes, nameEndPtrn);
            nameEndIndices = nameEndIndices(nameEndIndices > timingEndIndices(1));
            
            if ~isempty(nameEndIndices)
                solutionCount = min([numel(timingStartIndices), numel(timingEndIndices), numel(nameEndIndices)]);
                
                if solutionCount > 0
                    for i = 1:solutionCount
                        timingIdx = timingStartIndices(i) + length(timingStartPtrn);
                        nameIdx = timingEndIndices(i) + length(timingEndPtrn);
                        solTiming = str2double(notes(timingIdx : timingEndIndices(i)-1));
                        solName = strtrim(notes(nameIdx : nameEndIndices(i)-1));
                        
                        if ~isempty(solName) && ~isnan(solTiming)
                            newSolutions = [newSolutions; {solName, solTiming}];
                        end
                    end
                end
            end
        end 
    end
    
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
                  
    if strcmp(choice, 'Yes')
        dlgStyle = struct('Interpreter', 'tex', ...
                          'WindowStyle', 'non-modal');
        dlgContent = ['\fontsize{14}', notes];
        msgbox(dlgContent, dlgStyle);
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


% --------------------------------------------------------------------

% hObject    handle to menuEnableAllROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
