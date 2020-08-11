function varargout = analysis_1_2_IB(varargin)
% analysis_1_2_IB MATLAB code for analysis_1_2_IB.fig
%      analysis_1_2_IB, by itself, creates a new analysis_1_2_IB or raises the existing
%      singleton*.
%
%      H = analysis_1_2_IB returns the handle to a new analysis_1_2_IB or the handle to
%      the existing singleton*.
%
%      analysis_1_2_IB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in analysis_1_2_IB.M with the given input arguments.
%
%      analysis_1_2_IB('Property','Value',...) creates a new analysis_1_2_IB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysis_1_2_IB

% Last Modified by GUIDE v2.5 01-Jul-2019 13:36:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_070119_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_070119_OutputFcn, ...
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
% End initialization code - DO NOT EDIT

% --- Executes just before analysis_1_2_IB is made visible.
function analysis_1_2_IB_070119_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysis_1_2_IB (see VARARGIN)

% Choose default command line output for analysis_1_2_IB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analysis_1_2_IB wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = analysis_1_2_IB_070119_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%--------------------- Begin customized code --------------------------%

function update_ui(handles)
    global workspace;
    
    if strcmp(workspace.status, 'none')
        %% Disable Plotting
        set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'off');
        %% Disable Editting
        set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'off');
        %% Disable Saving
        set(findall(handles.panelSave, '-property', 'Enable'), 'Enable', 'off');
    elseif strcmp(workspace.status, 'preview')
        %% Enable Plotting
        set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
        %% Enable Editting
        set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
        %% Disable Saving
        set(findall(handles.panelSave, '-property', 'Enable'), 'Enable', 'off');
    elseif strcmp(workspace.status, 'adjust') ||  strcmp(workspace.status, 'results')
        %% Enable all
        set(findall(handles.panelPlot, '-property', 'Enable'), 'Enable', 'on');
        set(findall(handles.panelEdit, '-property', 'Enable'), 'Enable', 'on');
        set(findall(handles.panelSave, '-property', 'Enable'), 'Enable', 'on');
    end

function clear_workspace()
    global workspace;
    workspace.status = 'none';
    workspace.vars.file = '';
    workspace.vars.expname = '';
    workspace.vars.expdata = [];
    cd('C:');

% --- Executes during object creation, after setting all properties.
function idealsTable_CreateFcn(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
% hObject    handle to idealsTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% num = str2double(get(handles.num_baseline,'String'));
handles.numIdeals=33;
handles.num = 5;
% handles.numIdeals = str2double(get(hObject,'String'));
d = cell(handles.numIdeals,2); % default number of ideal times is 19
d(:,1) = num2cell(false(handles.numIdeals,1)); % initialize checkboxes to be unchecked
% default ideal times
d(:,2) = num2cell(-(handles.num-1)*1.33:1.33:(handles.numIdeals-handles.num)*1.33);
% d(:,2) = {-28, -21, -14, -7, 0, 2, 9, 16, 23, 30, 37, 44, 51, 58, 65, 72, 79, 86, 93};
set(hObject, 'Data', d);
set(hObject, 'RowName', {}, 'ColumnWidth', {25, 'auto'},'ColumnName', {'','Ideal Time'}, 'ColumnFormat', {'logical','numeric'}, 'ColumnEditable', [true,true]);

% callback function for dialog box in browse_Callback that chooses which data to load
function chooseVar(source, callbackdata, handles)
global data;
global stds;
global struct; % the 'nickdata' struct from the ROI file
global d;
% get string from popup menu in dialog box
index = get(source, 'Value');
items = get(source, 'String');
% set data to the matrix whose name was selected
eval(['data = struct.' char(items(index)) ';']);
% initialize standard errors to zero
stds = zeros(size(data));
% delete dialog box after data selection
delete(d);

% --- Executes on button press in btnBrowsePrep.
function btnBrowsePrep_Callback(hObject, eventdata, handles)

%% New IB Code Below
%{
%% Load workspace + browse file
global workspace;

[name, path] = uigetfile('*.mat');
try 
    load(fullfile(path, name))
catch loaderr
    %% Error while loading file
    clear_workspace();
    update_ui(handles);
    msgbox('Could not open file');
    disp(strcat('Avoided error: ', loaderr.identifier));
end

%% Successfully loaded file
cd(path);
workspace.vars.file = fullfile(path, name);
[~, workspace.vars.expname, ~] = fileparts(workspace.vars.file);

if exist(workspace.vars.expname, 'var')
    %% Handle ROI File
    try 
        evalc(['workspace.vars.expdata = ', workspace.vars.expname, '.analyzeData.nickdata.alldata']);
    catch evalerr
        %% File is not prepared
        clear_workspace();
        update_ui(handles);
        msgbox('ROI File is not prepared');
        disp(strcat('Avoided error: ', evalerr.identifier));
    end
    workspace.status = 'adjust';
    
    toggleAdjVal = get(handles.btnToggleAdj, 'Value');
    if toggleAdjVal == 1
        %% Find adjusted values
        try
            eval(['workspace.vars.expdata = ', workspace.vars.expname, 'analyzeData.nickdata.timeAdj_norm']);
        catch evalerr
            msgbox('ROI File has no adjusted values. Showing unadjusted values.');
            disp(strcat('Avoided error: ', evalerr.identifier));
            set(handles.btnToggleAdj, 'Value', 0.0);
        end
    end
    %% Setup labels
    numROI = (size(workspace.vars.expdata, 2) - 1) / 3;
    colLabels = cell(1, numROI * 3 + 1);
    colLabels{1} = 'time';
    for i = 1:numROI
        colLabels{1+i} = strcat('lifetime @', num2str(i));
        colLabels{numROI+i+1} = strcat('intensity @', num2str(i));
        colLabels{numROI+numROI+i+1} = strcat('red @', num2str(i));
    end
    
    %% Update Plotting Options
    plotOptions = [{'Choose Column'}, colLabels(2:end)];
    set(handles.dropNewGraph1, 'String', plotOptions);
    set(handles.dropNewGraph2, 'String', plotOptions);
    set(handles.dropNewGraph3, 'String', plotOptions);
    %% Show values
    set(handles.dataTable, 'ColumnName', colLabels);
    set(handles.dataTable, 'Data', workspace.vars.expdata);
elseif exist('averages', 'var') && exist('indivData', 'var')
    %% Handle Averages File
    workspace.status = 'results';
    workspace.vars.expdata = [];
    maxTime = [];
    for i = 1:3 %Each data col
        for j = 1:size(indivData, 2)
            expInst = indivData{1, j};
            expTime = expInst(:, 1);
            if length(expTime) > length(maxTime)
                maxTime = expTime;
            end
            numROI = (size(expInst, 2) - 1) / 3;
            expLen = size(expInst, 1);
            instData = expInst(:, (i-1)*numROI + 2 : 1 + (i*numROI));
            workspace.vars.expdata(1:expLen, end+1:end+numROI) = instData;
        end
    end
    workspace.vars.expdata = [maxTime, workspace.vars.expdata];
    set(handles.dataTable, 'Data', workspace.vars.expdata);
else
    %% Handle unsupported file
    clear_workspace();
    update_ui(handles);
    msgbox('File not supported');
end
update_ui(handles);
%}

%% CZ Code

global data;
global stds;
global fileName;
global pathName;
global struct;
global all_data_tau;
global all_data_Int;
global all_data_redInt;
global d;
global default;
global all_data;
% hObject    handle to btnBrowsePrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName,pathName] = uigetfile('*.mat');
load(fullfile(pathName,fileName),'-mat');
cd(pathName);

set(handles.figure1, 'Name', fullfile(pathName,fileName));
set(handles.btnClearAll, 'Enable', 'on');
set(handles.btnFixROI, 'Enable', 'off');
set(handles.btnSaveFix, 'Enable', 'off');

set(handles.newGraph, 'Enable', 'on');
set(handles.dropNewGraph1, 'Enable', 'on');
set(handles.dropNewGraph2, 'Enable', 'on');
set(handles.dropNewGraph3, 'Enable', 'on');
set(handles.toggleTime, 'Enable', 'on');
set(handles.makeDefGraph, 'Enable', 'on');

