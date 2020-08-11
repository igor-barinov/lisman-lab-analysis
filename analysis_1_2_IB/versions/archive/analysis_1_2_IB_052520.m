%% ################################################################################################################
%
% GUIDE FUNCTIONS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'analysis_1_2_IB'
%
function varargout = analysis_1_2_IB_052520(varargin)
    % ANALYSIS_1_2_IB_052520 MATLAB code for analysis_1_2_IB_052520.fig
    %      ANALYSIS_1_2_IB_052520, by itself, creates a new ANALYSIS_1_2_IB_052520 or raises the existing
    %      singleton*.
    %
    %      H = ANALYSIS_1_2_IB_052520 returns the handle to a new ANALYSIS_1_2_IB_052520 or the handle to
    %      the existing singleton*.
    %
    %      ANALYSIS_1_2_IB_052520('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in ANALYSIS_1_2_IB_052520.M with the given input arguments.
    %
    %      ANALYSIS_1_2_IB_052520('Property','Value',...) creates a new ANALYSIS_1_2_IB_052520 or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before analysis_1_2_IB_052520_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to analysis_1_2_IB_052520_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help analysis_1_2_IB_052520

    % Last Modified by GUIDE v2.5 29-May-2020 14:46:33

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @analysis_1_2_IB_052520_OpeningFcn, ...
                       'gui_OutputFcn',  @analysis_1_2_IB_052520_OutputFcn, ...
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
function analysis_1_2_IB_052520_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to analysis_1_2_IB_052520 (see VARARGIN)

    % Choose default command line output for analysis_1_2_IB_052520
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % Init code
    clear_globals();
    
function varargout = analysis_1_2_IB_052520_OutputFcn(~, ~, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

    
%% ----------------------------------------------------------------------------------------------------------------
% Initialization Functions
function inputDNAType_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end 
    

%% ----------------------------------------------------------------------------------------------------------------
% Unused Callabacks
function menuFile_Callback(~, ~, ~)
function menuData_Callback(~, ~, ~)
function menuToggle_Callback(~, ~, ~)
function menuToggleROI_Callback(~, ~, ~)
function menuRow_Callback(~, ~, ~)
function menuPlot_Callback(~, ~, ~)
function menuTools_Callback(~, ~, ~) 



%% ################################################################################################################
%
% INFO CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'solutionTable' Cell Edit Callback
%
function solutionTable_CellEditCallback(~, eventdata, handles)
global NEW_FILE;
try
    [~, numPts, ~] = roi_data_count(NEW_FILE.rawData);
    row = eventdata.Indices(1);
    column = eventdata.Indices(2);
    
    if isempty(eventdata.EditData)
        choice = questdlg('Do you want to remove this solution?', 'Remove Solution', 'Yes', 'No', 'No');
        if strcmp(choice, 'Yes')
            [NEW_FILE.info] = remove_solution_info(NEW_FILE.info, row);
        end
    else
        newSolutions = NEW_FILE.info.solutions;
        if column == 1
            newSol = eventdata.EditData;
            newSolutions{row, column} = newSol;
        elseif column == 2
            newTiming = str2double(eventdata.EditData);
            if isnan(newTiming) || newTiming < 1 || newTiming > numPts
                warndlg(['Please enter a timing from 1 to ', num2str(numPts)]);
            else
                newSolutions{row, column} = newTiming;
            end
        end
        
        [NEW_FILE.info] = update_exp_info_struct(NEW_FILE.info, newSolutions);
    end
    
    display_file_info(NEW_FILE, handles.inputDNAType, handles.solutionTable);
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnImportInfo' Callback
%
function btnImportInfo_Callback(~, ~, handles)
global NEW_FILE;

try
    [fileWasOpened, fileNotes] = import_notes_dlg();
    if fileWasOpened
        [foundDNAType, nSolFound, dnaType, solutions] = read_exp_notes(fileNotes);
        newData = {};
        if foundDNAType
            newData{end+1} = dnaType;
        end
        if nSolFound > 0
            newData{end+1} = solutions;
        end
        
        if isempty(newData)
            warndlg('No info could be extracted');
        else
            [NEW_FILE.info] = update_exp_info_struct(NEW_FILE.info, newData{:});
            display_file_info(NEW_FILE, handles.inputDNAType, handles.solutionTable);
        end
    end
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'inputDNAType' Callback
%
function inputDNAType_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnAddSolution' Callback
%
function btnAddSolution_Callback(~, ~, handles)
global NEW_FILE;
[solWasAdded, newExpInfo] = add_solution_dlg(NEW_FILE.info, handles.solutionTable);
if solWasAdded
    NEW_FILE.info = newExpInfo;
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnRemoveSol' Callback
%
function btnRemoveSol_Callback(hObject, eventdata, handles)
global NEW_FILE;
[solWasRemoved, newExpInfo] = remove_solution_dlg(NEW_FILE.info, handles.solutionTable);
if solWasRemoved
    NEW_FILE.info = newExpInfo;
end



%% ################################################################################################################
%
% ROI DATA CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Selection Callback
%
function dataTable_CellSelectionCallback(~, eventdata, ~)
global DATA_TABLE_SELECTION;
DATA_TABLE_SELECTION = eventdata.Indices;

%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Edit Callback
%
function dataTable_CellEditCallback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleAdjustedTime' Callback
%
function btnToggleAdjustedTime_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleNormVals' Callback
%
function btnToggleNormVals_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnEnableROI' Callback
%
function btnEnableROI_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end



%% ################################################################################################################
%
% MENU->FILE CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'menuOpen' Callback
%
% INPUTS
% ------
% <handles>, struct: Contains each GUI handle
%
% OUTPUTS/EFFECTS
% ---------------
% global <OPEN_FILE>, struct: Will contain combined data from selected file(s)
% global <NEW_FILE>, struct: Will contain data to be edited
% global <FILEPATHS>, char or cell: Contains the paths to the opened file(s)
% 
function menuOpen_Callback(~, ~, handles)
global OPEN_FILE;
global NEW_FILE;
global FILEPATHS;

try
    % Let the user select file(s)
    [fileCount, FILEPATHS, roiFiles] = open_roi_file_dlg();
    if fileCount == 0
        return;
    end
    
    % Combine the file data into a single struct
    if fileCount > 1
        [OPEN_FILE] = combine_roi_files(roiFiles);
    else
        OPEN_FILE = roiFiles;
    end
    
    % Display the file data and info
    display_file_data(OPEN_FILE, handles.dataTable);
    if ~is_raw_file_data(OPEN_FILE)
        display_file_info(OPEN_FILE, handles.inputDNAType, handles.solutionTable);
    end
    
    % Set the editable file to the opened file
    [NEW_FILE] = setup_new_file(OPEN_FILE);
    
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuSave' Callback
%
function menuSave_Callback(~, ~, handles)
global OPEN_FILE;
global NEW_FILE;

try
    [~,~,solutions] = read_exp_info_struct(NEW_FILE.info);
    [~, numBasePts] = solution_timings(solutions);
    
    [NEW_FILE.prepData] = prepare_roi_data(NEW_FILE.rawData, numBasePts);
    [NEW_FILE.avgData] = average_roi_data(NEW_FILE.prepData, numBasePts);
    
    [fileWasSaved, savedFile] = save_roi_file_dlg(NEW_FILE.rawData, NEW_FILE.prepData, NEW_FILE.info, NEW_FILE.avgData);
    if fileWasSaved
        choice = questdlg('Would you like to open the saved file?', 'Open File', 'Yes', 'No', 'No');
        if strcmp(choice, 'Yes')
            OPEN_FILE = savedFile;
            display_file_data(OPEN_FILE, handles.dataTable);
            display_file_info(OPEN_FILE, handles.inputDNAType, handles.solutionTable);
            [NEW_FILE] = setup_new_file(OPEN_FILE);
        end
    end
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuClose' Callback
%
function menuClose_Callback(~, ~, handles)
try
    choice = questdlg('Are you sure you want to close this file?', 'Confirmation', 'Yes', 'No', 'No');
    if strcmp(choice, 'Yes')
        clear_globals();
    end
catch err
    errordlg(exception_to_str(err));
end



%% ################################################################################################################
%
% MENU->DATA CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'menuFix' Callback
%
function menuFix_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end



%% ################################################################################################################
%
% MENU->DATA->TOGGLE CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'menuToggleNormVals' Callback
%
function menuToggleNormVals_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableSelectedROI' Callback
%
function menuEnableSelectedROI_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'toggleROI' Callback
%
function toggleROI_Callback(src, event, args)
try
catch err
    errordlg(exception_to_str(err));
end



%% ################################################################################################################
%
% MENU->DATA->ROW CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowAbove' Callback
%
function menuAddRowAbove_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowBelow' Callback
%
function menuAddRowBelow_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuZeroRow' Callback
%
function menuZeroRow_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuDeleteRow' Callback
%
function menuDeleteRow_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end



%% ################################################################################################################
%
% MENU->PLOT CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAll' Callback
%
function menuPlotAll_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotSelected' Callback
%
function menuPlotSelected_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAvg' Callback
%
function menuPlotAvg_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowAnnots' Callback
%
function menuShowAnnots_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowLifetime' Callback
%
function menuShowLifetime_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowGreen' Callback
%
function menuShowGreen_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowRed' Callback
%
function menuShowRed_Callback(hObject, eventdata, handles)
try
catch err
    errordlg(exception_to_str(err));
end



%% ################################################################################################################
%
% MENU->TOOLS CALLBACKS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'menuSPC' Callback 
%
function menuSPC_Callback(~, ~, ~)
spc_drawInit;

%% ----------------------------------------------------------------------------------------------------------------
% 'menuImstack' Callback
%
function menuImstack_Callback(~, ~, ~)
h_imstack;

%% ----------------------------------------------------------------------------------------------------------------
% 'menuROIStats' Callback
%
function menuROIStats_Callback(~, ~, ~)
stats_IB_052220;



%% ################################################################################################################
%
% PROGRAM UTILITY FUNCTIONS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'clear_globals' Function
%
function clear_globals()
global OPEN_FILE;
global NEW_FILE;
global FILEPATHS;

OPEN_FILE = struct;
NEW_FILE = struct;
FILEPATHS = {};





%% ----------------------------------------------------------------------------------------------------------------
% 'set_ui_availability' Function
%
function set_ui_availability(enabled, handles)
if nargin ~= 2
    throw(missing_inputs_error(nargin, 2));
end

if enabled
    set(handles, 'Enable', 'on');
else
    set(handles, 'Enable', 'off');
end



%% ################################################################################################################
%
% FILE UTILITY FUNCTIONS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'file_is_open' Function
%
function [tf] = file_is_open(fileData)
try 
    tf = is_raw_file_data(fileData) || ...
        is_prep_file_data(fileData) || ...
        is_avg_file_data(fileData);
catch err
    rethrow(err);
end




%% ----------------------------------------------------------------------------------------------------------------
% 'display_file_data' Function
%
% INPUTS
% ------
% <file>, struct: Contains file data in the 'file_data' format
% <hTable>, hObj: Handle to table that will hold file data
% 
% OUTPUTS/EFFECTS
% ---------------
% <hTable>
%   -> <Data>, matrix: Set to a matrix with either ROI data or ROI averages
%   -> <ColumnName>, cell: Set to labels of ROI data
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if 2 args were not given
% See also
%   'avg_data_to_table'
%   'select_roi_data_dlg'
%   'roi_data_to_table'
%
function display_file_data(file, hTable)
if nargin ~= 2
    throw(missing_inputs_error(nargin, 2));
end

if is_avg_file_data(file)
    [tableData, dataLabels] = avg_data_to_table(file.avgData);
else
    [dataWasChosen, tableData] = select_roi_data_dlg(file);
    if ~dataWasChosen
        return;
    end
    
    [tableData, dataLabels] = roi_data_to_table(tableData);
end

set(hTable, 'Data', tableData);
set(hTable, 'ColumnName', dataLabels);



%% ----------------------------------------------------------------------------------------------------------------
% 'setup_new_file' Function
function [newFile] = setup_new_file(openFile)
if nargin ~= 1
    throw(missing_inputs_error(nargin, 1));
end 

if is_raw_file_data(openFile)
    [numROI, ~, ~] = roi_data_count(openFile.rawData);
    [newFile] = make_roi_file('PREP', openFile.rawData, openFile.rawData, make_exp_info_struct(numROI));
elseif is_prep_file_data(openFile)
    [newFile] = make_roi_file('PREP', openFile.rawData, openFile.prepData, openFile.info);
elseif is_avg_file_data(openFile)
    newFile = openFile;
else
    throw(invalid_type_error({'openFile'}, {'file_data struct'}));
end



%% ################################################################################################################
%
% INFO UTILITY FUNCTIONS
%
% #################################################################################################################

%% ----------------------------------------------------------------------------------------------------------------
% 'display_file_info' Function
function display_file_info(file, hDNALabel, hSolTable)
set(hSolTable, 'Data', file.info.solutions);
set(hDNALabel, 'String', file.info.dnaType);


%% ----------------------------------------------------------------------------------------------------------------
% 'import_notes_dlg' Dialog Function
%
function [fileWasOpened, fileNotes] = import_notes_dlg()
fileNotes = '';
[filename, path] = uigetfile({'*.docx'; '*.doc'});

if isequal(filename, 0) || isequal(path, 0)
    fileWasOpened = false;
    return;
end

try
    wordApp = actxserver('Word.Application');
    wordDoc = wordApp.Documents.Open(fullfile(path, filename));
    fileNotes = wordDoc.Content.Text;
    wordDoc.Close();
    wordApp.Quit();
    fileWasOpened = true;
catch
    warndlg('There was an error opening the Word file');
    fileWasOpened = false;
    return;
end



%% ----------------------------------------------------------------------------------------------------------------
% 'add_solution_dlg' Dialog Function
%
function [solWasAdded, newExpInfo] = add_solution_dlg(currentExpInfo, hSolTable)
newExpInfo = struct;

if nargin ~= 2
    throw(missing_inputs_error(nargin, 2));
end

prompt = {'Solution Name:', 'Solution Timing (in # of points):'};
userInput = inputdlg(prompt, 'Add Solution');

if isempty(userInput) || isempty(userInput{1}) || isempty(userInput{2})
    solWasAdded = false;
    return;
end

solName = userInput{1};
solTiming = str2double(userInput{2});

if isnan(solTiming)
    warndlg('Please enter a number for the solution timing');
    solWasAdded = false;
    return;
end

try
    [newExpInfo] = add_solution_info(currentExpInfo, solName, solTiming);
    set(hSolTable, 'Data', newExpInfo.solutions);
    solWasAdded = true;
catch err
    errordlg(exception_to_str(err));
    solWasAdded = false;
end


%% ----------------------------------------------------------------------------------------------------------------
% 'remove_solution_dlg' Dialog Function
%
function [solWasRemoved, newExpInfo] = remove_solution_dlg(currentExpInfo, hSolTable)
newExpInfo = struct;

if nargin ~= 2
    throw(missing_inputs_error(nargin, 2));
end

try
    [~, ~, solutions] = read_exp_info_struct(currentExpInfo);
    options = solutions(:, 1);
    [solSelected, solWasChosen] = listdlg('Name', 'Choose Solution to Remove', 'ListString', options, 'PromptString', 'Select Solution to Remove:');
    
    if ~solWasChosen
        solWasRemoved = false;
        return;
    end
    
    newExpInfo = remove_solution_info(currentExpInfo, solSelected);
    set(hSolTable, 'Data', newExpInfo.solutions);
    solWasRemoved = true;
catch err
    errordlg(exception_to_str(err));
end







%% ----------------------------------------------------------------------------------------------------------------
% Ignore 'unused function' warning
%
%#ok<*DEFNU>