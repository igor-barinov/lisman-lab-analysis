%% --------------------------------------------------------------------
% 'stats_IB_080420'
%
function varargout = stats_IB_080420(varargin)
% STATS_IB_080420 MATLAB code for stats_IB_080420.fig
%      STATS_IB_080420, by itself, creates a new STATS_IB_080420 or raises the existing
%      singleton*.
%
%      H = STATS_IB_080420 returns the handle to a new STATS_IB_080420 or the handle to
%      the existing singleton*.
%
%      STATS_IB_080420('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATS_IB_080420.M with the given input arguments.
%
%      STATS_IB_080420('Property','Value',...) creates a new STATS_IB_080420 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stats_IB_080420_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stats_IB_080420_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stats_IB_080420

% Last Modified by GUIDE v2.5 04-Aug-2020 13:36:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stats_IB_080420_OpeningFcn, ...
                   'gui_OutputFcn',  @stats_IB_080420_OutputFcn, ...
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
% --- Executes just before stats_IB_080420 is made visible.
function stats_IB_080420_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stats_IB_080420 (see VARARGIN)

% Choose default command line output for stats_IB_080420
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set_sample_data(handles, SampleTable());

% --- Outputs from this function are returned to the command line.
function varargout = stats_IB_080420_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% --------------------------------------------------------------------
% Callback Declarations
%
function menuFile_Callback(~, ~, ~)
function menuSample_Callback(~, ~, ~)
function menuStats_Callback(~, ~, ~)

%% ----------------------------------------------------------------------------------------------------------------
% 'logdlg' Method
%
function logdlg(lastErr)
% Try making/adding to log
try
    scriptFilePath = which('stats_IB_080420');
    [path, ~, ~] = fileparts(scriptFilePath);
    logFile = 'stats_IB_080420_LOG.txt';
    filepath = fullfile(path, logFile);

    errordlg(['An error occured. See log at ', filepath]);
    IOUtils.log_error(lastErr, filepath);
catch
    errordlg('Could not log error. See console for details');
    error(getReport(lastErr));
end


%% --------------------------------------------------------------------
% 'set_open_files' Method
%
function set_open_files(handles, openFileObj)
setappdata(handles.('mainFig'), 'OPEN_FILE_OBJ', openFileObj);


%% --------------------------------------------------------------------
% 'get_open_files' Method
%
function [openFileObj] = get_open_files(handles)
openFileObj = getappdata(handles.('mainFig'), 'OPEN_FILE_OBJ');


%% --------------------------------------------------------------------
% 'set_roi_data' Method
%
function set_roi_data(handles, roiData)
setappdata(handles.('mainFig'), 'ROI_DATA', roiData);


%% --------------------------------------------------------------------
% 'get_roi_data' Method
%
function [roiData] = get_roi_data(handles)
roiData = getappdata(handles.('mainFig'), 'ROI_DATA');


%% --------------------------------------------------------------------
% 'set_sample_data' Method
%
function set_sample_data(handles, sampleData)
setappdata(handles.('mainFig'), 'SAMPLE_DATA', sampleData);


%% --------------------------------------------------------------------
% 'get_sample_data' Method
%
function [sampleData] = get_sample_data(handles)
sampleData = getappdata(handles.('mainFig'), 'SAMPLE_DATA');

%% --------------------------------------------------------------------
% 'set_file_table_selection' Method
%
function set_file_table_selection(handles, selection)
setappdata(handles.('mainFig'), 'FILE_TABLE_SELECTION', selection);


%% --------------------------------------------------------------------
% 'get_file_table_selection' Method
%
function [selection] = get_file_table_selection(handles)
selection = getappdata(handles.('mainFig'), 'FILE_TABLE_SELECTION');


%% --------------------------------------------------------------------
% 'update_file_table' Method
%
function update_file_table(handles)
% Get program state
tableData = get_roi_data(handles);

% Clear table if necessary
if isempty(tableData)
    set(handles.('fileTable'), 'Data', []);
    set(handles.('fileTable'), 'ColumnName', {});
    return;
end

% Get ROI values
time = tableData.time();
lifetime = tableData.lifetime();
int = tableData.green();
red = tableData.red();

% Set new values
set(handles.('fileTable'), 'Data', [time, lifetime, int, red]);
set(handles.('fileTable'), 'ColumnName', tableData.roi_labels());


%% --------------------------------------------------------------------
% 'update_sample_tables' Method
%
function update_sample_tables(handles)
% Get program state
sampleData = get_sample_data(handles);

% Clear table if necessary
if sampleData.is_empty()
    set(handles.('sampleTable'), 'Data', []);
    set(handles.('sampleTable'), 'ColumnName', {});

    set(handles.('sampleLUT'), 'Data', []);
    set(handles.('sampleLUT'), 'RowName', {});
    return;
end

set(handles.('sampleTable'), 'Data', sampleData.all_samples());
set(handles.('sampleTable'), 'ColumnName', sampleData.sample_labels());

set(handles.('sampleLUT'), 'Data', sampleData.all_info());
set(handles.('sampleLUT'), 'RowName', sampleData.sample_labels());


%% --------------------------------------------------------------------
% 'fileTable' Cell Selection Callback
%
function fileTable_CellSelectionCallback(hObject, eventdata, ~)
try
    handles = guidata(hObject);
    set_file_table_selection(handles, eventdata.Indices);
catch err
    logdlg(err);
end


%% --------------------------------------------------------------------
% 'File -> Open' Callback
%
function menuOpen_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    
    % Let user choose files
    fileFilter = {'*.mat', 'MATLAB ROI Files (*.mat)'; ...
                  '*.csv', 'FLIMage ROI Files (*.csv)'};
    
    [file, path] = uigetfile(fileFilter, 'Multiselect', 'on');
    if isequal(file, 0) || isequal(path, 0)
        return;
    end
    
    % Store all paths in a cell
    filepaths = fullfile(path, file);
    if ~iscell(filepaths)
        filepaths = { filepaths };
    end
    
    % Get the file type    
    if PreparedFile.follows_format(filepaths)
        % Let user choose between prepared and raw data
        dataChoice = questdlg('This file has raw and prepared ROI data. Which would you like to load?', ...
                              'Select ROI Data', ...
                              'Raw', 'Prepared', 'Cancel', ...
                              'Cancel');
                          
        switch dataChoice
            case 'Raw'
                openFile = RawFile(filepaths);
            case 'Prepared'
                openFile = PreparedFile(filepaths);
            otherwise
                return;
        end
        
    elseif FLIMageFile.follows_format(filepaths)
        openFile = FLIMageFile(filepaths);
        
    elseif RawFile.follows_format(filepaths)
        openFile = RawFile(filepaths);
        
    else
        % Unsupported file
        warndlg('The files selected are not supported');
        return;
    end
    
    % Get adjusted time if possible
    if openFile.has_exp_info()
        allSolutions = openFile.solution_info();
        solutionInfo = ROIUtils.combine_solution_info(allSolutions);
        if ROIUtils.has_number_of_baseline_pts(solutionInfo)
            nBaselinePts = ROIUtils.number_of_baseline_pts(solutionInfo);
            time = openFile.adjusted_time(nBaselinePts);
        else
            time = openFile.time();
        end
    else
        time = openFile.time();
    end
    
    % Get ROI data
    lifetime = openFile.lifetime();
    int = openFile.green();
    red = openFile.red();
    
    roiData = ROITable(time, lifetime, int, red);
    
    % Update program state
    set_open_files(handles, openFile);
    set_roi_data(handles, roiData);
    
    % Update tables
    update_file_table(handles);
catch err
    logdlg(err);
end


%% --------------------------------------------------------------------
% 'Sample -> Selection' Callback
%
function menuSampleSelection_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    openFile = get_open_files(handles);
    roiData = get_roi_data(handles);
    sampleData = get_sample_data(handles);
    dataSelection = get_file_table_selection(handles);
    
    % Check if a selection was made
    if isempty(dataSelection)
        warndlg('Please select values to sample');
        return;
    end
    
    % Get only selected values
    [lifetime, ltROIs] = roiData.select_lifetime(dataSelection);
    [int, intROIs] = roiData.select_green(dataSelection);
    [red, redROIs] = roiData.select_red(dataSelection);
    
    % Get samples
    ltSample = reshape(lifetime, numel(lifetime), 1);
    intSample = reshape(int, numel(int), 1);
    redSample = reshape(red, numel(red), 1);
    
    
    % Get sample info
    srcFiles = openFile.experiment_names();
    startPt = min(dataSelection(:, 1));
    endPt = max(dataSelection(:, 1));
    
    % Add sample data
    if any(ltROIs)
        sampleData = sampleData.add_sample(ltSample, 'Tau', startPt, endPt, find(ltROIs), srcFiles');
    end
    if any(intROIs)
        sampleData = sampleData.add_sample(intSample, 'Int', startPt, endPt, find(intROIs), srcFiles');
    end
    if any(redROIs)
        sampleData = sampleData.add_sample(redSample, 'Red', startPt, endPt, find(redROIs), srcFiles');
    end
    
    % Update program state
    set_sample_data(handles, sampleData);
    
    % Update tables
    update_sample_tables(handles);
    
    
catch err
    logdlg(err);
end

%% --------------------------------------------------------------------
% 'Sample -> Time Range' Callback
%
function menuSampleRange_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    openFile = get_open_files(handles);
    roiData = get_roi_data(handles);
    sampleData = get_sample_data(handles);
    
    % Let user choose time range
    prompt = {'First data point:', 'Last data point:'};
    userInput = inputdlg(prompt, 'Select Time Range', [1 50]);
    if isempty(userInput)
        return;
    end
    
    % Validate user input
    startPt = str2double(userInput{1});
    endPt = str2double(userInput{2});
    
    if isnan(startPt) || isnan(endPt)
        warndlg('Please enter numeric values');
        return;
    end
    
    if endPt < startPt
        warndlg('Please enter data points in order');
        return;
    end
    
    maxPoint = max(roiData.point_counts());
    if startPt < 1 || startPt > maxPoint
        warndlg(['The first data point must be from 1 to ', num2str(maxPoint)]); 
        return;
    end
    if endPt < 1 || endPt > maxPoint
        warndlg(['The last data point must be from 1 to ', num2str(maxPoint)]); 
        return;
    end
    
    % Get only selected ROI values
    lifetime = roiData.lifetime();
    int = roiData.green();
    red = roiData.red();
    
    lifetime = lifetime(startPt:endPt, :);
    int = int(startPt:endPt, :);
    red = red(startPt:endPt, :);
    
    % Get samples
    ltSample = reshape(lifetime, numel(lifetime), 1);
    intSample = reshape(int, numel(int), 1);
    redSample = reshape(red, numel(red), 1);
    
    % Get sample info
    srcFiles = openFile.experiment_names();
    srcROIs = 1:roiData.roi_count();
    
    % Add samples
    sampleData = sampleData.add_sample(ltSample, 'Tau', startPt, endPt, srcROIs, srcFiles');
    sampleData = sampleData.add_sample(intSample, 'Int', startPt, endPt, srcROIs, srcFiles');
    sampleData = sampleData.add_sample(redSample, 'Red', startPt, endPt, srcROIs, srcFiles');
    
    % Update program state
    set_sample_data(handles, sampleData);
    
    % Update tables
    update_sample_tables(handles);
catch err
    logdlg(err);
end


%% --------------------------------------------------------------------
% 'Sample -> Clear' Callback
%
function menuClear_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    
    % Clear sample data
    set_sample_data(handles, SampleTable());
    
    % Update tables
    update_sample_tables(handles);
    
catch err
    logdlg(err)
end

%% --------------------------------------------------------------------
% 'Statistics -> M+SE' Callback
%
function menuMSE_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    sampleData = get_sample_data(handles);
    
    % Check if any samples exist
    if sampleData.is_empty()
        warndlg('Please add a sample first');
        return;
    end
    
    % Let user choose sample
    sampleList = sampleData.sample_labels();
    [sampleIdx, sampleWasChosen] = listdlg('ListString', sampleList, 'PromptString', 'Select a Sample:', 'SelectionMode', 'Single');
    if ~sampleWasChosen
        return;
    end
    
    % Get sample and calculate stats
    sampleSizes = sampleData.sample_sizes();
    sample = sampleData.at(sampleIdx);
    
    M = nanmean(sample);
    SE = nanstd(sample) / sqrt(sampleSizes(sampleIdx));
    
    % Display results
    resultLabels = {'Sample:', 'M:', 'SE:'};
    resultValues = { [sampleList{sampleIdx}, ', n=', num2str(sampleSizes(sampleIdx))], ...
                     sprintf('%g', ROIUtils.precision_format(M)), ...
                     sprintf('%g', ROIUtils.precision_format(SE)) };
                 
    inputdlg(resultLabels, 'M+SE', [1 50], resultValues);
catch err
    logdlg(err);
end



%% --------------------------------------------------------------------
% 'Statistics -> P-Value' Callback
%
function menuPValue_Callback(hObject, ~, ~)
try
    % Get program state
    handles = guidata(hObject);
    sampleData = get_sample_data(handles);
    
    % Check if any samples exist
    if sampleData.is_empty()
        warndlg('Please add at least 2 samples first');
        return;
    end
    
    % Let user choose 2 samples
    sampleList = sampleData.sample_labels();
    [sampleIndices, sampleWasChosen] = listdlg('ListString', sampleList, 'PromptString', 'Select 2 Samples:');
    if ~sampleWasChosen
        return;
    end
    
    % Check that only 2 samples were chosen
    if numel(sampleIndices) ~= 2
        warndlg('Please select only 2 samples');
        return;
    end
    
    % Get sample info
    sampleSizes = sampleData.sample_sizes();
    sampleA = sampleData.at(sampleIndices(1));
    sampleB = sampleData.at(sampleIndices(2));
    sizeA = sampleSizes(sampleIndices(1));
    sizeB = sampleSizes(sampleIndices(2));
    meanA = nanmean(sampleA);
    meanB = nanmean(sampleB);
    seA = nanstd(sampleA) / sqrt(sizeA);
    seB = nanstd(sampleB) / sqrt(sizeB);
    
    % Make sure samples are not empty (at least 3 valid points)
    if sizeA < 3
        warndlg(['Sample A, ''', sampleList{sampleIndices(1)}, ''' is empty or too small. At least 3 data points are required']);
        return;
    end
    if sizeB < 3
        warndlg(['Sample B, ''', sampleList{sampleIndices(2)}, ''' is empty or too small. At least 3 data points are required']);
        return;
    end
    
    % Check for normality
    %
    % h | normal?
    % 0 |  yes
    % 1 |  no
    swAlpha = 0.05;
    [hSW_A, pSW_A] = swtest(sampleA, swAlpha);
    [hSW_B, pSW_B] = swtest(sampleB, swAlpha);
    isParametric = (~hSW_A && ~hSW_B);
    
    % Calculate p-value
    %
    % h | Sign. Diff
    % 0 |    no
    % 1 |    yes
    testAlpha = 0.05;
    if isParametric
        [h, pValue] = ttest2(sampleA, sampleB, 'Alpha', testAlpha);
        testName = '2 Sample t-test, 2 tailed, Unequal Var.';
    else
        [pValue, h] = ranksum(sampleA, sampleB, 'Alpha', testAlpha);
        testName = 'Wilcoxon Rank Sum Test, 2 tailed';
    end
    
    
    % Display results
    if h
        testResult = ['p < ', num2str(testAlpha)];
        testDetails = sprintf('p (%s) < %g: [%g]', ...
                              testName, ...
                              ROIUtils.precision_format(testAlpha), ...
                              ROIUtils.precision_format(pValue));
        interpretation = sprintf(['H0: The difference of location between samples is 0\n', ...
                                  'Ha: The difference of location between samples is not 0\n', ...
                                  'With a p-value below the significance level, one should reject the null hypothesis']);
    else
        testResult = ['p > ', num2str(testAlpha)];
        testDetails = sprintf('p (%s) > %g: [%g]', ...
                              testName, ...
                              ROIUtils.precision_format(testAlpha), ...
                              ROIUtils.precision_format(pValue));
        interpretation = sprintf(['H0: The difference of location between samples is 0\n', ...
                                  'Ha: The difference of location between samples is not 0\n', ...
                                  'With a p-value above the significance level, one should fail to reject the null hypothesis']);
    end
    
    if hSW_A
        normResultA = sprintf('p (Shapiro-Wilk, Sample A) < %g: [%g]', ...
                              ROIUtils.precision_format(swAlpha), ...
                              ROIUtils.precision_format(pSW_A));
    else
        normResultA = sprintf('p (Shapiro-Wilk, Sample A) > %g: [%g]', ...
                              ROIUtils.precision_format(swAlpha), ...
                              ROIUtils.precision_format(pSW_A));
    end
    if hSW_B
        normResultB = sprintf('p (Shapiro-Wilk, Sample B) < %g: [%g]', ...
                              ROIUtils.precision_format(swAlpha), ...
                              ROIUtils.precision_format(pSW_B));
    else
        normResultB = sprintf('p (Shapiro-Wilk, Sample B) > %g: [%g]', ...
                              ROIUtils.precision_format(swAlpha), ...
                              ROIUtils.precision_format(pSW_B));
    end
    
    sampleLbls = sampleList(sampleIndices);
    
    sampleAInfo = sprintf('%s, n=%d, M=%g, SE=%g', sampleLbls{1}, sizeA, ROIUtils.precision_format(meanA), ROIUtils.precision_format(seA));
    sampleBInfo = sprintf('%s, n=%d, M=%g, SE=%g', sampleLbls{2}, sizeB, ROIUtils.precision_format(meanB), ROIUtils.precision_format(seB));
    
    resultLabels = {'Sample A:', 'Sample B:', 'Results:', 'Interpretation:', 'Details:'};
    resultValues = { sampleAInfo, ...
                     sampleBInfo, ...
                     testResult, ...
                     interpretation, ...
                     sprintf('%s\n%s\n%s', ...
                     testDetails, ...
                     normResultA, ...
                     normResultB) };
                 
    inputdlg(resultLabels, 'P-Value', [1 75; 1 75; 1 75; 3 75; 3 75], resultValues);
catch err
    logdlg(err);
end


   
    
%% --------------------------------------------------------------------
%#ok<*DEFNU>
%    ^^^^
% Ignores 'unused function' warnings