set(handles.destination, 'Enable', 'on');
set(handles.newFile, 'Enable', 'on');
set(handles.save, 'Enable', 'on');
set(handles.Average, 'Enable', 'on');
set(handles.btnPlotResults, 'Enable', 'on');


idxFormat = strfind(fileName, 'ROI2');
if idxFormat % file is ROI File
    format long; % may not be need, but makes sure data is calculated correctly
    if isempty(idxFormat) % averages file instead of indiv file
        set(handles.lblStatus, 'String', 'Viewing ROI Averages');
        data = averages;
        stds = stdErrs;
    else % individ file
        set(handles.lblStatus, 'String', 'Viewing Prepared ROI File');
        trunc = fileName(1:idxFormat+3); % truncate everything after 'ROI2'
        % create dialog box for data selection
        d = dialog('Name','Choose Data','Position',[500 500 300 120]);
        txt = uicontrol('Parent',d,'Style','text','Position',[50 50 210 40],'String','Choose which data to load from the file:');
        % using eval because we need to use the string stored in trunc, not the string trunc itself
        eval(sprintf('vars = fieldnames(%s.analyzeData.nickdata)'';', trunc));
        eval(sprintf('struct = %s.analyzeData.nickdata;', trunc));
        %********by Cong on 08/10/18
        %     eval(sprintf('vars = fieldnames(%s.analyzeData)'';', trunc));
        %     eval(sprintf('struct = %s.analyzeData;', trunc));
        %*********end
        % callback for the popupmenu is the function chooseVar above
        menu = uicontrol('Parent',d,'Position',[80 20 150 30],'Style','popupmenu','String',vars,'Callback',@chooseVar);
    end
    % pause if the dialog box is still open, so that data doesn't get set yet
    while ishandle(d)
        pause(0.5);
    end
    % create or load file with default columns
    if exist(fullfile(pathName,'defaultColumns.mat')) ~=2 % if it doesn't exist
        % set the default column names
        %{
        columns(1,:) = {'Time','S1G','S2G','Dend_G','S1R','S2R','Dend_R','(S1g/Dg)/(S1r/Dr)','(S2g/Dg)/(S2r/Dr)','Image','S1G/S1R','S2G/S2R','(S1G/S1R)/(S2G/S2R)','S1G/S2G'};
        columns(1,:) = {'Time','S1G','S2G','Dend_G','S1R','S2R','Dend_R','(S1g/Dg)/(S1r/Dr)','(S2g/Dg)/(S2r/Dr)','Image','S1G/S1R','S2G/S2R','(S1G/S1R)/(S2G/S2R)','S1G/S2G', 'BA(S1):S1G-(DG/DR)*S1R', 'BA(S2):S2G-(DG/DR)*S2R', 'BA(S1)/BA(S2)'};
        columns(1,:) = {'time','tau_m1','tau_m2', 'tau_m3','tau_m4','mean_Int1','mean_Int2','mean_Int3','mean_Int4','Red_mean1','Red_mean2','Red_mean3','Red_mean4'};
        columns(1,:) = {'time','tau_m1','tau_m2', 'tau_m3','tau_m4','mean_Int1','mean_Int2','mean_Int3','mean_Int4','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan','Nan'};
        %}
         columns(1,:) = {'time','1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29'};
        % set the column formulas for non default columns
        %{
        columns(2,:) = {'','','','','','','','','','','data(:,2)./data(:,5)','data(:,3)./data(:,6)','data(:,11)./data(:,12)','data(:,2)./data(:,3)'};
        columns(2,:) = {'','','','','','','','','','','data(:,2)./data(:,5)','data(:,3)./data(:,6)','data(:,11)./data(:,12)','data(:,2)./data(:,3)', 'data(:,2)-data(:,4)./data(:,7).*data(:,5)','data(:,3)-data(:,4)./data(:,7).*data(:,6)', 'data(:,15)./data(:,16)'};
        %}
        columns(2,:) = {'','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''};
        cols = columns;
        % create a new file with default columns
        save(fullfile(pathName,'defaultColumns.mat'), 'cols');
    else % if file already exists
        load(fullfile(pathName,'defaultColumns.mat'));
        columns = cols;
    end
    if ~isempty(idxFormat) % if an individual ROI file was opened
        s = size(columns,2); % number of columns
        for i=31:s% i=11:s % for any columns greater than 10 (which is the default ROI data)
            data(:,i) = eval(columns{2,i});
        end
        % set standard errors to zero, since it's an individual experiment
        stds = zeros(size(data));
    end
    set(handles.dataTable, 'Data', data, 'ColumnName', columns(1,:));
    % display the column numbers above the data
    % set(handles.numbersTable, 'ColumnName', 1:size(data,2));
    % set the graphing popup menus
    pmOptions = columns(1,:);
    pmOptions{1} = 'Blank';
    set(handles.dropNewGraph1, 'String', pmOptions);
    set(handles.dropNewGraph2, 'String', pmOptions);
    set(handles.dropNewGraph3, 'String', pmOptions);
    % create or load file with default graphs
    if exist(fullfile(pathName,'defaultGraphs.mat')) ~=2 % if it doesn't exist
        % set the 5 original default graphs
        default = {[5 6 7] [2 3 4] [15 16 17]};
        def = default;
        save(fullfile(pathName,'defaultGraphs.mat'), 'def');
    else % file already exists
        load(fullfile(pathName,'defaultGraphs.mat'));
        default = def;
    end
    %refresh the destination dropdown
    results = dir(fullfile(pathName,'*average*.mat'));
    list = {'New File'};
    for i=1:size(results,1)
        list{end+1} = results(i).name;
    end
    set(handles.destination,'String',list);
else
    if exist('indivData')
        all_data_tau=[];
        all_data_Int=[];
        all_data_redInt=[];
        all_data=[];
        for i=1:size(indivData,2)
            roi_num(i)=(size(indivData{1,i},2)-1)/3;%****3 means tau, int, red_intensity
            for j=1:roi_num(i)  
                if i==1
                    all_data_tau(:,j) = indivData{1,i}(:,j+1);
                    all_data_Int(:,j) = indivData{1,i}(:,j+1+roi_num(i));
                    all_data_redInt(:,j) = indivData{1,i}(:,j+1+2*roi_num(i));
                else
                    all_data_tau(:,sum(roi_num(1:i-1))+j) = indivData{1,i}(:,j+1);
                    all_data_Int(:,sum(roi_num(1:i-1))+j) = indivData{1,i}(:,j+1+roi_num(i));
                    all_data_redInt(:,sum(roi_num(1:i-1))+j) = indivData{1,i}(:,j+1+2*roi_num(i));
                end
            end
        end
    end
    all_data(:,1) = indivData{1,1}(:,1);
    all_data(:,2:size(all_data_tau,2)*3+1) = [all_data_tau all_data_Int all_data_redInt];
    set(handles.dataTable, 'Data', all_data);
    %set(handles.numbersTable, 'ColumnName', 1:i*size(all_data,2));
     columns(1,:) = {'time','1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29'};
     pmOptions = columns(1,:);
    pmOptions{1} = 'Blank';
    set(handles.dropNewGraph1, 'String', pmOptions);
    set(handles.dropNewGraph2, 'String', pmOptions);
    set(handles.dropNewGraph3, 'String', pmOptions);
end

function num_ideals_Callback(hObject, eventdata, handles)
% hObject    handle to num_ideals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.num = str2double(get(handles.num_baseline,'String'));
handles.numIdeals = str2double(get(hObject,'String'));
current = get(handles.idealsTable, 'Data');
% shorten or lengthen the table of ideal times according to input
if handles.numIdeals <= size(current,1)
    current = current(1:handles.numIdeals,:);
else
    current(end+1:handles.numIdeals,:) = cell(handles.numIdeals-size(current,1),2);
    current(:,1) = num2cell(false(handles.numIdeals,1)); % initialize checkboxes to be unchecked
    current(:,2) = num2cell(-(handles.num-1)*1.33:1.33:(handles.numIdeals-handles.num)*1.33);
end
set(handles.idealsTable, 'Data', current);
% d(:,1) = num2cell(false(handles.numIdeals,1)); % initialize checkboxes to be unchecked
% % default ideal times
% d(:,2) = num2cell(-(handles.num-1)*1.33:1.33:(handles.numIdeals-handles.num)*1.33);
% % d(:,2) = {-28, -21, -14, -7, 0, 2, 9, 16, 23, 30, 37, 44, 51, 58, 65, 72, 79, 86, 93};
% set(hObject, 'Data', d);
% set(hObject, 'RowName', {}, 'ColumnWidth', {25, 'auto'},'ColumnName', {'','Ideal Time'}, 'ColumnFormat', {'logical','numeric'}, 'ColumnEditable', [true,true]);

% --- Executes when entered data in editable cell(s) in idealsTable.
function idealsTable_CellEditCallback(hObject, eventdata, handles) %#ok<*INUSD>
global idealRow;
% hObject    handle to idealsTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
% handles    structure with handles and user data (see GUIDATA)
data = get(hObject,'Data'); % get the data cell array of the table
cols = get(hObject,'ColumnFormat'); % get the column formats
if strcmp(cols(eventdata.Indices(2)),'logical') % if the column of the edited cell is logical
    if eventdata.EditData % if the checkbox was set to true
        data{eventdata.Indices(1),eventdata.Indices(2)}=true; % set the data value to true
        idealRow(eventdata.Indices(1),1) = 1; % set the idealRow value to true
    else % if the checkbox was set to false
        data{eventdata.Indices(1),eventdata.Indices(2)}=false; % set the data value to false
        idealRow(eventdata.Indices(1),1) = 0; % set the idealRow value to false
    end
end
set(hObject,'Data',data); % now set the table's data to the updated data cell array

% --- Executes when selected cell(s) is changed in dataTable.
function dataTable_CellSelectionCallback(hObject, eventdata, handles)
global dataRow;
global dataCol;
% hObject    handle to dataTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% take indices of selected cells in data table and put them into row and
% column variables
dataRow = eventdata.Indices(:,1);
dataCol = eventdata.Indices(:,2);

% --- Executes on button press in timeAdj.
function timeAdj_Callback(hObject, eventdata, handles)
global data;
% hObject    handle to timeAdj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblStatus, 'String', 'Adjusted Time Data');
handlles.num = str2double(get(handles.num_baseline,'String'));
% adjust the time based on the number of baseline points given by user
data(:,1) =(data(:,1)-data(1,1))*60*24;
data(:,1) = data(:,1) - data(handlles.num,1); % timepoint at num becomes 0
% normalize every column to the baseline except for image column
% for i = 2:size(data,2)
%     if i ~= 10
%         %*add by cong
% %        data(:,i)= (data(:,i)-min(data(:,i)))*60*24; 
%        %*end
%        data(:,i) = data(:,i) / mean(data(1:num,i));
%     end
% end

