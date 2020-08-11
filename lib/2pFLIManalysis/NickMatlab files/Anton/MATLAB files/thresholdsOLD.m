function varargout = thresholds(varargin)
% THRESHOLDS MATLAB code for thresholds.fig
%      THRESHOLDS, by itself, creates a new THRESHOLDS or raises the existing
%      singleton*.
%
%      H = THRESHOLDS returns the handle to a new THRESHOLDS or the handle to
%      the existing singleton*.
%
%      THRESHOLDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLDS.M with the given input arguments.
%
%      THRESHOLDS('Property','Value',...) creates a new THRESHOLDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before thresholds_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to thresholds_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help thresholds

% Last Modified by GUIDE v2.5 10-Nov-2015 16:43:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @thresholds_OpeningFcn, ...
                   'gui_OutputFcn',  @thresholds_OutputFcn, ...
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


% --- Executes just before thresholds is made visible.
function thresholds_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to thresholds (see VARARGIN)

% Choose default command line output for thresholds
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes thresholds wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = thresholds_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function rdf_Callback(hObject, eventdata, handles)
% hObject    handle to rdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rdf as text
%        str2double(get(hObject,'String')) returns contents of rdf as a double
global thresholds_list;
rdf = str2double(get(hObject,'String'));
thresholds_list(7) = rdf;


% --- Executes during object creation, after setting all properties.
function rdf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
rdf = str2double(get(hObject,'String'));
thresholds_list(7) = rdf;



function fw_Callback(hObject, eventdata, handles)
% hObject    handle to fw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fw as text
%        str2double(get(hObject,'String')) returns contents of fw as a double
global thresholds_list;
fw = str2double(get(hObject,'String'));
thresholds_list(1) = fw;


% --- Executes during object creation, after setting all properties.
function fw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
fw = str2double(get(hObject,'String'));
thresholds_list(1) = fw;



function bmf_Callback(hObject, eventdata, handles)
% hObject    handle to bmf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bmf as text
%        str2double(get(hObject,'String')) returns contents of bmf as a double
global thresholds_list;
bmf = str2double(get(hObject,'String'));
thresholds_list(2) = bmf;


% --- Executes during object creation, after setting all properties.
function bmf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bmf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
bmf = str2double(get(hObject,'String'));
thresholds_list(2) = bmf;



function bmfr_Callback(hObject, eventdata, handles)
% hObject    handle to bmfr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bmfr as text
%        str2double(get(hObject,'String')) returns contents of bmfr as a double
global thresholds_list;
bmfr = str2double(get(hObject,'String'));
thresholds_list(3) = bmfr;


% --- Executes during object creation, after setting all properties.
function bmfr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bmfr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
bmfr = str2double(get(hObject,'String'));
thresholds_list(3) = bmfr;



function sdbmfr_Callback(hObject, eventdata, handles)
% hObject    handle to sdbmfr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdbmfr as text
%        str2double(get(hObject,'String')) returns contents of sdbmfr as a double
global thresholds_list;
sdbmfr = str2double(get(hObject,'String'));
thresholds_list(4) = sdbmfr;


% --- Executes during object creation, after setting all properties.
function sdbmfr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdbmfr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
sdbmfr = str2double(get(hObject,'String'));
thresholds_list(4) = sdbmfr;



function srb_Callback(hObject, eventdata, handles)
% hObject    handle to srb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of srb as text
%        str2double(get(hObject,'String')) returns contents of srb as a double
global thresholds_list;
srb = str2double(get(hObject,'String'));
thresholds_list(5) = srb;


% --- Executes during object creation, after setting all properties.
function srb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to srb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
srb = str2double(get(hObject,'String'));
thresholds_list(5) = srb;



function sdf_Callback(hObject, eventdata, handles)
% hObject    handle to sdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdf as text
%        str2double(get(hObject,'String')) returns contents of sdf as a double
global thresholds_list;
sdf = str2double(get(hObject,'String'));
thresholds_list(6) = sdf;

% --- Executes during object creation, after setting all properties.
function sdf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
sdf = str2double(get(hObject,'String'));
thresholds_list(6) = sdf;



function plotav_Callback(hObject, eventdata, handles)
% hObject    handle to plotav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotav as text
%        str2double(get(hObject,'String')) returns contents of plotav as a double
global thresholds_list;
plotav = str2double(get(hObject,'String'));
thresholds_list(14) = plotav;

% --- Executes during object creation, after setting all properties.
function plotav_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
plotav = str2double(get(hObject,'String'));
thresholds_list(14) = plotav;



function red_Callback(hObject, eventdata, handles)
% hObject    handle to red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of red as text
%        str2double(get(hObject,'String')) returns contents of red as a double
global thresholds_list;
red = str2double(get(hObject,'String'));
thresholds_list(8) = red;


% --- Executes during object creation, after setting all properties.
function red_CreateFcn(hObject, eventdata, handles)
% hObject    handle to red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
red = str2double(get(hObject,'String'));
thresholds_list(8) = red;



