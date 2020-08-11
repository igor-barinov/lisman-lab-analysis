function varargout = h_imstack(varargin)
% H_IMSTACK M-file for h_imstack.fig
%      H_IMSTACK, by itself, creates a new H_IMSTACK or raises the existing
%      singleton*.
%
%      H = H_IMSTACK returns the handle to a new H_IMSTACK or the handle to
%      the existing singleton*.
%
%      H_IMSTACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_IMSTACK.M with the given input arguments.
%
%      H_IMSTACK('Property','Value',...) creates a new H_IMSTACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_imstack_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_imstack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_imstack

% Last Modified by GUIDE v2.5 17-Dec-2012 11:14:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_imstack_OpeningFcn, ...
                   'gui_OutputFcn',  @h_imstack_OutputFcn, ...
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


% --- Executes just before h_imstack is made visible.
function h_imstack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_imstack (see VARARGIN)

% Choose default command line output for h_imstack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_imstack wait for user response (see UIRESUME)
% uiwait(handles.h_imstack);

delete(findobj('Type','figure','Children',[]));
h_loadDefault(handles);
h = h_roiControlGUI;
h_setupVariableField(h, handles);
UserData = get(handles.roiControl,'UserData');
ss_setPara(handles.roiControl,UserData);
h_setParaAccordingToState('roiControl');
axes(handles.imageAxes);
im = ones(128,128,3);
image(im,'ButtonDownFcn','h_doubleClickMakeRoi');
set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn','h_doubleClickMakeRoi' );


% --- Outputs from this function are returned to the command line.
function varargout = h_imstack_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function imageMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in imageMode.
function imageMode_Callback(hObject, eventdata, handles)
% hObject    handle to imageMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns imageMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageMode
h_replot('fast');


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function greenLimit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function greenLimit1_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global h_img;
value = get(hObject,'Value');
maxIntensity = h_getMaxIntensity;
value2 = round(value*maxIntensity);
set(handles.greenLimitTextLow,'String',num2str(value2));
h_greenControlQuality;
h_replot('fast');



% --- Executes during object creation, after setting all properties.
function greenLimit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function greenLimit2_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global h_img;
value = get(hObject,'Value');
maxIntensity = h_getMaxIntensity;
value2 = round(value*maxIntensity);
set(handles.greenLimitTextHigh,'String',num2str(value2));
h_greenControlQuality;
h_replot('fast');



% --- Executes during object creation, after setting all properties.
function greenLimitTextLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimitTextLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function greenLimitTextLow_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimitTextLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of greenLimitTextLow as text
%        str2double(get(hObject,'String')) returns contents of greenLimitTextLow as a double
h_greenControlQuality;
h_replot('fast');


% --- Executes during object creation, after setting all properties.
function greenLimitTextHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimitTextHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function greenLimitTextHigh_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimitTextHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of greenLimitTextHigh as text
%        str2double(get(hObject,'String')) returns contents of greenLimitTextHigh as a double
h_greenControlQuality;
h_replot('fast');


% --- Executes on button press in maxProjectionOpt.
function maxProjectionOpt_Callback(hObject, eventdata, handles)
% hObject    handle to maxProjectionOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of maxProjectionOpt
h_zStackQuality;
h_replot;


% --- Executes during object creation, after setting all properties.
function redLimit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function redLimit1_Callback(hObject, eventdata, handles)
% hObject    handle to redLimit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global h_img;
value = get(hObject,'Value');
maxIntensity = h_getMaxIntensity;
value2 = round(value*maxIntensity);
set(handles.redLimitTextLow,'String',num2str(value2));
h_redControlQuality;
h_replot('fast');


% --- Executes during object creation, after setting all properties.
function redLimit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function redLimit2_Callback(hObject, eventdata, handles)
% hObject    handle to redLimit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global h_img;
value = get(hObject,'Value');
maxIntensity = h_getMaxIntensity;
value2 = round(value*maxIntensity);
set(handles.redLimitTextHigh,'String',num2str(value2));
h_redControlQuality;
h_replot('fast');


