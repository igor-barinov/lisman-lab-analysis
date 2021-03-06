function varargout = h_montageControlGUI(varargin)
% H_MONTAGECONTROLGUI M-file for h_montageControlGUI.fig
%      H_MONTAGECONTROLGUI, by itself, creates a new H_MONTAGECONTROLGUI or raises the existing
%      singleton*.
%
%      H = H_MONTAGECONTROLGUI returns the handle to a new H_MONTAGECONTROLGUI or the handle to
%      the existing singleton*.
%
%      H_MONTAGECONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_MONTAGECONTROLGUI.M with the given input arguments.
%
%      H_MONTAGECONTROLGUI('Property','Value',...) creates a new H_MONTAGECONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_montageControlGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_montageControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_montageControlGUI

% Last Modified by GUIDE v2.5 19-Jan-2006 08:58:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_montageControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_montageControlGUI_OutputFcn, ...
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


% --- Executes just before h_montageControlGUI is made visible.
function h_montageControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_montageControlGUI (see VARARGIN)

% Choose default command line output for h_montageControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_montageControlGUI wait for user response (see UIRESUME)
% uiwait(handles.h_montageControlGUI);

h = h_findobj('Tag','h_imstack');
pos = get(h, 'Position');
pos2 = get(hObject,'Position');
pos2(1) = pos(1) + pos(3) + 20;
pos2(2) = pos(2) + pos(4) - pos2(4);
set(hObject,'Position', pos2);


% --- Outputs from this function are returned to the command line.
function varargout = h_montageControlGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function rowNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rowNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rowNumber_Callback(hObject, eventdata, handles)
% hObject    handle to rowNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rowNumber as text
%        str2double(get(hObject,'String')) returns contents of rowNumber as a double

global h_img
h_img.state.montageControls.rowNumber.String = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function columnNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to columnNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function columnNumber_Callback(hObject, eventdata, handles)
% hObject    handle to columnNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of columnNumber as text
%        str2double(get(hObject,'String')) returns contents of columnNumber as a double
global h_img
h_img.state.montageControls.columnNumber.String = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function currentRow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function currentRow_Callback(hObject, eventdata, handles)
% hObject    handle to currentRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentRow as text
%        str2double(get(hObject,'String')) returns contents of currentRow as a double
global h_img
h_img.state.montageControls.currentRow.String = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function currentColumn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function currentColumn_Callback(hObject, eventdata, handles)
% hObject    handle to currentColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentColumn as text
%        str2double(get(hObject,'String')) returns contents of currentColumn as a double

global h_img
h_img.state.montageControls.currentColumn.String = get(hObject,'String');

% --- Executes on button press in newMontage.
function newMontage_Callback(hObject, eventdata, handles)
% hObject    handle to newMontage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_executeNewMontage_Callback;



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in labelXAxis.
function labelXAxis_Callback(hObject, eventdata, handles)
% hObject    handle to labelXAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
siz(1) = str2num(get(handles.rowNumber,'String'));
siz(2) = str2num(get(handles.columnNumber,'String'));
pos(1) = str2num(get(handles.currentRow,'String'));
pos(2) = str2num(get(handles.currentColumn,'String'));
pos2 = (pos(1) - 1) * siz(2) + pos(2);
fig = h_findobj('Tag','h_imstackMontage','Selected','on');
figure(fig);
subplot(siz(1),siz(2),pos2);
fontSize = str2num(get(handles.fontSize,'String'));
xlabel(get(handles.labelText,'String'),'FontSize',fontSize);


% --- Executes on button press in resizeMontage.
function resizeMontage_Callback(hObject, eventdata, handles)
% hObject    handle to resizeMontage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
h_resizeMontage(handles);