function green_Callback(hObject, eventdata, handles)
% hObject    handle to green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of green as text
%        str2double(get(hObject,'String')) returns contents of green as a double
global thresholds_list;
green = str2double(get(hObject,'String'));
thresholds_list(9) = green;


% --- Executes during object creation, after setting all properties.
function green_CreateFcn(hObject, eventdata, handles)
% hObject    handle to green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
green = str2double(get(hObject,'String'));
thresholds_list(9) = green;



function yellow_Callback(hObject, eventdata, handles)
% hObject    handle to yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yellow as text
%        str2double(get(hObject,'String')) returns contents of yellow as a double
global thresholds_list;
yellow = str2double(get(hObject,'String'));
thresholds_list(10) = yellow;


% --- Executes during object creation, after setting all properties.
function yellow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
yellow = str2double(get(hObject,'String'));
thresholds_list(10) = yellow;



function deltax_Callback(hObject, eventdata, handles)
% hObject    handle to deltax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltax as text
%        str2double(get(hObject,'String')) returns contents of deltax as a double
global thresholds_list;
deltax = str2double(get(hObject,'String'));
thresholds_list(11) = deltax;


% --- Executes during object creation, after setting all properties.
function deltax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
deltax = str2double(get(hObject,'String'));
thresholds_list(11) = deltax;



function deltay_Callback(hObject, eventdata, handles)
% hObject    handle to deltay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltay as text
%        str2double(get(hObject,'String')) returns contents of deltay as a double
global thresholds_list;
deltay = str2double(get(hObject,'String'));
thresholds_list(12) = deltay;


% --- Executes during object creation, after setting all properties.
function deltay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
deltay = str2double(get(hObject,'String'));
thresholds_list(12) = deltay;



function snroi_Callback(hObject, eventdata, handles)
% hObject    handle to snroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of snroi as text
%        str2double(get(hObject,'String')) returns contents of snroi as a double
global thresholds_list;
snroi = str2double(get(hObject,'String'));
thresholds_list(13) = snroi;


% --- Executes during object creation, after setting all properties.
function snroi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
snroi = str2double(get(hObject,'String'));
thresholds_list(13) = snroi;



function dpixels_Callback(hObject, eventdata, handles)
% hObject    handle to dpixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dpixels as text
%        str2double(get(hObject,'String')) returns contents of dpixels as a double
global thresholds_list;
dpixels = str2double(get(hObject,'String'));
thresholds_list(16) = dpixels;

% --- Executes during object creation, after setting all properties.
function dpixels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
dpixels = str2double(get(hObject,'String'));
thresholds_list(16) = dpixels;



function page3_Callback(hObject, eventdata, handles)
% hObject    handle to page3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of page3 as text
%        str2double(get(hObject,'String')) returns contents of page3 as a double
global thresholds_list;
page3 = str2double(get(hObject,'String'));
thresholds_list(15) = page3;


% --- Executes during object creation, after setting all properties.
function page3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to page3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
page3 = str2double(get(hObject,'String'));
thresholds_list(15) = page3;



function disp1_Callback(hObject, eventdata, handles)
% hObject    handle to disp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp1 as text
%        str2double(get(hObject,'String')) returns contents of disp1 as a double


% --- Executes during object creation, after setting all properties.
function disp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp5_Callback(hObject, eventdata, handles)
% hObject    handle to disp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp5 as text
%        str2double(get(hObject,'String')) returns contents of disp5 as a double


% --- Executes during object creation, after setting all properties.
function disp5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp3_Callback(hObject, eventdata, handles)
% hObject    handle to disp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp3 as text
%        str2double(get(hObject,'String')) returns contents of disp3 as a double


% --- Executes during object creation, after setting all properties.
function disp3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp2_Callback(hObject, eventdata, handles)
% hObject    handle to disp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp2 as text
%        str2double(get(hObject,'String')) returns contents of disp2 as a double


% --- Executes during object creation, after setting all properties.
function disp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp6_Callback(hObject, eventdata, handles)
% hObject    handle to disp6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp6 as text
%        str2double(get(hObject,'String')) returns contents of disp6 as a double


% --- Executes during object creation, after setting all properties.
function disp6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp4_Callback(hObject, eventdata, handles)
% hObject    handle to disp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp4 as text
%        str2double(get(hObject,'String')) returns contents of disp4 as a double


% --- Executes during object creation, after setting all properties.
function disp4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sgb_Callback(hObject, eventdata, handles)
% hObject    handle to sgb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sgb as text
%        str2double(get(hObject,'String')) returns contents of sgb as a double
global thresholds_list;
srb = str2double(get(hObject,'String'));
thresholds_list(19) = srb;


% --- Executes during object creation, after setting all properties.
function sgb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sgb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global thresholds_list;
srb = str2double(get(hObject,'String'));
thresholds_list(19) = srb;