% --- Executes during object creation, after setting all properties.
function redLimitTextLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimitTextLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function redLimitTextLow_Callback(hObject, eventdata, handles)
% hObject    handle to redLimitTextLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of redLimitTextLow as text
%        str2double(get(hObject,'String')) returns contents of redLimitTextLow as a double
h_redControlQuality;
h_replot('fast');


% --- Executes during object creation, after setting all properties.
function redLimitTextHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimitTextHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function redLimitTextHigh_Callback(hObject, eventdata, handles)
% hObject    handle to redLimitTextHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of redLimitTextHigh as text
%        str2double(get(hObject,'String')) returns contents of redLimitTextHigh as a double
h_redControlQuality;
h_replot('fast');


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function zStackControlLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackControlLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zStackControlLow_Callback(hObject, eventdata, handles)
% hObject    handle to zStackControlLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zStackControlLow as text
%        str2double(get(hObject,'String')) returns contents of zStackControlLow as a double
h_zStackQuality;
h_replot;


% --- Executes during object creation, after setting all properties.
function zStackControlHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackControlHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zStackControlHigh_Callback(hObject, eventdata, handles)
% hObject    handle to zStackControlHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zStackControlHigh as text
%        str2double(get(hObject,'String')) returns contents of zStackControlHigh as a double
h_zStackQuality;
h_replot;


% --- Executes during object creation, after setting all properties.
function zStackControl1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackControl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function zStackControl1_Callback(hObject, eventdata, handles)
% hObject    handle to zStackControl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global h_img;
value = get(hObject,'Value');
[xlim,ylim,zlim] = h_getLimits(handles);
zstacklow = round(value*(diff(zlim))+1);
set(handles.zStackControlLow,'String',num2str(zstacklow));
h_zStackQuality;
h_replot;



% --- Executes during object creation, after setting all properties.
function zStackControl2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackControl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function zStackControl2_Callback(hObject, eventdata, handles)
% hObject    handle to zStackControl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global h_img;
value = get(hObject,'Value');
[xlim,ylim,zlim] = h_getLimits(handles);
zstackhigh = round(value*(diff(zlim))+1);
set(handles.zStackControlHigh,'String',num2str(zstackhigh));
h_zStackQuality;
h_replot;


% --- Executes on button press in Open.
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

openImage;

% --- Executes on button press in JumpNext.
function JumpNext_Callback(hObject, eventdata, handles)
% hObject    handle to JumpNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2num(get(handles.jumpStep,'String'));
fname = get(handles.currentFileName,'String');
[pname, fname] = h_analyzeFilename(fname);

if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile(fname,pname);



% --- Executes on button press in OpenLast.
function OpenLast_Callback(hObject, eventdata, handles)
% hObject    handle to OpenLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = 1;
fname = get(handles.currentFileName,'String');
[pname, fname] = h_analyzeFilename(fname);

if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number-value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number-value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile(fname,pname);

% --- Executes on button press in OpenNext.
function OpenNext_Callback(hObject, eventdata, handles)
% hObject    handle to OpenNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = 1;
fname = get(handles.currentFileName,'String');
[pname, fname] = h_analyzeFilename(fname);

if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile(fname,pname);


% --- Executes on button press in JumpLast.
function JumpLast_Callback(hObject, eventdata, handles)
% hObject    handle to JumpLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2num(get(handles.jumpStep,'String'));
fname = get(handles.currentFileName,'String');
[pname, fname] = h_analyzeFilename(fname);
if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number-value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number-value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile(fname,pname);


function jumpStep_Callback(hObject, eventdata, handles)
% hObject    handle to jumpStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumpStep as text
%        str2double(get(hObject,'String')) returns contents of jumpStep as a double


% --- Executes on button press in autoGreen.
function autoGreen_Callback(hObject, eventdata, handles)
% hObject    handle to autoGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;
gamma = str2num(get(handles.gamma,'String'));
climitg = h_climit(h_img.greenimg,0.05^gamma^gamma,0.98^gamma^gamma);
set(handles.greenLimitTextLow,'String', num2str(climitg(1)));
set(handles.greenLimitTextHigh,'String', num2str(climitg(2)));
h_greenControlQuality;
h_replot('fast');


