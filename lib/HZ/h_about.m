function varargout = h_about(varargin)
% H_ABOUT M-file for h_about.fig
%      H_ABOUT, by itself, creates a new H_ABOUT or raises the existing
%      singleton*.
%
%      H = H_ABOUT returns the handle to a new H_ABOUT or the handle to
%      the existing singleton*.
%
%      H_ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_ABOUT.M with the given input arguments.
%
%      H_ABOUT('Property','Value',...) creates a new H_ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_about_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_about_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_about

% Last Modified by GUIDE v2.5 03-Aug-2005 23:21:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_about_OpeningFcn, ...
                   'gui_OutputFcn',  @h_about_OutputFcn, ...
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


% --- Executes just before h_about is made visible.
function h_about_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_about (see VARARGIN)

% Choose default command line output for h_about
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_about wait for user response (see UIRESUME)
% uiwait(handles.h_about);

img = imread('smiley_face_blind.jpg');
axes(handles.logoImg);
image(img);
set(handles.logoImg,'XTick',[],'YTick',[],'XColor',[0 0 0],'YColor',[0 0 0]);

% --- Outputs from this function are returned to the command line.
function varargout = h_about_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
