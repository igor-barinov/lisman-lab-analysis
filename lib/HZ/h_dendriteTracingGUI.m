function varargout = h_dendriteTracingGUI(varargin)
% H_DENDRITETRACINGGUI M-file for h_dendriteTracingGUI.fig
%      H_DENDRITETRACINGGUI, by itself, creates a new H_DENDRITETRACINGGUI or raises the existing
%      singleton*.
%
%      H = H_DENDRITETRACINGGUI returns the handle to a new H_DENDRITETRACINGGUI or the handle to
%      the existing singleton*.
%
%      H_DENDRITETRACINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_DENDRITETRACINGGUI.M with the given input arguments.
%
%      H_DENDRITETRACINGGUI('Property','Value',...) creates a new H_DENDRITETRACINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_generalAnalysisGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_dendriteTracingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_dendriteTracingGUI

% Last Modified by GUIDE v2.5 15-Dec-2012 14:45:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_dendriteTracingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_dendriteTracingGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before h_dendriteTracingGUI is made visible.
function h_dendriteTracingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_dendriteTracingGUI (see VARARGIN)

% Choose default command line output for h_dendriteTracingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_dendriteTracingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_dendriteTracingGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in makeTracingMark.
function makeTracingMark_Callback(hObject, eventdata, handles)
% hObject    handle to makeTracingMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_makeTracingMark;



% --- Executes on button press in tracingDendrite.
function tracingDendrite_Callback(hObject, eventdata, handles)
% hObject    handle to tracingDendrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img
h_img.lastDendriteTracing = h_tracingByMarks;



% --- Executes on button press in loadTracingData.
function loadTracingData_Callback(hObject, eventdata, handles)
% hObject    handle to loadTracingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadDendriteTracingData;




% --- Executes on button press in showTracingMark.
function showTracingMark_Callback(hObject, eventdata, handles)
% hObject    handle to showTracingMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showTracingMark

global h_img
h_img.state.dendriteTracing.showTracingMark.value = get(hObject,'value');
h_setDendriteTracingVis;

% --- Executes on button press in showMarkNumber.
function showMarkNumber_Callback(hObject, eventdata, handles)
% hObject    handle to showMarkNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showMarkNumber

global h_img
h_img.state.dendriteTracing.showMarkNumber.value = get(hObject,'value');
h_setDendriteTracingVis;

% --- Executes on button press in showSkeleton.
function showSkeleton_Callback(hObject, eventdata, handles)
% hObject    handle to showSkeleton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showSkeleton

global h_img
h_img.state.dendriteTracing.showSkeleton.value = get(hObject,'value');
h_setDendriteTracingVis;

% --- Executes on selection change in markFlag.
function markFlag_Callback(hObject, eventdata, handles)
% hObject    handle to markFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns markFlag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from markFlag

global h_img
h_img.state.dendriteTracing.markFlag.value = get(hObject,'value');


% --- Executes on button press in showImage.
function showImage_Callback(hObject, eventdata, handles)
% hObject    handle to showImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showImage

global h_img
h_img.state.dendriteTracing.showImage.value = get(hObject,'value');
h_setDendriteTracingVis;


% --- Executes on button press in showROI.
function showROI_Callback(hObject, eventdata, handles)
% hObject    handle to showROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showROI

global h_img
h_img.state.dendriteTracing.showROI.value = get(hObject,'value');
h_setDendriteTracingVis;