%  data(:,1)= data(:,1)/ mean(data(1:num,1));
%        data(:,i) = data(:,i) / mean(data(1:num,i));

set(handles.dataTable, 'Data', data);

% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
global times;
global all_data;
global all_data_tau;
global all_data_Int;
global all_data_redInt;
set(handles.lblStatus, 'String', 'Showing Default Graph');

% global data;
% global all_data

% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the current times (ideal or real)
num = str2double(get(handles.num_baseline,'String'));
times=[-(num-1)*1.33:1.33:(size(all_data,1)-num)*1.33];
% close all; % closes all previous graphs, to not clutter everything up
[x,y]=find(isnan(all_data_tau));
% doesn't close the gui because the gui's handle visibility is turned off
if size(x)<1
figure;
plot(times, all_data_tau,'-o', 'LineWidth', 2);
ylim([min(all_data_tau(all_data_tau~=0))-0.1 max(all_data_tau(all_data_tau~=0))+0.1]);
% end
% % [x,y]=find(all_data_Int==0);
% % if length(x)~=size(all_data_Int,1)*size(all_data_Int,2)
% if size(x)<1
    figure;
    plot(times, all_data_Int,'-o', 'LineWidth', 2);
    ylim([min(all_data_Int(all_data_Int~=0))-3 max(all_data_Int(all_data_Int~=0))+3]);
end
if nanmean(nanmean(all_data_redInt))
    baselin_redInt = nanmean(all_data_redInt(1:num,:));
    for i=1:size(all_data_redInt,2)
        all_data_redIntNorm(:,i) = all_data_redInt(:,i)/baselin_redInt(i);
    end
    figure;
    plot(times, all_data_redInt,'-o', 'LineWidth', 2);
    ylim([min(all_data_redInt(all_data_redInt~=0))-5 max(all_data_redInt(all_data_redInt~=0))+5]);
    figure;
    plot(times, all_data_redIntNorm,'-o', 'LineWidth', 2);
    ylim([min(all_data_redIntNorm(all_data_redIntNorm~=0))-1 max(all_data_redIntNorm(all_data_redIntNorm~=0))+2]);
end

% --- Executes on button press in newGraph.
function newGraph_Callback(hObject, eventdata, handles)

%% New IB Code Below
%{
global workspace;

if strcmp(workspace.status, 'none')
    msgbox('Plotting unavailable');
else
    selections = [get(handles.dropNewGraph1, 'Value'), get(handles.dropNewGraph2, 'Value'), get(handles.dropNewGraph3, 'Value')];
    selections(~(selections-1)) = [];
    if isempty(selections)
        msgbox('Select data before plotting');
    else
        if strcmp(workspace.status, 'preview')
            %% Handle unprepared ROI file data
            
            % Map selection values to dataset indices correctly            
            % Selection options are in groups of 4, data is in groups of 6
            % Get offset by dividing by 4, shift differently if offset is whole or not
            modA = selections + (selections / 4) * 2;
            modB = modA(mod(modA, 1) == 0) - 2;
            modC = modA(~(mod(modA, 1) == 0)) - 1.5;
            modA(mod(modA, 1) == 0) = modB;
            modA(~(mod(modA, 1) == 0)) = modC;
                       
            dataSets = workspace.vars.expdata(:, modA);
            times=workspace.vars.expdata(:, 1);
        elseif strcmp(workspace.status, 'adjust')
            %% Handle prepared ROI file data
            dataSets = workspace.vars.expdata(:, selections);
            times=workspace.vars.expdata(:, 1);
        end
        figure('Name', 'New Graph');
        plot(times, dataSets);
        xlabel('Time');
        selectionLabel = get(handles.dropNewGraph1, 'String');
        legend(selectionLabel(selections));     
    end
end
%}
%% CZ Code below

global data;
global all_data;
global all_data_tau;
global all_data_Int;
global all_data_redInt;
global pathName;
global fileName;

set(handles.lblStatus, 'String', 'Showing New Graph');

% global data;
% global all_data
global stds;
global times;
num = str2double(get(handles.num_baseline,'String'));
times=[-(num-1)*1.33:1.33:(size(all_data,1)-num)*1.33];
stds = zeros(size(all_data,1),size(all_data,2));
% hObject    handle to newGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get indices of popupmenu selections and column names from popup menus
index = [get(handles.dropNewGraph1, 'Value') get(handles.dropNewGraph2, 'Value') get(handles.dropNewGraph3, 'Value')];
items = get(handles.dropNewGraph1, 'String');
% get the current times (ideal or real)
% toggleTime_Callback(handles.toggleTime, eventdata, handles);
series = [];
if index(1)>1 % if anything but 'blank' selected
    series{1} = all_data(:,index(1));
%      series{1} = data(:,index(1));
    errors{1} = stds(:,index(1));
end
if index(2)>1 % if anything but 'blank' selected
    series{2} = all_data(:,index(2));
%      series{1} = data(:,index(2));
    errors{2} = stds(:,index(2));
end
if index(3)>1 % if anything but 'blank' selected
    series{3} = all_data(:,index(3));
%      series{1} = data(:,index(3));
    errors{3} = stds(:,index(3));
end
if ~isempty(series) % if not every popupmenu was 'blank'
    figure;
    % graph with default colors
    graph(series, errors, items(index), []);
end


