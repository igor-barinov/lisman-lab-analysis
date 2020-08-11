function varargout = tau_analysis(varargin)
% TAU_ANALYSIS MATLAB code for tau_analysis.fig
%      TAU_ANALYSIS, by itself, creates a new TAU_ANALYSIS or raises the existing
%      singleton*.
%
%      H = TAU_ANALYSIS returns the handle to a new TAU_ANALYSIS or the handle to
%      the existing singleton*.
%
%      TAU_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAU_ANALYSIS.M with the given input arguments.
%
%      TAU_ANALYSIS('Property','Value',...) creates a new TAU_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tau_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tau_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tau_analysis

% Last Modified by GUIDE v2.5 04-Nov-2016 11:39:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tau_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @tau_analysis_OutputFcn, ...
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


% --- Executes just before tau_analysis is made visible.
function tau_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tau_analysis (see VARARGIN)

% Choose default command line output for tau_analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tau_analysis wait for user response (see UIRESUME)
% uiwait(handles.tau_analysis);


% --- Outputs from this function are returned to the command line.
function varargout = tau_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function filepath_Callback(hObject, eventdata, handles)
global struct_data;
global FileName;
global xvalues;
global yvalues;
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepath as text
%        str2double(get(hObject,'String')) returns contents of filepath as a double
filepath = get(hObject, 'String');
if isempty(filepath) == 0,
    struct_data = load (filepath);
    % Find the filename from the full string
    filesep_indexes = find(filepath == filesep);
    FileName = filepath(filesep_indexes(end)+1:end);
    file = FileName(1:end-4);   % take off the .mat ending from the filename to use in the struct
    xvalues = ((struct_data.(file).analyzeData.time3(1,:) - struct_data.(file).analyzeData.time3(1,1))*24*60)';
    yvalues = (struct_data.(file).analyzeData.tau_m(1,:) - struct_data.(file).analyzeData.tau_m(1,1))';
end

% --- Executes during object creation, after setting all properties.
function filepath_CreateFcn(hObject, eventdata, handles)
global struct_data;
global FileName;
global xvalues;
global yvalues;
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
filepath = get(hObject, 'String');
if isempty(filepath) == 0,
    struct_data = load (filepath);
    % Find the filename from the full string
    filesep_indexes = find(filepath == filesep);
    FileName = filepath(filesep_indexes(end)+1:end);
    file = FileName(1:end-4);   % take off the .mat ending from the filename to use in the struct
    xvalues = ((struct_data.(file).analyzeData.time3(1,:) - struct_data.(file).analyzeData.time3(1,1))*24*60)';
    yvalues = (struct_data.(file).analyzeData.tau_m(1,:) - struct_data.(file).analyzeData.tau_m(1,1))';
end



function tau1_Callback(hObject, eventdata, handles)
% hObject    handle to tau1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau1 as text
%        str2double(get(hObject,'String')) returns contents of tau1 as a double


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



function tau2_Callback(hObject, eventdata, handles)
% hObject    handle to tau2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau2 as text
%        str2double(get(hObject,'String')) returns contents of tau2 as a double



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


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
global xvalues;
global yvalues;
global toggle;
global fitswitch;
global startpoints;
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(xvalues)==0 && isempty(yvalues)==0,
    startpoints(1) = str2double(get(handles.a_edit,'String'));
    startpoints(2) = str2double(get(handles.b_edit,'String'));
    startpoints(3) = str2double(get(handles.c_edit,'String'));
    startpoints(4) = str2double(get(handles.d_edit,'String'));
    if fitswitch == 1
        startpoints(3:4) = [];
    end
    [tau1, tau2, amp1, amp2, coefficients, gof, p] = n_calcTaus(xvalues, yvalues, toggle, fitswitch, startpoints);
    set(handles.tau1, 'String', num2str(tau1));
    set(handles.tau2, 'String', num2str(tau2));
    set(handles.rsquare, 'String', num2str(gof.rsquare));
    set(handles.adjrsquare, 'String', num2str(gof.adjrsquare));
    set(handles.SSE, 'String', num2str(gof.sse));
    set(handles.RMSE, 'String', num2str(gof.rmse));
    set(handles.pvalue, 'String', num2str(p));
    set(handles.amplitude1, 'String', num2str(amp1));
    set(handles.amplitude2, 'String', num2str(amp2));
    set(handles.a_text, 'String', num2str(coefficients(1)));
    set(handles.b_text, 'String', num2str(coefficients(2)));
    if fitswitch == 2
        set(handles.c_text, 'String', num2str(coefficients(3)));
        set(handles.d_text, 'String', num2str(coefficients(4)));
    else
        set(handles.c_text, 'String', '');
        set(handles.d_text, 'String', '');
    end
    % warnings for bad fits

    
    if tau1 < 0 || tau2 < 0,
        errordlg('Negative tau','Warning: bad fit');
    end
    if gof.rsquare <= 0.3 || gof.adjrsquare <= 0.3,
        errordlg('Low R-square','Warning: bad fit');
    end
