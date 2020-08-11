function varargout = h_morePlotOptGUI(varargin)
% H_MOREPLOTOPTGUI M-file for h_morePlotOptGUI.fig
%      H_MOREPLOTOPTGUI, by itself, creates a new H_MOREPLOTOPTGUI or raises the existing
%      singleton*.
%
%      H = H_MOREPLOTOPTGUI returns the handle to a new H_MOREPLOTOPTGUI or the handle to
%      the existing singleton*.
%
%      H_MOREPLOTOPTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_MOREPLOTOPTGUI.M with the given input arguments.
%
%      H_MOREPLOTOPTGUI('Property','Value',...) creates a new H_MOREPLOTOPTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_morePlotOptGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_morePlotOptGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_morePlotOptGUI

% Last Modified by GUIDE v2.5 21-Jul-2005 02:09:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_morePlotOptGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_morePlotOptGUI_OutputFcn, ...
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


% --- Executes just before h_morePlotOptGUI is made visible.
function h_morePlotOptGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_morePlotOptGUI (see VARARGIN)

% Choose default command line output for h_morePlotOptGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_morePlotOptGUI wait for user response (see UIRESUME)
% uiwait(handles.h_morePlotOptGUI);
global h_img;
h = h_img.currentHandles;
UserData = get(h.morePlotOpt,'UserData');
ss_setPara(hObject,UserData);


% --- Outputs from this function are returned to the command line.
function varargout = h_morePlotOptGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function lineStyleOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lineStyleOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in lineStyleOpt.
function lineStyleOpt_Callback(hObject, eventdata, handles)
% hObject    handle to lineStyleOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lineStyleOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lineStyleOpt


% --- Executes during object creation, after setting all properties.
function lineColorOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lineColorOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in lineColorOpt.
function lineColorOpt_Callback(hObject, eventdata, handles)
% hObject    handle to lineColorOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lineColorOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lineColorOpt


% --- Executes on button press in acceptSetting.
function acceptSetting_Callback(hObject, eventdata, handles)
% hObject    handle to acceptSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img

UserData.lineStyleOpt.String = get(handles.lineStyleOpt,'String');
UserData.lineStyleOpt.Value = get(handles.lineStyleOpt,'Value');
UserData.lineColorOpt.Value = get(handles.lineColorOpt,'Value');
UserData.lineColorOpt.String = get(handles.lineColorOpt,'String');

lineStyle = get(handles.lineStyleOpt,'String');
value = get(handles.lineStyleOpt,'Value');
UserData.lineStyle = lineStyle{value};
lineColor = get(handles.lineColorOpt,'String');
value = get(handles.lineColorOpt,'Value');
UserData.lineColor = lineColor{value};

h_handles = h_img.currentHandles;
set(h_handles.morePlotOpt,'UserData',UserData);
if isfield(h_handles,'paAverageOpt')
    paData = get(h_handles.paAnalysis,'UserData');
    paData.morePlotOpt.UserData = UserData;
    set(h_handles.paAnalysis,'UserData',paData);
elseif isfield(h_handles,'averageOpt')
    UData = get(h_handles.groupPlot,'UserData');
    UData.morePlotOpt.UserData = UserData;
    set(h_handles.groupPlot,'UserData',UData);
end
    
delete(handles.h_morePlotOptGUI);


% --- Executes on button press in cancelAction.
function cancelAction_Callback(hObject, eventdata, handles)
% hObject    handle to cancelAction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.h_morePlotOptGUI);


