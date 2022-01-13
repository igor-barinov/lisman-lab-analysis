%% GUIDE Methods --------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% Entry Point - DO NOT EDIT
%
%      ANALYSIS_1_2_IB_100921, by itself, creates a new ANALYSIS_1_2_IB_100921 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_100921 returns the handle to a new ANALYSIS_1_2_IB_100921 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_100921('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_100921.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_100921('Property','Value',...) creates a new ANALYSIS_1_2_IB_100921 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_100921_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_100921_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
function varargout = analysis_1_2_IB_100921(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_100921_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_100921_OutputFcn, ...
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
% varargin   command line arguments to analysis_1_2_IB_100921 (see VARARGIN)
%
function analysis_1_2_IB_100921_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for analysis_1_2_IB_100921
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
function varargout = analysis_1_2_IB_100921_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure

varargout{1} = handles.output;



%% ----------------------------------------------------------------------------------------------------------------
% Close Method
%
% hObject    handle to mainFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%
function mainFig_CloseRequestFcn(hObject, ~, ~)
GUI.try_callback(@GUI.close, @AppState.logdlg, hObject);


    

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
GUI.try_callback(@FileMenu.open, @AppState.logdlg, hObject)


%% ----------------------------------------------------------------------------------------------------------------
% 'menuSave' Callback
%
function menuSave_Callback(hObject, ~, ~)
GUI.try_callback(@FileMenu.save, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuClose' Callback
%
function menuClose_Callback(hObject, ~, ~)
GUI.try_callback(@FileMenu.close, @AppState.logdlg, hObject);




%% Data Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Selection Callback
%
function dataTable_CellSelectionCallback(hObject, eventdata, ~)
GUI.try_callback(@GUICallbacks.dataTable_select, @AppState.logdlg, hObject, eventdata);


%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Edit Callback 
%
function dataTable_CellEditCallback(hObject, eventdata, ~)
GUI.try_callback(@GUICallbacks.dataTable_edit, @AppState.logdlg, hObject, eventdata);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuFix' Callback
%
function menuFix_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.fix, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleAdjustedTime' Callback
%
function btnToggleAdjustedTime_Callback(hObject, ~, ~)
GUI.try_callback(@GUICallbacks.btnToggleAdjustedTime, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleNormVals' Callback
%
function btnToggleNormVals_Callback(hObject, ~, ~)
GUI.try_callback(@GUICallbacks.btnToggleNormVals, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuToggleNormVals' Callback
%
function menuToggleNormVals_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.toggle_norm_vals, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'toggleROI' Callback
%
function toggleROI_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.toggle_roi, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableAllROI' Callback
%
function menuEnableAllROI_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.enable_all_roi, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableSelectedROI' Callback
%
function menuEnableSelectedROI_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.enable_selected_roi, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'btnEnableROI' Callback
%
function btnEnableROI_Callback(hObject, ~, ~)
GUI.try_callback(@GUICallbacks.btnEnableROI, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowAbove' Callback
%
function menuAddRowAbove_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.add_row_above, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowBelow' Callback
%
function menuAddRowBelow_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.add_row_below, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuZeroRow' Callback
%
function menuZeroRow_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.zero_row, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuDeleteRow' Callback 
%
function menuDeleteRow_Callback(hObject, ~, ~)
GUI.try_callback(@DataMenu.delete_row, @AppState.logdlg, hObject);




%% Plot Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAll' Callback
%
function menuPlotAll_Callback(hObject, ~, ~)
GUI.try_callback(@PlotMenu.plot_all, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotSelected' Callback
%
function menuPlotSelected_Callback(hObject, ~, ~)
GUI.try_callback(@PlotMenu.plot_selected, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAvg' Callback
%
function menuPlotAvg_Callback(hObject, ~, ~)
GUI.try_callback(@PlotMenu.plot_averages, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowAnnots' Callback
%
function menuShowAnnots_Callback(hObject, ~, ~)
GUI.try_callback(@PlotMenu.show_annotations, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowLifetime' Callback
%
function menuShowLifetime_Callback(hObject, ~, ~)
GUI.try_callback(@PlotMenu.show_lifetime, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowGreen' Callback 
%
function menuShowGreen_Callback(hObject, ~, ~)
GUI.try_callback(@PlotMenu.show_green, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowRed' Callback 
%
function menuShowRed_Callback(hObject, ~, ~)
GUI.try_callback(@PlotMenu.show_red, @AppState.logdlg, hObject);




%% Experiment Info Methods ----------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'btnAddSolution' Callback
%
function btnAddSolution_Callback(hObject, ~, ~)
GUI.try_callback(@GUICallbacks.btnAddSolution, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'btnRemoveSolution' Callback
%
function btnRemoveSolution_Callback(hObject, ~, ~)
GUI.try_callback(@GUICallbacks.btnRemoveSolution, @AppState.logdlg, hObject);


%% ----------------------------------------------------------------------------------------------------------------
% 'solutionTable' Cell Edit Callback
%
function solutionTable_CellEditCallback(hObject, eventdata, ~)
GUI.try_callback(@GUICallbacks.solutionTable_edit, @AppState.logdlg, hObject, eventdata);


%% ----------------------------------------------------------------------------------------------------------------
% 'btnImportInfo' Callback
%
function btnImportInfo_Callback(hObject, ~, ~)
GUI.try_callback(@GUICallbacks.btnImportInfo, @AppState.logdlg, hObject);



%% Tools Menu Methods ---------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

function menuPreferences_Callback(hObject, ~, ~)
GUI.try_callback(@GUICallbacks.menuPreferences, @AppState.logdlg, hObject);


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
