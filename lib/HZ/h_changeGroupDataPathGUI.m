function varargout = h_changeGroupDataPathGUI(varargin)
% H_CHANGEGROUPDATAPATHGUI M-file for h_changeGroupDataPathGUI.fig
%      H_CHANGEGROUPDATAPATHGUI, by itself, creates a new H_CHANGEGROUPDATAPATHGUI or raises the existing
%      singleton*.
%
%      H = H_CHANGEGROUPDATAPATHGUI returns the handle to a new H_CHANGEGROUPDATAPATHGUI or the handle to
%      the existing singleton*.
%
%      H_CHANGEGROUPDATAPATHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_CHANGEGROUPDATAPATHGUI.M with the given input arguments.
%
%      H_CHANGEGROUPDATAPATHGUI('Property','Value',...) creates a new H_CHANGEGROUPDATAPATHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_changeGroupDataPathGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_changeGroupDataPathGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_changeGroupDataPathGUI

% Last Modified by GUIDE v2.5 25-Jul-2005 16:08:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_changeGroupDataPathGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_changeGroupDataPathGUI_OutputFcn, ...
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


% --- Executes just before h_changeGroupDataPathGUI is made visible.
function h_changeGroupDataPathGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_changeGroupDataPathGUI (see VARARGIN)

% Choose default command line output for h_changeGroupDataPathGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_changeGroupDataPathGUI wait for user response (see UIRESUME)
% uiwait(handles.h_changeGroupDataPathGUI);


% --- Outputs from this function are returned to the command line.
function varargout = h_changeGroupDataPathGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function formerPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formerPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function formerPath_Callback(hObject, eventdata, handles)
% hObject    handle to formerPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of formerPath as text
%        str2double(get(hObject,'String')) returns contents of formerPath as a double


% --- Executes during object creation, after setting all properties.
function currentPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function currentPath_Callback(hObject, eventdata, handles)
% hObject    handle to currentPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentPath as text
%        str2double(get(hObject,'String')) returns contents of currentPath as a double


% --- Executes on button press in browseForCurrentPath.
function browseForCurrentPath_Callback(hObject, eventdata, handles)
% hObject    handle to browseForCurrentPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directoryname = uigetdir;
if ~(directoryname == 0)
    set(handles.currentPath,'String',directoryname);
end

% --- Executes on button press in browseForFormerPath.
function browseForFormerPath_Callback(hObject, eventdata, handles)
% hObject    handle to browseForFormerPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directoryname = uigetdir;
if ~(directoryname == 0)
    set(handles.formerPath,'String',directoryname);
end


% --- Executes on button press in executeChangePath.
function executeChangePath_Callback(hObject, eventdata, handles)
% hObject    handle to executeChangePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_executeChangeGroupDataPath(handles);
close(handles.h_changeGroupDataPathGUI);

% --- Executes on button press in cancelChangePath.
function cancelChangePath_Callback(hObject, eventdata, handles)
% hObject    handle to cancelChangePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.h_changeGroupDataPathGUI);