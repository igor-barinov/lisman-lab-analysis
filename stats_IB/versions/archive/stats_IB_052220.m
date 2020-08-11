%% --------------------------------------------------------------------
% 'stats_IB_052220'
%
function varargout = stats_IB_052220(varargin)
% STATS_IB_052220 MATLAB code for stats_IB_052220.fig
%      STATS_IB_052220, by itself, creates a new STATS_IB_052220 or raises the existing
%      singleton*.
%
%      H = STATS_IB_052220 returns the handle to a new STATS_IB_052220 or the handle to
%      the existing singleton*.
%
%      STATS_IB_052220('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATS_IB_052220.M with the given input arguments.
%
%      STATS_IB_052220('Property','Value',...) creates a new STATS_IB_052220 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stats_IB_052220_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stats_IB_052220_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stats_IB_052220

% Last Modified by GUIDE v2.5 22-May-2020 15:49:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stats_IB_052220_OpeningFcn, ...
                   'gui_OutputFcn',  @stats_IB_052220_OutputFcn, ...
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
% --- Executes just before stats_IB_052220 is made visible.
function stats_IB_052220_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stats_IB_052220 (see VARARGIN)

% Choose default command line output for stats_IB_052220
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

clear_table(handles.fileTable);
clear_table(handles.sampleTable);
clear_table(handles.sampleLUT);

% --- Outputs from this function are returned to the command line.
function varargout = stats_IB_052220_OutputFcn(hObject, eventdata, handles) 
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
%   Stores the index of a clicked cell that contains file data
%
% INPUTS
% ------
% <eventdata>, struct
%   -> <Indices>, matrix: Each row is a selection: [row, column]
%
% OUTPUTS/EFFECTS
% ---------------
% global <FILE_DATA_SELECTION>, matrix: Set to <eventdata> -> <Indices>
%
function fileTable_CellSelectionCallback(~, eventdata, ~)
    global FILE_DATA_SELECTION;
    FILE_DATA_SELECTION = eventdata.Indices;


%% --------------------------------------------------------------------
% 'menuOpen' Callback
%   Opens a dialog allowing the user to select 1 or more ROI files
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
    global PATH;
    global FILES;
    global ROI_DATA;
    try
        [success, newPath, newFiles, newRoiData] = open_and_display_file(handles.fileTable);
        if success
            PATH = newPath;
            FILES = newFiles;
            ROI_DATA = newRoiData;
        end
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnOpenFile' Callback
%   Opens a dialog allowing the user to select 1 or more ROI files
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
    global PATH;
    global FILES;
    global ROI_DATA;
    try
        [success, newPath, newFiles, newROIData] = open_and_display_file(handles.fileTable);
        if success
            PATH = newPath;
            FILES = newFiles;
            ROI_DATA = newROIData;
        end
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'menuSampleSelection' Callback
%   Converts selected file data into samples split by ROI data type
%
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'sample_and_display_selection' Function
%
function menuSampleSelection_Callback(~, ~, handles)
    global FILES;
    global ROI_DATA;
    global FILE_DATA_SELECTION;
    try
        if isempty(FILE_DATA_SELECTION)
            warndlg('Please select data to sample');
        else
            sample_and_display_selection(ROI_DATA, FILES, handles.fileTable, FILE_DATA_SELECTION, handles.sampleTable, handles.sampleLUT);
        end
    catch err
        errordlg(exception_to_str(err));
    end

%% --------------------------------------------------------------------
% 'menuSampleRange' Callback
%   Opens a dialog letting the user enter a range of points from which data
%   will be sampled and split by ROI data type
%
% INPUTS
% ------
% <handles>, struct: Containes each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'sample_and_display_time_range' Function
%
function menuSampleRange_Callback(~, ~, handles)
    global FILES;    
    global ROI_DATA;
    try
        sample_and_display_time_range(ROI_DATA, FILES, handles.fileTable, handles.sampleTable, handles.sampleLUT);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnSampleSelection' Callback
%   Converts selected file data into samples split by ROI data type
%
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'sample_and_display_selection'
%
function btnSampleSelection_Callback(~, ~, handles)
    global FILES;    
    global ROI_DATA;
    global FILE_DATA_SELECTION;
    try
        if isempty(FILE_DATA_SELECTION)
            warndlg('Please select data to sample');
        else
            sample_and_display_selection(ROI_DATA, FILES, handles.fileTable, FILE_DATA_SELECTION, handles.sampleTable, handles.sampleLUT);
        end
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnSampleRange' Callback
%   Opens a dialog letting the user enter a range of points from which data
%   will be sampled and split by ROI data type
%
% INPUTS
% ------
% <handles>, struct: Containes each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'sample_and_display_time_range' Function
%
function btnSampleRange_Callback(~, ~, handles)
    global FILES;    
    global ROI_DATA;
    try
        sample_and_display_time_range(ROI_DATA, FILES, handles.fileTable, handles.sampleTable, handles.sampleLUT);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'menuMSE' Callback
%   Opens a dialog letting the user select a sample and see its mean and
%   standard error
%
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'mean_and_ste_dlg' Function
function menuMSE_Callback(~, ~, handles)
    try
        mean_and_ste_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end



%% --------------------------------------------------------------------
% 'menuPValue' Callback
%   Opens a dialog letting the user select 2 samples and see if they have a
%   statistically significant difference using a 2-sample t-test
%
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
% 
% OUTPUTS/EFFECTS
% ---------------
% See 'p_value_dlg' Function
%
function menuPValue_Callback(~, ~, handles)
    try
        p_value_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnMSE' Callback
%   Opens a dialog letting the user select a sample and see its mean and
%   standard error
% 
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% See 'mean_and_ste_dlg' Function
function btnMSE_Callback(~, ~, handles)
    try
        mean_and_ste_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnPValue' Callback
%   Opens a dialog letting the user select 2 samples and see if they have a
%   statistically significant difference using a 2-sample t-test
%
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
% 
% OUTPUTS/EFFECTS
% ---------------
% See 'p_value_dlg' Function
%
function btnPValue_Callback(~, ~, handles)
    try
        p_value_dlg(handles.sampleTable);
    catch err
        errordlg(exception_to_str(err));
    end


%% --------------------------------------------------------------------
% 'btnClearSamples' Callback
%   Clears all selected samples and related info
%
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% <handles>
%   -> <sampleTable>: All data and column labels are cleared
%   -> <smapleLUT>: All data and row labels are cleared
%
function btnClearSamples_Callback(~, ~, handles)
    clear_table(handles.sampleTable);
    set(handles.sampleTable, 'ColumnName', {});
    clear_table(handles.sampleLUT);
    set(handles.sampleLUT, 'RowName', {});

%% --------------------------------------------------------------------
% 'clear_table' Function
%   Clears the data from the input table
%
% INPUTS
% ------
% <hTable>, hObj: Handle to table to clear
%
% OUTPUTS/EFFECTS
% ---------------
% <hTable>
%   -> <Data>: Set to an empty matrix, clearing any existing data
%
function clear_table(hTable)
    set(hTable, 'Data', []);



%% --------------------------------------------------------------------
% 'open_and_display_file' Function
%   Opens a dialog letting the user select 1 or more ROI files, 
%   storing the selected path, filenames, and the combined ROI data
% 
% INPUTS
% ------
% <hTable>, hObj: Handle to table that will display file data
%
% OUTPUTS/EFFECTS
% ---------------
% <path>, char: Set to the path to the selected file(s)
% <files>, cell: Contains the names of selected file(s) without the extension
% <roiData>, struct: Contains the combined data of the selected file(s). Follows the 'roi_data' struct format
% 
% EXCEPTIONS
% ----------
% See
%   'open_roi_file_dlg'
%   'multiple_fileparts'
%   'combine_roi_files'
%   'select_roi_data_dlg'
%   'roi_data_to_table'
%
function [success, path, files, roiData] = open_and_display_file(hTable)
path = '';
files = {};
roiData = struct;
try
    %% Let the user open file(s)
    [fileCount, filepaths, fileDataStructs] = open_roi_file_dlg();  
    
    %% Get the path and filenames and combine the file data
    if fileCount == 0
        success = false;
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
        success = false;
        return;
    end
    
    
    %% Display the ROI data
    [dataTable, colNames] = roi_data_to_table(roiData);
    set(hTable, 'Data', dataTable);
    set(hTable, 'ColumnName', colNames);
    
    success = true;
catch err
    rethrow(err);
end


%% --------------------------------------------------------------------
% 'sample_and_display_selection' Function
%   Uses the input file table and selection to output sample data and details
%
% INPUTS
% ------
% <roiData>, struct: Contains currently loaded ROI data. Must follow 'roi_data' struct format
% <files>, cell: Names of files that are currently open
% <hFileTable>, hObj: Handle to table that contains file data
% <selection>, matrix: Selected <hFileTable> indices. Must be a collection of [row, column] pairs
% <hSampleTable>, hObj: Handle to table that will display the selected samples
% <hSampleLUT>, hObj: Handle to the table that contains details about the selected samples
%
% OUTPUTS/EFFECTS
% ---------------
% <hSampleTable>
%   -> <Data>: Will contain additional columns corresponding to selected
%              samples. If the samples are longer than existing entries, the table
%              will be padded with NaNs. If the samples are shorter, then the samples
%              will be padded with NaNs.
%   -> <ColumnName>: Will include additional labels in the form: 'Sample <number> (<type>)'
% <hSampleLUT>
%   -> <Data>: Will contain additional rows with details about the selected
%              samples. Rows are in the form: 
%       { <sampleSize>, <startPt>, <endPt>, <sourceCol1> , ..., <sourcColN>, <sourceFile1>, ..., <sourceFileM> }
%   -> <RowName>: Same as <hSampleTable> -> <ColumnName>
%
% EXCEPTIONS
% ----------
% See
%   'roi_data_count'
%   'table_layout_of_roi_data'
%   'table_selection_layout'
%   'select_roi_data_from_table'
%   'add_samples_to_table'
%   'add_sample_to_lut'
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
        if isempty(selectionLayout{2}) && ...
           isempty(selectionLayout{3}) && ...
           isempty(selectionLayout{4})
            warndlg('Please select a column other than the time column');
            return;
        end
        
        
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
%   Opens a dialog letting the user input a range of points from which to
%   sample ROI data. This data and its details are then displayed in a
%   seperate table
%
% INPUTS
% ------
% <roiData>, struct: Contains currently loaded ROI data. Must follow 'roi_data' struct format
% <files>, cell: Names of files that are currently open
% <hFileTable>, hObj: Handle to table that contains file data
% <selection>, matrix: Selected <hFileTable> indices. Must be a collection of [row, column] pairs
% <hSampleTable>, hObj: Handle to table that will display the selected samples
% <hSampleLUT>, hObj: Handle to the table that contains details about the selected samples
%
% OUTPUTS/EFFECTS
% ---------------
% See 'select_time_range_dlg' and 'sample_and_display_selection'
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
%   Opens a dialog letting the user input a start data point and an
%   end data point. This along with some time values is used to construct a
%   range of data points
%
% INPUTS
% ------
% <timeVals>, matrix: The currently loaded time values. Must have at least 2 values
%
% OUTPUTS/EFFECTS
% ---------------
% <rangeWasChosen>, logical: True if the user input valid values. False otherwise
% <ptRange>, matrix: The range of points corresponding to the input start and end points
%
% EXCEPTIONS
% ----------
% 'general_error' if <timeVals> has less than 2 values
% warning if 
%   User did not input 2 values
%   User did not input numeric values
%   User input values out of order
%   User input values outside range of <timeVals>
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
    if isempty(userInput)
        rangeWasChosen = false;
        return;
    elseif isempty(userInput{1}) || isempty(userInput{2})
        warndlg('Not all values were entered');
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
% 'mean_and_ste_dlg' Function
%   Opens a dialog letting the user select a sample to display the sample's
%   size, mean, and standard error
%
% INPUTS
% ------
% <hSampleTable>, hObj: Handle to table containing sample data
%
% NO OUTPUTS/EFFECTS
% 
function mean_and_ste_dlg(hSampleTable)
    options = get(hSampleTable, 'ColumnName');
    if isempty(options)
        warndlg('Please add a sample before calculating statistics');
        return;
    end
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
% 'p_value_dlg' Function
%   Opens a dialog letting the user select two samples to see if there is a
%   statistically significant difference using a 2-sample t-test. The
%   p-value is also displayed
%
% INPUTS
% ------
% <hSampleTable>, hObj: Handle to table containg sample data
%
% NO OUTPUTS/EFFECTS
%
function p_value_dlg(hSampleTable)
    options = get(hSampleTable, 'ColumnName');
    if isempty(options)
        warndlg('Please add a sample before calculating statistics');
        return;
    end
    [columns, sampleWasChosen] = listdlg('Name', 'P-Value', 'ListString', options, 'PromptString', 'Select 2 samples:');
    if sampleWasChosen
        if length(columns) ~= 2
            warndlg('Please select only 2 columns');
            return;
        end
        
        sampleTable = get(hSampleTable, 'Data');
        sampleA = sampleTable(:, columns(1));
        sampleB = sampleTable(:, columns(2));
        
        [reject, pVal] = ttest2(sampleA, sampleB);
        
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
%#ok<*DEFNU>
%    ^^^^
% Ignores 'unused function' warnings