% --- Executes on button press in autoRed.
function autoRed_Callback(hObject, eventdata, handles)
% hObject    handle to autoRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;
gamma = str2num(get(handles.gamma,'String'));
climitr = h_climit(h_img.redimg,0.05^gamma^gamma,0.98^gamma^gamma);
set(handles.redLimitTextLow,'String', num2str(climitr(1)));
set(handles.redLimitTextHigh,'String', num2str(climitr(2)));
h_redControlQuality;
h_replot('fast');


% --- Executes on button press in fullZStack.
function fullZStack_Callback(hObject, eventdata, handles)
% hObject    handle to fullZStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;
[xlim,ylim,zlim] = h_getLimits(handles);
set(handles.zStackControlLow,'String', num2str(1));
set(handles.zStackControlHigh,'String', num2str(zlim(2)));
h_zStackQuality;
h_replot;


% --- Executes on button press in smoothImage.
function smoothImage_Callback(hObject, eventdata, handles)
% hObject    handle to smoothImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smoothImage

h_replot;


% --- Executes on button press in zoomIn.
function zoomIn_Callback(hObject, eventdata, handles)
% hObject    handle to zoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_zoomIn(handles);


% --- Executes on button press in zoomOut.
function zoomOut_Callback(hObject, eventdata, handles)
% hObject    handle to zoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_zoomOut(handles);


% --- Executes during object creation, after setting all properties.
function moveHorizontal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to moveHorizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function moveHorizontal_Callback(hObject, eventdata, handles)
% hObject    handle to moveHorizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

h_resetZoomBox(handles);


% --- Executes during object creation, after setting all properties.
function moveVertical_CreateFcn(hObject, eventdata, handles)
% hObject    handle to moveVertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function moveVertical_Callback(hObject, eventdata, handles)
% hObject    handle to moveVertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

h_resetZoomBox(handles);


% --- Executes on button press in montageControls.
function montageControls_Callback(hObject, eventdata, handles)
% hObject    handle to montageControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_montageControlGUI('Visible','off');
h_setupVariableField(h, handles);
h_setParaAccordingToState('montageControls');

% --- Executes on button press in lineScanAnalysis.
function lineScanAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to lineScanAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_LSAnalysisGUI;
h_setupVariableField(h, handles);
UserData = get(hObject,'UserData');
ss_setPara(hObject,UserData);



% --- Executes on button press in roiControl.
function roiControl_Callback(hObject, eventdata, handles)
% hObject    handle to roiControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_roiControlGUI;
h_setupVariableField(h, handles);
UserData = get(hObject,'UserData');
ss_setPara(hObject,UserData);
h_setParaAccordingToState(get(hObject,'Tag'));

% --- Executes on button press in groupControl.
function groupControl_Callback(hObject, eventdata, handles)
% hObject    handle to groupControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_groupControlGUI;
h_setupVariableField(h, handles);
UserData = get(hObject,'UserData');
ss_setPara(hObject,UserData);


% --- Executes on button press in paAnalysis.
function paAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to paAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_paAnalysisGUI;
h_setupVariableField(h, handles);
UserData = get(hObject,'UserData');
ss_setPara(hObject,UserData);



% --- Executes on button press in groupPlot.
function groupPlot_Callback(hObject, eventdata, handles)
% hObject    handle to groupPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_groupPlotGUI;
h_setupVariableField(h, handles);
UserData = get(hObject,'UserData');
ss_setPara(hObject,UserData);
h_setParaAccordingToState('groupPlot');


% --- Executes during object creation, after setting all properties.
function viewingAxisControl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewingAxisControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in viewingAxisControl.
function viewingAxisControl_Callback(hObject, eventdata, handles)
% hObject    handle to viewingAxisControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns viewingAxisControl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from viewingAxisControl

global h_img;

h_autoSetAxesRatio;
[xlim,ylim,zlim] = h_getLimits(handles);
set(handles.zStackControlLow,'String', num2str(zlim(1)));
set(handles.zStackControlHigh,'String', num2str(zlim(2)));
h_zstackQuality;
set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
h_getCurrentImg;
h_greenControlQuality;
h_redControlQuality;
h_replot('fast');
h_roiQuality;
h_updateInfo(guihandles(hObject));



