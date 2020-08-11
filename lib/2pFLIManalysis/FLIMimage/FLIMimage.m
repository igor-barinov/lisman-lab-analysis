% #########################################################################
% FLIMimage v1.0r100
% Ryohei Yasuda, Aleksander Sobczyk
% Cold Spring Harbor Labs
% #########################################################################

function varargout = FLIMimage(varargin)
% FLIMIMAGE M-file for FLIMimage.fig
%      FLIMIMAGE, by itself, creates a new FLIMIMAGE or raises the existing
%      singleton*.
%
%      H = FLIMIMAGE returns the handle to a new FLIMIMAGE or the handle to
%      the existing singleton*.
%
%      FLIMIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLIMIMAGE.M with the given input arguments.
%
%      FLIMIMAGE('Property','Value',...) creates a new FLIMIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FLIMimage_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FLIMimage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FLIMimage

% Last Modified by GUIDE v2.5 08-Nov-2004 13:37:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FLIMimage_OpeningFcn, ...
                   'gui_OutputFcn',  @FLIMimage_OutputFcn, ...
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

% #########################################################################
% --- Executes just before FLIMimage is made visible.
function FLIMimage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FLIMimage (see VARARGIN)

% Choose default command line output for FLIMimage
global gh;
global state;
global gui;
gh.spc.FLIMimage = handles;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FLIMimage wait for user response (see UIRESUME)
% uiwait(handles.figure1);
openini('flim.ini');
try
    stopGrab;
    spc_setupPixelClockDAQ_Common;
    spc_stopGrab;
catch
end

handles=FLIM_Init(hObject,handles);
guidata(hObject,handles);

try
	spc_drawInit;
end

pause(0.1)

%%%%Set Initial values%%%%%%%%%%%%%%%%%%
set(handles.image, 'Value', state.spc.acq.spc_image);
set(handles.flimcheck, 'Value', 1); 
set(handles.checkbox3, 'Value', state.spc.acq.spc_binning);
set(handles.checkbox1,'Value', 1);
%set(handles.checkbox3,'Value', 0); %Binning
set(handles.Uncage, 'Value', 0);
set(handles.BinFPop, 'Value', 1);
set(handles.uncageEveryFrame, 'Value', state.spc.acq.uncageEveryXFrame);

state.spc.acq.spc_binning = 0;
out1=calllib('spcm32','SPC_clear_rates',state.spc.acq.module);
state.spc.acq.timer.timerRatesEVER=true;
state.spc.acq.timer.timerRates=timer('TimerFcn','FLIM_TimerFunctionRates','ExecutionMode','fixedSpacing','Period',2.0);
start(state.spc.acq.timer.timerRates);

% #########################################################################
% --- Outputs from this function are returned to the command line.
function varargout = FLIMimage_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% #########################################################################
function FLIM_MenuFile_Callback(hObject, eventdata, handles)

% #########################################################################
function FLIM_MenuFileExit_Callback(hObject, eventdata, handles)
FLIM_Close;

% #########################################################################
function FLIM_MenuParameters_Callback(hObject, eventdata, handles)
FLIM_Parameters;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc
%    set(hObject,'BackgroundColor','white');
%else
%    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc
%   set(hObject,'BackgroundColor','white');
%else
%    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc
%    set(hObject,'BackgroundColor','white');
%else
%    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc
%    set(hObject,'BackgroundColor','white');
%else
%    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc
%    set(hObject,'BackgroundColor','white');
%else
%    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

global state;


if(isvalid(state.spc.acq.timer.timerRates)==1) & (get(hObject,'Value')==1)
    out1=calllib('spcm32','SPC_clear_rates',state.spc.acq.module);
    state.spc.acq.timer.timerRatesEVER=true;
    %state.spc.acq.timer.timerRates=timer('TimerFcn','FLIM_TimerFunctionRates','ExecutionMode','fixedSpacing','Period',2.0);
    start(state.spc.acq.timer.timerRates);