% function to use in newGraph and plot callback
function graph(series, errors, names, colors)
% series is a cell with either 1, 2, or 3 nx1 matrices in it
% errors is a cell with either 1, 2, or 3 nx1 matrices in it
% names is an array of strings for the legend
% colors is a cell with either 1, 2, or 3 1x3 RGB colors in it
% all 4 input variables should have the same number of elements
global all_data;
global times;
% delete data points corresponding to zero rows
% index = find(sum(all_data==0,2)>5); %find indices of zero rows
t = times;
% t(index,:) = []; % delete zero rows
% for i=1:size(series,2)
%     series{i}(index,:) = []; % delete zero rows
%     if ~isempty(errors)
%         errors{i}(index,:) = [];
%     end
% end
if isempty(colors) % if no colors provided, set default colors to R, G, B
    colors = {[1 0 0] [0 0.5 0] [0 0 1]};
end
if ~isempty(errors) % if errors has data, i.e. plot errorbars
    errorbar(t, series{1}, errors{1}, '-o', 'LineWidth', 2, 'Color', colors{1});
    hold on;
    if size(series,2) == 2
        errorbar(t, series{2}, errors{2}, ':o', 'LineWidth', 2, 'Color', colors{2});
    elseif size(series,2) == 3
        errorbar(t, series{2}, errors{2}, ':o', 'LineWidth', 2, 'Color', colors{2});
        errorbar(t, series{3}, errors{3}, '-d', 'LineWidth', 2, 'Color', colors{3});
    end
else % if errors is empty, i.e. don't plot errorbars
    plot(t, series{1}, '-o', 'LineWidth', 2, 'Color', colors{1});
    hold on;
    if size(series,2) == 2
        plot(t, series{2}, ':o', 'LineWidth', 2, 'Color', colors{2});
    elseif size(series,2) == 3
        plot(t, series{2}, ':o', 'LineWidth', 2, 'Color', colors{2});
        plot(t, series{3}, '-d', 'LineWidth', 2, 'Color', colors{3});
    end
end
% set x and y axes, set x and y labels
%axis([-60 100 0 3]);
xlabel('Time (min)', 'FontSize', 12);
ylabel('F(sum, norm)', 'FontSize', 12);
% turn off command line warning about extra legend entries
warning('off','all');
legend(names, 'Interpreter', 'none');
warning('on','all');
plottools; % show the graph in the plottools window with the other figures

% --- Executes on button press in makeDefGraph.
function makeDefGraph_Callback(hObject, eventdata, handles)
global default; % a cell with data for default graphs in each column
global pathName;
% hObject    handle to makeDefGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = [get(handles.dropNewGraph1, 'Value') get(handles.dropNewGraph2, 'Value') get(handles.dropNewGraph3, 'Value')];
% add new 1x3 matrix to end of default
default{end+1} = index;
def = default;
% save variable to existing file
save(fullfile(pathName,'defaultGraphs.mat'), 'def', '-append');

% --- Executes on button press in makeDefCol.
function makeDefCol_Callback(hObject, eventdata, handles)
global pathName;
% hObject    handle to makeDefCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
equation = get(handles.formula, 'String');
name = get(handles.colName, 'String');
load(fullfile(pathName,'defaultColumns.mat'));
% add new column to defaults
cols(:,end+1) = {name; equation};
% save to existing file
save(fullfile(pathName,'defaultColumns.mat'), 'cols', '-append');

% --- Executes on button press in addCol.
function addCol_Callback(hObject, eventdata, handles)
global data
global stds
% hObject    handle to addCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
equation = get(handles.formula, 'String');
% add new column of data
data(:,end+1) = eval(equation);
set(handles.dataTable,'Data',data);
stds = zeros(size(data));%nicko make stds=0 for new colomn
columns = get(handles.dataTable, 'ColumnName');
% add new column name
columns{end+1} = get(handles.colName, 'String');
set(handles.dataTable, 'ColumnName', columns);
%set(handles.numbersTable, 'ColumnName', 1:size(data,2));
% update pop up menus
pmOptions = columns;
pmOptions{1} = 'Blank';
set(handles.dropNewGraph1, 'String', pmOptions);
set(handles.dropNewGraph2, 'String', pmOptions);
set(handles.dropNewGraph3, 'String', pmOptions);

% --- Executes on button press in delCol.
function delCol_Callback(hObject, eventdata, handles)
global dataCol;
global data;
% hObject    handle to delCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data(:,dataCol) = []; % delete indices of columns specified by dataCol
set(handles.dataTable, 'Data', data);
columns = get(handles.dataTable, 'ColumnName');
% delete column name too
columns(dataCol) = [];
set(handles.dataTable, 'ColumnName', columns);
%set(handles.numbersTable, 'ColumnName', 1:size(data,2));
% update pop up menus
pmOptions = columns;
pmOptions{1} = 'Blank';
set(handles.dropNewGraph1, 'String', pmOptions);
set(handles.dropNewGraph2, 'String', pmOptions);
set(handles.dropNewGraph3, 'String', pmOptions);

