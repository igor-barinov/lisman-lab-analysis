function varargout = analysis_1_2_user_options(varargin)
% ANALYSIS_1_2_USER_OPTIONS MATLAB code for analysis_1_2_user_options.fig
%      ANALYSIS_1_2_USER_OPTIONS, by itself, creates a new ANALYSIS_1_2_USER_OPTIONS or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_USER_OPTIONS returns the handle to a new ANALYSIS_1_2_USER_OPTIONS or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_USER_OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_USER_OPTIONS.M with the given input arguments.
%
%      ANALYSIS_1_2_USER_OPTIONS('Property','Value',...) creates a new ANALYSIS_1_2_USER_OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_user_options_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_user_options_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysis_1_2_user_options

% Last Modified by GUIDE v2.5 09-Oct-2021 12:37:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_user_options_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_user_options_OutputFcn, ...
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


% --- Executes just before analysis_1_2_user_options is made visible.
function analysis_1_2_user_options_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysis_1_2_user_options (see VARARGIN)

% Choose default command line output for analysis_1_2_user_options
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Custom init code
PreferencesApp.startup(handles);

% UIWAIT makes analysis_1_2_user_options wait for user response (see UIRESUME)
% uiwait(handles.mainFig);


% --- Outputs from this function are returned to the command line.
function varargout = analysis_1_2_user_options_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function btnSaveChanges_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.btnSaveChanges, @PreferencesApp.logdlg, hObject);

function show_lifetime_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.checkBoxSetting, @PreferencesApp.logdlg, hObject, 'show_lifetime');

function show_green_int_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.checkBoxSetting, @PreferencesApp.logdlg, hObject, 'show_green_int');

function show_red_int_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.checkBoxSetting, @PreferencesApp.logdlg, hObject, 'show_red_int');

function show_annotations_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.checkBoxSetting, @PreferencesApp.logdlg, hObject, 'show_annotations');

function lt_x_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_x');

function lt_y_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_y');

function lt_w_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_w');

function lt_h_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_h');

function lt_x_min_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_x_min');

function lt_x_max_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_x_max');

function lt_y_min_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_y_min');

function lt_y_max_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'lt_y_max');

function green_y_max_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_y_max');

function green_y_min_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_y_min');

function green_x_max_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_x_max');

function green_x_min_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_x_min');

function green_h_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_h');

function green_w_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_w');

function green_y_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_y');

function green_x_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'green_x');

function red_x_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_x');

function red_y_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_y');

function red_w_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_w');

function red_h_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_h');

function red_x_min_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_x_min');

function red_x_max_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_x_max');

function red_y_min_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_y_min');

function red_y_max_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.textInputSetting, @PreferencesApp.logdlg, hObject, 'red_y_max');

function savedDefsList_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.savedDefsList, @PreferencesApp.logdlg, hObject);

function btnAddDefault_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.btnAddDefault, @PreferencesApp.logdlg, hObject);

function btnRemoveDefault_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.btnRemoveDefault, @PreferencesApp.logdlg, hObject);

function btnEditDefault_Callback(hObject, ~, ~)
GUI.try_callback(@PreferencesApp.btnEditDefault, @PreferencesApp.logdlg, hObject);

%#ok<*DEFNU>
