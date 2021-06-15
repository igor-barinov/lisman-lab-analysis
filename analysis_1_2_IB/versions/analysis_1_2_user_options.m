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

% Last Modified by GUIDE v2.5 14-Jun-2021 21:56:19

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
function analysis_1_2_user_options_OpeningFcn(hObject, eventdata, handles, varargin)
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
function varargout = analysis_1_2_user_options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function btnSaveChanges_Callback(hObject, ~, ~)
try
    PreferencesApp.btnSaveChanges(hObject);
catch err
    PreferencesApp.logdlg(err);
end

function show_lifetime_Callback(hObject, ~, ~)
try
    PreferencesApp.checkBoxSetting(hObject, 'show_lifetime');
catch err
    PreferencesApp.logdlg(err);
end

function show_green_int_Callback(hObject, ~, ~)
try
    PreferencesApp.checkBoxSetting(hObject, 'show_green_int');
catch err
    PreferencesApp.logdlg(err);
end

function show_red_int_Callback(hObject, ~, ~)
try
    PreferencesApp.checkBoxSetting(hObject, 'show_red_int');
catch err
    PreferencesApp.logdlg(err);
end

function show_annotations_Callback(hObject, ~, ~)
try
    PreferencesApp.checkBoxSetting(hObject, 'show_annotations');
catch err
    PreferencesApp.logdlg(err);
end

function lt_x_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_x');
catch err
    PreferencesApp.logdlg(err);
end

function lt_y_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_y');
catch err
    PreferencesApp.logdlg(err);
end

function lt_w_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_w');
catch err
    PreferencesApp.logdlg(err);
end

function lt_h_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_h');
catch err
    PreferencesApp.logdlg(err);
end

function lt_x_min_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_x_min');
catch err
    PreferencesApp.logdlg(err);
end

function lt_x_max_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_x_max');
catch err
    PreferencesApp.logdlg(err);
end

function lt_y_min_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_y_min');
catch err
    PreferencesApp.logdlg(err);
end

function lt_y_max_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'lt_y_max');
catch err
    PreferencesApp.logdlg(err);
end

function green_y_max_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_y_max');
catch err
    PreferencesApp.logdlg(err);
end

function green_y_min_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_y_min');
catch err
    PreferencesApp.logdlg(err);
end

function green_x_max_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_x_max');
catch err
    PreferencesApp.logdlg(err);
end

function green_x_min_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_x_min');
catch err
    PreferencesApp.logdlg(err);
end

function green_h_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_h');
catch err
    PreferencesApp.logdlg(err);
end

function green_w_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_w');
catch err
    PreferencesApp.logdlg(err);
end

function green_y_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_y');
catch err
    PreferencesApp.logdlg(err);
end

function green_x_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'green_x');
catch err
    PreferencesApp.logdlg(err);
end

function red_x_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_x');
catch err
    PreferencesApp.logdlg(err);
end

function red_y_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_y');
catch err
    PreferencesApp.logdlg(err);
end

function red_w_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_w');
catch err
    PreferencesApp.logdlg(err);
end

function red_h_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_h');
catch err
    PreferencesApp.logdlg(err);
end

function red_x_min_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_x_min');
catch err
    PreferencesApp.logdlg(err);
end

function red_x_max_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_x_max');
catch err
    PreferencesApp.logdlg(err);
end

function red_y_min_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_y_min');
catch err
    PreferencesApp.logdlg(err);
end

function red_y_max_Callback(hObject, ~, ~)
try
    PreferencesApp.textInputSetting(hObject, 'red_y_max');
catch err
    PreferencesApp.logdlg(err);
end

function savedDefsList_Callback(hObject, ~, ~)
try
    PreferencesApp.savedDefsList(hObject);
catch err
    PreferencesApp.logdlg(err);
end

function btnAddDefault_Callback(hObject, ~, ~)
try
    PreferencesApp.btnAddDefault(hObject);
catch err
    PreferencesApp.logdlg(err);
end

function btnRemoveDefault_Callback(hObject, ~, ~)
try
    PreferencesApp.btnRemoveDefault(hObject);
catch err
    PreferencesApp.logdlg(err);
end

%#ok<*DEFNU>