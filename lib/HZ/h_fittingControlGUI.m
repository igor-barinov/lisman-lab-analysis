function varargout = h_fittingControlGUI(varargin)
% H_FITTINGCONTROLGUI M-file for h_fittingControlGUI.fig
%      H_FITTINGCONTROLGUI, by itself, creates a new H_FITTINGCONTROLGUI or raises the existing
%      singleton*.
%
%      H = H_FITTINGCONTROLGUI returns the handle to a new H_FITTINGCONTROLGUI or the handle to
%      the existing singleton*.
%
%      H_FITTINGCONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_FITTINGCONTROLGUI.M with the given input arguments.
%
%      H_FITTINGCONTROLGUI('Property','Value',...) creates a new H_FITTINGCONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_fittingControlGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_fittingControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_fittingControlGUI

% Last Modified by GUIDE v2.5 12-Apr-2006 23:56:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_fittingControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_fittingControlGUI_OutputFcn, ...
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


% --- Executes just before h_fittingControlGUI is made visible.
function h_fittingControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_fittingControlGUI (see VARARGIN)

% Choose default command line output for h_fittingControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_fittingControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_fittingControlGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fitting.
function fitting_Callback(hObject, eventdata, handles)
% hObject    handle to fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global h_img
handles = h_img.currentHandles;
fittingOpt = get(handles.fittingOpt,'Value');
h = findobj('Type','figure','Tag','h_imstackPlot','Selected','on');
line = findobj(h,'Type','line','Selected','on');
switch fittingOpt
    case {1}
    case {2}
        fit = h_fitCurve(1,line)
        if fit.converge
            clipboard('copy', [num2str(fit.t),char(9),num2str(fit.a),char(9),num2str(fit.b)]);
        else
            clipboard('copy','');
        end
    case {3}
        fit = h_fitCurve(2,line)
        if fit.converge
            clipboard('copy', [num2str(fit.t1),char(9),num2str(fit.t2),char(9),num2str(fit.a),char(9),num2str(fit.b),char(9),num2str(fit.c)]);
        else
            clipboard('copy','');
        end
    case {4}
        fit = h_fitCurve(3,line)
    otherwise
end
try
    if h_img.state.fittingControls.plotFitOpt.Value
        h2 = get(line,'parent');
        axes(h2);
        hold on;
        plot(fit.x,fit.y);
        hold off;
    end
end


% --- Executes during object creation, after setting all properties.
function fittingOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fittingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in fittingOpt.
function fittingOpt_Callback(hObject, eventdata, handles)
% hObject    handle to fittingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fittingOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fittingOpt

UserData = get(handles.fittingControls,'UserData');
UserData.fittingOpt.Value = get(hObject,'Value');
set(handles.fittingControls,'UserData',UserData);


% --- Executes on button press in plotFitOpt.
function plotFitOpt_Callback(hObject, eventdata, handles)
% hObject    handle to plotFitOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotFitOpt

global h_img
UserData = get(handles.fittingControls,'UserData');
UserData.plotFitOpt.Value = get(hObject,'Value');
set(handles.fittingControls,'UserData',UserData);
h_img.state.fittingControls.plotFitOpt.Value = get(hObject,'Value');