%     if gof.rmse >= 0.5 || gof.sse >= 0.5,
%         errordlg('High square error','Warning: bad fit');
%     end
    if p > 0.05,
        errordlg('High p-value','Warning: bad fit');
    end
else,
    errordlg('You must select a file or enter x and y values to calculate', 'Warning')
end

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
global struct_data;
global FileName
global xvalues;
global yvalues;
global yvalues_red;
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uigetfile('*.mat', 'Select mat file');
if FileName == 0, 
    return, 
end
struct_data = load(fullfile(PathName,FileName));
csv_data = load(fullfile(PathName,FileName));
 MatDef = [PathName FileName];
 set(handles.filepath,'String',MatDef);
%  file = FileName(1:end-4);   % take off the .mat ending from the filename to use in the struct
% xvalues = ((struct_data.(file).analyzeData.time3(1,:) - struct_data.(file).analyzeData.time3(1,1))*24*60)';
% yvalues = (struct_data.(file).analyzeData.tau_m(1,:))';
% xvalues =struct_data(:,1); %next three lines nicko to load excell file in .csv format
% yvalues = struct_data(:,2);
% yvalues_red = struct_data(:,3);
xvalues = csv_data(:,1);
yvalues = csv_data(:,2);
yvalues_red=csv_data(:,3);

function rsquare_Callback(hObject, eventdata, handles)
% hObject    handle to rsquare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rsquare as text
%        str2double(get(hObject,'String')) returns contents of rsquare as a double


% --- Executes during object creation, after setting all properties.
function rsquare_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsquare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RMSE_Callback(hObject, eventdata, handles)
% hObject    handle to RMSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RMSE as text
%        str2double(get(hObject,'String')) returns contents of RMSE as a double


% --- Executes during object creation, after setting all properties.
function RMSE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RMSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SSE_Callback(hObject, eventdata, handles)
% hObject    handle to SSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SSE as text
%        str2double(get(hObject,'String')) returns contents of SSE as a double


% --- Executes during object creation, after setting all properties.
function SSE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adjrsquare_Callback(hObject, eventdata, handles)
% hObject    handle to adjrsquare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adjrsquare as text
%        str2double(get(hObject,'String')) returns contents of adjrsquare as a double


% --- Executes during object creation, after setting all properties.
function adjrsquare_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adjrsquare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pvalue_Callback(hObject, eventdata, handles)
% hObject    handle to pvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pvalue as text
%        str2double(get(hObject,'String')) returns contents of pvalue as a double


% --- Executes during object creation, after setting all properties.
function pvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amplitude1_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amplitude1 as text
%        str2double(get(hObject,'String')) returns contents of amplitude1 as a double


% --- Executes during object creation, after setting all properties.
function amplitude1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pastedx_Callback(hObject, eventdata, handles)
global xvalues;
% hObject    handle to pastedx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pastedx as text
%        str2double(get(hObject,'String')) returns contents of pastedx as a double
xvalues = str2num(get(hObject, 'String'))';


