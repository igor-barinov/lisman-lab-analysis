%% ENTRY POINT, DO NOT EDIT =======================================================================================
function varargout = analysis_1_2_IB_012220(varargin)
    % ANALYSIS_1_2_IB_012220 MATLAB code for analysis_1_2_IB_012220.fig
    %      ANALYSIS_1_2_IB_012220, by itself, creates a new ANALYSIS_1_2_IB_012220 or raises the existing
    %      singleton*.
    %
    %      H = ANALYSIS_1_2_IB_012220 returns the handle to a new ANALYSIS_1_2_IB_012220 or the handle to
    %      the existing singleton*.
    %
    %      ANALYSIS_1_2_IB_012220('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in ANALYSIS_1_2_IB_012220.M with the given input arguments.
    %
    %      ANALYSIS_1_2_IB_012220('Property','Value',...) creates a new ANALYSIS_1_2_IB_012220 or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before analysis_1_2_IB_012220_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to analysis_1_2_IB_012220_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help analysis_1_2_IB_012220

    % Last Modified by GUIDE v2.5 25-May-2020 14:01:14

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @analysis_1_2_IB_012220_OpeningFcn, ...
                       'gui_OutputFcn',  @analysis_1_2_IB_012220_OutputFcn, ...
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
    
%% STARTUP METHOD =================================================================================================
function analysis_1_2_IB_012220_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to analysis_1_2_IB_012220 (see VARARGIN)

    % Choose default command line output for analysis_1_2_IB_012220
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    %% Methods called on startup
    clear_workspace();
    update_menu(handles);
    update_exp_info(handles);
    update_data_table(handles.dataTable);

%% OUTPUT METHOD ==================================================================================================
function varargout = analysis_1_2_IB_012220_OutputFcn(~, ~, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
%% ================================================================================================================
    



%% FILE METHODS ===================================================================================================

%% ================================================================================================================
    


%% UI METHODS =====================================================================================================

%% ================================================================================================================
    


%% INITIALIZATION METHODS, DO NOT EDIT ============================================================================
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
%% ================================================================================================================    
    


%% UI CALLBACKS ===================================================================================================
function dataTable_CellSelectionCallback(hObject, eventdata, handles)

function dataTable_CellEditCallback(hObject, eventdata, handles)

function btnToggleAdjustedTime_Callback(hObject, eventdata, handles)

function btnToggleNormVals_Callback(hObject, eventdata, handles)

function btnEnableROI_Callback(hObject, eventdata, handles)

function inputDNAType_Callback(hObject, eventdata, handles)
function inputSolBase_Callback(hObject, eventdata, handles)
function inputNumBase_Callback(hObject, eventdata, handles)
function btnAddSolution_Callback(hObject, eventdata, handles)
function solutionTable_CellEditCallback(hObject, eventdata, handles)

function btnImportInfo_Callback(hObject, eventdata, handles)
%% ================================================================================================================



%% MENU->FILE CALLBACKS ===========================================================================================
function menuFile_Callback(~, ~, ~)

function menuOpen_Callback(hObject, eventdata, handles)
    opened = open_files();
    if (opened)
        update_menu(handles);
        update_exp_info(handles);
        update_data_table(handles.dataTable);
    end
    
function menuSave_Callback(hObject, eventdata, handles)
    save_file();
    
function menuClose_Callback(hObject, eventdata, handles)
    closed = close_file();
    if (closed)
        update_menu(handles);
        update_exp_info(handles);
        update_data_table(handles.dataTable);
    end
%% ================================================================================================================
    


%% MENU->DATA CALLBACKS ===========================================================================================
function menuData_Callback(~, ~, ~)

function menuFix_Callback(hObject, eventdata, handles)

function menuToggle_Callback(hObject, eventdata, handles)

function menuToggleNormVals_Callback(hObject, eventdata, handles)

function menuToggleROI_Callback(hObject, eventdata, handles)

function toggleROI_Callback(src, event, args)

function menuEnableSelectedROI_Callback(hObject, eventdata, handles)

function menuRow_Callback(hObject, eventdata, handles)

function menuAddRowAbove_Callback(hObject, eventdata, handles)

function menuAddRowBelow_Callback(hObject, eventdata, handles)

function menuZeroRow_Callback(hObject, eventdata, handles)

function menuDeleteRow_Callback(hObject, eventdata, handles)
%% ================================================================================================================



%% MENU->PLOT CALLBACKS ===========================================================================================
function menuPlot_Callback(~, ~, ~)

function menuPlotAll_Callback(hObject, eventdata, handles)

function menuPlotSelected_Callback(hObject, eventdata, handles)

function menuPlotAvg_Callback(hObject, eventdata, handles)

function menuShowAnnots_Callback(hObject, eventdata, handles)

function menuShowLifetime_Callback(hObject, eventdata, handles)

function menuShowGreen_Callback(hObject, eventdata, handles)

function menuShowRed_Callback(hObject, eventdata, handles)
%% ================================================================================================================



%% MENU->TOOLS CALLBACKS ==========================================================================================
function menuTools_Callback(~, ~, ~) 

function menuSPC_Callback(~, ~, ~)

function menuImstack_Callback(~, ~, ~)
%% ================================================================================================================
%#ok<*DEFNU>


% --- Executes on button press in btnSetBaselineSol.
function btnSetBaselineSol_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetBaselineSol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
