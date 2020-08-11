function varargout = h_LSAnalysisGUI(varargin)
% H_LSANALYSISGUI M-file for h_LSAnalysisGUI.fig
%      H_LSANALYSISGUI, by itself, creates a new H_LSANALYSISGUI or raises the existing
%      singleton*.
%
%      H = H_LSANALYSISGUI returns the handle to a new H_LSANALYSISGUI or the handle to
%      the existing singleton*.
%
%      H_LSANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_LSANALYSISGUI.M with the given input arguments.
%
%      H_LSANALYSISGUI('Property','Value',...) creates a new H_LSANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_LSAnalysisGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_LSAnalysisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_LSAnalysisGUI

% Last Modified by GUIDE v2.5 28-Jun-2016 14:20:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_LSAnalysisGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_LSAnalysisGUI_OutputFcn, ...
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


% --- Executes just before h_LSAnalysisGUI is made visible.
function h_LSAnalysisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_LSAnalysisGUI (see VARARGIN)

% Choose default command line output for h_LSAnalysisGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_LSAnalysisGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_LSAnalysisGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calcLS.
function calcLS_Callback(hObject, eventdata, handles)
% hObject    handle to calcLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;

h_img.lastLSAnalysis = h_LSAnalysis;
assignin('base','lastLSAnalysis',h_img.lastLSAnalysis);


% --- Executes on button press in filterLSAnalysis.
function filterLSAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to filterLSAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img;
handles = guihandles(hObject);
F = str2num(get(handles.cutoffFrequency,'String'));
h_img.lastLSAnalysis = h_LSAnalysis(F);



% --- Executes on button press in plotLSAnalysis.
function plotLSAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to plotLSAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_plotLSAnalysis;


% --- Executes during object creation, after setting all properties.
function cutoffFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cutoffFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cutoffFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to cutoffFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cutoffFrequency as text
%        str2double(get(hObject,'String')) returns contents of cutoffFrequency as a double


% --- Executes on button press in lineScanDisplay.
function lineScanDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to lineScanDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lineScanDisplay

global h_img

handles = h_img.currentHandles;
if get(hObject,'Value')
    set(handles.maxProjectionOpt,'Enable','off');
    set(handles.viewingAxisControl,'Enable','off','Value',1);
else
    set(handles.maxProjectionOpt,'Enable','on');
    set(handles.viewingAxisControl,'Enable','on');
end

UserData = get(handles.lineScanAnalysis,'UserData');
UserData.lineScanDisplay.Value = get(hObject,'Value');;
set(handles.lineScanAnalysis,'UserData',UserData);

[xlim,ylim,zlim] = h_getLimits(handles);
set(handles.zStackControlLow,'String', num2str(zlim(1)));
set(handles.zStackControlHigh,'String', num2str(zlim(2)));
h_zStackQuality;
set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
h_replot;
h_roiQuality;
h_updateInfo(handles);


% --- Executes on button press in autoROISelection.
function autoROISelection_Callback(hObject, eventdata, handles)
% hObject    handle to autoROISelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoROISelection

UserData = get(handles.lineScanAnalysis,'UserData');
UserData.autoROISelection.Value = get(hObject,'Value');;
set(handles.lineScanAnalysis,'UserData',UserData);

if get(hObject,'Value')
    h_autoSelectLSRoi;
end


% --- Executes during object creation, after setting all properties.
function numberOfROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function numberOfROI_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfROI as text
%        str2double(get(hObject,'String')) returns contents of numberOfROI as a double

global h_img

UserData = get(handles.lineScanAnalysis,'UserData');
UserData.numberOfROI.Value = get(hObject,'Value');;
set(handles.lineScanAnalysis,'UserData',UserData);

if get(h_img.currentHandles.autoROISelection,'Value')
    h_autoSelectLSRoi;
end


% --- Executes during object creation, after setting all properties.
function roiBoundaryThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiBoundaryThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function roiBoundaryThresh_Callback(hObject, eventdata, handles)
% hObject    handle to roiBoundaryThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiBoundaryThresh as text
%        str2double(get(hObject,'String')) returns contents of roiBoundaryThresh as a double

global h_img
UserData = get(handles.lineScanAnalysis,'UserData');
UserData.roiBoundaryThresh.Value = get(hObject,'Value');;
set(handles.lineScanAnalysis,'UserData',UserData);

if get(h_img.currentHandles.autoROISelection,'Value')
    h_autoSelectLSRoi;
end


% --- Executes during object creation, after setting all properties.
function roiSelectionChannelOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiSelectionChannelOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in roiSelectionChannelOpt.
function roiSelectionChannelOpt_Callback(hObject, eventdata, handles)
% hObject    handle to roiSelectionChannelOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns roiSelectionChannelOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roiSelectionChannelOpt
global h_img
UserData = get(handles.lineScanAnalysis,'UserData');
UserData.roiSelectionChannelOpt.Value = get(hObject,'Value');;
set(handles.lineScanAnalysis,'UserData',UserData);

if get(h_img.currentHandles.autoROISelection,'Value')
    h_autoSelectLSRoi;
end


% --- Executes on button press in autoShutterBaselineSelection.
function autoShutterBaselineSelection_Callback(hObject, eventdata, handles)
% hObject    handle to autoShutterBaselineSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoShutterBaselineSelection


% --- Executes on button press in backAPwithYphys.
function backAPwithYphys_Callback(hObject, eventdata, handles)
% hObject    handle to backAPwithYphys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_bAPwithYphys;



% --- Executes on button press in subtractBackground.
function subtractBackground_Callback(hObject, eventdata, handles)
% hObject    handle to subtractBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of subtractBackground
