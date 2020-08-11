%% ******************************* GUIDE FUNCTIONS - DO NOT EDIT
function varargout = analysis_1_2_IB_122319(varargin)
% ANALYSIS_1_2_IB_122319 MATLAB code for analysis_1_2_IB_122319.fig
%      ANALYSIS_1_2_IB_122319, by itself, creates a new ANALYSIS_1_2_IB_122319 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_122319 returns the handle to a new ANALYSIS_1_2_IB_122319 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_122319('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_122319.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_122319('Property','Value',...) creates a new ANALYSIS_1_2_IB_122319 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_122319_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_122319_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysis_1_2_IB_122319

% Last Modified by GUIDE v2.5 23-Dec-2019 12:24:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_122319_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_122319_OutputFcn, ...
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
function analysis_1_2_IB_122319_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysis_1_2_IB_122319 (see VARARGIN)

% Choose default command line output for analysis_1_2_IB_122319
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
function varargout = analysis_1_2_IB_122319_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% **********************************************
%               GUI INIT FUNCTIONS   
%************************************************
function inputDNAType_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputSolBase_CreateFcn(hObject, ~, ~)
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
function inputNumBase_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputWashStart_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% **********************************************
%               GUI INPUT CALLBACKS
%************************************************
function inputDNAType_Callback(hObject, eventdata, handles)
function inputSolBase_Callback(hObject, eventdata, handles)
function inputSolA_Callback(hObject, eventdata, handles)
function inputSolB_Callback(hObject, eventdata, handles)
function inputNumBase_Callback(hObject, eventdata, handles)
function inputWashStart_Callback(hObject, eventdata, handles)
function btnImportInfo_Callback(hObject, eventdata, handles)

%% **********************************************
%               DATA TABLE CALLBACKS
%************************************************
function dataTable_CellSelectionCallback(hObject, eventdata, handles)
function dataTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to dataTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

%% **********************************************
%               MENU -> FILE CALLBACKS
%************************************************
function menuFile_Callback(~, ~, ~)
function menuOpen_Callback(hObject, eventdata, handles)
function menuSave_Callback(hObject, eventdata, handles)
function menuClose_Callback(hObject, eventdata, handles)


%% **********************************************
%               MENU -> DATA CALLBACKS
%************************************************
function menuData_Callback(~, ~, ~)
function menuFix_Callback(hObject, eventdata, handles)

%% **********************************************
%          MENU -> DATA -> TOGGLE CALLBACKS
%************************************************
function menuToggle_Callback(~, ~, ~)
function btnToggleAdjustedTime_Callback(hObject, eventdata, handles)
function menuToggleNormVals_Callback(hObject, eventdata, handles)
function menuToggleROI_Callback(~, ~, ~)
function toggleROI_Callback(src, event, args)
function menuToggleSelectedROI_Callback(hObject, eventdata, handles)

%% **********************************************
%          MENU -> DATA -> ROW CALLBACKS
%************************************************
function menuRow_Callback(hObject, eventdata, handles)
function menuAddRowAbove_Callback(hObject, eventdata, handles)
function menuAddRowBelow_Callback(hObject, eventdata, handles)
function menuZeroRow_Callback(hObject, eventdata, handles)
function menuDeleteRow_Callback(hObject, eventdata, handles)

%% **********************************************
%           MENU -> DATA -> PLOT CALLBACKS
%************************************************
function menuPlot_Callback(~, ~, ~)
function menuPlotAll_Callback(hObject, eventdata, handles)
function menuPlotSelected_Callback(hObject, eventdata, handles)
function menuPlotAvg_Callback(hObject, eventdata, handles)

%% **********************************************
%           MENU -> DATA -> SHOW CALLBACKS
%************************************************
function menuShowAnnots_Callback(hObject, eventdata, handles)
function menuShowLifetime_Callback(hObject, eventdata, handles)
function menuShowGreen_Callback(hObject, eventdata, handles)
function menuShowRed_Callback(hObject, eventdata, handles)

%% **********************************************
%               MENU -> TOOLS CALLBACKS
%************************************************
function menuTools_Callback(~, ~, ~)
function menuSPC_Callback(~, ~, ~)
function menuImstack_Callback(~, ~, ~)
