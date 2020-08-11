function varargout = h_groupControlGUI(varargin)
% H_GROUPCONTROLGUI M-file for h_groupControlGUI.fig
%      H_GROUPCONTROLGUI, by itself, creates a new H_GROUPCONTROLGUI or raises the existing
%      singleton*.
%
%      H = H_GROUPCONTROLGUI returns the handle to a new H_GROUPCONTROLGUI or the handle to
%      the existing singleton*.
%
%      H_GROUPCONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_GROUPCONTROLGUI.M with the given input arguments.
%
%      H_GROUPCONTROLGUI('Property','Value',...) creates a new H_GROUPCONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_groupControlGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_groupControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_groupControlGUI

% Last Modified by GUIDE v2.5 19-Feb-2006 01:28:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_groupControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_groupControlGUI_OutputFcn, ...
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


% --- Executes just before h_groupControlGUI is made visible.
function h_groupControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_groupControlGUI (see VARARGIN)

% Choose default command line output for h_groupControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_groupControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_groupControlGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in newGroup.
function newGroup_Callback(hObject, eventdata, handles)
% hObject    handle to newGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
h_newGroup(handles);


% --- Executes on button press in addToCurrentGroup.
function addToCurrentGroup_Callback(hObject, eventdata, handles)
% hObject    handle to addToCurrentGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
currentFilename = get(handles.currentFileName,'String');
if isempty(strfind(currentFilename,'currentFileName'))
    h_addToCurrentGroup(currentFilename);
    h_updateInfo(handles);
end


% --- Executes on button press in removeFromCurrentGroup.
function removeFromCurrentGroup_Callback(hObject, eventdata, handles)
% hObject    handle to removeFromCurrentGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
currentFilename = get(handles.currentFileName,'String');
h_removeFromCurrentGroup(currentFilename);
h_updateInfo(handles);



% --- Executes on button press in mergeWith.
function mergeWith_Callback(hObject, eventdata, handles)
% hObject    handle to mergeWith (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guihandles(hObject);
h_mergeTwoGroups(handles);



% --- Executes on button press in openGroup.
function openGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openGroup (see GCBO)
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

h_openGroup(fname, pname, handles);


% --- Executes on button press in loadCurrentImgGroup.
function loadCurrentImgGroup_Callback(hObject, eventdata, handles)
% hObject    handle to loadCurrentImgGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img

handles = guihandles(hObject);
h_openGroup(h_img.imgGroupInfo.groupName, h_img.imgGroupInfo.groupPath, handles);


% --- Executes on button press in batchAddToGroup.
function batchAddToGroup_Callback(hObject, eventdata, handles)
% hObject    handle to batchAddToGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
h = h_searchForGroupGUI;
pos = get(handles.h_imstack, 'Position');
pos2 = get(h,'Position');
pos2(1) = pos(1) + 20;
pos2(2) = pos(2) + pos(4)/2;
set(h,'Position', pos2);

h_handles = guihandles(h);

currentFilename = get(handles.currentFileName,'String');
[pname,fname,fExt] = fileparts(currentFilename);
if isempty(strfind(currentFilename,'currentFileName'))
    set(h_handles.pathName,'String',pname);
    if ~strcmp(fname(end-2:end),'max')
        set(h_handles.fileBasename,'String',fname(1:end-3));
        set(h_handles.maxOpt,'Value',0);
    else
        set(h_handles.fileBasename,'String',fname(1:end-6));
        set(h_handles.maxOpt,'Value',1);
    end
end
    


% --- Executes on button press in loadAnalyzedRoiData.
function loadAnalyzedRoiData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnalyzedRoiData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadAnalyzedRoiData(guihandles(hObject));


% --- Executes on button press in calculateZRoi.
function calculateZRoi_Callback(hObject, eventdata, handles)
% hObject    handle to calculateZRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img;
handles = guihandles(hObject);
h_img.lastCalcROI = h_executecalcRoi(handles);
h_updateInfo(handles);
h_img.lastCalcROI


% --- Executes on button press in changeGroupPath.
function changeGroupPath_Callback(hObject, eventdata, handles)
% hObject    handle to changeGroupPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img

handles = guihandles(hObject);
h = h_changeGroupDatapathGUI;
pos = get(handles.h_imstack, 'Position');
pos2 = get(h,'Position');
pos2(1) = pos(1) + 20;
pos2(2) = pos(2) + pos(4)/2;
set(h,'Position', pos2);

h_handles = guihandles(h);

currentFilename = get(handles.currentFileName,'String');
[pname,fname,fExt] = fileparts(currentFilename);
if isempty(strfind(currentFilename,'currentFileName'))
    set(h_handles.currentPath,'String',pname);
end
if isfield(h_img,'activeGroup')&~isempty(h_img.activeGroup.groupFiles)
    [pname,fname,fExt] = fileparts(h_img.activeGroup.groupFiles(1).name);
    set(h_handles.formerPath,'String',pname);
end


% --- Executes on button press in autoGroup.
function autoGroup_Callback(hObject, eventdata, handles)
% hObject    handle to autoGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_autoGroupByPosition(guihandles(hObject));


% --- Executes on button press in closeGroup.
function closeGroup_Callback(hObject, eventdata, handles)
% hObject    handle to closeGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img

h_img.activeGroup.groupName = [];
h_img.activeGroup.groupPath = [];
h_img.activeGroup.groupFiles = [];
h_updateInfo(h_img.currentHandles);