% --- Executes on button press in place.
function place_Callback(hObject, eventdata, handles)
% places row of data into row specified by idealRow
global idealRow;
global dataRow; %column vector of rows selected
global data;
% hObject    handle to place (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if size(find(idealRow),1) > 1 % if more than one checkbox selected
    warndlg('Select a single ideal time to place data in bin');
    return;
end
if size(dataRow,1) < 1 % if nothing in data table selected
    warndlg('Select at least one row to put in bin');
    return;
end
s = size(dataRow,1);
% average selected rows
sum = data(dataRow(1,1),:);
if s>1
    for i=2:s %s is the number of selected rows
        index = dataRow(i,1);
        sum = sum + data(index,:);
    end
end
% place the resulting row into the row of the checked off ideal time
data(find(idealRow),:) = sum/s;
set(handles.dataTable, 'Data', data);

% --- Executes on button press in delRow.
function delRow_Callback(hObject, eventdata, handles)
global dataRow;
% global data;
global data;
% global stds;
% global fileName;
% global pathName;
% global struct;
global all_data_tau;
global all_data_Int;
global all_data_redInt;
% global d;
% global default;
global all_data;

% hObject    handle to delRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(all_data) && dataRow <= size(all_data, 1)
    all_data(dataRow,:) = []; % delete rows selected in data table
    all_data_tau(dataRow,:) = [];
    all_data_Int(dataRow,:) = [];
    all_data_redInt(dataRow,:) = [];
end
if ~isempty(data) && dataRow <= size(data, 1);
    data(dataRow,:) = []; % delete rows selected in data table
end
tableData = get(handles.dataTable, 'Data');
tableData(dataRow,:) = [];
set(handles.dataTable, 'Data', tableData);

% --- Executes on button press in addRow.
function addRow_Callback(hObject, eventdata, handles)
global dataRow;
global data;
% hObject    handle to addRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(dataRow) % if no row was selected
    msgbox('Please select a cell. Row will be inserted above selected row.');
end
%{
if ~isempty(data)
    i = dataRow(1); % if multiple rows selected, insert above first row
    s = size(data);
    data = vertcat(data(1:i-1,:), zeros(1,s(2)), data(i:end,:));
end
%}
tabData = get(handles.dataTable, 'Data');
i = dataRow(1);
s = size(tabData);
tabData = [tabData(1:i-1, :); zeros(1, s(2)); tabData(i:end, :)];
set(handles.dataTable, 'Data', tabData);

% --- Executes on button press in zeroRow.
function zeroRow_Callback(hObject, eventdata, handles)
global data;
global dataRow;
% hObject    handle to zeroRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(dataRow)
    msgbox('Please select a cell to zero out the row.');
elseif ~isempty(data)
    s1 = size(dataRow);
    s2 = size(data);
    data(dataRow,:) = zeros(s1(1),s2(2));
end
tabData = get(handles.dataTable, 'Data');
s1 = size(dataRow);
s2 = size(tabData);
tabData(dataRow, :) = zeros(s1(1),s2(2));
set(handles.dataTable, 'Data', tabData);

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
global data;
global pathName;
global fileName;
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save time adjusted, normalized, binned data to individ file
set(handles.lblStatus, 'String', 'Saving Adjusted ROI File');
load(fullfile(pathName,fileName),'-mat');
index = strfind(fileName, 'ROI2');
trunc = fileName(1:index+3); % take off everything after ROI2
eval(sprintf('%s.analyzeData.nickdata.timeAdj_norm = data;', trunc));
% save the edited struct back to the file
save(fullfile(pathName,fileName), trunc, '-append');

% save data to averages file starts here
idealsData = get(handles.idealsTable,'Data');
idealTimes = cell2mat(idealsData(:,2)); % nx1 matrix of ideal times
numIdeals = size(idealTimes,1);
% selecting destination
selected = get(handles.destination, 'Value'); % index of popupmenu selection
destinations = get(handles.destination, 'String'); % list of files
if selected == 1 % if 'New File' was selected
    newName = fullfile(pathName,get(handles.newFile,'String'));
else
    newName = fullfile(pathName,char(destinations(selected)));
end
averages = data;
stdErrs = zeros(size(data));
if exist(newName, 'file') ~= 2 % if averages file doesn't exist yet, create a new one
    indivData = cell(2,1);
    indivData{1,1} = data;
    indivData{2,1} = fileName(1:end-4);
    save(newName, 'indivData', 'averages', 'stdErrs', 'idealTimes');
    msgbox(['Data from ' fileName ' saved to itself and to new file ' newName]);
    set(handles.lblStatus, 'String', 'Adjusted ROI File Saved');
else % if averages file exists
    load(newName);
    s = size(indivData,2);
    % if data has different number of rows or columns as previously saved data
    if  size(data,1) ~= size(indivData{1,1},1)
%         if size(data,2) ~= size(indivData{1,1},2) || size(data,1) ~= size(indivData{1,1},1)
        warndlg(['Data must have same number of rows as other data: ', num2str(size(data, 1)),' vs ', num2str(size(indivData{1,1},1))]);
        set(handles.lblStatus, 'String', 'Failed to save: dimension error');
        return;
    end
    distinct = 0;
    for i=1:s
        % check to make sure same data isn't being saved twice
        if isequal(fileName(1:end-4), indivData{2,i})
            warndlg('Already saved this data to averages file. Saved data to individ file only.');
            set(handles.lblStatus, 'String', 'File already saved');
            distinct = 1;
            break;
        end
    end
    if distinct == 0 % data hasn't already been saved to this file, continue
        indivData{1,end+1} = data;
        indivData{2,end} = fileName(1:end-4);
        s = size(indivData,2);
%         % i = row number
%         for i=1:numIdeals
%             sum = []; % a matrix where each row is a row to be averaged
%             count = 0;
%             for j=1:s
%                 % if the first 5 entries of a row are 0, assume it isn't
%                 % data and do not include it in averaging
%                 if ~isequal(indivData{1,j}(i,1:5),zeros(1,5))
%                     sum = [sum; indivData{1,j}(i,:)];
%                     count = count + 1;
%                 end
%             end
%             if count == 0 % if there was only one nonzero row across experiments
%                 averages(i,:) = zeros(1,size(data,2));
%             else % if multiple experiments had data in that row
%                 averages(i,:) = mean(sum,1); %average along columns
%                 stdErrs(i,:) = std(sum,0,1) / sqrt(size(sum,1)); % compute standard errors
%             end
%         end
        save(newName, 'indivData', 'averages', 'stdErrs', 'idealTimes', '-append');
        msgbox(['Data from ' fileName ' saved to itself and to ' newName]);
        set(handles.lblStatus, 'String', 'Adjusted ROI File Saved');
    end
end
%refresh the destination dropdown
results = dir(fullfile(pathName,'*average*.mat'));
list = {'New File'};
for i=1:size(results,1)
    list{end+1} = results(i).name;
end
set(handles.destination,'String',list);

% --- Executes on button press in toggleTime.
function toggleTime_Callback(hObject, eventdata, handles)
global times;
global data;
% hObject    handle to toggleTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of toggleTime
if get(hObject,'Value') == 0 % default state sets time to real time
    times = data(:,1);
else % pressed state sets time to ideal time
    idealsData = get(handles.idealsTable,'Data');
    times = cell2mat(idealsData(:,2));
end

% --- Executes during object creation, after setting all properties.
function destination_CreateFcn(hObject, eventdata, handles)
global pathName;
% hObject    handle to destination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
results = dir(fullfile(pathName,'*average*.mat')); % search for mat files with term average
% display list of found files in pop up menu
list = {'New File'};
for i=1:size(results,1)
    list{end+1} = results(i).name;
end
set(hObject,'String',list);

% --- Executes on button press in autoBin.
function autoBin_Callback(hObject, eventdata, handles)
global data;
global dataRow;
global idealRow;
% hObject    handle to autoBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ideals = get(handles.idealsTable, 'Data');
ideals = cell2mat(ideals(:,2));
s = size(ideals,1);
zeroIndex = find(ideals==0);
for i=find(idealRow)' % index of each nonzero element in idealRow
    % define the boundaries of each bin
    if i == 1 
        minBin = -inf;
        maxBin = mean([ideals(1) ideals(2)]);
    elseif i == zeroIndex-1
        minBin = mean([ideals(i-1) ideals(i)]);
        maxBin = 0;
    elseif i == zeroIndex
        minBin = 0;
        maxBin = 0;
    elseif i == zeroIndex+1
        minBin = 0;
        maxBin = mean([ideals(i) ideals(i+1)]);
    elseif i == s
        minBin = mean([ideals(i-1) ideals(i)]);
        maxBin = inf;
    else % each ideal time is the center of its bin
        minBin = mean([ideals(i-1) ideals(i)]);
        maxBin = mean([ideals(i) ideals(i+1)]);
    end
    % find the rows of data that fall in the bin
    dataRow = []; % reset matrix of rows
    for j=1:size(data,1)
        if isequal(data(j,1:5),zeros(1,5)) % if its a zero row
            continue; % skip to the next iteration of the loop
        end
        % if the time is within the bin limits, add the row to dataRow
        if i == zeroIndex+1
            if data(j,1) > minBin && data(j,1) < maxBin
                dataRow(end+1) = j;
            end
        elseif i == zeroIndex
            if data(j,1) == minBin
                dataRow(end+1) = j;
            end
        else
            if data(j,1) >= minBin && data(j,1) < maxBin
                dataRow(end+1) = j;
            end
        end
    end
    % found which data to put in bin, now place it correctly
    if isempty(dataRow) % if no data fits in bin, add empty row
        dataRow = i; % for use in addRow_Callback
        addRow_Callback(handles.addRow, eventdata, handles);
    else
        sz = size(dataRow,2);
        % average selected rows
        sum = data(dataRow(1,1),:);
        if sz>1
            for j=2:sz %s is the number of selected rows
            sum = sum + data(dataRow(1,j),:);
            end
        end
        % delete all the rows found and replace them with a single new row
        data(dataRow,:) = [];
        addRow_Callback(handles.addRow, eventdata, handles);
        data(i,:) = sum/sz;
    end
end
set(handles.dataTable, 'Data', data);

% --- Executes on button press in checkAll.
function checkAll_Callback(hObject, eventdata, handles)
global idealRow;
% hObject    handle to checkAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkAll
idealValues = get(handles.idealsTable, 'Data');
if get(hObject,'Value') % if box is checked
    % set values to all ones
    idealValues(:,1) = num2cell(true(size(idealValues,1),1));
    idealRow = true(size(idealValues,1),1);
else % if box is unchecked
    % set values to all zeroes
    idealValues(:,1) = num2cell(false(size(idealValues,1),1));
    idealRow = false(size(idealValues,1),1);
end
set(handles.idealsTable, 'Data', idealValues);


%----------------------- End customized code --------------------------%
% Unedited default Callbacks placed below

% --- Executes during object creation, after setting all properties.
function num_ideals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_ideals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function num_baseline_Callback(hObject, eventdata, handles)
% hObject    handle to num_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.num = str2double(get(handles.num_baseline,'String'));
handles.numIdeals = str2double(get(handles.num_ideals,'String'));
% current = get(handles.idealsTable, 'Data');
% shorten or lengthen the table of ideal times according to input
% current(:,1) = num2cell(false(handles.numIdeals,1)); % initialize checkboxes to be unchecked
current(:,2) = num2cell(-(handles.num-1)*1.33:1.33:(handles.numIdeals-handles.num)*1.33);

set(handles.idealsTable, 'Data', current);
% --- Executes during object creation, after setting all properties.
function num_baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function dataTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function formula_Callback(hObject, eventdata, handles)
% hObject    handle to formula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function formula_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function colName_Callback(hObject, eventdata, handles)
% hObject    handle to colName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function colName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in dropNewGraph1.
function dropNewGraph1_Callback(hObject, eventdata, handles)
% hObject    handle to dropNewGraph1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function dropNewGraph1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropNewGraph1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in dropNewGraph2.
function dropNewGraph2_Callback(hObject, eventdata, handles)
% hObject    handle to dropNewGraph2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function dropNewGraph2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropNewGraph2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in dropNewGraph3.
function dropNewGraph3_Callback(hObject, eventdata, handles)
% hObject    handle to dropNewGraph3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function dropNewGraph3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropNewGraph3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in destination.
function destination_Callback(hObject, eventdata, handles)
% hObject    handle to destination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = get(handles.destination, 'Value');
if (selection ~= 1)
    set(handles.newFile, 'Enable', 'off');
else
    set(handles.newFile, 'Enable', 'on');
    name = get(handles.newFile, 'String');
    existing = get(handles.destination, 'String');
    
end

function newFile_Callback(hObject, eventdata, handles)
% hObject    handle to newFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function newFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function makeDefGraph_CreateFcn(hObject, eventdata, handles)
global default;
global pathName;
% hObject    handle to makeDefGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Average.
function Average_Callback(hObject, eventdata, handles)
% hObject    handle to Average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
global all_data;
global all_data_tau;
global all_data_Int;
global all_data_redInt;
global pathName;
global fileName;

if exist ('all_data_tau')
    num = str2double(get(handles.num_baseline,'String'));
    %normal_value = get(handles.normalization, 'Value');
    all_data_tau(all_data_tau==0)=nan;
    all_data_Int(all_data_Int==0)=nan;
    all_data_redInt(all_data_redInt==0)=nan;
    baseline_tau= nanmean(all_data_tau(1:num,:));
    baseline_redInt = nanmean(all_data_redInt(1:num,:));
    %normal_value=1;
    for i=1:size(all_data_tau,2)
        all_data_tauNorm(:,i) = all_data_tau(:,i)/baseline_tau(i);
    end
    for i=1:size(all_data_redInt,2)
        all_data_redIntNorm(:,i) = all_data_redInt(:,i)/baseline_redInt(i);
    end
    mean_tau = nanmean(all_data_tau,2);
    mean_tauNorm = nanmean(all_data_tauNorm,2);
    mean_Int = nanmean(all_data_Int,2);
    mean_redInt = nanmean(all_data_redIntNorm,2);
    for i=1:size(all_data_tau,1)
        if isnan(all_data_tau(1,2))
            num_nan = isnan(all_data_redIntNorm(i,:));
        else
            num_nan = isnan(all_data_tau(i,:));
        end
        [~,c]=find(num_nan==0);
        if length(c)==size(all_data_tau,2)
            ste_tau(i) = nanstd(all_data_tau(i,:),0,2)/(size(all_data_tau(i,:),2))^0.5;
            ste_tauNorm(i)=nanstd(all_data_tauNorm(i,:),0,2)/(size(all_data_tauNorm(i,:),2))^0.5;
            ste_Int(i) = nanstd(all_data_Int(i,:),0,2)/(size(all_data_Int(i,:),2))^0.5;
            ste_redInt(i) = nanstd(all_data_redIntNorm(i,:),0,2)/(size(all_data_redIntNorm(i,:),2))^0.5;
        else
            ste_tau(i) = nanstd(all_data_tau(i,:),0,2)/(length(c))^0.5;
            ste_tauNorm(i)=nanstd(all_data_tauNorm(i,:),0,2)/(length(c))^0.5;
            ste_Int(i) = nanstd(all_data_Int(i,:),0,2)/(length(c))^0.5;
            ste_redInt(i) = nanstd(all_data_redIntNorm(i,:),0,2)/(length(c))^0.5;
        end
    end
    time=[-(num-1)*1.33:1.33:(length(mean_tau)-num)*1.33];
    [loc,~]=find(isnan(mean_tau)==1)
    if length(loc)>1
        figure;set(gcf,'color','w');
        errorbar(time,mean_redInt,ste_redInt,'o-','color','k');
        xlabel('Time(min)');
        ylabel('Red Intensity')
        xlim([time(1),time(end)]);
        %      ylim([2.4 2.8]);
    else
        figure;set(gcf,'color','w');
        subplot(2,1,1)
        errorbar(time,mean_tau,ste_tau,'o-','color','k');
        xlabel('Time(min)');
        ylabel('Lifetime(ns)')
        xlim([time(1),time(end)]);
        if max(mean_tau)>2.45 & max(mean_tau)<3
             ylim([2.45 2.8]);
        end
        if max(mean_tau)<2.45 & max(mean_tau)>1.5
        ylim([1.8 2.45]);
        end
        if max(mean_tau)>3
           ylim([2 4]); 
        end
        %     ylim([min(mean_tau)-0.05,max(mean_tau)+0.05]);
        subplot(2,1,2)
        errorbar(time,mean_Int,ste_Int,'o-','color','k');
        xlabel('Time(min)');
        ylabel('Mean Intensity(FLIM)')
        xlim([time(1),time(end)]);
    end
%     ylim([min(mean_Int)-1,max(mean_Int)+1]);
results.time = time;
results.all_data_tau = all_data_tau;
results.all_data_Int =all_data_Int;
results.all_data_redIntNorm= all_data_redIntNorm;
results.mean_tauNorm = mean_tauNorm;
results.ste_tauNorm = ste_tauNorm;
results.mean_tau = mean_tau;
results.ste_tau = ste_tau;
results.mean_Int = mean_Int;
results.ste_Int = ste_Int;
results.mean_redInt = mean_redInt;
results.ste_redInt = ste_redInt;
    save('results.mat');
    set(handles.lblStatus, 'String', 'Averaged ROI Data. Displaying Results');
else
    warndlg('Press Save to Average button first');
    set(handles.lblStatus, 'String', 'Cannot Average ROI Data');
end


% --- Executes on button press in AddRowBelow.
function AddRowBelow_Callback(hObject, eventdata, handles)
% hObject    handle to AddRowBelow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global dataRow;
%global data;
% hObject    handle to addRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(dataRow) % if no row was selected
    msgbox('Please select a cell. Row will be inserted above selected row.');
end
%{
if ~isempty(data)
    i = dataRow(1); % if multiple rows selected, insert above first row
    s = size(data);
    data = [data(1:i-1, :); zeros(1,s(2)); data(i:end, :)];
end
%}

tabData = get(handles.dataTable, 'Data');
i = dataRow(1);
s = size(tabData);
tabData = [tabData(1:i, :); zeros(1,s(2)); tabData(i+1:end, :)];
 set(handles.dataTable, 'Data', tabData);

% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in normalization.
function normalization_Callback(hObject, eventdata, handles)
% hObject    handle to normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of normalization


% --- Executes on button press in timeAdj.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to timeAdj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnPlotResults.
function btnPlotResults_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlotResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global t
    global meanLT
    global steLT
    global meanLTNorm
    global steLTNorm
    global meanInt
    global steInt
    global meanIntNorm
    global steIntNorm
    global numROI
    set(handles.lblStatus, 'String', 'Showing Results');
    load('results.mat');
    t=results.time;
    meanLT = results.mean_tau;
    steLT = results.ste_tau;
    meanLTNorm = results.mean_tauNorm;
    steLTNorm = results.ste_tauNorm;

    meanInt = results.mean_Int;
    steInt = results.ste_Int;
    k = num / sum(mean_Int(1:5));
    meanIntNorm = k * meanInt;
    steIntNorm = k * steInt;

    numROI = length(all_data_Int(1,:));
    show_results();


function show_results()
    global t
    global meanLT
    global steLT
    global meanLTNorm
    global steLTNorm
    global meanInt
    global steInt
    global meanIntNorm
    global steIntNorm
    global numROI
    figMain = figure('name', 'Original','color', 'w');
    subplot(2, 1, 1);
    errorbar(t, meanLT, steLT,'o-','color','k','MarkerSize',10,'MarkerFaceColor','k','linewidth',2);

    legend(strcat('n = ', num2str(numROI)));
    box off;
    legend boxoff;
    set(get(gca,'YLabel'),'String','Lifetime','fontsize',19);
    set(get(gca,'XLabel'),'String','Time(min)','fontsize',19 );
    set(gca,'FontSize',18);

    subplot(2, 1, 2);
    errorbar(t, meanInt, steInt,'o-','color','k','MarkerSize',10,'MarkerFaceColor','k','linewidth',2);

    legend(strcat('n = ', num2str(numROI)));
    box off;
    legend boxoff;
    set(get(gca,'YLabel'),'String','Intensity','fontsize',19);
    set(get(gca,'XLabel'),'String','Time(min)','fontsize',19 );
    set(gca,'FontSize',18);

    figNorm = figure('name', 'Normalized', 'color', 'w');
    subplot(2, 1, 1);
    errorbar(t, meanLTNorm, steLTNorm, 'o-','color','k','MarkerSize',10,'MarkerFaceColor','k','linewidth',2);

    xlim([-10, inf]);
    ylim([0.95, inf]);
    legend(strcat('n = ', num2str(numROI)));
    box off;
    legend boxoff;
    set(get(gca,'YLabel'),'String','Normalized Lifetime','fontsize',19);
    set(get(gca,'XLabel'),'String','Time(min)','fontsize',19 );
    set(gca,'FontSize',18);

    subplot(2, 1, 2);
    errorbar(t, meanIntNorm, steIntNorm, 'o-','color','k','MarkerSize',10,'MarkerFaceColor','k','linewidth',2);

    xlim([-10, inf]);
    legend(strcat('n = ', num2str(numROI)));
    box off;
    legend boxoff;
    set(get(gca,'YLabel'),'String','Normalized Intensity','fontsize',19);
    set(get(gca,'XLabel'),'String','Time(min)','fontsize',19 );
    set(gca,'FontSize',18);


% --- Executes on button press in btnSPCAnalysis.
function btnSPCAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to btnSPCAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblStatus, 'String', 'Running SPC Analysis');
spc_drawInit;


