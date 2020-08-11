function varargout = h_paAnalysisGUI(varargin)
% H_PAANALYSISGUI M-file for h_paAnalysisGUI.fig
%      H_PAANALYSISGUI, by itself, creates a new H_PAANALYSISGUI or raises the existing
%      singleton*.
%
%      H = H_PAANALYSISGUI returns the handle to a new H_PAANALYSISGUI or the handle to
%      the existing singleton*.
%
%      H_PAANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_PAANALYSISGUI.M with the given input arguments.
%
%      H_PAANALYSISGUI('Property','Value',...) creates a new H_PAANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_paAnalysisGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_paAnalysisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_paAnalysisGUI

% Last Modified by GUIDE v2.5 17-Feb-2006 18:01:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_paAnalysisGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_paAnalysisGUI_OutputFcn, ...
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


% --- Executes just before h_paAnalysisGUI is made visible.
function h_paAnalysisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_paAnalysisGUI (see VARARGIN)

% Choose default command line output for h_paAnalysisGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_paAnalysisGUI wait for user response (see UIRESUME)
% uiwait(handles.h_paAnalysisGUI);


% --- Outputs from this function are returned to the command line.
function varargout = h_paAnalysisGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plotPAAnalysis.
function plotPAAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to plotPAAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_plotPAAnalyzedData(guihandles(hObject));


% --- Executes on button press in calculatePAROI.
function calculatePAROI_Callback(hObject, eventdata, handles)
% hObject    handle to calculatePAROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img

h_img.lastPaAnalysis = h_calculatePAROI(guihandles(hObject));
h_updateInfo(guihandles(hObject));


% --- Executes during object creation, after setting all properties.
function paPlotChannelOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paPlotChannelOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in paPlotChannelOpt.
function paPlotChannelOpt_Callback(hObject, eventdata, handles)
% hObject    handle to paPlotChannelOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns paPlotChannelOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from paPlotChannelOpt

handles = guihandles(hObject);
UserData = get(handles.paAnalysis,'UserData');
UserData.paPlotChannelOpt.Value = get(handles.paPlotChannelOpt,'Value');
set(handles.paAnalysis,'UserData',UserData);



% --- Executes on button press in paHoldOnOpt.
function paHoldOnOpt_Callback(hObject, eventdata, handles)
% hObject    handle to paHoldOnOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of paHoldOnOpt

handles = guihandles(hObject);
currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end

UserData = get(handles.paAnalysis,'UserData');
UserData.paHoldOnOpt.Value = get(handles.paHoldOnOpt,'Value');
UserData.paHoldOnOpt.BackgroundColor = get(handles.paHoldOnOpt,'BackgroundColor');
set(handles.paAnalysis,'UserData',UserData);


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

UserData = get(handles.paAnalysis,'UserData');
UserData.xLimSetting.String = get(handles.xLimSetting,'String');
set(handles.paAnalysis,'UserData',UserData);


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

UserData = get(handles.paAnalysis,'UserData');
UserData.yLimSetting.String = get(handles.yLimSetting,'String');
set(handles.paAnalysis,'UserData',UserData);




% --- Executes during object creation, after setting all properties.
function paPlotRoiOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paPlotRoiOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function paPlotRoiOpt_Callback(hObject, eventdata, handles)
% hObject    handle to paPlotRoiOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of paPlotRoiOpt as text
%        str2double(get(hObject,'String')) returns contents of paPlotRoiOpt as a double

handles = guihandles(hObject);
UserData = get(handles.paAnalysis,'UserData');
UserData.paPlotRoiOpt.String = get(handles.paPlotRoiOpt,'String');
set(handles.paAnalysis,'UserData',UserData);



% --- Executes on button press in newPlot.
function newPlot_Callback(hObject, eventdata, handles)
% hObject    handle to newPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fig = figure('Tag','h_imstackPlot','ButtonDownFcn','h_selectCurrentPlot');
h_selectCurrentPlot;


% --- Executes on button press in loadAnalyzedPARoiData.
function loadAnalyzedPARoiData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnalyzedPARoiData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_loadAnalyzedPARoiData(guihandles(hObject));


% --- Executes on button press in deleteSelectedLine.
function deleteSelectedLine_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSelectedLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deleteSelectedLine

h = findobj('Tag','h_imstackPlot','Selected','on');
lineobj = findobj(h,'Type','Line','Selected','on');
delete(lineobj);


% --- Executes on button press in morePlotOpt.
function morePlotOpt_Callback(hObject, eventdata, handles)
% hObject    handle to morePlotOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_morePlotOptGUI;


% --- Executes on button press in paAverageOpt.
function paAverageOpt_Callback(hObject, eventdata, handles)
% hObject    handle to paAverageOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of paAverageOpt

handles = guihandles(hObject);
if get(hObject,'Value')
    set(handles.paErrorBarOpt,'Enable','on');
    set(handles.paErrorBarText,'Enable','on');
else
    set(handles.paErrorBarOpt,'Enable','off');
    set(handles.paErrorBarText,'Enable','off');
end
UserData = get(handles.paAnalysis,'UserData');
UserData.paAverageOpt.Value = get(hObject,'Value');
UserData.paErrorBarOpt.Enable = get(handles.paErrorBarOpt,'Enable');
UserData.paErrorBarText.Enable = get(handles.paErrorBarText,'Enable');
set(handles.paAnalysis,'UserData',UserData);


% --- Executes during object creation, after setting all properties.
function paErrorBarOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paErrorBarOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in paErrorBarOpt.
function paErrorBarOpt_Callback(hObject, eventdata, handles)
% hObject    handle to paErrorBarOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns paErrorBarOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from paErrorBarOpt

handles = guihandles(hObject);
UserData = get(handles.paAnalysis,'UserData');
UserData.paErrorBarOpt.Value = get(handles.paErrorBarOpt,'Value');
set(handles.paAnalysis,'UserData',UserData);

% --- Executes on button press in paGroupPlot.
function paGroupPlot_Callback(hObject, eventdata, handles)
% hObject    handle to paGroupPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_executePaGroupPlot;


% --- Executes on button press in paGroupCalc.
function paGroupCalc_Callback(hObject, eventdata, handles)
% hObject    handle to paGroupCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_executePAGroupCalcRoi;

% --- Executes on button press in pausePAGroupCalc.
function pausePAGroupCalc_Callback(hObject, eventdata, handles)
% hObject    handle to pausePAGroupCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentValue = get(hObject,'Value');
handles = guihandles(hObject);
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
    UserData = get(handles.paAnalysis,'UserData');
    UserData.pausePAGroupCalc.Value = currentValue;
    UserData.pausePAGroupCalc.BackgroundColor = get(hObject,'BackgroundColor');
    UserData.pausePAGroupCalc.Enable = get(hObject,'Enable');
    set(handles.paAnalysis,'UserData',UserData);
    uiwait;
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
    UserData = get(handles.paAnalysis,'UserData');
    UserData.pausePAGroupCalc.Value = currentValue;
    UserData.pausePAGroupCalc.BackgroundColor = get(hObject,'BackgroundColor');
    set(handles.paAnalysis,'UserData',UserData);
    uiresume;
end
