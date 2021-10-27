function varargout = spc_main(varargin)
%% SPC_MAIN ENTRY POINT ===========================================================================================
%

% SPC_MAIN Application M-file for spc_main.fig
%    FIG = SPC_MAIN launch spc_main GUI.
%    SPC_MAIN('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 27-Oct-2021 13:06:43
global gui;

if nargin == 0  % LAUNCH GUI
	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    gui.spc.spc_main = handles;
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
    end
    
    SPCMainPanel.Initialize(handles);
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
	try
		if nargout
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
    catch err
        errMsg = sprintf('Caught the following exception:\n%s', getReport(err, 'extended', 'hyperlinks', 'off'));
        warning(errMsg);
    end
end
%% ================================================================================================================










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
SPCAnalysisMenu.Smoothing();


function binning_Callback(~, ~, ~, varargin)
SPCAnalysisMenu.Binning();


function spc_averageMultipleImages_Callback(~, ~, ~)
SPCAnalysisMenu.AverageMultipleImages();


function Frames_Callback(~, ~, ~)

function fastAnalysis_Callback(~, ~, ~)
SPCAnalysisMenu.FrameCalcRois();


function frameCurrentAnal_Callback(~, ~, ~)
SPCAnalysisMenu.FrameCalcRoisCurrentFrame();


function alignFrames_Callback(~, ~, ~)
SPCAnalysisMenu.AlignFrames();


function TFilter_Callback(~, ~, ~)
SPCAnalysisMenu.TemporalFilter();


function UT_average_Callback(~, ~, ~)
SPCAnalysisMenu.UncagingTriggeredAverage();

%% ================================================================================================================










%% ROI MENU =======================================================================================================
%

function Roi_Callback(~, ~, ~)


function Roi0_Callback(~, ~, ~)
SPCRoiMenu.RoiBackground();


function Roi1_Callback(~, ~, ~)
SPCRoiMenu.Roi1();


function Roi2_Callback(~, ~, ~)
SPCRoiMenu.Roi2();


function Roi3_Callback(~, ~, ~)
SPCRoiMenu.Roi3();


function Roi4_Callback(~, ~, ~)
SPCRoiMenu.Roi4();


function Roi5_Callback(~, ~, ~)
SPCRoiMenu.Roi5();


function RoiMore_Callback(~, ~, ~)
SPCRoiMenu.RoiMore();


function RecRoi_Callback(~, ~, ~)
SPCRoiMenu.RecoverRoi();


function asRoi_Callback(~, ~, ~)
SPCRoiMenu.ArbitraryShapedRoi();

%% ================================================================================================================










%% POLYLINE MENU ==================================================================================================
%

function Untitled_1_Callback(~, ~, ~)


function s_profile_Callback(~, ~, ~)
SPCPolylineMenu.MakeSpatialProfile();


function polylines_Callback(~, ~, ~)
SPCPolylineMenu.Polylines();

%% ================================================================================================================










%% MAIN PANEL =====================================================================================================
%

function File_N_Callback(~, ~, handles)
SPCMainPanel.ImageNumber(handles);


function spc_openprevious_Callback(~, ~, ~)
SPCMainPanel.OpenPrevImage();


function spc_opennext_Callback(~, ~, ~)
SPCMainPanel.OpenNextImage();


function calcRoi_Callback(~, ~, ~)
SPCMainPanel.CalcRois();


function calcRoiBatch_Callback(~, ~, handles)
SPCMainPanel.CalcRoisBatch(handles);


function Ch1_Callback(~, ~, ~)
SPCMainPanel.Channel1();


function Ch2_Callback(~, ~, ~)
SPCMainPanel.Channel2();


function Ch3_Callback(~, ~, ~)
SPCMainPanel.Channel3();


function spc_page_Callback(~, ~, ~, varargin)
SPCMainPanel.Slices();


function minSlider_Callback(~, ~, handles)
SPCMainPanel.SlicesFrom(handles);


function slider1_Callback(~, ~, handles, varargin)
SPCMainPanel.SlicesTo(handles);


function radiobutton4_Callback(hObject, ~, ~)
SPCMainPanel.AverageProjection(hObject);


function onePageLeft_Callback(~, ~, ~)
SPCMainPanel.OnePageLeft();


function tenPageLeft_Callback(~, ~, ~)
SPCMainPanel.TenPagesLeft();


function onePageRight_Callback(~, ~, ~)
SPCMainPanel.OnePageRight();


function tenPageRight_Callback(~, ~, ~)
SPCMainPanel.TenPagesRight();

%% ================================================================================================================










%% FITTING PANEL ==================================================================================================
%

function spc_fit1_Callback(~, ~, ~, varargin)
SPCFittingPanel.FitWithSingle();


function spc_fit2_Callback(~, ~, ~, varargin)
SPCFittingPanel.FitWithDouble();


function spc_look_Callback(~, ~, ~, varargin)
SPCFittingPanel.PlotCurrent();


function pushbutton14_Callback(~, ~, ~)
SPCFittingPanel.Timecourse();


function spc_redraw_Callback(~, ~, ~, varargin)
SPCFittingPanel.RedrawLifetime();


function beta1_Callback(hObject, ~, ~, varargin)
SPCFittingPanel.Population1(hObject);


function beta3_Callback(hObject, ~, ~, varargin)
SPCFittingPanel.Population2(hObject);


function beta2_Callback(hObject, ~, ~, varargin)
SPCFittingPanel.Tau1(hObject);


function fixtau1_Callback(hObject, ~, ~, varargin)
SPCFittingPanel.FixTau1(hObject);


function beta4_Callback(hObject, ~, ~, varargin)
SPCFittingPanel.Tau2(hObject);


function fixtau2_Callback(hObject, ~, ~, varargin)
SPCFittingPanel.FixTau2(hObject);


function beta5_Callback(hObject, ~, ~, varargin)
SPCFittingPanel.DeltaPeakTime(hObject);


function fix_delta_Callback(hObject, ~, ~)
SPCFittingPanel.FixDeltaPeakTime(hObject);


function beta6_Callback(hObject, ~, ~)
SPCFittingPanel.GaussianWidth(hObject);


function fix_g_Callback(hObject, ~, ~)
SPCFittingPanel.FixGaussianWidth(hObject);


function estimate_bg_Callback(~, ~, ~)
SPCFittingPanel.EstimateBackground();


function spc_fitstart_Callback(~, ~, ~, varargin)
SPCFittingPanel.FitStart();


function spc_fitend_Callback(~, ~, ~, varargin)
SPCFittingPanel.FitEnd();


function F_offset_Callback(~, ~, ~)
SPCFittingPanel.FigureOffset();


function auto_A_Callback(~, ~, ~)
SPCFittingPanel.AutoFigureOffset();


function checkUseSpcFit_Callback(~, ~, ~)

%% ================================================================================================================


%#ok<*DEFNU>


% --- Executes on button press in fit_eachtime.
function fit_eachtime_Callback(hObject, eventdata, handles)
global gui;
gui.spc.spc_main.new_old = get(handles.fit_eachtime, 'Value');
% hObject    handle to fit_eachtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit_eachtime