% --- Executes during object creation, after setting all properties.
function pastedx_CreateFcn(hObject, eventdata, handles)
global xvalues;
% hObject    handle to pastedx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
xvalues = str2num(get(hObject, 'String'))';



function pastedy_Callback(hObject, eventdata, handles)
global yvalues;
% hObject    handle to pastedy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pastedy as text
%        str2double(get(hObject,'String')) returns contents of pastedy as a double
yvalues = str2num(get(hObject, 'String'))';


% --- Executes during object creation, after setting all properties.
function pastedy_CreateFcn(hObject, eventdata, handles)
global yvalues;
% hObject    handle to pastedy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
yvalues = str2num(get(hObject, 'String'))';



function amplitude2_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amplitude2 as text
%        str2double(get(hObject,'String')) returns contents of amplitude2 as a double


% --- Executes during object creation, after setting all properties.
function amplitude2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pastedx, 'String', '');
set(handles.pastedy, 'String', '');


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
global toggle;
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    % toggle button is pressed
    toggle = 1;
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    toggle = 0;
end


% --- Executes on button press in singleExp.
function singleExp_Callback(hObject, eventdata, handles)
global fitswitch;
% hObject    handle to singleExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fitswitch = 1;

% --- Executes on button press in doubleExp.
function doubleExp_Callback(hObject, eventdata, handles)
global fitswitch;
% hObject    handle to doubleExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fitswitch = 2;


% --- Executes on button press in smooth.
function smooth_Callback(hObject, eventdata, handles)
global yvalues;
global yvalues_red
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = size(yvalues);
num = str2double(get(handles.span, 'String'));
yvalues = smooth(yvalues, num/s(2), 'moving');
s_r = size(yvalues_red);
yvalues_red = smooth(yvalues_red, num/s_r(2), 'moving');

function span_Callback(hObject, eventdata, handles)
% hObject    handle to span (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of span as text
%        str2double(get(hObject,'String')) returns contents of span as a double


% --- Executes during object creation, after setting all properties.
function span_CreateFcn(hObject, eventdata, handles)
% hObject    handle to span (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in unsmooth.
function unsmooth_Callback(hObject, eventdata, handles)
global yvalues;
global yvalues_red;
global csv_data;
% hObject    handle to unsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yvalues = str2num(get(handles.pastedy, 'String'))';
%csv_data = load(fullfile(PathName,FileName));
%yvalues = csv_data(:,2);
%yvalues_red=csv_data(:,3);


function a_edit_Callback(hObject, eventdata, handles)
% hObject    handle to a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_edit as text
%        str2double(get(hObject,'String')) returns contents of a_edit as a double

% --- Executes during object creation, after setting all properties.
function a_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_edit_Callback(hObject, eventdata, handles)
% hObject    handle to c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_edit as text
%        str2double(get(hObject,'String')) returns contents of c_edit as a double


% --- Executes during object creation, after setting all properties.
function c_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d_edit_Callback(hObject, eventdata, handles)
% hObject    handle to d_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d_edit as text
%        str2double(get(hObject,'String')) returns contents of d_edit as a double

% --- Executes during object creation, after setting all properties.
function d_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b_edit_Callback(hObject, eventdata, handles)
% hObject    handle to b_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b_edit as text
%        str2double(get(hObject,'String')) returns contents of b_edit as a double


% --- Executes during object creation, after setting all properties.
function b_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in raising.
function raising_Callback(hObject, eventdata, handles)
global rasingfallingswitch;
% hObject    handle to raising (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rasingfallingswitch =2;

% --- Executes on button press in falling.
function falling_Callback(hObject, eventdata, handles)
global rasingfallingswitch;
% hObject    handle to falling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rasingfallingswitch =1;



function end_time_Callback(hObject, eventdata, handles)
% hObject    handle to end_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_time as text
%        str2double(get(hObject,'String')) returns contents of end_time as a double


% --- Executes during object creation, after setting all properties.
function end_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
