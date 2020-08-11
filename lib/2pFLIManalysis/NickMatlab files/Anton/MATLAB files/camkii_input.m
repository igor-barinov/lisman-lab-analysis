function varargout = camkii_input(varargin)
% CAMKII_INPUT MATLAB code for camkii_input.fig
%      CAMKII_INPUT, by itself, creates a new CAMKII_INPUT or raises the existing
%      singleton*.
%
%      H = CAMKII_INPUT returns the handle to a new CAMKII_INPUT or the handle to
%      the existing singleton*.
%
%      CAMKII_INPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMKII_INPUT.M with the given input arguments.
%
%      CAMKII_INPUT('Property','Value',...) creates a new CAMKII_INPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before camkii_input_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to camkii_input_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help camkii_input

% Last Modified by GUIDE v2.5 30-Aug-2014 20:13:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camkii_input_OpeningFcn, ...
                   'gui_OutputFcn',  @camkii_input_OutputFcn, ...
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


% --- Executes just before camkii_input is made visible.
function camkii_input_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to camkii_input (see VARARGIN)

% Choose default command line output for camkii_input
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes camkii_input wait for user response (see UIRESUME)
% uiwait(handles.camkii_input);


% --- Outputs from this function are returned to the command line.
function varargout = camkii_input_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tau2_Callback(hObject, eventdata, handles)
% hObject    handle to tau2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau2 as text
%        str2double(get(hObject,'String')) returns contents of tau2 as a double
global input_list;
tau2 = str2double(get(hObject,'String'));
input_list(7) = tau2;


% --- Executes during object creation, after setting all properties.
function tau2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
tau2 = str2double(get(hObject,'String'));
input_list(7) = tau2;



function noCnoP_Callback(hObject, eventdata, handles)
% hObject    handle to noCnoP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noCnoP as text
%        str2double(get(hObject,'String')) returns contents of noCnoP as a double
global input_list;
noCnoP = str2double(get(hObject,'String'));
input_list(1) = noCnoP;


% --- Executes during object creation, after setting all properties.
function noCnoP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noCnoP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
noCnoP = str2double(get(hObject,'String'));
input_list(1) = noCnoP;



function yesCnoP_Callback(hObject, eventdata, handles)
% hObject    handle to yesCnoP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yesCnoP as text
%        str2double(get(hObject,'String')) returns contents of yesCnoP as a double
global input_list;
yesCnoP = str2double(get(hObject,'String'));
input_list(2) = yesCnoP;


% --- Executes during object creation, after setting all properties.
function yesCnoP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yesCnoP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
yesCnoP = str2double(get(hObject,'String'));
input_list(2) = yesCnoP;



function noCyesP_Callback(hObject, eventdata, handles)
% hObject    handle to noCyesP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noCyesP as text
%        str2double(get(hObject,'String')) returns contents of noCyesP as a double
global input_list;
noCyesP = str2double(get(hObject,'String'));
input_list(3) = noCyesP;


% --- Executes during object creation, after setting all properties.
function noCyesP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noCyesP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
noCyesP = str2double(get(hObject,'String'));
input_list(3) = noCyesP;



function yesCyesP_Callback(hObject, eventdata, handles)
% hObject    handle to yesCyesP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yesCyesP as text
%        str2double(get(hObject,'String')) returns contents of yesCyesP as a double
global input_list;
yesCyesP = str2double(get(hObject,'String'));
input_list(4) = yesCyesP;


% --- Executes during object creation, after setting all properties.
function yesCyesP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yesCyesP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
yesCyesP = str2double(get(hObject,'String'));
input_list(4) = yesCyesP;



function P305_Callback(hObject, eventdata, handles)
% hObject    handle to P305 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P305 as text
%        str2double(get(hObject,'String')) returns contents of P305 as a double
global input_list;
P305 = str2double(get(hObject,'String'));
input_list(5) = P305;


% --- Executes during object creation, after setting all properties.
function P305_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P305 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
P305 = str2double(get(hObject,'String'));
input_list(5) = P305;



function tau1_Callback(hObject, eventdata, handles)
% hObject    handle to tau1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau1 as text
%        str2double(get(hObject,'String')) returns contents of tau1 as a double
global input_list;
tau1 = str2double(get(hObject,'String'));
input_list(6) = tau1;


% --- Executes during object creation, after setting all properties.
function tau1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
tau1 = str2double(get(hObject,'String'));
input_list(6) = tau1;



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double
global input_list;
beta = str2double(get(hObject,'String'));
input_list(9) = beta;


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
beta = str2double(get(hObject,'String'));
input_list(9) = beta;



function k_Callback(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k as text
%        str2double(get(hObject,'String')) returns contents of k as a double
global input_list;
k = str2double(get(hObject,'String'));
input_list(8) = k;


% --- Executes during object creation, after setting all properties.
function k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global input_list;
k = str2double(get(hObject,'String'));
input_list(8) = k;


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
camkii;