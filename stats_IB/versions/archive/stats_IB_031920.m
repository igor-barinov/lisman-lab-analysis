%% --------------------------------------------------------------------
% 'stats_IB_031920'
%
function varargout = stats_IB_031920(varargin)
% STATS_IB_031920 MATLAB code for stats_IB_031920.fig
%      STATS_IB_031920, by itself, creates a new STATS_IB_031920 or raises the existing
%      singleton*.
%
%      H = STATS_IB_031920 returns the handle to a new STATS_IB_031920 or the handle to
%      the existing singleton*.
%
%      STATS_IB_031920('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATS_IB_031920.M with the given input arguments.
%
%      STATS_IB_031920('Property','Value',...) creates a new STATS_IB_031920 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stats_IB_031920_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stats_IB_031920_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stats_IB_031920

% Last Modified by GUIDE v2.5 21-May-2020 13:14:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stats_IB_031920_OpeningFcn, ...
                   'gui_OutputFcn',  @stats_IB_031920_OutputFcn, ...
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
% --- Executes just before stats_IB_031920 is made visible.
function stats_IB_031920_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stats_IB_031920 (see VARARGIN)

% Choose default command line output for stats_IB_031920
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

clear_table(handles.fileTable);
clear_table(handles.sampleTable);
clear_table(handles.sampleLUT);

% --- Outputs from this function are returned to the command line.
function varargout = stats_IB_031920_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% --------------------------------------------------------------------
% Callback Declarations
%
function menuFile_Callback(~, ~, ~)
function menuSample_Callback(~, ~, ~)
function menuStats_Callback(~, ~, ~)


%% --------------------------------------------------------------------
% 'fileTable' Cell Selection Callback
% 
% INPUTS
% ------
% <eventdata>, struct
%   -> <Indices>, matrix: Each row is a selection: [row, column]
%
% OUTPUTS/EFFECTS
% ---------------
% global <fileDataSelection>, matrix: Set to <eventdata> -> <Indices>
%
function fileTable_CellSelectionCallback(~, eventdata, ~)
global fileDataSelection;
fileDataSelection = eventdata.Indices;

%% --------------------------------------------------------------------
%
%
function sampleTable_CellSelectionCallback(~, eventdata, ~)
global sampleDataSelection;
sampleDataSelection = eventdata.Indices;


%% --------------------------------------------------------------------
% 'menuOpen' Callback
%
% INPUTS
% ------
% <handles>, struct: Containes each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'open_and_display_file' function
%
function menuOpen_Callback(~, ~, handles)
    global path;
    global files;
    global roiData;
    try
        [path, files, roiData] = open_and_display_file(handles.fileTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnOpenFile' Callback
%
% INPUTS
% ------
% <handles>, struct: Containes each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'open_and_display_file' function
%
function btnOpenFile_Callback(~, ~, handles)
    global path;
    global files;
    global roiData;
    try
        [path, files, roiData] = open_and_display_file(handles.fileTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
function menuSampleSelection_Callback(~, ~, handles)
    global files;
    global roiData;
    global fileDataSelection;
    try
        if isempty(fileDataSelection)
            warndlg('Please select data to sample');
        else
            sample_and_display_selection(roiData, files, handles.fileTable, fileDataSelection, handles.sampleTable, handles.sampleLUT);
        end
    catch err
        errordlg(exception_to_str(err));
    end

%% --------------------------------------------------------------------
function menuSampleRange_Callback(~, ~, handles)
    global files;    
    global roiData;
    try
        sample_and_display_time_range(roiData, files, handles.fileTable, handles.sampleTable, handles.sampleLUT);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnSampleSelection' Callback
%
function btnSampleSelection_Callback(~, ~, handles)
    global files;    
    global roiData;
    global fileDataSelection;
    try
        if isempty(fileDataSelection)
            warndlg('Please select data to sample');
        else
            sample_and_display_selection(roiData, files, handles.fileTable, fileDataSelection, handles.sampleTable, handles.sampleLUT);
        end
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
function btnSampleRange_Callback(~, ~, handles)
    global files;    
    global roiData;
    try
        sample_and_display_time_range(roiData, files, handles.fileTable, handles.sampleTable, handles.sampleLUT);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
function menuMSE_Callback(~, ~, handles)
    try
        mean_and_ste_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end



%% --------------------------------------------------------------------
function menuPValue_Callback(hObject, eventdata, handles)
    try
        p_value_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
function btnMSE_Callback(~, ~, handles)
    try
        mean_and_ste_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
function btnPValue_Callback(hObject, eventdata, handles)
    try
        p_value_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
function btnClearSamples_Callback(~, ~, handles)
    clear_table(handles.sampleTable);
    set(handles.sampleTable, 'ColumnName', {});
    clear_table(handles.sampleLUT);
    set(handles.sampleLUT, 'RowName', {});

%% --------------------------------------------------------------------
% 'clear_table' Function
%
function clear_table(hTable)
    set(hTable, 'Data', []);



%% --------------------------------------------------------------------
% 'open_and_display_file' Function
% 
%
function [path, files, roiData] = open_and_display_file(hTable)
path = '';
files = {};
roiData = struct;
try
    %% Let the user open file(s)
    [fileCount, filepaths, fileDataStructs] = open_roi_file_dlg('*.mat');  
    
    %% Get the path and filenames and combine the file data
    if fileCount == 0
        return;
    elseif fileCount > 1
        [path, files] = multiple_fileparts(filepaths);
        [fileData] = combine_roi_files(fileDataStructs);
    elseif fileCount == 1
        fileData = fileDataStructs;
        [path, files{end+1}] = fileparts(filepaths);
    end
    
    %% Select the appropriate ROI data
    [dataWasChosen, roiData] = select_roi_data_dlg(fileData);
    if ~dataWasChosen
        return;
    end
    
    
    %% Display the ROI data
    [dataTable, colNames] = roi_data_to_table(roiData);
    set(hTable, 'Data', dataTable);
    set(hTable, 'ColumnName', colNames);
catch err
    rethrow(err);
end


%% --------------------------------------------------------------------
% 'sample_and_display_selection' Function
%
%
function sample_and_display_selection(roiData, files, hFileTable, selection, hSampleTable, hSampleLUT)
    try
        %% Get data based on selection and table
        fileTable = get(hFileTable, 'Data');
        roiLabels = get(hFileTable, 'ColumnName');
        [numROI, ~, hasLifetime] = roi_data_count(roiData);
        [intCols, redCols, lifetimeCols] = table_layout_of_roi_data(numROI, hasLifetime);
        
        tableLayout = {1, intCols, redCols, lifetimeCols};
        [rowsSelected, selectionLayout] = table_selection_layout(selection, fileTable, tableLayout);
        [intData, redData, lifetimeData] = select_roi_data_from_table(selection, fileTable, tableLayout);
        startPt = rowsSelected(1);
        endPt = rowsSelected(end);
        
        %% Get sample table info
        sampleTable = get(hSampleTable, 'Data');
        sampleLabels = get(hSampleTable, 'ColumnName');
        
        %% Add samples to table
        [sampleTable, newSampleLabels] = add_samples_to_table(sampleTable, intData, redData, lifetimeData);
        
        %% Add samples to LUT
        sampleLUT = get(hSampleLUT, 'Data');
        if ~isempty(intData)
            selectedInt = selectionLayout{2};
            selectedInt = roiLabels(selectedInt)';
            [sampleLUT] = add_sample_to_lut(sampleLUT, length_without_nans(intData), startPt, endPt, selectedInt, files);
        end
        if ~isempty(redData)
            selectedRed = selectionLayout{3};
            selectedRed = roiLabels(selectedRed)';
            [sampleLUT] = add_sample_to_lut(sampleLUT, length_without_nans(redData), startPt, endPt, selectedRed, files);
        end
        if ~isempty(lifetimeData)
            selectedLt = selectionLayout{4};
            selectedLt = roiLabels(selectedLt)';
            [sampleLUT] = add_sample_to_lut(sampleLUT, length_without_nans(lifetimeData), startPt, endPt, selectedLt, files);
        end
        
        %% Display new data
        allLabels = [sampleLabels; newSampleLabels];
        set(hSampleTable, 'Data', sampleTable);
        set(hSampleTable, 'ColumnName', allLabels);
        
        set(hSampleLUT, 'Data', sampleLUT);
        set(hSampleLUT, 'RowName', allLabels);
        
    catch err
        rethrow(err);
    end


%% --------------------------------------------------------------------
% 'sample_and_display_time_range' Function
%
%
function sample_and_display_time_range(roiData, files, hFileTable, hSampleTable, hSampleLUT)
    try
        fileTable = get(hFileTable, 'Data');
        timeVals = fileTable(:, 1);
        [rangeWasChosen, ptRange] = select_time_range_dlg(timeVals);
        if rangeWasChosen
            [selection] = table_selection_by_rows(ptRange, fileTable);
            sample_and_display_selection(roiData, files, hFileTable, selection, hSampleTable, hSampleLUT);
        end
    catch err
        rethrow(err);
    end


%% --------------------------------------------------------------------
% 'select_time_range_dlg' Function
%
%
function [rangeWasChosen, ptRange] = select_time_range_dlg(timeVals)
    ptRange = [];

    %% Check if at least 2 time values were given
    numPts = length(timeVals);
    if numPts < 2
        throw(general_error({'timeVals'}, 'Need at least 2 values'));
    end

    %% Prompt the user
    prompt = {'Enter first data point:', 'Enter last data point:'};
    userInput = inputdlg(prompt, 'Select Time Range');
    if isempty(userInput) || isempty(userInput{1}) || isempty(userInput{2})
        rangeWasChosen = false;
        return;
    end

    %% Check if the user input is valid
    startPt = str2double(userInput{1});
    endPt = str2double(userInput{2});
    if isnan(startPt) || isnan(endPt)
        warndlg('Please enter numeric values');
        rangeWasChosen = false;
        return;
    end
    if endPt < startPt
        warndlg('The last point must come after the first point');
        rangeWasChosen = false;
        return;
    end
    if startPt < 1 || endPt < 1 || startPt > numPts || endPt > numPts
        validVal = ['number from 1 to ', num2str(numPts)];
        warndlg(['Please enter a ', validVal]);
        rangeWasChosen = false;
        return;
    end

    %% Get the point range
    ptRange = startPt:endPt;
    rangeWasChosen = true;


%% --------------------------------------------------------------------
%
%
function mean_and_ste_dlg(hSampleTable)
    options = get(hSampleTable, 'ColumnName');
    [column, sampleWasChosen] = listdlg('Name', 'Mean and Std. Error', 'ListString', options, 'PromptString', 'Select a sample: ', 'SelectionMode', 'single');
    if sampleWasChosen
        sampleTable = get(hSampleTable, 'Data');
        sample = sampleTable(:, column);
        sampleSz = length_without_nans(sample);
        avg = nanmean(sample);
        ste = nanstd(sample) / sqrt(sampleSz);
        
        formattedMsg = ['Count: ', num2str(sampleSz), ' | Mean: ', num2str(avg), ' | Std. Error: ', num2str(ste)];
        title = ['Stats for ', options{column}];
        msgbox(formattedMsg, title);
    end

    
%% --------------------------------------------------------------------
function p_value_dlg(hSampleTable)
    options = get(hSampleTable, 'ColumnName');
    [columns, sampleWasChosen] = listdlg('Name', 'P-Value', 'ListString', options, 'PromptString', 'Select 2 samples:');
    if sampleWasChosen
        if length(columns) ~= 2
            warndlg('Please select only 2 columns');
            return;
        end
        
        sampleTable = get(hSampleTable, 'Data');
        sampleA = sampleTable(:, columns(1));
        sampleB = sampleTable(:, columns(2));
        
        if length_without_nans(sampleA) ~= length_without_nans(sampleB)
            warndlg('Please select samples of the same size');
            return;
        end
        
        [reject, pVal] = ttest(sampleA, sampleB);
        
        if isnan(reject)
            warndlg('The samples selected are identical');
            return;
        elseif reject
            formattedMsg = ['There is a significant difference with a p-value of ', num2str(pVal)];
        else
            formattedMsg = ['There is no significanct difference with a p-value of ', num2str(pVal)];
        end
        
        title = ['Stats for ', options{columns(1)}, ' and ', options{columns(2)}];
        msgbox(formattedMsg, title);
    end
        
        
%% --------------------------------------------------------------------
% Ignore 'unused function' warnings
%#ok<*DEFNU>