end

if (isvalid(state.spc.acq.timer.timerRates)==1)&(get(hObject,'Value')==0)
    set(handles.edit2,'String','');
    set(handles.edit3,'String','');
    set(handles.edit4,'String','');
    set(handles.edit5,'String','');
    stop(state.spc.acq.timer.timerRates);
    %delete(state.spc.acq.timer.timerRates);
end


% --- Executes on button press in focus.
function focus_Callback(hObject, eventdata, handles)
% hObject    handle to focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state;

state.spc.acq.SPCdata.trigger = 1;
if FLIM_setupScanning(1)
    return;
end
state.internal.whatToDo=1;

str = get(hObject, 'String');

FLIM_Measurement(hObject,handles);



% --- Executes on button press in grab.
function grab_Callback(hObject, eventdata, handles)
% hObject    handle to grab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state;
if state.spc.acq.SPCdata.mode == 2
	state.spc.acq.SPCdata.trigger = 1;
    if FLIM_setupScanning(0)
        return;
    end
	state.internal.whatToDo=2;
	FLIM_Measurement(hObject, handles);
end

% --- Executes on button press in loop.
function loop_Callback(hObject, eventdata, handles)
% hObject    handle to loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state;
if state.spc.acq.SPCdata.mode == 2
	%state.spc.acq.SPCdata.trigger = 1;
    if FLIM_setupScanning(0)
        return;
    end    
    spc_executeLoop;
end

% --- Executes on button press in image.
function image_Callback(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of image


global state;

value = get(hObject, 'Value');
state.spc.acq.spc_image = value;


% --- Executes on button press in recover.
function recover_Callback(hObject, eventdata, handles)
% hObject    handle to recover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spc_abortCurrent;


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
global state;
value=get(hObject, 'Value');
state.spc.acq.spc_binning = value;


% --- Executes on button press in Uncage.
function Uncage_Callback(hObject, eventdata, handles)
% hObject    handle to Uncage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Uncage
global state;
value=get(hObject, 'Value');
state.spc.acq.uncageBox = value;
%%
% if value
% 	state.acq.numberOfFrames = state.standardMode.numberOfFrames * state.spc.acq.uncageEveryXFrame;
% else
%     state.acq.numberOfFrames = state.standardMode.numberOfFrames;
% end
% preAllocateMemory;
% alterDAQ_NewNumberOfFrames;
% state.init.eom.changed(:) = 1;

% --- Executes during object creation, after setting all properties.
function BinFPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinFPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in BinFPop.
function BinFPop_Callback(hObject, eventdata, handles)
% hObject    handle to BinFPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BinFPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BinFPop

global state;
value=get(hObject, 'Value');
state.spc.acq.binFactor= 2^(value-1);
state.spc.acq.spc_binning = 1;
set(handles.checkbox3, 'Value', 1);


% --- Executes during object creation, after setting all properties.
function uncageEveryFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uncageEveryFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function uncageEveryFrame_Callback(hObject, eventdata, handles)
% hObject    handle to uncageEveryFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uncageEveryFrame as text
%        str2double(get(hObject,'String')) returns contents of uncageEveryFrame as a double

global state;
value = str2num(get(hObject, 'String'));
state.spc.acq.uncageEveryXFrame = value;

% if value > 1 & get(handles.Uncage, 'Value');
% 	state.acq.numberOfFrames = state.standardMode.numberOfFrames * state.spc.acq.uncageEveryXFrame;
% else
%     state.acq.numberOfFrames = state.standardMode.numberOfFrames;
% end
% preAllocateMemory;
% alterDAQ_NewNumberOfFrames;
% state.init.eom.changed(:) = 1;



% --- Executes on button press in flimcheck.
function flimcheck_Callback(hObject, eventdata, handles)
% hObject    handle to flimcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flimcheck

global state;

value = get(hObject, 'Value');
state.spc.acq.spc_takeFLIM = value;