% --- Executes on button press in autoResize.
function autoResize_Callback(hObject, eventdata, handles)
% hObject    handle to autoResize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
fig = h_findobj('Tag','h_imstackMontage','Selected','on');
axesobj = get(fig,'Children');
montagesize = h_montageSize(length(axesobj));
set(handles.rowNumber,'String',num2str(montagesize(1)));
set(handles.columnNumber,'String',num2str(montagesize(2)));
h_resizeMontage(handles);


% --- Executes during object creation, after setting all properties.
function labelText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function labelText_Callback(hObject, eventdata, handles)
% hObject    handle to labelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of labelText as text
%        str2double(get(hObject,'String')) returns contents of labelText as a double


% --- Executes on button press in labelYAxis.
function labelYAxis_Callback(hObject, eventdata, handles)
% hObject    handle to labelYAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
siz(1) = str2num(get(handles.rowNumber,'String'));
siz(2) = str2num(get(handles.columnNumber,'String'));
pos(1) = str2num(get(handles.currentRow,'String'));
pos(2) = str2num(get(handles.currentColumn,'String'));
pos2 = (pos(1) - 1) * siz(2) + pos(2);
fig = h_findobj('Tag','h_imstackMontage','Selected','on');
figure(fig);
subplot(siz(1),siz(2),pos2);
fontSize = str2num(get(handles.fontSize,'String'));
ylabel(get(handles.labelText,'String'),'FontSize',fontSize);


% --- Executes on button press in labelTitle.
function labelTitle_Callback(hObject, eventdata, handles)
% hObject    handle to labelTitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
siz(1) = str2num(get(handles.rowNumber,'String'));
siz(2) = str2num(get(handles.columnNumber,'String'));
pos(1) = str2num(get(handles.currentRow,'String'));
pos(2) = str2num(get(handles.currentColumn,'String'));
pos2 = (pos(1) - 1) * siz(2) + pos(2);
fig = h_findobj('Tag','h_imstackMontage','Selected','on');
figure(fig);
subplot(siz(1),siz(2),pos2);
fontSize = str2num(get(handles.fontSize,'String'));
title(get(handles.labelText,'String'),'FontSize',fontSize);


% --- Executes during object creation, after setting all properties.
function fontSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fontSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fontSize_Callback(hObject, eventdata, handles)
% hObject    handle to fontSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fontSize as text
%        str2double(get(hObject,'String')) returns contents of fontSize as a double


% --- Executes on button press in addToMontage.
function addToMontage_Callback(hObject, eventdata, handles)
% hObject    handle to addToMontage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
h_addImageToMontage(handles);


% --- Executes on button press in deleteMontageAxes.
function deleteMontageAxes_Callback(hObject, eventdata, handles)
% hObject    handle to deleteMontageAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
fig = h_findobj('Tag','h_imstackMontage','Selected','on');
siz(1) = str2num(get(handles.rowNumber,'String'));
siz(2) = str2num(get(handles.columnNumber,'String'));
currentRow = str2num(get(handles.currentRow,'String'));
currentColumn = str2num(get(handles.currentColumn,'String'));
pos = currentColumn + (currentRow - 1)*siz(2);
figure(fig);
h = subplot(siz(1),siz(2),pos);
delete(h);



% --- Executes on button press in addPlotToMontage.
function addPlotToMontage_Callback(hObject, eventdata, handles)
% hObject    handle to addPlotToMontage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
h_addPlotToMontage(handles);


% --- Executes on button press in copyImage.
function copyImage_Callback(hObject, eventdata, handles)
% hObject    handle to copyImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img;

F = getframe(handles.imageAxes);
fig = figure;
set(fig,'position',[50 50 600 600]);
colormap(F.colormap);
img = image(F.cdata);
axis image;
set(gca,'XTickLabel', '', 'YTickLabel', '', 'XTick',[],'YTick',[],'unit','normalized','position',[0 0 1 1]);
print('-dbitmap','-noui',fig);
delete(fig);


% --- Executes on button press in autoGroupMontage.
function autoGroupMontage_Callback(hObject, eventdata, handles)
% hObject    handle to autoGroupMontage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_autoGroupMontage;
