function varargout = h_groupPlotGUI(varargin)
% H_GROUPPLOTGUI M-file for h_groupPlotGUI.fig
%      H_GROUPPLOTGUI, by itself, creates a new H_GROUPPLOTGUI or raises the existing
%      singleton*.
%
%      H = H_GROUPPLOTGUI returns the handle to a new H_GROUPPLOTGUI or the handle to
%      the existing singleton*.
%
%      H_GROUPPLOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_GROUPPLOTGUI.M with the given input arguments.
%
%      H_GROUPPLOTGUI('Property','Value',...) creates a new H_GROUPPLOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_groupPlotGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_groupPlotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_groupPlotGUI

% Last Modified by GUIDE v2.5 03-Jun-2013 12:11:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_groupPlotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_groupPlotGUI_OutputFcn, ...
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


% --- Executes just before h_groupPlotGUI is made visible.
function h_groupPlotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_groupPlotGUI (see VARARGIN)

% Choose default command line output for h_groupPlotGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_groupPlotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_groupPlotGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in newPlot.
function newPlot_Callback(hObject, eventdata, handles)
% hObject    handle to newPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig = figure('Tag','h_imstackPlot','ButtonDownFcn','h_selectCurrentPlot');
plottools; % AZ
h_selectCurrentPlot;



% --- Executes on button press in plotFcn.
function plotFcn_Callback(hObject, eventdata, handles)
% hObject    handle to plotFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
h_plotGroupFcn(handles);


% --- Executes during object creation, after setting all properties.
function plotDataOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotDataOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in plotDataOpt.
function plotDataOpt_Callback(hObject, eventdata, handles)
% hObject    handle to plotDataOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotDataOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotDataOpt
UserData = get(handles.groupPlot,'UserData');
UserData.plotDataOpt.Value = get(hObject,'Value');
set(handles.groupPlot,'UserData',UserData);



% --- Executes on button press in holdOnOpt.
function holdOnOpt_Callback(hObject, eventdata, handles)
% hObject    handle to holdOnOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of holdOnOpt
global h_img

currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end
UserData = get(handles.groupPlot,'UserData');
UserData.holdOnOpt.BackgroundColor = get(hObject,'BackgroundColor');
UserData.holdOnOpt.Value = get(hObject,'Value');
h_img.state.groupPlot.holdOnOpt.value = UserData.holdOnOpt.Value;
h_img.state.groupPlot.holdOnOpt.backgroundColor = UserData.holdOnOpt.BackgroundColor;
set(handles.groupPlot,'UserData',UserData);


% --- Executes during object creation, after setting all properties.
function xLimSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xLimSetting_Callback(hObject, eventdata, handles)
% hObject    handle to xLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xLimSetting as text
%        str2double(get(hObject,'String')) returns contents of xLimSetting as a double
handles = guihandles(hObject);
h_resetXYLimit(handles);


% --- Executes during object creation, after setting all properties.
function yLimSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yLimSetting_Callback(hObject, eventdata, handles)
% hObject    handle to yLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLimSetting as text
%        str2double(get(hObject,'String')) returns contents of yLimSetting as a double
handles = guihandles(hObject);
h_resetXYLimit(handles);


% --- Executes during object creation, after setting all properties.
function plotRoiOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotRoiOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function plotRoiOpt_Callback(hObject, eventdata, handles)
% hObject    handle to plotRoiOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotRoiOpt as text
%        str2double(get(hObject,'String')) returns contents of plotRoiOpt as a double
UserData = get(handles.groupPlot,'UserData');
UserData.plotRoiOpt.String = get(hObject,'String');
set(handles.groupPlot,'UserData',UserData);


% --- Executes on button press in deleteSelectedLine.
function deleteSelectedLine_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSelectedLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','h_imstackPlot','Selected','on');
lineobj = findobj(h,'Type','Line','Selected','on');
delete(lineobj);


% --- Executes on button press in averageOpt.
function averageOpt_Callback(hObject, eventdata, handles)
% hObject    handle to averageOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of averageOpt

handles = guihandles(hObject);
if get(hObject,'Value')
    set(handles.errorBarOpt,'Enable','on');
    set(handles.errorBarText,'Enable','on');
else
    set(handles.errorBarOpt,'Enable','off');
    set(handles.errorBarText,'Enable','off');
end
UserData = get(handles.groupPlot,'UserData');
UserData.averageOpt.Value = get(hObject,'Value');
UserData.errorBarOpt.Enable = get(handles.errorBarOpt,'Enable');
UserData.errorBarText.Enable = get(handles.errorBarText,'Enable');
set(handles.groupPlot,'UserData',UserData);



% --- Executes on selection change in errorBarOpt.
function errorBarOpt_Callback(hObject, eventdata, handles)
% hObject    handle to errorBarOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns errorBarOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from errorBarOpt
handles = guihandles(hObject);
UserData = get(handles.groupPlot,'UserData');
UserData.errorBarOpt.Value = get(handles.errorBarOpt,'Value');
set(handles.groupPlot,'UserData',UserData);


% --------------------------------------------------------------------
function errorBarText_Callback(hObject, eventdata, handles)
% hObject    handle to errorBarText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in morePlotOpt.
function morePlotOpt_Callback(hObject, eventdata, handles)
% hObject    handle to morePlotOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_morePlotOptGUI;
UserData = get(handles.groupPlot,'UserData');
UserData.morePlotOpt.UserData = get(hObject,'UserData');
set(handles.groupPlot,'UserData',UserData);


% --- Executes on button press in plotIntegration.
function plotIntegration_Callback(hObject, eventdata, handles)
% hObject    handle to plotIntegration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotIntegration

global h_img

h_img.state.groupPlot.plotIntegration.value = get(hObject,'value');


% --- Executes on selection change in bleedthrough.
function bleedthrough_Callback(hObject, eventdata, handles)
% hObject    handle to bleedthrough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns bleedthrough contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bleedthrough
global h_img

h_img.state.groupPlot.bleedthrough.value = get(hObject,'value');


% --- Executes during object creation, after setting all properties.
function bleedthrough_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bleedthrough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in estBleedthrough.
function estBleedthrough_Callback(hObject, eventdata, handles)
% hObject    handle to estBleedthrough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_determinBleedthroughUsingCorr




function baselinePos_Callback(hObject, eventdata, handles)
% hObject    handle to baselinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baselinePos as text
%        str2double(get(hObject,'String')) returns contents of baselinePos as a double

global h_img

h_img.state.groupPlot.baselinePos.string = get(hObject,'string');

% --- Executes during object creation, after setting all properties.
function baselinePos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baselinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