% --- Executes on button press in btnPrepAnalysis.
function btnPrepAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to btnPrepAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uigetfile('*.mat');

set(handles.lblStatus, 'String', 'Preparing ROI File');
set(handles.btnFixROI, 'Enable', 'off');
set(handles.btnSaveFix, 'Enable', 'off');

prepStatus = aio_prep_analysis(file, path);
msg = sprintf(prepStatus);
if (length(prepStatus) > 1)
    set(handles.lblStatus, 'String', 'Preparation Failed');
    warndlg(msg);
else
    set(handles.lblStatus, 'String', 'Preparation Succeeded');
    msgbox('ROI File Prepared Successfully');
end


% --- Executes on button press in btnPreviewROI.
function btnPreviewROI_Callback(hObject, eventdata, handles)
% hObject    handle to btnPreviewROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% New IB Code Below
%{
global workspace;

[name, path] = uigetfile('*.mat');

try 
    load(fullfile(path, name))
catch loaderr
    clear_workspace();
    update_ui(handles);
    msgbox('Could not open file.');
    disp(strcat('Avoided error: ', loaderr.identifier));
end

workspace.vars.file = fullfile(path,name);
[~, workspace.vars.expname, ~] = fileparts(workspace.vars.file);

if exist(workspace.vars.expname, 'var')
    %% Prepare formatting vars
    workspace.status = 'preview';
    eval(['roiData = ', workspace.vars.expname, '.roiData']);
    maxLen = max(max(cellfun(@length, struct2cell(roiData))));
    
    workspace.vars.expdata = [];
    colNames = cell(1, length(roiData)*6);
    plotOptions = {'Choose Data'};
    %% Format ROI data
    for i = 1:length(roiData)
        roiData(i).time(end+1:maxLen) = NaN;
        roiData(i).time3(end+1:maxLen) = NaN;
        roiData(i).tau_m(end+1:maxLen) = NaN;
        roiData(i).mean_int(end+1:maxLen) = NaN;
        roiData(i).int_int2(end+1:maxLen) = NaN;
        roiData(i).red_mean(end+1:maxLen) = NaN;
        workspace.vars.expdata(:, (i-1)*6 + 1) = roiData(i).time;
        workspace.vars.expdata(:, (i-1)*6 + 2) = roiData(i).time3;
        workspace.vars.expdata(:, (i-1)*6 + 3) = roiData(i).tau_m;
        workspace.vars.expdata(:, (i-1)*6 + 4) = roiData(i).mean_int;
        workspace.vars.expdata(:, (i-1)*6 + 5) = roiData(i).int_int2;
        workspace.vars.expdata(:, i*6) = roiData(i).red_mean;
        colNames{i*6-5} = strcat('time @', num2str(i));
        colNames{i*6-4} = strcat('time3 @', num2str(i));
        colNames{i*6-3} = strcat('tau_m @', num2str(i));
        colNames{i*6-2} = strcat('mean_int @', num2str(i));
        colNames{i*6-1} = strcat('int_int2 @', num2str(i));
        colNames{i*6} = strcat('red_mean @', num2str(i));
        plotOptions = [plotOptions, colNames((i-1)*6+3:i*6)];
    end
    
    %% Show Preview
    set(handles.dropNewGraph1, 'String', plotOptions);
    set(handles.dropNewGraph2, 'String', plotOptions);
    set(handles.dropNewGraph3, 'String', plotOptions);
    set(handles.dataTable, 'ColumnName', colNames);
    set(handles.dataTable, 'Data', workspace.vars.expdata);
else
    clear_workspace();
    update_ui(handles);
    msgbox('File not supported');
end
update_ui(handles);
%}
%% Old IB Code Below

