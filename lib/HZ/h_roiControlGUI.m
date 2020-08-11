function varargout = h_roiControlGUI(varargin)
% H_ROICONTROLGUI M-file for h_roiControlGUI.fig
%      H_ROICONTROLGUI, by itself, creates a new H_ROICONTROLGUI or raises the existing
%      singleton*.
%
%      H = H_ROICONTROLGUI returns the handle to a new H_ROICONTROLGUI or the handle to
%      the existing singleton*.
%
%      H_ROICONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_ROICONTROLGUI.M with the given input arguments.
%
%      H_ROICONTROLGUI('Property','Value',...) creates a new H_ROICONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_roiControlGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_roiControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_roiControlGUI

% Last Modified by GUIDE v2.5 07-Nov-2006 21:24:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_roiControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_roiControlGUI_OutputFcn, ...
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


% --- Executes just before h_roiControlGUI is made visible.
function h_roiControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_roiControlGUI (see VARARGIN)

% Choose default command line output for h_roiControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_roiControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_roiControlGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bgRoi.
function bgRoi_Callback(hObject, eventdata, handles)
% hObject    handle to bgRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
shape = get(handles.roiShapeOpt,'String');
shape = shape{get(handles.roiShapeOpt,'Value')};
h_makeBGRoi2(shape);


% --- Executes on button press in newRoi.
function newRoi_Callback(hObject, eventdata, handles)
% hObject    handle to newRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
shape = get(handles.roiShapeOpt,'String');
shape = shape{get(handles.roiShapeOpt,'Value')};
h_makeRoi2(shape);



% --- Executes on button press in deleteRoi.
function deleteRoi_Callback(hObject, eventdata, handles)
% hObject    handle to deleteRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
roi = findobj(handles.imageAxes,'Selected','on');
if ~isempty(strfind(get(roi,'Tag'),'ROI'))
    try
        roiUserData = get(roi,'UserData');
        delete(roi);
        delete(roiUserData.texthandle);
        h = sort(findobj(handles.imageAxes,'Tag','HROI'));
        for i = 1:length(h)
            UserData = get(h(i),'UserData');
            UserData.number = i;
            set(UserData.texthandle,'String',num2str(i),'UserData',UserData);
            set(h(i),'UserData',UserData);
        end
    end
end



% --- Executes on button press in calcROI.
function calcROI_Callback(hObject, eventdata, handles)
% hObject    handle to calcROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;
handles = guihandles(hObject);
h_img.lastCalcROI = h_executecalcRoi(handles);
assignin('base','lastCalcROI',h_img.lastCalcROI);
h_updateInfo(handles);
h_img.lastCalcROI


% --- Executes on button press in deleteAll.
function deleteAll_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
h = get(handles.imageAxes,'Children');
g = findobj(h,'Type','Image');
h(h==g(1)) = [];
delete(h);


% --- Executes on button press in autoPosition.
function autoPosition_Callback(hObject, eventdata, handles)
% hObject    handle to autoPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_autoPosition(handles);

