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

% Last Modified by GUIDE v2.5 24-Aug-2020 10:31:18

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
iniFile = settings_file();
[settings, values] = IOUtils.read_ini_file(iniFile);
settingsMap = containers.Map(settings, values);
set_settings_map(handles, settingsMap);
update_gui(handles);

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


%% ----------------------------------------------------------------------------------------------------------------
% 'logdlg' Method
%
function logdlg(error)
try
    version = Analysis_1_2_Versions.release();
    scriptFilePath = which(version);
    [path, ~, ~] = fileparts(scriptFilePath);
    logFile = [version, '_LOG.txt'];
    filepath = fullfile(path, logFile);

    errordlg(['An error occured. See log at ', filepath]);
    IOUtils.log_error(lastErr, filepath);
catch
    errordlg('Could not log error. See console for details');
    error(getReport(lastErr));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'settings_file' Method
%
function [filepath] = settings_file()
version = Analysis_1_2_Versions.release();
[path, ~, ~] = fileparts(which(version));
filename = [version, '_SETTINGS.ini'];
filepath = fullfile(path, filename);


%% ----------------------------------------------------------------------------------------------------------------
% 'set_settings_map' Method
%
function set_settings_map(handles, newSettingsMap)
setappdata(handles.('mainFig'), 'SETTINGS_MAP', newSettingsMap);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_settings_map' Method
%
function [settingsMap] = get_settings_map(handles)
settingsMap = getappdata(handles.('mainFig'), 'SETTINGS_MAP');


%% ----------------------------------------------------------------------------------------------------------------
% 'is_checked' Method
%
function [tf] = is_checked(hObject)
tf = get(hObject, 'Value');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_gui' Method
%
function update_gui(handles)
settingsMap = get_settings_map(handles);
guiFields = fieldnames(handles);

for i = 1:numel(guiFields)
    hGUI = handles.(guiFields{i});
    
    if isKey(settingsMap, guiFields{i})
        setting = guiFields{i};
        value = settingsMap(setting);
        
        if strcmp(value, 'true')
            set(hGUI, 'Value', 1);
        elseif strcmp(value, 'false')
            set(hGUI, 'Value', 0);
        else
        end
    end
    

end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnSaveChanges' Callback
%
function btnSaveChanges_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    settingsMap = get_settings_map(handles);
    iniFile = settings_file();
    
    % Get the new setting values
    newSettings = keys(settingsMap);
    newValues = values(settingsMap, newSettings);
    
    % Make a new ini file with the new settings
    IOUtils.create_ini_file(iniFile, newSettings, newValues);
    
    % Close the window
    close(handles.('mainFig'));
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'show_lifetime' Callback
%
function show_lifetime_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    settingsMap = get_settings_map(handles);
    
    % Change the appropriate setting
    if is_checked(hObject)
        settingsMap('show_lifetime') = 'true';
    else
        settingsMap('show_lifetime') = 'false';
    end
    
    set_settings_map(handles, settingsMap);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'show_green_int' Callback
%
function show_green_int_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    settingsMap = get_settings_map(handles);
    
    % Change the appropriate setting
    if is_checked(hObject)
        settingsMap('show_green_int') = 'true';
    else
        settingsMap('show_green_int') = 'false';
    end
    
    set_settings_map(handles, settingsMap);
catch err
    logdlg(err);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'show_red_int' Callback
%
function show_red_int_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    settingsMap = get_settings_map(handles);
    
    % Change the appropriate setting
    if is_checked(hObject)
        settingsMap('show_red_int') = 'true';
    else
        settingsMap('show_red_int') = 'false';
    end
    
    set_settings_map(handles, settingsMap);
catch err
    logdlg(err);
end




%#ok<*DEFNU>