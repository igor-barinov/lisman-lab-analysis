function varargout = spc_main(varargin)
% SPC_MAIN Application M-file for spc_main.fig
%    FIG = SPC_MAIN launch spc_main GUI.
%    SPC_MAIN('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 23-Nov-2020 15:13:17
global gui spc;

if nargin == 0  % LAUNCH GUI
    fig = openfig(mfilename,'reuse');
    
    % Generate a structure of handles to pass to callbacks, and store it.
    handles = guihandles(fig);
    gui.spc.spc_main = handles;
    guidata(fig, handles);
    
    if nargout > 0
        varargout{1} = fig;
    end
    
    range = round(spc.fit(gui.spc.proChannel).range.*spc.datainfo.psPerUnit/100)/10;
    set(handles.spc_fitstart, 'String', num2str(range(1)));
    set(handles.spc_fitend, 'String', num2str(range(2)));
    set(handles.back_value, 'String', num2str(spc.fit(gui.spc.proChannel).background));
    set(handles.filename, 'String', spc.filename);
    set(handles.spc_page, 'String', num2str(spc.switches.currentPage));
    set(handles.slider1, 'Value', (spc.switches.currentPage-1)/100);
    spc_dispbeta();
    
    
    set(handles.fracCheck, 'Value', 1);
    set(handles.tauCheck, 'Value', 1);
    set(handles.greenCheck, 'Value', 1);
    set(handles.redCheck, 'Value', 1);
    set(handles.RatioCheck, 'Value', 0);
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    try
        if nargout
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        else
            feval(varargin{:}); % FEVAL switchyard
        end
    catch err
        disp(err);
    end
end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and
%| sets objects' callback properties to call them through the FEVAL
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



%% FILE MENU ======================================================================================================
%
function spc_file_Callback(~, ~, ~, varargin)


function spc_open_Callback(~, ~, ~, varargin)
SPCFileMenu.Open();


function saveMovie_Callback(~, ~, ~)
SPCFileMenu.SaveTifMovieAs();

%% ================================================================================================================










%% DRAWING MENU ===================================================================================================
%
function spc_drawing_Callback(~, ~, ~, varargin)

function spc_drawall_Callback(~, ~, ~, varargin)
SPCDrawingMenu.RedrawLifetime();


function logscale_Callback(~, ~, ~, varargin)
SPCDrawingMenu.Logscale();


function lifetime_map_Callback(~, ~, ~, varargin)
SPCDrawingMenu.LifetimeRange();


function show_all_Callback(~, ~, ~, varargin)
SPCDrawingMenu.ShowAll();


function redraw_all_Callback(~, ~, ~, varargin)
SPCDrawingMenu.RedrawAll();

%% ================================================================================================================










%% ANALYSIS MENU ==================================================================================================
%

function analysis_Callback(~, ~, ~, varargin)

function smoothing_Callback(~, ~, ~, varargin)
%% ANALYSIS -> SMOOTHING ------------------------------------------------------------------------------------------
%
spc_smooth();


function binning_Callback(~, ~, ~, varargin)
%% ANALYSIS -> BINNING --------------------------------------------------------------------------------------------
%
spc_binning();


function spc_averageMultipleImages_Callback(~, ~, ~)
%% ANALYSIS -> AVERAGE MULTIPLE IMAGES ----------------------------------------------------------------------------
%
spc_averageMultipleImages();


function Frames_Callback(~, ~, ~)
%% ANALYSIS -> FRAMES ... -----------------------------------------------------------------------------------------
%


function fastAnalysis_Callback(~, ~, ~)
%% ANALYSIS -> FRAMES -> FRAME CALCROIS ---------------------------------------------------------------------------
%
spc_calc_timeCourseFromStack();


function frameCurrentAnal_Callback(~, ~, ~)
%% ANALYSIS -> FRAMES -> FRAME CALCROIS (CURRENT FRAME) -----------------------------------------------------------
%
global gui;

slicesS = get(gui.spc.spc_main.spc_page, 'String');
slices = str2num(slicesS);
spc_calc_timeCourseFromStack(slices);
set(gui.spc.spc_main.spc_page, 'String', slicesS);
spc_redrawSetting(1);
spc_updateMainStrings();

%% ================================================================================================================

% --------------------------------------------------------------------
function openall_Callback(~, ~, ~, varargin)
spc_updateMainStrings;

% --------------------------------------------------------------------
function spc_loadPrf_Callback(~, ~, ~, varargin)
global spc;
[fname,pname] = uigetfile('*.mat','Select mat-file');
if exist([pname, fname], 'file') == 2
    load ([pname,fname], 'prf');
end
spc.fit.prf = prf;

% --------------------------------------------------------------------
function spc_savePrf_Callback(~, ~, ~, varargin)
global spc;
[fname,pname] = uiputfile('*.mat','Select the mat-file');
filestr = [pname, fname];
prf = spc.fit.prf;
save(filestr, 'prf');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fitting menu
% --------------------------------------------------------------------
function spc_fitting_Callback(~, ~, ~, varargin)
% --------------------------------------------------------------------
function spc_exps_Callback(~, ~, handles, varargin)
global spc;
range = spc.fit.range;
lifetime = spc.lifetime(range(1):1:range(2));
x = 1:1:length(lifetime);
beta0 = [max(lifetime), sum(lifetime)/max(lifetime)];
betahat = spc_nlinfit(x, lifetime, sqrt(lifetime)/sqrt(max(lifetime)), @expfit, beta0);
tau = betahat(2)*spc.datainfo.psPerUnit/1000;
set(handles.beta1, 'String', num2str(betahat(1)));
set(handles.beta2, 'String', num2str(tau));
set(handles.beta3, 'String', '0');
set(handles.beta4, 'String', '0');
set(handles.beta5, 'String', '0');
set(handles.pop1, 'String', '100');
set(handles.pop2, 'String', '0');
set(handles.average, 'String', num2str(tau));

%Drawing
fit = expfit(betahat, x);
t = range(1):1:range(2);
t = t*spc.datainfo.psPerUnit/1000;
spc_drawfit(t, fit, lifetime, betahat);


function y=expfit(beta0, x)
y=exp(-x/beta0(2))*beta0(1);

% --------------------------------------------------------------------
function spc_expgauss_Callback(~, ~, ~, varargin)
spc_fitexpgauss();
spc_redrawSetting(1);
% --------------------------------------------------------------------
function spc_exp2gauss_Callback(~, ~, ~, varargin)
spc_fitexp2gauss();
spc_redrawSetting(1);

% --------------------------------------------------------------------
function expgauss_triple_Callback(~, ~, ~, varargin)
spc_fitWithSingleExp_triple();

% --------------------------------------------------------------------
function Double_expgauss_triple_Callback(~, ~, ~, varargin)
spc_fitWithDoubleExp_triple();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Drawing menu
% --------------------------------------------------------------------

% --------------------------------------------------------------------


% --------------------------------------------------------------------

% --------------------------------------------------------------------

% --------------------------------------------------------------------


% --------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Analysis menu
% --------------------------------------------------------------------

% --------------------------------------------------------------------

% --------------------------------------------------------------------


% --------------------------------------------------------------------
function smooth_all_Callback(~, ~, ~, varargin)
spc_smoothAll();

% --------------------------------------------------------------------
function binning_all_Callback(~, ~, ~, varargin)
spc_binningAll();

% --------------------------------------------------------------------
function undoall_Callback(~, ~, ~, varargin)
spc_undoAll();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function spc_fit1_Callback(~, ~, ~, varargin)
spc_fitexpgauss();
spc_redrawSetting(1);

% --------------------------------------------------------------------
function spc_fit2_Callback(~, ~, ~, varargin)
spc_fitexp2gauss();
spc_redrawSetting(1);

% --------------------------------------------------------------------
function spc_look_Callback(~, ~, ~, varargin)
global spc gui;
range = spc.fit(gui.spc.proChannel).range;
lifetime = spc.lifetime(range(1):1:range(2));
x = 1:1:length(lifetime);
beta0 = spc_initialValue_double();

%Drawing
fit = exp2gauss(beta0, x);
t = range(1):1:range(2);
t = t*spc.datainfo.psPerUnit/1000;

%Drawing
spc_drawfit(t, fit, lifetime, gui.spc.proChannel);
figure(gui.spc.figure.project);
figure(gui.spc.figure.lifetime);
figure(gui.spc.figure.lifetimeMap);
figure(gui.spc.figure.scanImgF);
spc_dispbeta();

% --------------------------------------------------------------------
function spc_redraw_Callback(~, ~, ~, varargin)
global gui;

spc_redrawSetting(1);
figure(gui.spc.figure.project);
figure(gui.spc.figure.lifetime);
figure(gui.spc.figure.lifetimeMap);
figure(gui.spc.figure.scanImgF);
set(gui.spc.spc_main.spc_main, 'color',  [1, 1, 0.75]);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Beta windows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function beta1_Callback(h, ~, ~, varargin)
global spc gui;
val1 = str2double(get(h, 'String'));
spc.fit(gui.spc.proChannel).beta0(1) = val1;
spc_dispbeta();

% --------------------------------------------------------------------
function beta2_Callback(h, ~, ~, varargin)
global spc gui;
val1 = str2double(get(h, 'String'));
spc.fit(gui.spc.proChannel).beta0(2) = val1*1000/spc.datainfo.psPerUnit;
spc_dispbeta();

% --------------------------------------------------------------------
function beta3_Callback(h, ~, ~, varargin)
global spc gui;
val1 = str2double(get(h, 'String'));
spc.fit(gui.spc.proChannel).beta0(3) = val1;
spc_dispbeta();

% --------------------------------------------------------------------
function beta4_Callback(h, ~, ~, varargin)
global spc gui;
val1 = str2double(get(h, 'String'));
spc.fit(gui.spc.proChannel).beta0(4) = val1*1000/spc.datainfo.psPerUnit;
spc_dispbeta();

% --------------------------------------------------------------------
function beta5_Callback(h, ~, ~, varargin)
global spc gui;
val1 = str2double(get(h, 'String'));
spc.fit(gui.spc.proChannel).beta0(5) = val1*1000/spc.datainfo.psPerUnit;
spc_dispbeta();

% --------------------------------------------------------------------
function beta6_Callback(~, ~, ~)
global spc gui;
val1 = str2double(get(h, 'String'));
spc.fit(gui.spc.proChannel).beta0(6) = val1*1000/spc.datainfo.psPerUnit;
spc_dispbeta();

% --------------------------------------------------------------------
function spc_fitstart_Callback(~, ~, ~, varargin)
spc_redrawSetting(1);

% --------------------------------------------------------------------
function spc_fitend_Callback(~, ~, ~, varargin)
% --------------------------------------------------------------------
spc_redrawSetting(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Spc, page control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function spc_page_Callback(~, ~, ~, varargin)
global spc gui;

current = spc.page;
spc.page = str2num(get(gui.spc.spc_main.spc_page, 'String'));

if any(spc.page > length(spc.stack.image1))
    spc.page = current;
end
if any(spc.page < 1)
    spc.page = current;
end
spc.switches.currentPage = spc.page;

spc_redrawSetting(1);
set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_updateMainStrings();



% --------------------------------------------------------------------
function slider1_Callback(~, ~, handles, varargin)
global spc gui;

current = spc.page;
slider_value = get(handles.slider1, 'Value');
page = round(slider_value);


if page > spc.stack.nStack
    page = spc.stack.nStack;
end
if page < 1
    page = 1;
end
if page < min(spc.page)
    page = min(spc.page);
end
spc.page = min(current):page;
spc.switches.currentPage = spc.page;
set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_redrawSetting(1);

spc_updateMainStrings();

%
% --- Executes on slider movement.
function minSlider_Callback(~, ~, handles)
global spc gui;

current = spc.page;
slider_value = get(handles.minSlider, 'Value');
page = round(slider_value);


if page > spc.stack.nStack
    page = spc.stack.nStack;
end
if page > max(spc.page)
    page = max(spc.page);
end
if page < 1
    page = 1;
end
spc.page = page:max(current);
spc.switches.currentPage = spc.page;
set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_redrawSetting(1);


spc_updateMainStrings();


% --- Executes during object creation, after setting all properties.
function minSlider_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --------------------------------------------------------------------
function spcN_Callback(~, ~, handles, varargin)
spcN = str2num(get(handles.spcN, 'String'));
spc_changeCurrent(spcN);
spc_updateMainStrings();

% --------------------------------------------------------------------
function slider2_Callback(~, ~, handles, varargin)
slider_value = get(handles.slider2, 'Value');
spcN = slider_value*100+1;

spc_changeCurrent(spcN);
spc_updateMainStrings();


% --------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Utilities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fixtau1_Callback(h, ~, ~, varargin)
global spc gui;
spc.fit(gui.spc.proChannel).fixtau(2) = get(h, 'Value');

function fixtau2_Callback(h, ~, ~, varargin)
global spc gui;
spc.fit(gui.spc.proChannel).fixtau(4) = get(h, 'Value');

% --- Executes on button press in fix_g.
function fix_g_Callback(hObject, ~, ~)
global spc gui;
spc.fit(gui.spc.proChannel).fixtau(5) = get(hObject, 'Value');

% --- Executes on button press in fix_delta.
function fix_delta_Callback(hObject, ~, ~)
global spc gui;
spc.fit(gui.spc.proChannel).fixtau(6) = get(hObject, 'Value');

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(~, ~, ~)
spc_auto(1);





% --- Executes during object creation, after setting all properties.
function beta6_CreateFcn(hObject, ~, ~)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(~, ~, ~)


% --- Executes on button press in spc_opennext. Open the next file.
function spc_opennext_Callback(~, ~, ~)
spc_opennext();


% --- Executes on button press in spc_openprevious. Open the Previous file.
function spc_openprevious_Callback(~, ~, ~)
spc_openprevious();


% --------------------------------------------------------------------
function Roi_Callback(~, ~, ~)

% --------------------------------------------------------------------
function Roi0_Callback(~, ~, ~)
spc_makeRoiA(0);
% --------------------------------------------------------------------
function Roi1_Callback(~, ~, ~)
spc_makeRoiA(1);
% --------------------------------------------------------------------
function Roi2_Callback(~, ~, ~)
spc_makeRoiA(2);
% --------------------------------------------------------------------
function Roi3_Callback(~, ~, ~)
spc_makeRoiA(3);


% --------------------------------------------------------------------
function Roi4_Callback(~, ~, ~)
spc_makeRoiA(4);

% --------------------------------------------------------------------
function Roi5_Callback(~, ~, ~)
spc_makeRoiA(5);

% --------------------------------------------------------------------
function RoiMore_Callback(~, ~, ~)
prompt = 'Roi Number:';
dlg_title = 'Roi';
num_lines= 1;
def     = {'6'};
answer  = inputdlg(prompt,dlg_title,num_lines,def);

spc_makeRoiA(str2double(answer{1}));

% --------------------------------------------------------------------
function asRoi_Callback(~, ~, ~)
prompt = 'Roi Number:';
dlg_title = 'Roi';
num_lines= 1;
def     = {'1'};
answer  = inputdlg(prompt,dlg_title,num_lines,def);

spc_makeRoiB(str2double(answer{1}));



function File_N_Callback(~, ~, handles)
global spc;
[filepath, basename, ~, max] = spc_AnalyzeFilename(spc.filename);
fileN = get(handles.File_N, 'String');
next_filenumber_str = '000';
next_filenumber_str ((end+1-length(fileN)):end) = num2str(fileN);
if max == 0
    next_filename = [filepath, basename, next_filenumber_str, '.tif'];
else
    next_filename = [filepath, basename, next_filenumber_str, '_max.tif'];
end
if exist(next_filename, 'file')
    spc_openCurves(next_filename);
else
    disp([next_filename, ' not exist!']);
end
spc_updateMainStrings();

% --- Executes during object creation, after setting all properties.
function File_N_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(~, ~, ~)

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in auto_A.
function auto_A_Callback(~, ~, ~)

spc_adjustTauOffset();

function F_offset_Callback(~, ~, ~)

spc_redrawSetting(1);

% --- Executes during object creation, after setting all properties.
function F_offset_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function fit_single_prf_Callback(~, ~, ~)
global spc;

if ~isfield(spc.fit, 'prf')
    spc_prfdefault();
end
if length(spc.fit.prf) ~= spc.lifetime
    spc_prfdefault();
end

spc_fitWithSingleExp();
spc_dispbeta();

% --------------------------------------------------------------------
function fit_double_prf_Callback(~, ~, ~)
global spc;

if ~isfield(spc.fit, 'prf')
    spc_prfdefault();
end
if length(spc.fit.prf) ~= spc.lifetime
    spc_prfdefault();
end

spc_fitWithDoubleExp();
spc_dispbeta();


% --- Executes on button press in fit_eachtime.
function fit_eachtime_Callback(~, ~, ~)


% --- Executes on button press in calcRoi.
function calcRoi_Callback(~, ~, ~)
spc_calcRoi();


% --------------------------------------------------------------------
function RecRoi_Callback(~, ~, ~)
spc_recoverRois();


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over spc_opennext.
function spc_opennext_ButtonDownFcn(~, ~, ~)


% --------------------------------------------------------------------
function Untitled_1_Callback(~, ~, ~)


% --------------------------------------------------------------------
function s_profile_Callback(~, ~, ~)
global gui;
figure(gui.spc.figure.project);

spc_makepolyLines();

% --------------------------------------------------------------------
function polylines_Callback(~, ~, ~)
global spc;
fn = spc.filename;
fn = [fn, '_ROI2'];
spc_DendriteAnalysis(fn);


% --------------------------------------------------------------------


function calcRoiTo_CreateFcn(~, ~, ~)

function calcRoiFrom_CreateFcn(~, ~, ~)

% --- Executes on button press in calcRoiBatch.
function calcRoiBatch_Callback(~, ~, handles)
fromVal = str2double(get(handles.calcRoiFrom, 'String'));
toVal = str2double(get(handles.calcRoiTo, 'String'));
for i = fromVal : toVal
    spc_openCurves(i);
    pause(0.05);
    if ~isempty(findobj('Tag', 'RoiA0'))
        spc_calcRoi();
    end
    spc_auto(1);
end


% --- Executes on button press in tauCheck.
function tauCheck_Callback(~, ~, ~)

% --- Executes on button press in fracCheck.
function fracCheck_Callback(~, ~, ~)


% --- Executes on button press in redCheck.
function redCheck_Callback(~, ~, ~)


% --- Executes on button press in greenCheck.
function greenCheck_Callback(~, ~, ~)


% --- Executes on button press in RatioCheck.
function RatioCheck_Callback(~, ~, ~)


% --- Executes on button press in Ch1.
function Ch1_Callback(~, ~, ~)

global gui
gui.spc.proChannel = 1;
spc_switchChannel();



% --- Executes on button press in Ch2.
function Ch2_Callback(~, ~, ~)

global gui;
gui.spc.proChannel = 2;
spc_switchChannel();

% --- Executes on button press in Ch3.
function Ch3_Callback(~, ~, ~)

global gui;
gui.spc.proChannel = 3;
spc_switchChannel;


% --------------------------------------------------------------------



% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, ~, ~)
global spc gui;

spc.switches.maxAve = get(hObject, 'value');
set(gui.spc.figure.redAuto, 'Value', 1);
spc_redrawSetting(1);


% --- Executes on button press in onePageRight.
function onePageRight_Callback(~, ~, ~)
global spc gui;

if length(spc.page) == spc.stack.nStack
    spc.page = 1;
else
    spc.page = sort(spc.page+1);
end

if spc.page(end) > spc.stack.nStack
    if length(spc.page) > 1
        spc.page = spc.page(1:end-1);
    else
        spc.page =spc.stack.nStack;
    end
end

set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_redrawSetting(1);

spc_updateMainStrings();

% --- Executes on button press in onePageLeft.
function onePageLeft_Callback(~, ~, ~)
global spc gui;

if length(spc.page) == spc.stack.nStack
    spc.page = 1;
else
    spc.page = sort(spc.page-1);
end

if spc.page(1) < 1
    if length(spc.page) > 1
        for i=1:length(spc.page)-1
            spc.page(i) = spc.page(i+1);
        end
        
        spc.page = spc.page(1:end-1);
    else
        spc.page = 1;
    end
end


set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_redrawSetting(1);

spc_updateMainStrings();


% --- Executes on button press in tenPageLeft.
function tenPageLeft_Callback(~, ~, ~)
global spc gui;

if length(spc.page) == spc.stack.nStack
    spc.page = 1;
else
    spc.page = sort(spc.page-10);
end

if spc.page(1) < 1
    if length(spc.page) > 1
        for i=1:length(spc.page)-1
            spc.page(i) = spc.page(i+1);
        end
        
        spc.page = spc.page(1:end-1);
    else
        spc.page = 1;
    end
end


set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_redrawSetting(1);

spc_updateMainStrings();

% --- Executes on button press in tenPageRight.
function tenPageRight_Callback(~, ~, ~)
global spc gui;

if length(spc.page) == spc.stack.nStack
    spc.page = 1;
else
    spc.page = sort(spc.page+10);
end


if spc.page(end) > spc.stack.nStack
    if length(spc.page) > 1
        spc.page = spc.page(1:end-1);
    else
        spc.page =spc.stack.nStack;
    end
end

set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_redrawSetting(1);

spc_updateMainStrings();


% --------------------------------------------------------------------
function alignFrames_Callback(~, ~, ~)
global gui;

slicesS = get(gui.spc.spc_main.spc_page, 'String');
spc_alignFrames();
set(gui.spc.spc_main.spc_page, 'String', slicesS);
spc_redrawSetting(1);
spc_updateMainStrings;

% --------------------------------------------------------------------





% --------------------------------------------------------------------



% --------------------------------------------------------------------
function TFilter_Callback(~, ~, ~)
spc_filterFrames();


% --------------------------------------------------------------------
function UT_average_Callback(~, ~, ~)
spc_frames_uncagingTAverage();



function beta7_Callback(~, ~, ~)


% --- Executes during object creation, after setting all properties.
function beta7_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in estimate_bg.
function estimate_bg_Callback(~, ~, ~)
spc_estimate_bg();


% --- Executes on button press in Saved.
function Saved_Callback(~, ~, ~)

%#ok<*DEFNU>