% --- Executes on button press in lockROI.
function lockROI_Callback(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockROI

currentValue = get(hObject,'Value');
handles = guihandles(hObject);
if currentValue
    set(handles.lockROI,'Value',currentValue,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(handles.lockROI,'Value',currentValue,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end
try
    UserData = get(handles.roiControl,'UserData');
    UserData.lockROI.Value = currentValue;
    UserData.lockROI.BackgroundColor = get(hObject,'BackgroundColor');
    set(handles.roiControl,'UserData',UserData);
end
% if isfield(handles,'lockROI2')
%     if currentValue
%         set(handles.lockROI2,'Value',currentValue,'BackgroundColor',[0.8 0.8 0.8]);
%     else
%         set(handles.lockROI2,'Value',currentValue,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
%     end
% end




% --- Executes during object creation, after setting all properties.
function threshControl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in threshControl.
function threshControl_Callback(hObject, eventdata, handles)
% hObject    handle to threshControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns threshControl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from threshControl



% --- Executes on button press in loadAnalyzedRoiData.
function loadAnalyzedRoiData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnalyzedRoiData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_loadAnalyzedRoiData(guihandles(hObject));


% --- Executes on button press in twoStepAutoPosition.
function twoStepAutoPosition_Callback(hObject, eventdata, handles)
% hObject    handle to twoStepAutoPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
h_twoStepAutoPosition(handles);


% --- Executes during object creation, after setting all properties.
function roiShapeOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiShapeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in roiShapeOpt.
function roiShapeOpt_Callback(hObject, eventdata, handles)
% hObject    handle to roiShapeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns roiShapeOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roiShapeOpt

currentValue = get(hObject,'Value');
handles = guihandles(hObject);
try
    UserData = get(handles.roiControl,'UserData');
    UserData.roiShapeOpt.String = get(hObject,'String');
    UserData.roiShapeOpt.Value = currentValue;
    set(handles.roiControl,'UserData',UserData);
end


% --- Executes on button press in groupCalcRoi.
function groupCalcRoi_Callback(hObject, eventdata, handles)
% hObject    handle to groupCalcRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
h_executeGroupCalcRoi(handles);


% --- Executes on button press in pauseGroupCalc.
function pauseGroupCalc_Callback(hObject, eventdata, handles)
% hObject    handle to pauseGroupCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseGroupCalc



currentValue = get(hObject,'Value');
handles = guihandles(hObject);
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
    uiwait;
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
    uiresume;
end
try
    UserData = get(handles.roiControl,'UserData');
    UserData.pauseGroupCalc.Value = currentValue;
    UserData.pauseGroupCalc.BackgroundColor = get(hObject,'BackgroundColor');
    set(handles.roiControl,'UserData',UserData);
end


% --- Executes on button press in undoAutoPosition.
function undoAutoPosition_Callback(hObject, eventdata, handles)
% hObject    handle to undoAutoPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_executeUndoAutoPosition;


% --- Executes on button press in ruler.
function ruler_Callback(hObject, eventdata, handles)
% hObject    handle to ruler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_drawARuler;


% --- Executes during object creation, after setting all properties.
function rulerMarkingOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rulerMarkingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in rulerMarkingOpt.
function rulerMarkingOpt_Callback(hObject, eventdata, handles)
% hObject    handle to rulerMarkingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns rulerMarkingOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rulerMarkingOpt

UserData = get(handles.roiControl,'UserData');
UserData.rulerMarkingOpt.Value = get(hObject,'Value');
set(handles.roiControl,'UserData',UserData);


% --- Executes during object creation, after setting all properties.
function analysisNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in analysisNumber.
function analysisNumber_Callback(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns analysisNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisNumber

global h_img
UserData = get(handles.roiControl,'UserData');
UserData.analysisNumber.Value = get(hObject,'Value');
h_img.state.analysisNumber.Value = get(hObject,'Value');
set(handles.roiControl,'UserData',UserData);
set(handles.analysisNumber,'value',h_img.state.analysisNumber.Value);
h_updateInfo(guihandles(hObject));


% --- Executes on button press in plotROI.
function plotROI_Callback(hObject, eventdata, handles)
% hObject    handle to plotROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_plotROIFcn;


% --- Executes during object creation, after setting all properties.
function plotROIOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in plotROIOpt.
function plotROIOpt_Callback(hObject, eventdata, handles)
% hObject    handle to plotROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotROIOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotROIOpt

global h_img
h_img.state.roiControl.plotROIOpt.value = get(hObject,'Value');


% --- Executes on button press in channelForZ.
function channelForZ_Callback(hObject, eventdata, handles)
% hObject    handle to channelForZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channelForZ

global h_img
h_img.state.roiControl.channelForZ.value = get(hObject,'Value');

