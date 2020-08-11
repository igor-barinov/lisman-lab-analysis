%% ******************************************************************************

% PROGRAM FUNCTIONS - DO NOT EDIT

function varargout = analysis_1_2_IB_071519(varargin)
%ANALYSIS_1_2_IB_071519 M-file for analysis_1_2_IB_071519.fig
%      ANALYSIS_1_2_IB_071519, by itself, creates a new ANALYSIS_1_2_IB_071519 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_071519 returns the handle to a new ANALYSIS_1_2_IB_071519 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_071519('Property','Value',...) creates a new ANALYSIS_1_2_IB_071519 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to analysis_1_2_IB_071519_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ANALYSIS_1_2_IB_071519('CALLBACK') and ANALYSIS_1_2_IB_071519('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ANALYSIS_1_2_IB_071519.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysis_1_2_IB_071519

% Last Modified by GUIDE v2.5 22-Jul-2019 13:45:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_071519_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_071519_OutputFcn, ...
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
function analysis_1_2_IB_071519_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for analysis_1_2_IB_071519
clearWorkspace();
handles.output = hObject;
updateUI(handles);

% Update handles structure
guidata(hObject, handles);
function varargout = analysis_1_2_IB_071519_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% ******************************************************************************

% GUI INITIALIZATION FUNCTIONS

function dataTable_CreateFcn(~, ~, ~)
function popupData1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupData2_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupData3_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputNumBase_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputDNAType_CreateFcn(hObject, ~, ~)
% hObject    handle to inputDNAType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputBaseSol_CreateFcn(hObject, ~, ~)
% hObject    handle to inputBaseSol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputSolA_CreateFcn(hObject, ~, ~)
% hObject    handle to inputSolA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputSolB_CreateFcn(hObject, ~, ~)
% hObject    handle to inputSolB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputStartWash_CreateFcn(hObject, ~, ~)
% hObject    handle to inputStartWash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%% ******************************************************************************

% GUI CALLBACKS


%% *********** Open/Browse Callbacks ***********

function btnSPCAnalysis_Callback(~, ~, ~)
%% Open SPC Analysis GUI
spc_drawInit;

function btnHZAnalysis_Callback(~, ~, ~)
%% Open h_imstack analysis GUI
h_imstack;

function btnAutoAnalyze_Callback(hObject, eventdata, handles)

%% Load + Clear Workspace/UI
    global workspace;

    clearWorkspace();
    updateUI(handles);

%% Notify user of start
    waitfor(warndlg('Auto Analysis will run until you have chosen all of the files you want to analyze. Press OK to continue'));
    pause(1);

%% Loop until user stops analysis 
    isFirst = true;
    while 1
    %% Let user enter # of base pts
        set(handles.text12, 'Enable', 'on');
        set(handles.inputNumBase, 'Enable', 'on');
        waitfor(warndlg('Please set number of baseline points now before starting analysis. Press OK when done'));
        pause(1);
    
    %% Notify of continuation + open browse dialog
        waitfor(msgbox('Select a file to continue analysis. Press cancel on the dialog to stop.'));
        pause(0.5);
        btnOpen_Callback(handles.btnOpen, eventdata, handles);

    %% Check if user canceled file selection + stop if necessary
        if strcmp(workspace.status, 'none')
            warndlg('Stopped Analysis');
            break;
        end

    %% Fix ROI File
        btnFixROI_Callback(handles.btnFixROI, eventdata, handles);
        
        if strcmp(workspace.status, 'raw')
        %% Prepare ROI File if necessary + open save dialog
            waitfor(warndlg('ROI File prepared. Please specify where to save prepared ROI File.'));
            pause(1);
            btnSave_Callback(handles.btnSave, eventdata, handles);
        end
        
    %% Adjust ROI Time values
        btnAdjustTime_Callback(handles.btnAdjustTime, eventdata, handles);
        
        if isFirst
        %% Let user create new group if necessary
            waitfor(warndlg('Please specify where to save new ROI Group File. Press cancel on saving dialog if you dont want a group file'));
            pause(1);
            btnNewGroup_Callback(handles.btnNewGroup, eventdata, handles);
            isFirst = false;
        end

    %% Let user add ROI data to group
        waitfor(warndlg('Please specify which group will hold ROI data. Press cancel on saving dialog if you dont want to add ROI data.'));
        pause(1);
        btnAddToGroup_Callback(handles.btnAddToGroup, eventdata, handles);

    %% Clear varaibles for next iteration
        clearWorkspace();
    end

%% Update UI based on workspace state
updateUI(handles);

function btnOpen_Callback(hObject, eventdata, handles)
%% Get workspace vars and open browse dialog
    global workspace;
    [name, path] = uigetfile('*.mat', 'Multiselect', 'on');

%% Check if file browsing wasn't canceled
    if ~isequal(name, 0) && ~isequal(path, 0)
        
        %% Load possible formats of file
            cd(path);
            clearWorkspace();
            workspace.file = fullfile(path, name);
            czData = reformat_roi_file(workspace.file, 'ROI');
            hzData = reformat_roi_file(workspace.file, 'HZ');

        %% Check if file is in CZ Format
            if ~isempty(czData)
        
                %% Update workspace vars
                    workspace.status = 'raw';
                    [~, workspace.expname, ~] = fileparts(workspace.file);
                    workspace.expname = workspace.expname(1:strfind(workspace.expname, 'ROI2')+3);
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
                    workspace.numROI = (size(workspace.expdata, 2) - 1) / workspace.nDataTypes;

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
                    
        %% Handle other file formats
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
                            
                        %% Load experiment details
                        
                        if exist('expDetails', 'var')
                            set(handles.inputDNAType, 'String', expDetails.tyDNA);
                            set(handles.inputBaseSol, 'String', expDetails.solBase);
                            set(handles.inputSolA, 'String', expDetails.solA);
                            set(handles.inputSolB, 'String', expDetails.solB);
                            set(handles.inputNumBase, 'String', num2str(expDetails.numBase));
                            set(handles.inputStartWash, 'String', num2str(expDetails.washStart));
                        end
                            
                            
                        %% Set the column names
                            colNames = cell(1, size(workspace.expdata, 2));
                            colNames{1} = 'time';
                            
                            if workspace.nDataTypes == 2
                                [colNames{2:2+workspace.numROI-1}] = deal('green');
                                [colNames{2+workspace.numROI:2+2*workspace.numROI-1}] = deal('red');
                            elseif workspace.nDataTypes == 3
                                [colNames{2:2+workspace.numROI-1}] = deal('lifetime');
                                [colNames{2+workspace.numROI:2+2*workspace.numROI-1}] = deal('int');
                                [colNames{2+2*workspace.numROI:2+3*workspace.numROI-1}] = deal('red');
                            end
                            
                %% Dont handle any other file types
                    else
                        warndlg('File not supported');
                        clearWorkspace();
                    end
            end
            
    %% Adjust the column names based on # of ROI
        for i = 1:workspace.nDataTypes
            colNames(2+(i-1)*workspace.numROI:1+i*workspace.numROI)=strcat(colNames(2+(i-1)*workspace.numROI:1+i*workspace.numROI), sprintfc('%d', 1:workspace.numROI));
        end
        
    %% Display data
        set(handles.dataTable, 'Data', workspace.expdata);
        set(handles.dataTable, 'ColumnName', colNames);
        set(handles.popupData1, 'String', colNames(2:end));
        set(handles.popupData2, 'String', colNames(2:end));
        set(handles.popupData3, 'String', colNames(2:end));
    end

%% Update GUI based on workspace state
updateUI(handles);


%% *********** Exp Detail/Info Callbacks ***********

function btnImportExpInfo_Callback(hObject, eventdata, handles)
    global workspace;
    [name, path] = uigetfile('*.docx');
    
    if ~isequal(name, 0) && ~isequal(path, 0)
        wordApp = actxserver('Word.Application');
        wordDoc = wordApp.Documents.Open(fullfile(path, name));
        docTxt = lower(wordDoc.Content.Text);
        wordDoc.Close;
        wordApp.Quit;
        
        [~, docName, ~] = fileparts(lower(name));
        
        idxDNA = strfind(docTxt, docName);
        endIdxDNA = strfind(docTxt, 'cells are');
        try
            dna = docTxt(idxDNA + length(docName):endIdxDNA(1) -1);
        catch
            dna = ' ';
        end
        
        idxSolStart = strfind(docTxt, 'start with');
        endIdxSolStart = strfind(docTxt, '(');
        endIdxSolStart = endIdxSolStart(endIdxSolStart > idxSolStart(1));
        try
            solStart = docTxt(idxSolStart + length('start with'):endIdxSolStart(1)-1);
        catch
            solStart = ' ';
        end
        
        
        idxPts = strfind(docTxt, 'after img');
        endIdxPts = strfind(docTxt, 'start ');
        endIdxPts = endIdxPts(endIdxPts > idxPts(1));
        try
            nBase = docTxt(idxPts(1)+length('after img'):endIdxPts(1)-1);
            if isnan(str2double(nBase))
                nBase = ' ';
            end
        catch
            nBase = ' ';
        end
        try
            startWash = docTxt(idxPts(2)+length('after img'):endIdxPts(2)-1);
            if isnan(str2double(startWash))
                startWash = ' ';
            end
        catch
            startWash = ' ';
        end
        
        endIdxSol = strfind(docTxt, '. ');
        endIdxSol = endIdxSol(endIdxSol > idxPts(1));
        try
            solA = docTxt(endIdxPts(1)+length('start'):endIdxSol(1)-1);
        catch
            solA = ' ';
        end
        try
            solB = docTxt(endIdxPts(2)+length('start'):endIdxSol(2)-1);
        catch
            solB = ' ';
        end
        
        set(handles.inputDNAType, 'String', dna);
        set(handles.inputBaseSol, 'String', solStart);
        set(handles.inputSolA, 'String', solA);
        set(handles.inputSolB, 'String', solB);
        set(handles.inputNumBase, 'String', nBase);
        set(handles.inputStartWash, 'String', startWash);
    end
function inputDNAType_Callback(hObject, ~, ~)
function inputBaseSol_Callback(hObject, ~, ~)
function inputSolA_Callback(hObject, ~, ~)
function inputSolB_Callback(hObject, ~, ~)
function inputNumBase_Callback(hObject, ~, ~)
function inputStartWash_Callback(hObject, ~, ~)


%% *********** Editting Callbacks ***********

function dataTable_CellEditCallback(hObject, eventdata, handles)
%% Get/Update workspace vars based on selected position in table
    global workspace;
    global tablepos;
    row = tablepos(1);
    col = tablepos(2);
    if isnan(eventdata.NewData)
        choice = questdlg('Delete cell?', 'Confirmation', 'Yes', 'No', 'No');
        if strcmp(choice, 'Yes')
            workspace.expdata(row, col) = eventdata.NewData;
            if ~isempty(workspace.adjdata)
                workspace.adjdata(row, col) = eventdata.NewData;
            end
            if ~isempty(workspace.normdata)
                workspace.normdata(row, col) = eventdata.NewData;
            end
        end
    end
    if get(handles.btnToggleAdjTime, 'Value') == 1 && ~isempty(workspace.adjdata)
        set(handles.dataTable, 'Data', workspace.adjdata);
    else
        set(handles.dataTable, 'Data', workspace.expdata);
    end

function dataTable_CellSelectionCallback(hObject, eventdata, handles)
%% Update selected position in table
    global tablepos;
    tablepos = eventdata.Indices;
    cols = unique(tablepos(:, 2))-1;
    cols(cols == 0) = [];
    if length(cols) > 2
        set(handles.popupData1, 'Value', cols(1));
        set(handles.popupData2, 'Value', cols(2));
        set(handles.popupData3, 'Value', cols(3));
    elseif length(cols) > 1
        set(handles.popupData1, 'Value', cols(1));        
        set(handles.popupData2, 'Value', cols(2));
    elseif length(cols) > 0
        set(handles.popupData1, 'Value', cols(1));
    end

function btnAddRow_Callback(hObject, eventdata, handles)
%% Get current table data + selected position in table
    global workspace;
    global tablepos;
    
%% Get the target row
    if isempty(tablepos)
        row = size(workspace.expdata, 1) + 1;
    else
        row = tablepos(1);
    end
    
%% Add a row of zeros based on current data dimensions
    count = size(workspace.expdata, 2);
    workspace.expdata = [workspace.expdata(1:row-1, :); zeros(1, count); workspace.expdata(row:end, :)];
    if ~isempty(workspace.adjdata)
        workspace.adjdata = [workspace.adjdata(1:row-1, :); zeros(1, count); workspace.adjdata(row:end, :)];
    end
    if ~isempty(workspace.normdata)
        workspace.normdata = [workspace.normdata(1:row-1, :); zeros(1, count); workspace.normdata(row:end, :)];
    end
    
%% Update Table in GUI
    
    if get(handles.btnToggleAdjTime, 'Value') == 1 && ~isempty(workspace.adjdata)
        set(handles.dataTable, 'Data', workspace.adjdata);
    else
        set(handles.dataTable, 'Data', workspace.expdata);
    end

function btnDeleteRow_Callback(hObject, eventdata, handles)
global workspace;
global tablepos;
if isempty(tablepos)
    row = size(workspace.expdata, 1);
else
    row = tablepos(1);
end

choice = questdlg('Keep Time Values?', 'Confirmation', 'Cancel');

if strcmp(choice, 'Yes')
    time = workspace.expdata(1:end-1, 1);
    workspace.expdata(row, :) = [];
    workspace.expdata(:, 1) = time;
    if ~isempty(workspace.adjdata)
        time = workspace.adjdata(1:end-1, 1);
        workspace.adjdata(row, :) = [];
        workspace.adjdata(:, 1) = time;
    end
    if ~isempty(workspace.normdata)
        time = workspace.normdata(1:end-1, 1);
        workspace.normdata(row, :) = [];
        workspace.normdata(:, 1) = time;
    end
elseif strcmp(choice, 'No')
    workspace.expdata(row, :) = [];
    if ~isempty(workspace.adjdata)
        workspace.adjdata(row, :) = [];
    end
    if ~isempty(workspace.normdata)
        workspace.normdata(row, :) = [];
    end
end

if get(handles.btnToggleAdjTime, 'Value') == 1 && ~isempty(workspace.adjdata)
    set(handles.dataTable, 'Data', workspace.adjdata);
else
    set(handles.dataTable, 'Data', workspace.expdata);
end

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
if ~isempty(workspace.adjdata)
    workspace.adjdata(row, :) = zeros(1, count);
end
if ~isempty(workspace.normdata)
    workspace.normdata(row, :) = zeros(1, count);
end

if get(handles.btnToggleAdjTime, 'Value') == 1 && ~isempty(workspace.adjdata)
    set(handles.dataTable, 'Data', workspace.adjdata);
else
    set(handles.dataTable, 'Data', workspace.expdata);
end

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
if ~isempty(workspace.adjdata)
    workspace.adjdata = [workspace.adjdata(:,1:col-1), zeros(count, 1), workspace.adjdata(:, col:end)];
end
if ~isempty(workspace.normdata)
    workspace.normdata = [workspace.normdata(:,1:col-1), zeros(count, 1), workspace.normdata(:, col:end)];
end

if get(handles.btnToggleAdjTime, 'Value') == 1 && ~isempty(workspace.adjdata)
    set(handles.dataTable, 'Data', workspace.adjdata);
else
    set(handles.dataTable, 'Data', workspace.expdata);
end

function btnDeleteCol_Callback(hObject, eventdata, handles)
global workspace;
global tablepos;
if isempty(tablepos)
    col = size(workspace.expdata, 2);
else
    col = tablepos(2);
end
workspace.expdata(:, col) = [];
if ~isempty(workspace.adjdata)
    workspace.adjdata(:, col) = [];
end
if ~isempty(workspace.normdata)
    workspace.normdata(:, col) = [];
end

if get(handles.btnToggleAdjTime, 'Value') == 1 && ~isempty(workspace.adjdata)
    set(handles.dataTable, 'Data', workspace.adjdata);
else
    set(handles.dataTable, 'Data', workspace.expdata);
end

function btnZeroCol_Callback(hObject, eventdata, handles)

global workspace;
global tablepos;

col = (size(workspace.expdata, 2) + 1) * isempty(tablepos) + (1-isempty(tablepos))*tablepos(2);
count = size(workspace.expdata, 1);
workspace.expdata(:, col) = zeros(count, 1);
if ~isempty(workspace.adjdata)
    workspace.adjdata(:, col) = zeros(count, 1);
end
if ~isempty(workspace.normdata)
    workspace.normdata(:, col) = zeros(count, 1);
end

if get(handles.btnToggleAdjTime, 'Value') == 1 && ~isempty(workspace.adjdata)
    set(handles.dataTable, 'Data', workspace.adjdata);
else
    set(handles.dataTable, 'Data', workspace.expdata);
end

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
    
    if get(handles.btnToggleAdjTime, 'Value') ~= 1
        set(handles.btnToggleAdjTime, 'Value', 1);
    end
    
    set(handles.dataTable, 'Data', workspace.adjdata);
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
    load(workspace.file);
    prepData = struct;
    prepData.alldata = workspace.expdata;
    if ~isempty(workspace.adjdata)
        prepData.time_adjNorm = workspace.adjdata;
    end
    cmdAssign = strcat(workspace.expname, '.analyzeData.nickdata = prepData;');
    eval(cmdAssign);
    [~, filename, ~] = fileparts(workspace.file);
    uisave(workspace.expname, strcat(filename, '.mat'));
elseif strcmp(workspace.status, 'group')
    %% Save ROI group
    load(workspace.file);
    for i = 1:workspace.nDataTypes
        expIdxOffset = 0;
        for j = 1:size(indivData, 2)
            expData = indivData{1, j};
            nExpROI = (size(expData, 2) - 1) / workspace.nDataTypes;
            expData(:, 1) = workspace.adjdata(:, 1);
            
            dataTypeIdx = 2+(i-1)*workspace.numROI;
            srcCols = workspace.adjdata(:, dataTypeIdx + expIdxOffset : dataTypeIdx + expIdxOffset + nExpROI-1);
            expData(:, 2+(i-1)*nExpROI : 1+i*nExpROI) = srcCols;
            expIdxOffset = expIdxOffset + nExpROI;
            indivData{1, j} = expData;
        end
    end
    
    [~, filename, ~] = fileparts(workspace.file);
    uisave('indivData', strcat(filename, '.mat'));
end

function btnAddToGroup_Callback(hObject, eventdata, handles)
global workspace;

[name, path] = uigetfile('*.mat');
if ~isequal(name, 0) && ~isequal(path, 0)
    load(fullfile(path, name));
    if exist('indivData', 'var')
        if isempty(workspace.adjdata)
            warndlg('Please adjust time before adding data to a group');
        elseif size(indivData{1,1}, 1) ~= size(workspace.adjdata, 1)
            warndlg(strcat('The number of rows do not match. Add or remove rows until the length is ', num2str(size(indivData{1,1}, 1))));
        else            
            indivData{1, end+1} = workspace.adjdata;
            indivData{2,end} = workspace.file;
            
            expDetailsTxt = findall(handles.panelDetails, 'Style', 'edit');
            for h = expDetailsTxt
                if ~isempty(get(h, 'String'))
                    choice = questdlg('This group already has experiment details. Do you want to overwrite?', 'Confirmation', 'Cancel');
                    
                    if strcmp(choice, 'Yes')
                        expDetails = struct;
                        expDetails.tyDNA = get(handles.inputDNAType, 'String');
                        expDetails.solBase = get(handles.inputBaseSol, 'String');
                        expDetails.solA = get(handles.inputSolA, 'String');
                        expDetails.solB = get(handles.inputSolB, 'String');
                        expDetails.numBase = str2double(get(handles.inputNumBase, 'String'));
                        expDetails.washStart = str2double(get(handles.inputStartWash, 'String'));
                        save(fullfile(path, name), 'indivData', 'expDetails');
                    elseif strcmp(choice, 'No')
                        save(fullfile(path, name), 'indivData');
                    end
                end
            end
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
    indivData = cell(3, 1);
    indivData{1} = workspace.adjdata;
    indivData{2} = workspace.file;
    
    expDetails = struct;
    expDetails.tyDNA = get(handles.inputDNAType, 'String');
    expDetails.solBase = get(handles.inputBaseSol, 'String');
    expDetails.solA = get(handles.inputSolA, 'String');
    expDetails.solB = get(handles.inputSolB, 'String');
    expDetails.numBase = str2double(get(handles.inputNumBase, 'String'));
    expDetails.washStart = str2double(get(handles.inputStartWash, 'String'));
    
    formatStr = 'ROI2';
    idxFormat = strfind(workspace.expname, formatStr);
    if idxFormat
        groupName = strcat(workspace.expname(1:idxFormat-1), 'ROI');
    else
        groupName = workspace.expname;
    end
    uisave({'averages', 'stdErrs', 'indivData', 'expDetails'}, strcat(groupName, '_group.mat'));
end


%% *********** Plotting Callbacks ***********

function popupData1_Callback(hObject, eventdata, handles)
function popupData2_Callback(hObject, eventdata, handles)
function popupData3_Callback(hObject, eventdata, handles)

function btnPlotSelected_Callback(hObject, eventdata, handles)
global workspace;

useAdj = get(handles.btnToggleAdjTime, 'Value');
useNorm = get(handles.radioUseNormVals, 'Value');

choices = [get(handles.popupData1, 'Value'), get(handles.popupData2, 'Value'), get(handles.popupData3, 'Value')];

if strcmp(workspace.status, 'raw')
    time = workspace.expdata(:, 1);
    dataCols = [workspace.expdata(:, choices(1)+1), workspace.expdata(:, choices(2)+1), workspace.expdata(:, choices(3)+1)];
    plot(time, dataCols, 'o-');
    xlabel('Time');
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
   xlabel('Time');
   colNames = get(handles.dataTable, 'ColumnName');
   choiceNames = colNames(choices+1);
   legend(choiceNames);
end

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
            idxZero = find(~workspace.adjdata);
            numBaseline = idxZero(1);
            
            
            %% Calculate the coefficient for normalization for each column ( k = nBase / sum(x, 1->nBase) )
            factors = (numBaseline * ones(1, size(workspace.adjdata(:, 2:end), 2))) ./ sum(workspace.adjdata(1:numBaseline, 2:end), 1);
            
            %% Multiply each column by the coefficent to get the normalized values
            for i=1:length(factors)
                workspace.normdata(:, i+1) = factors(i)*workspace.adjdata(:, i+1);
            end
        end
    end
end

function radioOverlapData_Callback(hObject, eventdata, handles)

function btnPlotAll_Callback(hObject, eventdata, handles)
global workspace;

%% Get the plotting preferences
useAdj = get(handles.btnToggleAdjTime, 'Value');
useNorm = get(handles.radioUseNormVals, 'Value');

if strcmp(workspace.status, 'raw')
    time = workspace.expdata(:, 1);
    allData = workspace.expdata;
    %% Setup a figure with mutlitple graphs
    figure('Name', workspace.expname);
    
    if workspace.nDataTypes == 2
        ylabels = {'Green Intensity' , 'Red Intensity'};
    elseif workspace.nDataTypes == 3
        ylabels = {'Lifetime', 'Green Intensity' , 'Red Intensity'};
    end
    
    %% Go through each datatype
    for i = 1:workspace.nDataTypes
        subplot(workspace.nDataTypes, 1, i);
        plot(time, allData(:, 2+(i-1)*workspace.numROI:1+i*workspace.numROI), 'o-');
        dataLabels = get(handles.dataTable, 'ColumnName');
        legend(dataLabels(2+(i-1)*workspace.numROI:1+i*workspace.numROI));
        xlabel('Time');
        ylabel(ylabels{i});
    end
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14);
elseif strcmp(workspace.status, 'prepared') || strcmp(workspace.status, 'group')    
    if useAdj == 1
        if isempty(workspace.adjdata)
            %% Use unadjusted time values if adjusted values are preferred but unavailable
            msgbox('Time values are unadjusted. Using unadjusted values');
            set(handles.btnToggleAdjTime, 'Value', 0.0);
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
    figure('Name', workspace.expname);
    
    if workspace.nDataTypes == 2
        ylabels = {'Green Intensity', 'Red Intensity'};
    elseif workspace.nDataTypes == 3
        ylabels = {'Lifetime', 'Green Intensity', 'Red Intensity'};
    end
    
    %% Go through each datatype
    for i = 1:workspace.nDataTypes
        subplot(workspace.nDataTypes, 1, i);
        plot(time, allData(:, 2+(i-1)*workspace.numROI:1+i*workspace.numROI), 'o-');
        dataLabels = get(handles.dataTable, 'ColumnName');
        legend(dataLabels(2+(i-1)*workspace.numROI:1+i*workspace.numROI));
        xlabel('Time');
        ylabel(ylabels{i});
    end
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14);
end


%% *********** Results Callbacks ***********

function btnAverage_Callback(hObject, eventdata, handles)

%% Get current workspace data
    global workspace;

%% Get time column, either adjusted or unadjusted
    if isempty(workspace.adjdata)
        time = workspace.expdata(:, 1);
    else
        time = workspace.adjdata(:, 1);
    end

%% Make a new figure + struct to plot averages
    figure('Name', strcat(workspace.expname, ' Averages'));
    avgData = cell(2, workspace.nDataTypes);
    
    if workspace.nDataTypes == 2
        ylabels = {'Green Intensity', 'Red Intensity'};
    elseif workspace.nDataTypes == 3
        ylabels = {'Lifetime', 'Green Intensity', 'Red Intensity'};
    end
    
%% Loop through each data type
    for i = 1:workspace.nDataTypes
        
    %% Calculate the average + std err of all columns of current data type
        subplot(workspace.nDataTypes, 1, i);
        avgData{1, i} = workspace.expdata(:, 2+(i-1)*workspace.numROI:1+i*workspace.numROI);
        avgData{1, i} = mean(avgData{1, i}, 2);
        avgData{2, i} = std(avgData{1, i}, 0, 2) / size(avgData{1, i}, 1) ^ 0.5;
    
    %% Plot calculations
        errorbar(time, avgData{1, i}, avgData{2, i}, 'o-', 'color', 'k');
        xlabel('Time');
        ylabel(ylabels{i});
    end
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14);
    
function btnResults_Callback(hObject, eventdata, handles)
%% Get the current workspace data - should be group data
    global workspace;

%% Check if adjusted values exist, stop otherwise
    if isempty(workspace.adjdata)
        warndlg('Please adjust values before saving results');
        return;
    end

%% Get all columns + time column
    all_data = workspace.adjdata;
    time = workspace.adjdata(:, 1);
    
%% Get the # of base pts
    idxZero = find(~time);
    num = idxZero(1);

%% Check if data is normalized
if isempty(workspace.normdata)
    
    %% Set up vars for normalization
        workspace.normdata = workspace.adjdata;
        numBaseline = num;
    
    %% Get the coefficent for normalization ( k_x = n_base / sum(x, 1->n_base) )
        factors = (numBaseline * ones(1, size(workspace.normdata(:, 2:end), 2))) ./ sum(workspace.normdata(1:numBaseline, 2:end), 1);
        
    %% Multiply each data column by the corresponding coefficient
        for i=1:length(factors)
            workspace.normdata(:, i+1) = factors(i)*workspace.normdata(:, i+1);
        end
end

%% Get the normalized data
    norm_data = workspace.normdata;

%% Get columns of data based on # of data types
    if workspace.nDataTypes < 3           
        
    %% Get columns for int,red
        tau = [];
        tauNorm = [];
        int = all_data(:,2:2+workspace.numROI-1);
        intNorm = norm_data(:,2:2+workspace.numROI-1);
        red = all_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
        redNorm = norm_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));

    else
        
    %% Get columns for tau,int,red
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
mean_IntNorm = mean(intNorm, 2);
ste_Int = std(int, 0, 2) / size(int, 1) ^ 0.5;
ste_IntNorm = std(intNorm, 0, 2) / size(intNorm, 1) ^ 0.5;
mean_redInt = mean(red, 2);
mean_redIntNorm = mean(redNorm, 2);
ste_redInt = std(red, 0, 2) / size(red, 1) ^ 0.5;
ste_redIntNorm = std(redNorm, 0, 2) / size(redNorm, 1) ^ 0.5;


expDetails = struct;
expDetails.tyDNA = get(handles.inputDNAType, 'String');
expDetails.solBase = get(handles.inputBaseSol, 'String');
expDetails.solA = get(handles.inputSolA, 'String');
expDetails.solB = get(handles.inputSolB, 'String');
expDetails.numBase = str2double(get(handles.inputNumBase, 'String'));
expDetails.washStart = str2double(get(handles.inputStartWash, 'String'));

%% Save data + calculations
uisave({'expDetails', 'num', 'all_data', 'time', 'mean_tau', 'mean_tauNorm', 'ste_tau', 'ste_tauNorm', 'mean_Int', 'ste_Int', 'mean_IntNorm', 'ste_IntNorm','mean_redInt', 'ste_redInt', 'mean_redIntNorm','ste_redIntNorm'}, strcat(workspace.expname, '_results.mat'));

function btnAddResults_Callback(hObject, eventdata, handles)
global workspace;

[name, path] = uigetfile('*.mat');

if ~isequal(name, 0) && ~isequal(path, 0)
    load(fullfile(path, name));
    
    if exist('all_data', 'var') && exist('mean_Int', 'var')       
        
        if isempty(workspace.adjdata)
            warndlg('Please adjust values before saving results');
            return;
        end
        
        if ~iscell(all_data)
            all_data = {all_data};
        end

        allData = workspace.adjdata;
        all_data{end+1} = allData;
        time = [time, workspace.adjdata(:, 1)];

        
        if isempty(workspace.normdata)
            workspace.normdata = workspace.adjdata;
            numBaseline = num;
            factors = (numBaseline * ones(1, size(workspace.normdata(:, 2:end), 2))) ./ sum(workspace.normdata(1:numBaseline, 2:end), 1);
            for i=1:length(factors)
                workspace.normdata(:, i+1) = factors(i)*workspace.normdata(:, i+1);
            end
        end

        norm_data = workspace.normdata;

        %% Get columns of data based on # of data types
        if workspace.nDataTypes < 3           

        %% Get columns for int,red
            tau = [];
            tauNorm = [];
            int = allData(:,2:2+workspace.numROI-1);
            intNorm = norm_data(:,2:2+workspace.numROI-1);
            red = allData(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
            redNorm = norm_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));

        else

        %% Get columns for tau,int,red
            tau = allData(:,2:2+workspace.numROI-1);
            tauNorm = norm_data(:,2:2+workspace.numROI-1);
            int = allData(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
            intNorm = norm_data(:,2+workspace.numROI:2+workspace.numROI+(workspace.numROI-1));
            red = allData(:,2+2*workspace.numROI:2+2*workspace.numROI+(workspace.numROI-1));
            redNorm = norm_data(:,2+2*workspace.numROI:2+2*workspace.numROI+(workspace.numROI-1));
        end

        %% Calculate column averages + std. errs
        mean_tau = [mean_tau, mean(tau, 2)];
        mean_tauNorm = [mean_tauNorm, mean(tauNorm, 2)];
        ste_tau = [ste_tau, std(tau, 0, 2) / size(tau, 1) ^ 0.5];
        ste_tauNorm = [ste_tauNorm, std(tauNorm, 0, 2) / size(tauNorm, 1) ^ 0.5];
        mean_Int = [mean_Int, mean(int, 2)];
        mean_IntNorm = [mean_IntNorm, mean(intNorm, 2)];
        ste_Int = [ste_Int, std(int, 0, 2) / size(int, 1) ^ 0.5];
        ste_IntNorm = [ste_IntNorm, std(intNorm, 0, 2) / size(intNorm, 1) ^ 0.5];
        mean_redInt = [mean_redInt, mean(red, 2)];
        mean_redIntNorm = [mean_redIntNorm, mean(redNorm, 2)];
        ste_redInt = [ste_redInt, std(red, 0, 2) / size(red, 1) ^ 0.5];
        ste_redIntNorm = [ste_redIntNorm, std(redNorm, 0, 2) / size(redNorm, 1) ^ 0.5];
        
        
        if ~iscell(expDetails)
            expDetails = {expDetails};
        end
        expDetails{end+1} = struct;
        expDetails{end}.tyDNA = get(handles.inputDNAType, 'String');
        expDetails{end}.solBase = get(handles.inputBaseSol, 'String');
        expDetails{end}.solA = get(handles.inputSolA, 'String');
        expDetails{end}.solB = get(handles.inputSolB, 'String');
        expDetails{end}.numBase = str2double(get(handles.inputNumBase, 'String'));
        expDetails{end}.washStart = str2double(get(handles.inputStartWash, 'String'));
        
        save(fullfile(path, name), 'all_data', 'time', 'mean_tau', 'mean_tauNorm', 'ste_tau', 'ste_tauNorm', 'mean_Int', 'ste_Int', 'mean_IntNorm', 'ste_IntNorm','mean_redInt', 'ste_redInt', 'mean_redIntNorm','ste_redIntNorm', 'expDetails', '-append');
    end
    
end

function btnBrowseResults_Callback(hObject, eventdata, handles)
[name, path] = uigetfile('*.mat');

if ~isequal(name, 0) && ~isequal(path, 0)
    load(fullfile(path, name));
    
    if isempty(mean_tau)
        nDataTypes = 2;
    else
        nDataTypes = 3;
    end
    
    if iscell(all_data)
        nROI = (size(all_data{1}, 2) - 1) / nDataTypes;
    else
        nROI = (size(all_data, 2) - 1) / nDataTypes;
    end
    if iscell(expDetails)
        expNames = cell2mat(expDetails);
        expNames = expNames(:).tyDNA;
    else
        expNames = expDetails.tyDNA;
    end
    
    winRC = get(0, 'Screensize');
    figRC = [winRC(1), winRC(2), winRC(3) / 2, winRC(4) * 0.8];
    figure('Name', 'Original Values');    
    
    if nDataTypes == 3
        subplot(nDataTypes, 1, 1);
        errorbar(time, mean_tau, ste_tau, 'o-', 'color', 'k', 'LineWidth', 2, 'MarkerSize', 10);
        xlabel('Time (min)');
        ylabel('Lifetime');
        xLim = get(gca, 'xlim');
        yLim = get(gca, 'ylim');
        line(time([expDetails.numBase, expDetails.washStart]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6);
        line(time([expDetails.washStart, end]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6, 'linestyle', ':');
        legend(strcat(expNames,',n=',num2str(nROI)));
    end    
    set(findall(gcf,'-property','FontSize'),'FontSize', 16)
    set(gcf, 'Position', figRC);
    
    
    
    subplot(nDataTypes, 1, 2);
    errorbar(time, mean_Int, ste_Int, 'o-', 'color', 'k', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('Time (min)');
    ylabel('Intensity');
    xLim = get(gca, 'xlim');
    yLim = get(gca, 'ylim');
    line(time([expDetails.numBase, expDetails.washStart]), [yLim(2) * 0.99, yLim(2) * 0.99], 'color', 'k', 'LineWidth', 6);
    line(time([expDetails.washStart, end]), [yLim(2) * 0.99, yLim(2) * 0.99], 'color', 'k', 'LineWidth', 6, 'linestyle', ':');
    annotation('textbox', 'Position', [.1 .9 .1 .1], 'String', expDetails.solBase, 'LineStyle', 'none'); 
    annotation('textbox', 'Position', [.3 .9 .1 .1], 'String', expDetails.solA, 'LineStyle', 'none'); 
    annotation('textbox', 'Position', [.7 .9 .1 .1], 'String', expDetails.solB, 'LineStyle', 'none'); 
    legend(strcat(expNames,',n=',num2str(nROI)));
    
    subplot(nDataTypes, 1, 2);
    errorbar(time, mean_redInt, ste_redInt, 'o-', 'color', 'k', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('Time (min)');
    ylabel('Red Intensity')
    xLim = get(gca, 'xlim');
    yLim = get(gca, 'ylim');
    
    %{
    x1 = expDetails.numBase * expDetails.numBase / ((xLim(2) - xLim(1)) * 1.5);
    x2 = expDetails.washStart * expDetails.washStart / ((xLim(2) - xLim(1)) * 1.5);
    
    annotation('line', [x1, x1], [0.1, 0.9]);
    annotation('line', [x2, x2], [0.1, 0.9]);
    %}
    line(time([expDetails.numBase, expDetails.washStart]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6);
    line(time([expDetails.washStart, end]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6, 'linestyle', ':');
    legend(strcat(expNames,',n=',num2str(nROI)));
    
    
    figure('Name', 'Normalized Values');    
    subplot(nDataTypes, 1, 3);
    errorbar(time, mean_IntNorm, ste_IntNorm, 'o-', 'color', 'k', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('Time (min)');
    ylabel('Norm. Intensity');
    xLim = get(gca, 'xlim');
    yLim = get(gca, 'ylim');
    line(time([expDetails.numBase, expDetails.washStart]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6);
    line(time([expDetails.washStart, end]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6, 'linestyle', ':');
    annotation('textbox', 'Position', [.1 .9 .1 .1], 'String', expDetails.solBase, 'LineStyle', 'none'); 
    annotation('textbox', 'Position', [.3 .9 .1 .1], 'String', expDetails.solA, 'LineStyle', 'none'); 
    annotation('textbox', 'Position', [.7 .9 .1 .1], 'String', expDetails.solB, 'LineStyle', 'none'); 
    legend(strcat(expNames,',n=',num2str(nROI)));
    
    subplot(nDataTypes, 1, 2);
    errorbar(time, mean_redIntNorm, ste_redIntNorm, 'o-', 'color', 'k', 'LineWidth', 2, 'MarkerSize', 10);
    xlabel('Time (min)');
    ylabel('Norm. Red Intensity');
    xLim = get(gca, 'xlim');
    yLim = get(gca, 'ylim');
    line(time([expDetails.numBase, expDetails.washStart]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6);
    line(time([expDetails.washStart, end]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6, 'linestyle', ':');
    legend(strcat(expNames,',n=',num2str(nROI)));
    
    if nDataTypes == 3
        subplot(nDataTypes, 1, 1);
        errorbar(time, mean_tauNorm, ste_tauNorm, 'o-', 'color', 'k', 'LineWidth', 2, 'MarkerSize', 10);
        xlabel('Time (min)');
        ylabel('Norm. Lifetime');
        xLim = get(gca, 'xlim');
        yLim = get(gca, 'ylim');
        line(time([expDetails.numBase, expDetails.washStart]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6);
        line(time([expDetails.washStart, end]), [yLim(2) * 0.99 , yLim(2) * 0.99 ], 'color', 'k', 'LineWidth', 6, 'linestyle', ':');
        legend(strcat(expNames,',n=',num2str(nROI)));
    end
    set(findall(gcf,'-property','FontSize'),'FontSize', 16)
    set(gcf, 'Position', figRC);
end




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

set(handles.figure1, 'Name', strcat('Workspace file: ', workspace.expname, '| Workspace File Type: ', workspace.status));
if isempty(workspace.status) || strcmp(workspace.status, 'none')
    %% Disable almost all ui
    set(handles.dataTable, 'Data', []);
    set(handles.dataTable, 'ColumnName', {});
    set(handles.btnToggleAdjTime, 'Value', 0.0);
    set(handles.radioUseNormVals, 'Value', 0.0);
    set(findall(handles.panelDetails, '-property', 'Enable'), 'Enable', 'off');
    set(findall(handles.panelDetails, 'Style', 'Edit'), 'String', ' ');
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'off');
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'off');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'off');
elseif strcmp(workspace.status, 'raw')
    %% Enable some editting
    set(handles.dataTable, 'ColumnEditable', true(1, size(workspace.expdata, 2)));
    set(findall(handles.panelDetails, '-property', 'Enable'), 'Enable', 'off');
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
    set(handles.btnAdjustTime, 'Enable', 'off');
    set(handles.btnToggleAdjTime, 'Value', 0.0);
    set(handles.radioUseNormVals, 'Value', 0.0);
    set(handles.btnToggleAdjTime, 'Enable', 'off');
    set(handles.btnAddToGroup, 'Enable', 'off');
    set(handles.btnNewGroup, 'Enable', 'off');
    %% Enable most plotting
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
    set(handles.radioUseNormVals, 'Enable', 'off');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'off');
elseif strcmp(workspace.status, 'prepared')
    %% Enable almost all
    set(handles.dataTable, 'ColumnEditable', true(1, size(workspace.expdata, 2)));
    set(findall(handles.panelDetails, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'on');
elseif strcmp(workspace.status, 'group')
    %% Enable almost all
    set(handles.dataTable, 'ColumnEditable', true(1, size(workspace.expdata, 2)));
    set(findall(handles.panelDetails, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelResults, '-property', 'Enable'), 'Enable', 'on');
    set(handles.btnFixROI, 'Enable', 'off');
    set(handles.btnAdjustTime, 'Enable', 'off');
    set(handles.btnToggleAdjTime, 'Enable', 'off');
    set(handles.btnAddToGroup, 'Enable', 'off');
    set(handles.btnNewGroup, 'Enable', 'off');
end