global times;
global all_data;
global all_data_tau;
global all_data_Int;
global all_data_redInt;

[file, path] = uigetfile('*.mat');
load(fullfile(path, file));
cd(path);
set(handles.figure1, 'Name', fullfile(path, file));
set(handles.lblStatus, 'String', 'ROI File Preview');
set(handles.btnClearAll, 'Enable', 'on');
set(handles.btnFixROI, 'Enable', 'on');
set(handles.btnSaveFix, 'Enable', 'on');

set(handles.newGraph, 'Enable', 'off');
set(handles.dropNewGraph1, 'Enable', 'off');
set(handles.dropNewGraph2, 'Enable', 'off');
set(handles.dropNewGraph3, 'Enable', 'off');
set(handles.toggleTime, 'Enable', 'off');
set(handles.makeDefGraph, 'Enable', 'off');

set(handles.destination, 'Enable', 'off');
set(handles.newFile, 'Enable', 'off');
set(handles.save, 'Enable', 'off');
set(handles.Average, 'Enable', 'off');
set(handles.btnPlotResults, 'Enable', 'off');

fileData = eval(file(1:end-4));
preview = [];
colNames = {};
roi = fileData.roiData;
maxlen = max(max(cellfun(@length, struct2cell(roi))));

times = [];
all_data_tau = [];
all_data_Int = [];
all_data_redInt = [];

