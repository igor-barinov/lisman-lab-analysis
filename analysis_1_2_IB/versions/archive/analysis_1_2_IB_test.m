%% ******************************************************************************

% PROGRAM FUNCTIONS

function varargout = analysis_1_2_IB_test(varargin)
%ANALYSIS_1_2_IB_TEST M-file for analysis_1_2_IB_test.fig
%      ANALYSIS_1_2_IB_TEST, by itself, creates a new ANALYSIS_1_2_IB_TEST or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_TEST returns the handle to a new ANALYSIS_1_2_IB_TEST or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_TEST('Property','Value',...) creates a new ANALYSIS_1_2_IB_TEST using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to analysis_1_2_IB_test_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ANALYSIS_1_2_IB_TEST('CALLBACK') and ANALYSIS_1_2_IB_TEST('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ANALYSIS_1_2_IB_TEST.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysis_1_2_IB_test

% Last Modified by GUIDE v2.5 12-Jul-2019 12:41:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_test_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_test_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
function analysis_1_2_IB_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for analysis_1_2_IB_test
clearWorkspace();
handles.output = hObject;
updateUI(handles);

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes analysis_1_2_IB_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function varargout = analysis_1_2_IB_test_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% ******************************************************************************

% GUI INITIALIZATION FUNCTIONS

function dataTable_CreateFcn(hObject, eventdata, handles)
function popupData1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupData2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupData3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputNumBase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% ******************************************************************************

% GUI CALLBACKS


%% *********** Open/Browse Callbacks ***********
function btnSPCAnalysis_Callback(hObject, eventdata, handles)
spc_drawInit;
function btnHZAnalysis_Callback(hObject, eventdata, handles)
h_imstack;
function btnAutoAnalyze_Callback(hObject, eventdata, handles)
global workspace;

clearWorkspace();
updateUI(handles);

waitfor(warndlg('Auto Analysis will run until you have chosen all of the files you want to analyze. Press OK to continue'));
pause(1);

isFirst = true;

while 1
    set(handles.inputNumBase, 'Enable', 'on');
    waitfor(warndlg('Please set number of baseline points now before starting analysis. Press OK when done'));
    pause(1);
    waitfor(msgbox('Select a file to continue analysis. Press cancel on the dialog to stop.'));
    pause(0.5);
    btnOpen_Callback(handles.btnOpen, eventdata, handles);
    
    if strcmp(workspace.status, 'none')
        warndlg('Stopped Analysis');
        break;
    end
    
    btnFixROI_Callback(handles.btnFixROI, eventdata, handles);
    if strcmp(workspace.status, 'raw')
        waitfor(warndlg('ROI File prepared. Please specify where to save prepared ROI File.'));
        pause(1);
        btnSave_Callback(handles.btnSave, eventdata, handles);
    end
    btnAdjustTime_Callback(handles.btnAdjustTime, eventdata, handles);
    if isFirst
        waitfor(warndlg('Please specify where to save new ROI Group File. Press cancel on saving dialog if you dont want a group file'));
        pause(1);
        btnNewGroup_Callback(handles.btnNewGroup, eventdata, handles);
        isFirst = false;
    end

    waitfor(warndlg('Please specify which group will hold ROI data. Press cancel on saving dialog if you dont want to add ROI data.'));
    pause(1);
    btnAddToGroup_Callback(handles.btnAddToGroup, eventdata, handles);

    clearWorkspace();
end

updateUI(handles);
function btnOpen_Callback(hObject, eventdata, handles)

%{
Open any supported data files, format the data, and display the contents

*precondition: workspace is defined as struct with necessary fields
%}
%% Get workspace vars and file path
global workspace;
[name, path] = uigetfile('*.mat', 'Multiselect', 'on');

%% Check if choose dialog wasnt canceled
if ~isequal(name, 0) && ~isequal(path, 0)
    %% Load possible formats of file
    cd(path);
    clearWorkspace();
    workspace.file = fullfile(path, name);
    czData = reformat_roi_file(workspace.file, 'CZ');
    hzData = reformat_roi_file(workspace.file, 'HZ');
        
    %% Check if file is in CZ Format
    if ~isempty(czData)
        %% Update workspace vars
        workspace.status = 'raw';
        [~, workspace.expname, ~] = fileparts(workspace.file);
        workspace.expname = workspace.expname(1:strfind(workspace.expname, 'ROI2')+3);
        workspace.numROI = czData.numROI;
        workspace.nDataTypes = 3;
        
        %% Load prepared data if available, raw data otherwise
        if isempty(czData.prep.all)
            workspace.expdata = czData.raw.all;
        else
            workspace.status = 'prepared';
            workspace.expdata = czData.prep.all;
        end
        if ~isempty(czData.prep.alladj)
            workspace.adjdata = czData.prep.alladj;
        end
        
        %% Set the column names for display
        colNames = cell(1, size(workspace.expdata, 2));
        colNames{1} = 'time';
        [colNames{2:2+workspace.numROI-1}] = deal('lifetime');
        [colNames{2+workspace.numROI:2+2*workspace.numROI-1}] = deal('int');
        [colNames{2+2*workspace.numROI:2+3*workspace.numROI-1}] = deal('red');
        
    %% Check if file is in HZ format
    elseif ~isempty(hzData)
        %% Update workspace vars
        workspace.status = 'prepared';
        [~, workspace.expname, ~] = fileparts(workspace.file{1});
        workspace.expname = workspace.expname(1:8);
        workspace.numROI = hzData.numROI;
        workspace.nDataTypes = 2;
        
        %% Load the raw data
        workspace.expdata = hzData.raw.all;       
        
        %% Set the column names
        colNames = cell(1, size(workspace.expdata, 2));
        colNames{1} = 'time';
        [colNames{2:2+workspace.numROI-1}] = deal('green');
        [colNames{2+workspace.numROI:2+2*workspace.numROI-1}] = deal('red');
    else
        %% Load the file and check if in group format
        load(workspace.file);
        if exist('indivData', 'var')
            %% Update workspace vars
            workspace.status = 'group';
            [~, workspace.expname, ~] = fileparts(workspace.file);
            
            if strfind(workspace.file, 'ROI')
                workspace.nDataTypes = 3;
            else
                workspace.nDataTypes = 2;
            end
            
                       
            %% Load the group data
            workspace.expdata = indivData{1,1}(:, 1);
            nExp = size(indivData, 2);
            for i = 1:workspace.nDataTypes
                for j = 1:nExp
                    expData = indivData{1, j};
                    nExpROI = (size(expData, 2) - 1) / workspace.nDataTypes;
                    colStart = 2 + (nExpROI*(i-1));
                    columns = expData(:, colStart:colStart+nExpROI-1);
                    workspace.expdata = [workspace.expdata, columns];
                end
            end           
            workspace.adjdata = workspace.expdata;
            workspace.numROI = (size(workspace.expdata, 2)-1) / workspace.nDataTypes;
            colNames = cell(1, size(workspace.expdata, 2));
            colNames{1} = 'time';
        else
            %% Dont handle any other file types
            warndlg('File not supported');
            clearWorkspace();
        end
    end
    for i = 1:workspace.nDataTypes
        colNames(2+(i-1)*workspace.numROI:1+i*workspace.numROI)=strcat(colNames(2+(i-1)*workspace.numROI:1+i*workspace.numROI), sprintfc('%d', 1:workspace.numROI));
    end
    set(handles.dataTable, 'Data', workspace.expdata);
    set(handles.dataTable, 'ColumnName', colNames);
    set(handles.popupData1, 'String', colNames(2:end));
    set(handles.popupData2, 'String', colNames(2:end));
    set(handles.popupData3, 'String', colNames(2:end));
end

%% Update GUI
updateUI(handles);

%% *********** Editting Callbacks ***********
function dataTable_CellEditCallback(hObject, eventdata, handles)
%{
Update workspace vars based on UI update in data table
%}
global workspace;
global tablepos;
row = tablepos(1);
col = tablepos(2);
workspace.expdata(row, col) = eventdata.NewData;
function dataTable_CellSelectionCallback(hObject, eventdata, handles) %#ok<*DEFNU>
global tablepos;
tablepos = eventdata.Indices;
function btnAddRow_Callback(hObject, eventdata, handles)
global workspace;
global tablepos;
if isempty(tablepos)
    row = size(workspace.expdata, 1) + 1;
else
    row = tablepos(1);
end
count = size(workspace.expdata, 2);
workspace.expdata = [workspace.expdata(1:row-1, :); zeros(1, count); workspace.expdata(row:end, :)];
set(handles.dataTable, 'Data', workspace.expdata);
function btnDeleteRow_Callback(hObject, eventdata, handles)
global workspace;
global tablepos;
if isempty(tablepos)
    row = size(workspace.expdata, 1);
else
    row = tablepos(1);
end
workspace.expdata(row, :) = [];
set(handles.dataTable, 'Data', workspace.expdata);
function btnZeroRow_Callback(hObject, eventdata, handles)
global workspace;
global tablepos;
if isempty(tablepos)
    row = size(workspace.expdata, 1) + 1;
else
    row = tablepos(1);
end
count = size(workspace.expdata, 2);
workspace.expdata(row, :) = zeros(1, count);
set(handles.dataTable, 'Data', workspace.expdata);
function btnAddCol_Callback(hObject, eventdata, handles)
global workspace;
global tablepos;
if isempty(tablepos)
    col = size(workspace.expdata, 2) + 1;
else
    col = tablepos(2);
end
count = size(workspace.expdata, 1);
workspace.expdata = [workspace.expdata(:,1:col-1), zeros(count, 1), workspace.expdata(:, col:end)];
set(handles.dataTable, 'Data', workspace.expdata);
function btnDeleteCol_Callback(hObject, eventdata, handles)
global workspace;
global tablepos;
if isempty(tablepos)
    col = size(workspace.expdata, 2);
else
    col = tablepos(2);
end
workspace.expdata(:, col) = [];
set(handles.dataTable, 'Data', workspace.expdata);
function btnZeroCol_Callback(hObject, eventdata, handles)

global workspace;
global tablepos;
if isempty(tablepos)
    col = size(workspace.expdata, 2) + 1;
else
    col = tablepos(2);
end
count = size(workspace.expdata, 1);
workspace.expdata(:, col) = zeros(count, 1);
set(handles.dataTable, 'Data', workspace.expdata);
function btnAdjustTime_Callback(hObject, eventdata, handles)

%{
Adjust time data and store seperately in workspace vars

*precondition: workspace.expdata is a matrix with time in first column
%}

%% Get the workspace vars and the number of base line pts
global workspace;
numBase = str2double(get(handles.inputNumBase, 'String'));
if isnan(numBase)
    warndlg('Please input a number for # of baseline pts');
else
    %% Adjust the time if [num_base] is valid (t = 0 @ [num_base], t in minutes
    time = workspace.expdata(:, 1);
    time = ((time - time(1)) * 60 * 24);
    time = time - time(numBase);
    
    %% Define seperate field for adjusted time if non-existent
    if isempty(workspace.adjdata)
        workspace.adjdata = workspace.expdata;
    end
    workspace.adjdata(:, 1) = time;
    
    %% Update data table time based on toggle button
    useAdj = get(handles.btnToggleAdjTime, 'Value');
    if useAdj == 1
        set(handles.dataTable, 'Data', workspace.adjdata);
    else
        set(handles.dataTable, 'Data', workspace.expdata);
    end
end
function btnFixROI_Callback(hObject, eventdata, handles)

%{
Fix data by filling missing values in time column and data columns

*precondition: workspace.expdata is a contructed matrix
%}


global workspace;

%% Go through each column
for i = 1:size(workspace.expdata, 2)
    colData = workspace.expdata(:, i);
        
    if i == 1
        %% Fix the time column (treat as independent var)
        colFix = fix_ind_var(colData);
    else
        %% Fix the data column (treat as dependent var)
        colFix = fix_dep_var(colData);
    end
    
    workspace.expdata(:, i) = colFix;   
end

%% Show the updated data
set(handles.dataTable, 'Data', workspace.expdata);
function inputNumBase_Callback(hObject, eventdata, handles)
function btnToggleAdjTime_Callback(hObject, eventdata, handles)
global workspace;
useAdj = get(hObject, 'Value');
if useAdj == 1
    if isempty(workspace.adjdata)
        set(hObject, 'Value', 0);
        warndlg('Values have not been adjusted yet');
    else
        set(handles.dataTable, 'Data', workspace.adjdata);
    end
else
    set(handles.dataTable, 'Data', workspace.expdata);
end
function btnSave_Callback(hObject, eventdata, handles)
global workspace;

if strcmp(workspace.status, 'raw')
    if strfind(workspace.expname, 'ROI2')
        %% Save + prepare raw CZ ROI file
        load(workspace.file);
        [fileStruct] = save_roi_file(workspace.expdata, 'CZ');
        cmdGetRoidata = strcat('roidata=',workspace.expname, '.roiData;');
        eval(cmdGetRoidata);
        roidata(length(fileStruct.roiData)+1:end) = [];
        roiCell = struct2cell(fileStruct.roiData);
        timeVals = roiCell(1, :);
        tauVals = roiCell(2, :);
        intVals = roiCell(3, :);
        redVals = roiCell(4, :);
        [roidata.time] = timeVals{:};
        [roidata.tau_m] = tauVals{:};
        [roidata.mean_int] = intVals{:};
        [roidata.red_mean] = redVals{:};
        cmdSaveRoidata = strcat(workspace.expname, '.roiData=roidata;', workspace.expname, '.analyzeData=fileStruct.analyzeData;');
        eval(cmdSaveRoidata);
        uisave(workspace.expname, strcat(workspace.expname, '_prep.mat'));
    else
        %% Save + prepare raw HZ ROI file
        [fileStructs] = save_roi_file(workspace.expdata, 'HZ');
        j = 1;
        for i = 1:length(workspace.file)
            load(workspace.file{i});
            if exist('Aout', 'var')
                Aout.timestr = fileStructs{j}.timestr;
                Aout.green = fileStructs{j}.green;
                Aout.red = fileStructs{j}.red;
                save(workspace.file{i}, 'Aout');
                clear Aout;
                j = j + 1;
            end
        end
        msgbox(strcat('Prepared data and saved changes to: ', workspace.expname, ' Files'));
    end
elseif strcmp(workspace.status, 'prepared')
    %% Save prepared/adjusted ROI file
elseif strcmp(workspace.status, 'group')
    %% Save ROI group
end
function btnAddToGroup_Callback(hObject, eventdata, handles)
global workspace;

[name, path] = uigetfile('*.mat');
if ~isequal(name, 0) && ~isequal(path, 0)
    load(fullfile(path, name));
    if exist('indivData', 'var')
        if isempty(workspace.adjdata)
            warndlg('Please adjust time before adding data to a group');
        else
            indivData{1, end+1} = workspace.adjdata;
            indivData{2,end} = workspace.file;
            save(fullfile(path, name), 'indivData');
        end
    else
        warndlg('Not a valid group file');
    end
end
function btnClear_Callback(hObject, eventdata, handles)
clearWorkspace();
updateUI(handles);
function btnNewGroup_Callback(hObject, eventdata, handles)
global workspace;

if isempty(workspace.adjdata)
    warndlg('Please adjust times before making a group file');
else
    averages = [];
    stdErrs = [];
    indivData = cell(2, 1);
    indivData{1} = workspace.adjdata;
    indivData{2} = workspace.file;
    formatStr = 'ROI2';
    idxFormat = strfind(workspace.expname, formatStr);
    if idxFormat
        groupName = strcat(workspace.expname(1:idxFormat-1), 'ROI');
    else
        groupName = workspace.expname;
    end
    uisave({'averages', 'stdErrs', 'indivData'}, strcat(groupName, '_group.mat'));
end

%% *********** Plotting Callbacks ***********
function popupData1_Callback(hObject, eventdata, handles)
function popupData2_Callback(hObject, eventdata, handles)
function popupData3_Callback(hObject, eventdata, handles)
function btnPlotSelected_Callback(hObject, eventdata, handles)
global workspace;

useAdj = get(handles.radioUseAdjTime, 'Value');
useNorm = get(handles.radioUseNormVals, 'Value');

choices = [get(handles.popupData1, 'Value'), get(handles.popupData2, 'Value'), get(handles.popupData3, 'Value')];

if strcmp(workspace.status, 'raw')
    time = workspace.expdata(:, 1);
    dataCols = [workspace.expdata(:, choices(1)+1), workspace.expdata(:, choices(2)+1), workspace.expdata(:, choices(3)+1)];
    plot(time, dataCols, 'o-');
elseif strcmp(workspace.status, 'prepared') || strcmp(workspace.status, 'group')
    if useAdj
        if isempty(workspace.adjdata)
            warndlg('Time values are unadjusted. Using unadjusted time values');
            time = workspace.expdata(:, 1);
        else
            time = workspace.adjdata(:, 1);
        end
    else
        time = workspace.expdata(:, 1);
    end
    if useNorm
        if isempty(workspace.normdata)
            warndlg('Values are not normalized. Using raw unadjusted values');
            allData = workspace.expdata;
        else
            allData = workspace.normdata;
        end
    else
        allData = workspace.expdata;
    end
    
   figure();
   dataCols = [allData(:, choices(1)+1), allData(:, choices(2)+1), allData(:, choices(3)+1)]; 
   plot(time, dataCols, 'o-');
   colNames = get(handles.dataTable, 'ColumnName');
   choiceNames = colNames(choices+1);
   legend(choiceNames);
end


function radioUseAdjTime_Callback(hObject, eventdata, handles)
function radioUseNormVals_Callback(hObject, eventdata, handles)
global workspace;

%% Get the value type preference
useNorm = get(hObject, 'Value');
if useNorm == 1
    if isempty(workspace.normdata)
        if isempty(workspace.adjdata)
            %% Data cannot be normalized if unadjusted
            warndlg('Please adjust file to use normalized values');
            set(hObject, 'Value', 0.0);
        else
            %% Get the adjusted data and the number of baseline pts
            workspace.normdata = workspace.adjdata;
            numBaseline = str2double(get(handles.inputNumBase, 'String'));
            
            %% Calculate the coefficient for normalization for each column ( k = nBase / sum(x, 1->nBase) )
            factors = (numBaseline * ones(1, size(workspace.adjdata(:, 2:end), 2))) ./ sum(workspace.adjdata(1:numBaseline, 2:end), 1);
            
            %% Multiply each column by the coefficent to get the normalized values
            for i=1:length(factors)
                workspace.normdata(:, i+1) = factors(i)*workspace.adjdata(:, i+1);
            end
        end
    end
end
function btnPlotAll_Callback(hObject, eventdata, handles)
global workspace;

%% Get the plotting preferences
useAdj = get(handles.radioUseAdjTime, 'Value');
useNorm = get(handles.radioUseNormVals, 'Value');

if strcmp(workspace.status, 'raw')
    time = workspace.expdata(:, 1);
    allData = workspace.expdata;
    %% Setup a figure with mutlitple graphs
    figure();    
    %% Go through each datatype
    for i = 1:workspace.nDataTypes
        subplot(workspace.nDataTypes, 1, i);
        plot(time, allData(:, 2+(i-1)*workspace.numROI:1+i*workspace.numROI), 'o-');
    end
elseif strcmp(workspace.status, 'prepared') || strcmp(workspace.status, 'group')    
    if useAdj == 1
        if isempty(workspace.adjdata)
            %% Use unadjusted time values if adjusted values are preferred but unavailable
            msgbox('Time values are unadjusted. Using unadjusted values');
            set(handles.radioUseAdjTime, 'Value', 0.0);
            time = workspace.expdata(:, 1);
        else
            %% Use adjusted time values if preferred and available
            time = workspace.adjdata(:, 1);
        end
    else
        %% Use unadjusted time values if preferred
        time = workspace.expdata(:, 1);
    end
    
    if useNorm == 1
        if isempty(workspace.normdata)
            %% Use raw values if normalized vals are preferrd but unavailable
            msgbox('Values are not normalized. Using raw unadjusted values');
            set(handles.radioUseNormVals, 'Value', 0.0);
            allData = workspace.expdata;
        else
            %% Use normalized vals if preffered and available
            allData = workspace.normdata;
        end
    else
        %% Use raw values if preffered
        allData = workspace.expdata;
    end
    
    %% Setup a figure with mutlitple graphs
    figure();    
    %% Go through each datatype
    for i = 1:workspace.nDataTypes
        subplot(workspace.nDataTypes, 1, i);
        plot(time, allData(:, 2+(i-1)*workspace.numROI:1+i*workspace.numROI), 'o-');
    end
end

%% *********** Results Callbacks ***********
function btnAverage_Callback(hObject, eventdata, handles)
global workspace;

%% Get time column, either adjusted or unadjusted
if isempty(workspace.adjdata)
    time = workspace.expdata(:, 1);
else
    time = workspace.adjdata(:, 1);
end


figure('Name', strcat(workspace.expname, ' Averages'));
avgData = cell(2, workspace.nDataTypes);
for i = 1:workspace.nDataTypes
    subplot(workspace.nDataTypes, 1, i);
    avgData{1, i} = workspace.expdata(:, 2+(i-1)*workspace.numROI:1+i*workspace.numROI);
    avgData{1, i} = mean(avgData{1, i}, 2);
    avgData{2, i} = std(avgData{1, i}, 0, 2) / size(avgData{1, i}, 1) ^ 0.5;
    errorbar(time, avgData{1, i}, avgData{2, i}, 'o-', 'color', 'k');
end
function btnResults_Callback(hObject, eventdata, handles)
global workspace;

if isempty(workspace.adjdata)
    warndlg('Please adjust values before saving results');
    return;
end

%% Get all columns + time column
all_data = workspace.adjdata;
time = workspace.adjdata(:, 1);
idxZero = find(~time);
num = idxZero(1);

if isempty(workspace.normdata)
    workspace.normdata = workspace.adjdata;
    numBaseline = num;
    
    factors = (numBaseline * ones(1, size(workspace.normdata(:, 2:end), 2))) ./ sum(workspace.normdata(1:numBaseline, 2:end), 1);
    for i=1:length(factors)
        workspace.normdata(:, i+1) = factors(i)*workspace.normdata(:, i+1);
    end
end
norm_data = workspace.normdata;


%% Get just data colums
if workspace.nDataTypes < 3
    tau = [];
    tauNorm = [];
    int = all_data(:,2:2+workspace.numROI-1);
    intNorm = norm_data(:,2:2+workspace.numROI-1);
    red = all_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
    redNorm = norm_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
else
    tau = all_data(:,2:2+workspace.numROI-1);
    tauNorm = norm_data(:,2:2+workspace.numROI-1);
    int = all_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
    intNorm = norm_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
    red = all_data(:,2+2*workspace.numROI:2+2*workspace.numROI+(workspace.numROI-1));
    redNorm = norm_data(:,2+2*workspace.numROI:2+2*workspace.numROI+(workspace.numROI-1));
end

%% Calculate column averages + std. errs
mean_tau = mean(tau, 2);
mean_tauNorm = mean(tauNorm, 2);
ste_tau = std(tau, 0, 2) / size(tau, 1) ^ 0.5;
ste_tauNorm = std(tauNorm, 0, 2) / size(tauNorm, 1) ^ 0.5;
mean_Int = mean(int, 2);
ste_Int = std(int, 0, 2) / size(int, 1) ^ 0.5;
mean_redInt = mean(red, 2);
ste_redInt = std(red, 0, 2) / size(red, 1) ^ 0.5;

%% Save data + calculations
uisave({'num', 'all_data', 'time', 'mean_tau', 'mean_tauNorm', 'ste_tau', 'ste_tauNorm', 'mean_Int', 'ste_Int', 'mean_redInt', 'ste_redInt'}, strcat(workspace.expname, '_results.mat'));
function btnEditResults_Callback(hObject, eventdata, handles)
plot_results;




%% ******************************************************************************

% CUSTOM FUNCTIONS


function clearWorkspace()
global workspace;
global tablepos;
workspace.status = 'none';
workspace.file = [];
workspace.numROI = 0;
workspace.nDataTypes = 0;
workspace.expname = [];
workspace.expdata = [];
workspace.adjdata = [];
workspace.normdata = [];
tablepos = [];
function updateUI(handles)
global workspace;

if isempty(workspace.status) || strcmp(workspace.status, 'none')
    %% Disable almost all ui
    set(handles.dataTable, 'Data', []);
    set(handles.btnToggleAdjTime, 'Value', 0.0);
    set(handles.radioUseAdjTime, 'Value', 0.0);
    set(handles.radioUseNormVals, 'Value', 0.0);
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'off');
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'off');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'off');
elseif strcmp(workspace.status, 'raw')
    %% Enable some editting
    set(handles.dataTable, 'ColumnEditable', true(1, size(workspace.expdata, 2)));
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
    set(handles.inputNumBase, 'Enable', 'off');
    set(handles.btnAdjustTime, 'Enable', 'off');
    set(handles.btnToggleAdjTime, 'Value', 0.0);
    set(handles.radioUseAdjTime, 'Value', 0.0);
    set(handles.radioUseNormVals, 'Value', 0.0);
    set(handles.btnToggleAdjTime, 'Enable', 'off');
    set(handles.btnAddToGroup, 'Enable', 'off');
    set(handles.btnNewGroup, 'Enable', 'off');
    %% Enable most plotting
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
    set(handles.radioUseAdjTime, 'Enable', 'off');
    set(handles.radioUseNormVals, 'Enable', 'off');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'off');
elseif strcmp(workspace.status, 'prepared')
    %% Enable almost all
    set(handles.dataTable, 'ColumnEditable', true(1, size(workspace.expdata, 2)));
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'on');
elseif strcmp(workspace.status, 'group')
    %% Enable almost all
    set(handles.dataTable, 'ColumnEditable', true(1, size(workspace.expdata, 2)));
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'on');
    set(handles.btnFixROI, 'Enable', 'off');
    set(handles.inputNumBase, 'Enable', 'off');
    set(handles.btnAdjustTime, 'Enable', 'off');
    set(handles.btnToggleAdjTime, 'Enable', 'off');
    set(handles.btnAddToGroup, 'Enable', 'off');
end








        

        