function varargout = h_generalAnalysisGUI(varargin)
% H_GENERALANALYSISGUI M-file for h_generalAnalysisGUI.fig
%      H_GENERALANALYSISGUI, by itself, creates a new H_GENERALANALYSISGUI or raises the existing
%      singleton*.
%
%      H = H_GENERALANALYSISGUI returns the handle to a new H_GENERALANALYSISGUI or the handle to
%      the existing singleton*.
%
%      H_GENERALANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_GENERALANALYSISGUI.M with the given input arguments.
%
%      H_GENERALANALYSISGUI('Property','Value',...) creates a new H_GENERALANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_generalAnalysisGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_generalAnalysisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_generalAnalysisGUI

% Last Modified by GUIDE v2.5 28-Jun-2016 11:57:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_generalAnalysisGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_generalAnalysisGUI_OutputFcn, ...
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


% --- Executes just before h_generalAnalysisGUI is made visible.
function h_generalAnalysisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_generalAnalysisGUI (see VARARGIN)

% Choose default command line output for h_generalAnalysisGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_generalAnalysisGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_generalAnalysisGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in improfile.
function improfile_Callback(hObject, eventdata, handles)
% hObject    handle to improfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_improfile2;


% --- Executes on button press in calcSphere.
function calcSphere_Callback(hObject, eventdata, handles)
% hObject    handle to calcSphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;
handles = h_img.currentHandles;
h_img.lastCalcROI = h_executecalcRoi(handles);
h_updateInfo(handles);
h_img.lastCalcROI

Aout = h_findGravityCenter;
Aout.center(end)
h_img.lastCalcSpere = h_calcSphere(Aout.center(end));
h_img.lastCalcSpere







% --- Executes on button press in reCalcAllInGroup.
function reCalcAllInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to reCalcAllInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_reCalcAllInGrp;



% --- Executes on button press in showHeader.
function showHeader_Callback(hObject, eventdata, handles)
% hObject    handle to showHeader (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;
handles = guihandles(hObject);
fileName = get(h_img.currentHandles.currentFileName,'String');
text = evalc('Tiff(fileName)'); % capture output of Tiff command in a string
text = text(10:end-2); % remove unneccessary 'ans = ' and extra blank lines
set(handles.headerText,'String',text);

function headerText_Callback(hObject, eventdata, handles)
% hObject    handle to headerText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of headerText as text
%        str2double(get(hObject,'String')) returns contents of headerText as a double


% --- Executes during object creation, after setting all properties.
function headerText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to headerText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