for i = 1:length(roi)
    roi(i).time(end+1:maxlen) = NaN;
    roi(i).time3(end+1:maxlen) = NaN;
    roi(i).tau_m(end+1:maxlen) = NaN;
    roi(i).mean_int(end+1:maxlen) = NaN;
    roi(i).int_int2(end+1:maxlen) = NaN;
    roi(i).red_mean(end+1:maxlen) = NaN;
    
    times = [times, roi(i).time'];
    all_data_tau = [all_data_tau, roi(i).tau_m'];
    all_data_Int = [all_data_Int, roi(i).mean_int'];
    all_data_redInt = [all_data_redInt, roi(i).red_mean'];
    
    preview = [preview, roi(i).time', roi(i).time3', roi(i).tau_m', roi(i).mean_int', roi(i).int_int2', roi(i).red_mean'];
    colNames{end+1} = 'time';
    colNames{end+1} = 'time3';
    colNames{end+1} = 'tau_m';
    colNames{end+1} = 'mean_int';
    colNames{end+1} = 'int_int2';
    colNames{end+1} = 'red_mean';
end

all_data = preview;


set(handles.dataTable, 'Data', preview, 'ColumnName', colNames);


% --- Executes on button press in btnEditResults.
function btnEditResults_Callback(hObject, eventdata, handles)
% hObject    handle to btnEditResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblStatus, 'String', 'Running Result Editor');
plot_results;


% --- Executes on button press in btnFixROI.
function btnFixROI_Callback(hObject, eventdata, handles)
% hObject    handle to btnFixROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblStatus, 'String', 'ROI Fix Attempted');
roiData = get(handles.dataTable, 'Data');
sz = size(roiData, 2);
for i = 1:6:sz
    if i > sz
        break;
    end
    t = roiData(:,i);
    t3 = roiData(:,i+1);
    tau = roiData(:,i+2);
    int_m = roiData(:,i+3);
    int = roiData(:, i+4);
    red = roiData(:,i+5);
    
    [tFix, status] = fix_ind_var(t);
    [t3Fix, status] = fix_ind_var(t3);
    [tauFix, status] = fix_dep_var(tau);
    [intmFix, status] = fix_dep_var(int_m);
    [intFix, status] = fix_dep_var(int);
    [redFix, status] = fix_dep_var(red);
    t = tFix';
    t3 = t3Fix';
    tau = tauFix';
    int_m = intmFix';
    int = intFix';
    red = redFix';
    
    if isempty(t)
       roiData(:,i) = [];
       i = i-1;
    else
        roiData(:,i) = t;
    end
    if isempty(t3)
       roiData(:,i+1) = [];
       i = i-1;
    else
        roiData(:,i+1) = t3;
    end
    if isempty(tau)
       roiData(:,i+2) = [];
       i = i-1;
    else
        roiData(:,i+2) = tau;
    end
    if isempty(int_m)
       roiData(:,i+3) = [];
       i = i-1;
    else
        roiData(:,i+3) = int_m;
    end
    if isempty(int)
       roiData(:,i+4) = [];
       i = i-1;
    else
        roiData(:,i+4) = int;
    end
    if isempty(red)
       roiData(:,i+5) = [];
       i = i-1;
    else
        roiData(:,i+5) = red;
    end
    sz = size(roiData, 2);
end
set(handles.dataTable, 'Data', roiData);


% --- Executes on button press in btnSaveFix.
function btnSaveFix_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveFix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'off');
roiData = get(handles.dataTable, 'Data');
file = get(handles.figure1, 'Name');
load(file);
[~, filename, ~] = fileparts(file);
oldData = eval([filename, '.roiData']);
for i=1:length(oldData)
    if (i > length(oldData))
        break;
    end
    r = eval([filename, '.roiData(', num2str(i), ')']);
    k=i*6;
    if k > size(roiData, 2)
        eval([filename, '.roiData(', num2str(i), ') = []']);
    else
        r.time = roiData(:, k-5)';
        r.time3 = roiData(:, k-4)';
        r.tau_m = roiData(:, k-3)';
        r.mean_int = roiData(:, k-2)';
        r.int_int2 = roiData(:, k-1)';
        r.red_mean = roiData(:, k)';
        eval([filename, '.roiData(', num2str(i), ') = r']);
    end
    oldData = eval([filename, '.roiData']);
end
save(file, filename);
set(handles.lblStatus, 'String', 'ROI File Saved');
set(hObject, 'Enable', 'on');


% --- Executes on button press in btnClearAll.
function btnClearAll_Callback(hObject, eventdata, handles)
% hObject    handle to btnClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
global stds;
global fileName;
global pathName;
global struct;
global all_data_tau;
global all_data_Int;
global all_data_redInt;
global d;
global default;
global all_data;
cd('C:/');
set(handles.figure1, 'Name', 'analysis_1_2_IB');
set(handles.dataTable, 'Data', cell(4, 2));
set(handles.dataTable, 'ColumnName', {'1', '2'});
set(handles.btnClearAll, 'Enable', 'off');
set(handles.lblStatus, 'String', 'Cleared Data');

set(handles.newGraph, 'Enable', 'on');
set(handles.dropNewGraph1, 'Enable', 'on');
set(handles.dropNewGraph2, 'Enable', 'on');
set(handles.dropNewGraph3, 'Enable', 'on');
set(handles.toggleTime, 'Enable', 'on');
set(handles.makeDefGraph, 'Enable', 'on');

set(handles.destination, 'Enable', 'on');
set(handles.newFile, 'Enable', 'on');
set(handles.save, 'Enable', 'on');
set(handles.Average, 'Enable', 'on');
set(handles.btnPlotResults, 'Enable', 'on');

clear


% --- Executes on button press in btnAutoAnalyze.
function btnAutoAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to btnAutoAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global all_data_tau;
global all_data_Int;
global all_data_redInt;

set(handles.btnPlotResults, 'Enable', 'on');

%% Initalize all vars for analysis
[file, path] = uigetfile('*.mat', 'Multiselect', 'on');
cd(path);
nBase = str2num(get(handles.num_baseline, 'String'));
idealsData = get(handles.idealsTable,'Data');
idealTimes = cell2mat(idealsData(:,2));
saveSelection = get(handles.destination, 'Value');
saveOptions = get(handles.destination, 'String');
if (saveSelection == 1)
    savename = get(handles.newFile, 'String');
else
    savename = char(saveOptions(saveSelection));
end
savepath = path;

%% Start Analysis
if iscell(file)
    for i = 1:length(file)
        [status] = aio_auto_analyze(file{i}, path, nBase, idealTimes, savepath, savename);
        if ~isempty(status)
            warndlg(status);
            return;
        end
    end
else
    [status] = aio_auto_analyze(file, path, nBase, idealTimes, savepath, savename);
    if ~isempty(status)
        warndlg(status);
        return;
    end
end

%% Load Analyis Results
load(fullfile(savepath, savename));
all_data_tau=[];
all_data_Int=[];
all_data_redInt=[];
for i=1:size(indivData,2)
    numRoi(i) =(size(indivData{1,i},2)-1)/3;%****3 means tau, int, red_intensity
    for j=1:numRoi(i)  
        if i==1
            all_data_tau(:,j) = indivData{1,i}(:,j+1);
            all_data_Int(:,j) = indivData{1,i}(:,j+1+numRoi(i));
            all_data_redInt(:,j) = indivData{1,i}(:,j+1+2*numRoi(i));
        else
            all_data_tau(:,sum(numRoi(1:i-1))+j) = indivData{1,i}(:,j+1);
            all_data_Int(:,sum(numRoi(1:i-1))+j) = indivData{1,i}(:,j+1+numRoi(i));
            all_data_redInt(:,sum(numRoi(1:i-1))+j) = indivData{1,i}(:,j+1+2*numRoi(i));
        end
    end
end

%% Averaage + Plot Results
cbAvg = get(handles.Average, 'Callback');
cbAvg(handles.Average, []);








% % load default graphs
% load(fullfile(pathName,'defaultGraphs.mat'));
% % each cell in default is a 1x3 matrix representing column numbers
% default = def;
% items = get(handles.dropNewGraph1, 'String');
% if size(default,2)>0 % if there are default graphs, which there should be
%     for i=1:size(default,2)
%         series = {};
%         series{1} = data(:,default{i}(1));
%         errors{1} = stds(:,default{i}(1));
%         if default{i}(2)>1 % if it's any column other than 'Blank'
%             series{2} = data(:,default{i}(2));
%             errors{2} = stds(:,default{i}(2));
%         end
%         if default{i}(3)>1
%             series{3} = data(:,default{i}(3));
%             errors{3} = stds(:,default{i}(3));
%         end
%         figure;
%         % plot with default colors
%         graph(series, errors, items(default{i}), []);
%     end
% end


% --- Executes on button press in btnToggleAdj.
function btnToggleAdj_Callback(hObject, eventdata, handles)
% hObject    handle to btnToggleAdj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnToggleAdj

