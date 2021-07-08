%% GUIDE Methods --------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% Entry Point - DO NOT EDIT
%
%      ANALYSIS_1_2_IB_061521, by itself, creates a new ANALYSIS_1_2_IB_061521 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_061521 returns the handle to a new ANALYSIS_1_2_IB_061521 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_061521('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_061521.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_061521('Property','Value',...) creates a new ANALYSIS_1_2_IB_061521 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_061521_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_061521_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
function varargout = analysis_1_2_IB_061521(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_061521_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_061521_OutputFcn, ...
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
% varargin   command line arguments to analysis_1_2_IB_061521 (see VARARGIN)
%
function analysis_1_2_IB_061521_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for analysis_1_2_IB_061521
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set initial program state
GUI.update_ui_access(handles, ROIFileType.None);


%% ----------------------------------------------------------------------------------------------------------------
% Output Method
%
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
function varargout = analysis_1_2_IB_061521_OutputFcn(hObject, eventdata, handles) 
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
    FileMenu.open(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuSave' Callback
%
function menuSave_Callback(hObject, ~, ~)
try
    FileMenu.save(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuClose' Callback
%
function menuClose_Callback(hObject, ~, ~)
try
    FileMenu.close(hObject);
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
    GUICallbacks.dataTable_select(hObject, eventdata);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Edit Callback 
%
function dataTable_CellEditCallback(hObject, eventdata, ~)
try
    GUICallbacks.dataTable_edit(hObject, eventdata);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuFix' Callback
%
function menuFix_Callback(hObject, ~, ~)
try
    DataMenu.fix(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleAdjustedTime' Callback
%
function btnToggleAdjustedTime_Callback(hObject, ~, ~)
try
    GUICallbacks.btnToggleAdjustedTime(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleNormVals' Callback
%
function btnToggleNormVals_Callback(hObject, ~, ~)
try
    GUICallbacks.btnToggleNormVals(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuToggleNormVals' Callback
%
function menuToggleNormVals_Callback(hObject, ~, ~)
try
    DataMenu.toggle_norm_vals(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'toggleROI' Callback
%
function toggleROI_Callback(hObject, ~, ~)
try
    DataMenu.toggle_roi(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableAllROI' Callback
%
function menuEnableAllROI_Callback(hObject, ~, ~)
try
    DataMenu.enable_all_roi(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableSelectedROI' Callback
%
function menuEnableSelectedROI_Callback(hObject, ~, ~)
try
    DataMenu.enable_selected_roi(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnEnableROI' Callback
%
function btnEnableROI_Callback(hObject, ~, ~)
try
    GUICallbacks.btnEnableROI(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowAbove' Callback
%
function menuAddRowAbove_Callback(hObject, ~, ~)
try
    DataMenu.add_row_above(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowBelow' Callback
%
function menuAddRowBelow_Callback(hObject, ~, ~)
try
    DataMenu.add_row_below(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuZeroRow' Callback
%
function menuZeroRow_Callback(hObject, ~, ~)
try
    DataMenu.zero_row(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuDeleteRow' Callback 
%
function menuDeleteRow_Callback(hObject, ~, ~)
try
    DataMenu.delete_row(hObject);
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
    PlotMenu.plot_all(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotSelected' Callback
%
function menuPlotSelected_Callback(hObject, ~, ~)
try
    PlotMenu.plot_selected(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAvg' Callback
%
function menuPlotAvg_Callback(hObject, ~, ~)
try
    PlotMenu.plot_averages(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowAnnots' Callback
%
function menuShowAnnots_Callback(hObject, ~, ~)
try
    PlotMenu.show_annotations(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowLifetime' Callback
%
function menuShowLifetime_Callback(hObject, ~, ~)
try
    PlotMenu.show_lifetime(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowGreen' Callback 
%
function menuShowGreen_Callback(hObject, ~, ~)
try
   PlotMenu.show_green(hObject); 
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowRed' Callback 
%
function menuShowRed_Callback(hObject, ~, ~)
try
    PlotMenu.show_red(hObject);
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
    GUICallbacks.btnAddSolution(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnRemoveSolution' Callback
%
function btnRemoveSolution_Callback(hObject, ~, ~)
try
    GUICallbacks.btnRemoveSolution(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'solutionTable' Cell Edit Callback
%
function solutionTable_CellEditCallback(hObject, eventdata, ~)
try
    GUICallbacks.solutionTable_edit(hObject, eventdata);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnChooseBaseline' Callback
%
function btnChooseBaseline_Callback(hObject, ~, ~)
try
    GUICallbacks.btnChooseBaseline(hObject);
catch err
    AppState.logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnImportInfo' Callback
%
function btnImportInfo_Callback(hObject, ~, ~)
try
    GUICallbacks.btnImportInfo(hObject);
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

function menuViewLogs_Callback(~, ~, ~)
logFile = IOUtils.path_to_log(Analysis_1_2_Versions.release());
[logs] = IOUtils.read_log(logFile);
inputLbls = {};
inputVals = {};
for i = size(logs, 1):-1:1
    logDate = logs{i, 1};
    logText = logs{i, 2};
    
    inputLbls{end+1} = logDate;
    inputVals{end+1} = logText;
end

inputdlg(inputLbls, 'Logs', [5 100], inputVals);

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