% --- Executes during object creation, after setting all properties.
function ratioBetweenAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratioBetweenAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ratioBetweenAxes.
function ratioBetweenAxes_Callback(hObject, eventdata, handles)
% hObject    handle to ratioBetweenAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ratioBetweenAxes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ratioBetweenAxes

[xlim,ylim,zlim] = h_getLimits(handles);
set(handles.imageAxes,'XLim',xlim,'YLim',ylim);


% --- Executes on button press in makeMovie.
function makeMovie_Callback(hObject, eventdata, handles)
% hObject    handle to makeMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_makeMovieGUI;
h_setupVariableField(h, handles);
UserData = get(hObject,'UserData');
ss_setPara(hObject,UserData);


% --- Executes on button press in fittingControls.
function fittingControls_Callback(hObject, eventdata, handles)
% hObject    handle to fittingControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_fittingControlGUI;
h_setupVariableField(h, handles);
UserData = get(hObject,'UserData');
ss_setPara(hObject,UserData);



% --- Executes on button press in openPreviousInGroup.
function openPreviousInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openPreviousInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img
if isfield(h_img,'activeGroup') & ~isempty(h_img.activeGroup.groupFiles)
    currentFilename = get(handles.currentFileName,'String');
    [currentPname, currentFname] = h_analyzeFilename(currentFilename);
    
    groupFileNames = cell(length(h_img.activeGroup.groupFiles),1);
    for i = 1:length(h_img.activeGroup.groupFiles)
        [pname, fname] = h_analyzeFilename(h_img.activeGroup.groupFiles(i).name);
        groupFileNames(i) = {fname};
    end
    index = strmatch(currentFname,groupFileNames,'exact');
    if isempty(index)
        index = 2;
    end
    
    index = index - 1;
    
    if ~(index<1)
        [newPath,newFilename] = h_analyzeFilename(h_img.activeGroup.groupFiles(index).name);
        if exist(h_img.activeGroup.groupFiles(index).name,'file')
            h_openFile(newFilename,newPath);
        elseif exist(fullfile(fileparts(h_img.activeGroup.groupPath(1:end-1)), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,fileparts(h_img.activeGroup.groupPath(1:end-1)));
        elseif exist(fullfile(h_img.activeGroup.groupPath(1:end-1), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,h_img.activeGroup.groupPath(1:end-1));
        elseif exist(newFilename,'file')
            h_openFile(newFilename,pwd);
        end
    end
end
    



% --- Executes on button press in openNextInGroup.
function openNextInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openNextInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img
if isfield(h_img,'activeGroup') & ~isempty(h_img.activeGroup.groupFiles)
    currentFilename = get(handles.currentFileName,'String');
    [currentPname, currentFname] = h_analyzeFilename(currentFilename);
    
    groupFileNames = cell(length(h_img.activeGroup.groupFiles),1);
    for i = 1:length(h_img.activeGroup.groupFiles)
        [pname, fname] = h_analyzeFilename(h_img.activeGroup.groupFiles(i).name);
        groupFileNames(i) = {fname};
    end
    index = strmatch(currentFname,groupFileNames,'exact');
    if isempty(index)
        index = 0;
    end
    
    index = index + 1;
    
    if ~(index>length(h_img.activeGroup.groupFiles))
        [newPath,newFilename] = h_analyzeFilename(h_img.activeGroup.groupFiles(index).name);
        if exist(h_img.activeGroup.groupFiles(index).name,'file')
            h_openFile(newFilename,newPath);
        elseif exist(fullfile(fileparts(h_img.activeGroup.groupPath(1:end-1)), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,fileparts(h_img.activeGroup.groupPath(1:end-1)));
        elseif exist(fullfile(h_img.activeGroup.groupPath(1:end-1), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,h_img.activeGroup.groupPath(1:end-1));
        elseif exist(newFilename,'file')
            h_openFile(newFilename,pwd);
        end
    end
end



% --- Executes on button press in openFirstInGroup.
function openFirstInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openFirstInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img
if isfield(h_img,'activeGroup') & ~isempty(h_img.activeGroup.groupFiles)
    currentFilename = get(handles.currentFileName,'String');
    index = strmatch(currentFilename,{h_img.activeGroup.groupFiles.name}','exact');
    if isempty(index)
        index = 0;
    end
    if index~=1
        index = 1;
        [newPath,newFilename] = h_analyzeFilename(h_img.activeGroup.groupFiles(index).name);
        if exist(h_img.activeGroup.groupFiles(index).name,'file')
            h_openFile(newFilename,newPath);
        elseif exist(fullfile(fileparts(h_img.activeGroup.groupPath(1:end-1)), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,fileparts(h_img.activeGroup.groupPath(1:end-1)));
        elseif exist(fullfile(h_img.activeGroup.groupPath(1:end-1), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,h_img.activeGroup.groupPath(1:end-1));
        elseif exist(newFilename,'file')
            h_openFile(newFilename,pwd);
        end
    end
end


% --- Executes on button press in openLastInGroup.
function openLastInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openLastInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img
if isfield(h_img,'activeGroup') & ~isempty(h_img.activeGroup.groupFiles)
    currentFilename = get(handles.currentFileName,'String');
    index = strmatch(currentFilename,{h_img.activeGroup.groupFiles.name}','exact');
    if isempty(index)
        index = 0;
    end
    if index~=length(h_img.activeGroup.groupFiles)
        index = length(h_img.activeGroup.groupFiles);
        [newPath,newFilename] = h_analyzeFilename(h_img.activeGroup.groupFiles(index).name);
        if exist(h_img.activeGroup.groupFiles(index).name,'file')
            h_openFile(newFilename,newPath);
        elseif exist(fullfile(fileparts(h_img.activeGroup.groupPath(1:end-1)), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,fileparts(h_img.activeGroup.groupPath(1:end-1)));
        elseif exist(fullfile(h_img.activeGroup.groupPath(1:end-1), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,h_img.activeGroup.groupPath(1:end-1));
        elseif exist(newFilename,'file')
            h_openFile(newFilename,pwd);
        end
    end
end



% --------------------------------------------------------------------
function saveDefault_Callback(hObject, eventdata, handles)
% hObject    handle to saveDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_saveDefault(handles);

% --------------------------------------------------------------------
function loadDefault_Callback(hObject, eventdata, handles)
% hObject    handle to loadDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadDefault(handles);


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma as text
%        str2double(get(hObject,'String')) returns contents of gamma as a double

global h_img

gamma = str2num(get(handles.gamma,'String'));
h_img.temp.currentColorMap = imadjust(gray(64),[],[],gamma);
h_replot('fast');


% --- Executes on button press in openGroup2.
function openGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to openGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
d = dir('*.grp');
if isempty(d)&exist(fullfile(pwd,'Analysis'))==7
    cd Analysis;
    [fname,pname] = uigetfile('*.grp','Select an group file to open');
    cd ..;
else
    [fname,pname] = uigetfile('*.grp','Select an group file to open');
end

if ~pname==0
    h_openGroup(fname, pname, handles);
end



% --- Executes on button press in addToCurrentGroup2.
function addToCurrentGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to addToCurrentGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFilename = get(handles.currentFileName,'String');
if isempty(strfind(currentFilename,'currentFileName'))
    h_addToCurrentGroup(currentFilename);
    h_updateInfo(handles);
end



% --- Executes on button press in newGroup2.
function newGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to newGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_newGroup(handles);


% --- Executes on button press in removeFromCurrentGroup2.
function removeFromCurrentGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to removeFromCurrentGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFilename = get(handles.currentFileName,'String');
h_removeFromCurrentGroup(currentFilename);
h_updateInfo(handles);


% --- Executes on button press in lockROI.
function lockROI_Callback(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockROI
global h_img

handles = h_img.currentHandles;
currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end
UserData = get(handles.roiControl,'UserData');
UserData.lockROI.Value = currentValue;
UserData.lockROI.BackgroundColor = get(hObject,'BackgroundColor');
set(handles.roiControl,'UserData',UserData);
if isfield(handles,'lockROI')
    if currentValue
        set(handles.lockROI,'Value',currentValue,'BackgroundColor',[0.8 0.8 0.8]);
    else
        set(handles.lockROI,'Value',currentValue,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
    end
end

% --- Executes on button press in bgROI2.
function bgROI2_Callback(hObject, eventdata, handles)
% hObject    handle to bgROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData = get(handles.roiControl,'UserData');
h_makeBGRoi2(UserData.roiShapeOpt.String{UserData.roiShapeOpt.Value});


% --------------------------------------------------------------------
function exportAsTiff_Callback(hObject, eventdata, handles)
% hObject    handle to exportAsTiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_exportAsTiff;


% --- Executes on button press in generalAnalysis.
function generalAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to generalAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_generalAnalysisGUI;
h_setupVariableField(h, handles);
h_setParaAccordingToState('generalAnalysis');



% --- Executes on button press in calcROI2.
function calcROI2_Callback(hObject, eventdata, handles)
% hObject    handle to calcROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img;
handles = h_img.currentHandles;
h_img.lastCalcROI = h_executecalcRoi(handles);
assignin('base','lastCalcROI',h_img.lastCalcROI);
h_updateInfo(handles);
h_img.lastCalcROI


% --- Executes on button press in openPreviousGroup.
function openPreviousGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openPreviousGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img
if isfield(h_img,'activeGroup')
    [pname,fname] = fileparts(h_img.activeGroup.groupName);
    I = find(~(fname>=48 & fname<58)); %char(48) = '0', char(57) = '9'
    num = str2num(fname(I(end)+1:end));
    if isnumeric(num)
        num = num - 1;
        newGroupName = [fname(1:I(end)),num2str(num),'.grp'];
        if exist(fullfile(h_img.activeGroup.groupPath,newGroupName))
            h_openGroup(newGroupName, h_img.activeGroup.groupPath, handles);
        end
    end
end
    
% --- Executes on button press in openNextGroup.
function openNextGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openNextGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img
if isfield(h_img,'activeGroup')
    [pname,fname] = fileparts(h_img.activeGroup.groupName);
    I = find(~(fname>=48 & fname<58)); %char(48) = '0', char(57) = '9'
    num = str2num(fname(I(end)+1:end));
    if isnumeric(num)
        num = num + 1;
        newGroupName = [fname(1:I(end)),num2str(num),'.grp'];
        if exist(fullfile(h_img.activeGroup.groupPath,newGroupName))
            h_openGroup(newGroupName, h_img.activeGroup.groupPath, handles);
        end
    end
end    
    


% --- Executes during object creation, after setting all properties.
function zoomFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in zoomFactor.
function zoomFactor_Callback(hObject, eventdata, handles)
% hObject    handle to zoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns zoomFactor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zoomFactor

switch get(hObject,'Value')
    case 1
    case 2
        h_makeZoomInBox(1.5);
    case 3
        h_makeZoomInBox(2);
    case 4
        h_makeZoomInBox(3);
    case 5
        h_makeZoomInBox(4);
    otherwise
end

set(hObject,'Value', 1);


% --- Executes on button press in dendriteTracing.
function dendriteTracing_Callback(hObject, eventdata, handles)
% hObject    handle to dendriteTracing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_dendriteTracingGUI('Visible','off');
h_setupVariableField(h, handles);
h_setParaAccordingToState('dendriteTracing');



% --- Executes on selection change in analysisNumber.
function analysisNumber_Callback(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns analysisNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisNumber

global h_img
handles = guihandles(hObject);
UserData = get(handles.roiControl,'UserData');
UserData.analysisNumber.Value = get(hObject,'Value');
h_img.state.analysisNumber.Value = get(hObject,'Value');
set(handles.roiControl,'UserData',UserData);
set(handles.analysisNumber,'value',h_img.state.analysisNumber.Value);
h_updateInfo(guihandles(hObject));

% --- Executes during object creation, after setting all properties.
function analysisNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in deleteAll.
function deleteAll_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deleteAll

handles = guihandles(hObject);
h = get(handles.imageAxes,'Children');
g = findobj(h,'Type','Image');
h(h==g(1)) = [];
delete(h);

