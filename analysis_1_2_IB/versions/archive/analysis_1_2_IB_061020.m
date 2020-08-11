%% GUIDE Methods --------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% Entry Point - DO NOT EDIT
%
%      ANALYSIS_1_2_IB_061020, by itself, creates a new ANALYSIS_1_2_IB_061020 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_061020 returns the handle to a new ANALYSIS_1_2_IB_061020 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_061020('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_061020.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_061020('Property','Value',...) creates a new ANALYSIS_1_2_IB_061020 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_061020_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_061020_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
function varargout = analysis_1_2_IB_061020(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_061020_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_061020_OutputFcn, ...
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


%% ----------------------------------------------------------------------------------------------------------------
% Opening Method
%
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysis_1_2_IB_061020 (see VARARGIN)
%
function analysis_1_2_IB_061020_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for analysis_1_2_IB_061020
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
clear_global_vars();
update_ui(handles);


%% ----------------------------------------------------------------------------------------------------------------
% Output Method
%
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
function varargout = analysis_1_2_IB_061020_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure

varargout{1} = handles.output;


%% Utility Methods ------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'clear_global_vars' Method
%
% Pre-condition: None
% Post-condition: The following globals will all be empty ([]):
%   FILE_PATH
%   FILE_NAME
%   FILE_TYPE
%   CURRENT_ROI_DATA
%   ADJ_ROI_DATA
%   TABLE_SELECTION
%
function clear_global_vars()
global FILE_PATH; %string w/ full file path
global FILE_NAME; %string w/ file name
global FILE_TYPE; %string w/ file type (raw, prep, avg)    
global CURRENT_ROI_DATA; %matrix w/ data being displayed
global ADJ_ROI_DATA; %matrix w/ adjusted data
global TABLE_SELECTION; %indices of selected table cells
    FILE_PATH = [];
    FILE_NAME = [];
    FILE_TYPE = [];
    CURRENT_ROI_DATA = [];
    ADJ_ROI_DATA = [];
    TABLE_SELECTION = [];



    
    
%% App State Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'update_app_roi_data' Method
%
function update_app_roi_data(hAppFig, newROIData, newROIModifiers)
setappdata(hAppFig, 'ROI_DATA', newROIData);
setappdata(hAppFig, 'ROI_MODS', newROIModifiers);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_app_roi_data' Method
%
function [roiData, roiMods] = get_app_roi_data(hAppFig)
roiData = getappdata(hAppFig, 'ROI_DATA');
roiMods = getappdata(hAppFig, 'ROI_MODS');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_app_file_info' Method
%
function update_app_file_info(hAppFig, newFilePath, newFileName, newFileType)
setappdata(hAppFig, 'FILE_PATH', newFilePath);
setappdata(hAppFig, 'FILE_NAME', newFileName);
setappdata(hAppFig, 'FILE_TYPE', newFileType);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_app_file_info' Method
%
function [filePath, fileName, fileType] = get_app_file_info(hAppFig)
filePath = getappdata(hAppFig, 'FILE_PATH');
fileName = getappdata(hAppFig, 'FILE_NAME');
fileType = getappdata(hAppFig, 'FILE_TYPE');


%% ----------------------------------------------------------------------------------------------------------------
% 'update_app_exp_info' Method
%
function update_app_exp_info(hAppFig, newDNAType, newSolutions)
setappdata(hAppFig, 'DNA_TYPE', newDNAType);
setappdata(hAppFig, 'SOLUTIONS', newSolutions);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_app_exp_info' Method
%
function [dnaType, solutions] = get_app_exp_info(hAppFig)
dnaType = getappdata(hAppFig, 'DNA_TYPE');
solutions = getappdata(hAppFig, 'SOLUTIONS');




%% ROI Data Utiltity Methods --------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'get_roi_count' Method
%
function [count] = get_roi_count(roiData)
count = (size(roiData, 2) - 1) / 3;


%% ----------------------------------------------------------------------------------------------------------------
% 'get_time_values' Method
%
function [time] = get_time_values(roiData)
time = roiData(:,1);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_tau_values' Method
%
function [tau] = get_tau_values(roiData)
roiCount = get_roi_count(roiData);
tau = roiData(:, 2:roiCount+1);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_intensity_values' Method
%
function [int] = get_intensity_values(roiData)
roiCount = get_roi_count(roiData);
int = roiData(:, 2+roiCount:2*roiCount+1);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_red_values' Method
%
function [red] = get_red_values(roiData)
roiCount = get_roi_count(roiData);
red = roiData(:, 2+2*roiCount:3*roiCount+1);


%% ----------------------------------------------------------------------------------------------------------------
% 'normalize_values' Method
%
function [normVals] = normalize_values(values, nBasePts)
% k = # base pts / ( sum(data[1 -> baseline] )
factor = nBasePts / sum(values(1:nBasePts));
normVals = values * factor;


%% ----------------------------------------------------------------------------------------------------------------
% 'disable_values' Method
%
function [disabledVals] = disable_values(values)
disabledVals = NaN(size(values));


%% ----------------------------------------------------------------------------------------------------------------
% 'adjust_time_values' Method
%
function [adjustedTime] = adjust_time_values(time, nBasePts)
adjustedTime = time * 60 * 24;
adjustedTime = adjustedTime - adjustedTime(nBasePts);


%% ----------------------------------------------------------------------------------------------------------------
% 'add_row_above' Method
%
function [newROIData] = add_row_above(roiData, row)
newRow = zeros(1, size(roiData, 2));
newROIData = [roiData(1:row-1, :); newRow; roiData(row:end, :)];


%% ----------------------------------------------------------------------------------------------------------------
% 'add_row_below' Method
%
function [newROIData] = add_row_below(roiData, row)
newRow = zeros(1, size(roiData, 2));
newROIData = [roiData(1:row, :); newRow; roiData(row+1:end, :)];


%% ----------------------------------------------------------------------------------------------------------------
% 'remove_row' Method
%
function [newROIData] = remove_row(roiData, row, keepTime)
timeData = get_time_values(roiData);
if keepTime
    newTime = timeData(1:end-1);
else
    newTime = [timeData(1:row-1); timeData(row+1:end)];
end

newData = [roiData(1:row-1, 2:end); roiData(row+1:end, 2:end)];
newROIData = [newTime, newData];


%% ----------------------------------------------------------------------------------------------------------------
% 'fix_data' Method
%
function [fixedROIData] = fix_data(roiData)
% TODO
fixedROIData = roiData;



%% GUI Utiltity Methods -------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'set_ui_access' Method
%
function set_ui_access(handle, enabled, childrenEnabled)
if enabled
    set(handle, 'Enable', 'on');
else
    set(handle, 'Enable', 'off');
end

hChildren = findall(handle, '-property', 'Enable');
if childrenEnabled
    set(hChildren, 'Enable', 'on');
else
    set(hChildren, 'Enable', 'off');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'ui_is_enabled' Method
%
function [tf] = ui_is_enabled(handle)
try
    enableState = get(handle, 'Enable');
    tf = strcmp(enableState, 'on');
catch
    tf = false;
end


%% ----------------------------------------------------------------------------------------------------------------
% 'ui_is_toggled' Method
%
function [tf] = ui_is_toggled(handle)
try
    enableState = get(handle, 'Checked');
    tf = strcmp(enableState, 'on');
catch
    tf = false;
end


%% ----------------------------------------------------------------------------------------------------------------
% 'update_ui_access' Method
%
function update_ui_access(handles, fileType)
switch fileType
    case ROIFileType.Raw
        % Enable everything
        set_ui_access(handles.mainFig, true, true);
        
    case ROIFileType.Prepared
        % Enable everything 
        set_ui_access(handles.mainFig, true, true);
        % Except time toggle
        set_ui_access(handles.btnToggleAdjustedTime, false, false);
        
    case ROIFileType.Averaged
        % Enable everything
        set_ui_access(handles.mainFig, true, true);
        % Except info inputs
        set_ui_access(handles.panelInfo, true, false);
        set_ui_access(handles.btnToggleNormVals, true, false);
        set_ui_access(handles.btnEnableROI, true, false);
        % And data editting
        set_ui_access(handles.menuFix, false, false);
        set_ui_access(handles.menuRow, false, false);
        
    otherwise
        % Disable everything 
        set_ui_access(handles.mainFig, true, false);
        % Except file open
        set_ui_access(handles.menuFile, true, false);
        set_ui_access(handles.menuOpen, true, true);
        % And tools
        set_ui_access(handles.menuTools, true, true);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'update_info_panel' Method
%
function update_info_panel(hDNAInput, hSolutionTable, newDNAType, newSolutions)
set(hDNAInput, 'String',  newDNAType);
set(hSolutionTable, 'Data', newSolutions);



%% ----------------------------------------------------------------------------------------------------------------
% 'update_roi_table' Method
%
function update_roi_table(makeEnabled, isAvg, roiData, nBasePts, roiMods)




%% File Utiltity Methods ------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'get_file_data' Method
%
function [roiData, dnaType, solutions] = get_file_data(filepath)


%% ----------------------------------------------------------------------------------------------------------------
% 'get_file_info' Method
%
function [filePath, fileName] = get_file_info(filepath)


%% ----------------------------------------------------------------------------------------------------------------
% 'save_file' Method
%
function save_file(roiData, dnaType, solutions)

    
%% ----------------------------------------------------------------------------------------------------------------
% 'update_ui' Method
%
% Pre-condition: FILE_TYPE is a char array
% Post-condition: The UI will change depending on FILE_TYPE
%
function update_ui(handles)
global FILE_TYPE;
global CURRENT_ROI_DATA;

if isempty(FILE_TYPE) % No data loaded
    set(findall(handles.mainFig, '-property', 'Enable'), 'Enable', 'off');
    set(handles.menuFile, 'Enable', 'on');
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.menuTools, 'Enable', 'on');
    set(findall(handles.menuTools, '-property', 'Enable'), 'Enable', 'on');
elseif strcmp(FILE_TYPE, 'avg')
    set(findall(handles.mainFig, '-property', 'Enable'), 'Enable', 'on');
    set(findall(handles.panelInfo, '-property', 'Enable'), 'Enable', 'off');
    
    set(handles.menuSave, 'Enable', 'off');
    set(handles.menuFix, 'Enable', 'off');
    set(handles.menuRow, 'Enable', 'off');
    set(handles.menuToggleROI, 'Enable', 'off');
    
    set(handles.menuPlotAll, 'Enable', 'off');
    set(handles.menuPlotSelected, 'Enable', 'off');
    set(handles.menuShowAnnots, 'Enable', 'off');
    
    set(handles.btnToggleAdjustedTime, 'Enable', 'off');
    set(handles.btnToggleNormVals, 'Enable', 'on');
    set(handles.menuToggleNormVals, 'Checked', 'on');
    
    numAvg = (size(CURRENT_ROI_DATA,2)-1) / 12;
    colLabels = {};
    for i = 1:numAvg
        colLabels = [colLabels, {strcat('tauAvg',num2str(i)),strcat('tauSte',num2str(i)),strcat('tauNormAvg',num2str(i)),strcat('tauNormSte',num2str(i));strcat('intAvg',num2str(i)),strcat('intSte',num2str(i)),strcat('intNormAvg',num2str(i)),strcat('intNormSte',num2str(i));strcat('redAvg',num2str(i)),strcat('redSte',num2str(i)),strcat('redNormAvg',num2str(i)),strcat('redNormSte',num2str(i))}];
    end
    colLabels = {'time', colLabels{1,:}, colLabels{2,:}, colLabels{3,:}};
    set(handles.dataTable, 'ColumnName', colLabels);
else
    %% Enable all controls
    set(findall(handles.mainFig, '-property', 'Enable'), 'Enable', 'on');
    %% Temporarily disable adjtime + normvals
    set(handles.btnToggleAdjustedTime, 'Value', 0);
    set(handles.menuToggleNormVals, 'Checked', 'off');
    %% Re-enable adjtime if file is prepared
    if strcmp(FILE_TYPE, 'prep')
        set(handles.btnToggleAdjustedTime, 'Enable', 'off');
    else
        set(handles.btnToggleAdjustedTime, 'Enable', 'on');
    end
    
    %% Update 'Toggle ROI' controls w/ new number of ROIs + Update table's column labels
    numROI = (size(CURRENT_ROI_DATA, 2) - 1) / 3;
    delete(allchild(handles.menuToggleROI));
    uimenu(handles.menuToggleROI, 'Label', 'Enable Selected', 'Callback', {@menuEnableSelectedROI_Callback, handles});
    colLabels = {};
    for i = 1:numROI
        uimenu(handles.menuToggleROI, 'Label', strcat('ROI',num2str(i)), 'Callback', {@toggleROI_Callback, {i, handles}}, 'Checked', 'on');
        colLabels = [colLabels, {strcat('tau',num2str(i));strcat('int',num2str(i));strcat('red',num2str(i))}];
    end
    colLabels = {'time', colLabels{1,:}, colLabels{2,:}, colLabels{3,:}};
   set(handles.dataTable, 'ColumnName', colLabels);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'update_current_data' Method
%
% Pre-condition: 
% Post-condition: 
%
function update_current_data(handles)
global FILE_TYPE;
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;

%% Fill in enabled ROIs + normalize if necessary
if strcmp(FILE_TYPE, 'avg')
    vals = ADJ_ROI_DATA{1};
    %% Clear current data
    CURRENT_ROI_DATA = nan(size(vals));
    CURRENT_ROI_DATA(:, 1) = vals(:, 1);
    for i = 2:4:size(vals,2)
        if strcmp(get(handles.menuToggleNormVals, 'Checked'), 'on')
            CURRENT_ROI_DATA(:, i+2) = vals(:, i+2);
            CURRENT_ROI_DATA(:, i+3) = vals(:, i+3);
        else
            CURRENT_ROI_DATA(:, i) = vals(:, i);
            CURRENT_ROI_DATA(:, i+1) = vals(:, i+1);
        end
    end
else
    %% Clear current data
    CURRENT_ROI_DATA = nan(size(ADJ_ROI_DATA));
    %% Get # of base pts + toggle adjtime
    numBase = str2double(get(handles.inputNumBase,'String'));
    if get(handles.btnToggleAdjustedTime, 'Value') == 1
        time = ADJ_ROI_DATA(:, 1);
        time = (time) * 60 * 24;
        time = time - time(numBase);
        CURRENT_ROI_DATA(:, 1) = time;
    else
        CURRENT_ROI_DATA(:, 1) = ADJ_ROI_DATA(:, 1);
    end

    numROI = (size(ADJ_ROI_DATA,2)-1)/3;
    for i = 1:numROI
        if roi_is_enabled(i, handles)
            CURRENT_ROI_DATA(:, [1+i,1+numROI+i,1+2*numROI+i]) = ADJ_ROI_DATA(:, [1+i,1+numROI+i,1+2*numROI+i]);
            if strcmp(get(handles.menuToggleNormVals, 'Checked'), 'on')
                normalize_roi(i, numBase)
            end
        end
    end
end




%% ----------------------------------------------------------------------------------------------------------------
% 'roi_is_enabled' Method
%
% Pre-condition: 
% Post-condition: 
%
function [enabledROIs] = roi_is_enabled(roiIndices, handles)
indexCount = numel(roiIndices);

if ui_is_enabled(handles.menuToggleROI)
    enabledROIs = false(1, indexCount);
    for i = 1:length(roiIndices)
        menuLabel = ['ROI',num2str(roiIndices(i))];
        hToggleMenu = findall(allchild(handles.menuToggleROI),'Label',menuLabel);
        enabledROIs(i) = ui_is_toggled(hToggleMenu);
    end
else
    enabledROIs = true(1, indexCount);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'normalize_roi' Method
%
% Pre-condition: 
% Post-condition: 
%
function normalize_roi(roiIndices, numBase)
global CURRENT_ROI_DATA;

roiCount = numel(roiIndices);

%% Get coefficients for normaliztion based on # of base pts
numROI = (size(CURRENT_ROI_DATA,2)-1)/3;
tauCoef = (ones(1, roiCount) * numBase) ./ nansum(CURRENT_ROI_DATA(1:numBase, 1+roiIndices), 1);
intCoef = (ones(1, roiCount) * numBase) ./ nansum(CURRENT_ROI_DATA(1:numBase, 1+numROI+roiIndices), 1);
redCoef = (ones(1, roiCount) * numBase) ./ nansum(CURRENT_ROI_DATA(1:numBase, 1+2*numROI+roiIndices), 1);
%% Normalize data at given indices
CURRENT_ROI_DATA(:, 1+roiIndices) = CURRENT_ROI_DATA(:, 1+roiIndices).*repmat(tauCoef, size(CURRENT_ROI_DATA,1), 1);
CURRENT_ROI_DATA(:, 1+numROI+roiIndices) = CURRENT_ROI_DATA(:, 1+numROI+roiIndices).*repmat(intCoef, size(CURRENT_ROI_DATA,1), 1);
CURRENT_ROI_DATA(:, 1+2*numROI+roiIndices) = CURRENT_ROI_DATA(:, 1+2*numROI+roiIndices).*repmat(redCoef, size(CURRENT_ROI_DATA,1), 1);


%% ----------------------------------------------------------------------------------------------------------------
% 'get_exp_info' Method
%
% Pre-condition: 
% Post-condition: 
%
function [info] = get_exp_info(handles)
%% Compile experiment info based on UI entries
dnaType = get(handles.inputDNAType, 'String');
solutions = get(handles.solutionTable, 'Data');

if isempty(dnaType)
    warning('Attempted to get DNA type but there was no data');
end
if isempty(solutions)
    warning('Attempted to get solution info but there was no data');
end

info = struct('dnaType', dnaType, 'solutions', solutions);


%% ----------------------------------------------------------------------------------------------------------------
% 'update_exp_info' Method
%
% Pre-condition: 
% Post-condition: 
%
function update_exp_info(info, handles)
%{
if iscell(info) % Multiple info structs
    %% Init lists that will store unique entries
    uniqueDNA = {};
    uniqueSolBase = {};
    uniqueNumBase = {};
    uniqueSolutions = {};
    uniqueTimings = {};
    
    for i = 1:length(info)
        %% Get indices of current entry
        dnaExists = strfind(uniqueDNA, info{i}.dnaType);
        dnaIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), dnaExists, 'UniformOutput', false);
        dnaIdx = find([dnaIdx{:}]);
        if isempty(dnaIdx)
            %% Add entry if no indices found
            uniqueDNA{end+1} = strcat('|',info{i}.dnaType);
        end
        
        solBaseExists = strfind(uniqueSolBase, info{i}.solBase);
        solBaseIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), solBaseExists, 'UniformOutput', false);
        solBaseIdx = find([solBaseIdx{:}]);
        if isempty(solBaseIdx)
            uniqueSolBase{end+1} = strcat('|',info{i}.solBase);
        end
        
        
        
        solAExists = isfield(info, 'solA');
        if (solAExists)
            solAExists = strfind(uniqueSolA, info{i}.solA);
            solAIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), solAExists, 'UniformOutput', false);
            solAIdx = find([solAIdx{:}]);
            if isempty(solAIdx)
                uniqueSolA{end+1} = strcat('|',info{i}.solA);
            end
        end
        
        solBExists = isfield(info, 'solB');
        if (solBExists)
            solBExists = strfind(uniqueSolB, info{i}.solB);
            solBIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), solBExists, 'UniformOutput', false);
            solBIdx = find([solBIdx{:}]);
            if isempty(solBIdx)
                uniqueSolB{end+1} = strcat('|',info{i}.solB);
            end
        end
        
        solCExists = isfield(info, 'solC');
        if (solCExists)
            solCExists = strfind(uniqueSolC, info{i}.solC);
            solCIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), solCExists, 'UniformOutput', false);
            solCIdx = find([solCIdx{:}]);
            if isempty(solCIdx)
                uniqueSolC{end+1} = strcat('|',info{i}.solC);
            end
        end
        
        solDExists = isfield(info, 'solD');
        if (solDExists)
            solDExists = strfind(uniqueSolD, info{i}.solD);
            solDIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), solDExists, 'UniformOutput', false);
            solDIdx = find([solDIdx{:}]);
            if isempty(solDIdx)
                uniqueSolD{end+1} = strcat('|',info{i}.solD);
            end
        end
        
        numBaseExists = strfind(uniqueNumBase, num2str(info{i}.numBase));
        numBaseIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), numBaseExists, 'UniformOutput', false);
        numBaseIdx = find([numBaseIdx{:}]);
        if isempty(numBaseIdx)
            uniqueNumBase{end+1} = strcat('|',num2str(info{i}.numBase));
        end
        
        washStartExists = strfind(uniqueWashStart, num2str(info{i}.washStart));
        washStartIdx = cellfun(@(c)([zeros(isempty(c)), ones(~isempty(c))]), washStartExists, 'UniformOutput', false);
        washStartIdx = find([washStartIdx{:}]);
        if isempty(washStartIdx)
            uniqueWashStart{end+1} = strcat('|',num2str(info{i}.washStart));
        end
    end
    %% Update ui w/ unique entries
    set(handles.inputDNAType, 'String', [uniqueDNA{:}]);
    set(handles.inputSolBase, 'String', [uniqueSolBase{:}]);
    set(handles.inputSolA, 'String', [uniqueSolA{:}]);
    set(handles.inputSolB, 'String', [uniqueSolB{:}]);
    set(handles.inputSolC, 'String', [uniqueSolC{:}]);
    set(handles.inputSolD, 'String', [uniqueSolD{:}]);
    set(handles.inputNumBase, 'String', [uniqueNumBase{:}]);
    set(handles.inputWashStart, 'String', [uniqueWashStart{:}]);
%}
if iscell(info)
    dnaStr = '';
    numBaseStr = '';
    solBaseStr = '';
    solNames = {};
    solTiming = [];
    
    for i = 1:length(info)
        if (i == 1)
            padding = '';
        else
            padding = '; ';
        end
        
        dnaStr = strcat(dnaStr, padding, info{i}.dnaType);
        numBaseStr = strcat(numBaseStr, padding, num2str(info{i}.numBase));
        solBaseStr = strcat(solBaseStr, padding, info{i}.solBase);
        
        if (isfield(info{i}, 'solutions'))
            solNames = [solNames; info{i}.solutions(:, 1)];
            solTiming = [solTiming; info{i}.solutions(:, 2)];
        else
            solNames = [solNames; info{i}.solA; info{i}.solB];
            solTiming = [solTiming; info{i}.numBase; info{i}.washStart];
        end
    end
    
    set(handles.inputDNAType, 'String', dnaStr);
    set(handles.inputNumBase, 'String', numBaseStr);
    set(handles.inputSolBase, 'String', solBaseStr);
    
    [solTiming, indices] = sortrows(solTiming,1 );
    solNames = solNames(indices);
    solutions = [solNames, solTiming];
    set(handles.solutionTable, 'Data', solutions);
    
else % Single info struct
    %% Update ui w/ new entries
    set(handles.inputDNAType, 'String', info.dnaType);
    set(handles.inputNumBase, 'String', num2str(info.numBase));
    set(handles.inputSolBase, 'String', info.solBase);
    
    if (isfield(info, 'solutions'))
       set(handles.solutionTable, 'Data', info.solutions); 
    else
       solutions = cell(2, 2);
       solutions(:, 1) = {info.solA; info.solB};
       solutions(:, 2) = {info.numBase; info.washStart};
       set(handles.solutionTable, 'Data', solutions);
    end
end


%% ----------------------------------------------------------------------------------------------------------------
% 'plot_lt_results' Method
%
% Pre-condition: 
% Post-condition: 
%
function [hdl] = plot_lt_results(results)
    if iscell(results)
        titleStr = [];
        legendStr = {};
        annotYoffset = 0.0;
        [maxLen, idxMaxTime] = max(cell2mat(cellfun(@(c)(length(c.time)), results, 'UniformOutput', false)));
        maxTime = results{idxMaxTime}.time;
        markerFills = {[0 0 0], [1 1 1], [0 0 0], [1 1 1], [0 0 0], [1 1 1], [1 1 1]};
        markers='oovsd+d';
        for i = 1:length(results)
            if iscell(results{i}.filePath)
                [~, n, ~] = fileparts(results{i}.filePath{1});
            else
                [~, n, ~] = fileparts(results{i}.filePath);
            end
            titleStr = [titleStr, '|', n];
            legendStr{end+1} = strcat(results{i}.dnaType, ',n=', num2str(results{i}.numROI));
            marker=markers(mod(i,length(markers))+length(markers)*(mod(i,length(markers))==0));
            markerFill = markerFills{mod(i,length(markerFills)) + length(markerFills)*(mod(i,length(markerFills))==0)};
            errorbar(results{i}.time, results{i}.averages.tauAvg, results{i}.averages.tauSte, [marker,'-'], 'MarkerFaceColor', markerFill, 'color', 'k', 'linewidth', 2); hold on;
            xlim = [maxTime(1), maxTime(end)];
            ylim = [1.8 2.6];
            %set(gca, 'xlim', xlim);
            %set(gca, 'ylim', ylim);
            plot_annotations(gca, results{i}, 0, annotYoffset);
            %{
            axpos = get(gca, 'position');   
            axlim = get(gca, 'xlim');
            x0 = axpos(1);
            x1 = ((results{i}.time(results{i}.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
            x2 = ((results{i}.time(results{i}.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
            x3 = axpos(3) + axpos(1);
            y = 0.9 + annotYoffset;
            y1 = 0.97 + annotYoffset;
            annotation('line', [x1 x2], [y y], 'linewidth', 4);
            annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
            %annotation('textbox', [0 y x0 y1-y], 'String', results{i}.dnaType, 'linestyle', 'none');
            annotation('textbox', [x0 y x1-x0 y1-y], 'String', results{i}.solBase, 'linestyle', 'none');
            annotation('textbox', [x1 y x2-x1 y1-y], 'String', results{i}.solA, 'linestyle', 'none');
            annotation('textbox', [x2 y x3-x2 y1-y], 'String', results{i}.solB, 'linestyle', 'none');
            %}
            annotYoffset = annotYoffset - 0.05;
        end
        legend(legendStr);
        
        xlabel('Time (min)');
        ylabel('Mean Lifetime');
        msgStyle = struct;
        msgStyle.Interpreter = 'tex';
        msgStyle.WindowStyle = 'replace';
        msgbox(strcat('\fontsize{12}',titleStr), 'Files Being Averaged', msgStyle);
    else
        titleStr = [];
        errorbar(results.time, results.averages.tauAvg, results.averages.tauSte, 'o-', 'MarkerFaceColor', 'k', 'color', 'k', 'linewidth', 2); hold on;
        [~, n, ~] = fileparts(results.filePath);
        titleStr = [titleStr, '|', n];
        title(titleStr);
        legend(strcat(results.dnaType, ',n=', num2str(results.numROI)));
        xlabel('Time (min)');
        ylabel('Mean Lifetime');
        
        plot_annotations(gca, results, 0, 0);
        %{
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        axpos = get(gca, 'position');

        x0 = axpos(1);
        x1 = ((results.time(results.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x2 = ((results.time(results.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x3 = axpos(3) + axpos(1);
        y = 0.9;
        y1 = 0.97;
        annotation('line', [x1 x2], [y y], 'linewidth', 4);
        annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
        annotation('textbox', [x0 y x1-x0 y1-y], 'String', results.solBase, 'linestyle', 'none');
        annotation('textbox', [x1 y x2-x1 y1-y], 'String', results.solA, 'linestyle', 'none');
        annotation('textbox', [x2 y x3-x2 y1-y], 'String', results.solB, 'linestyle', 'none');
        %}
    end
    
    hdl = gca;
    
    
%% ----------------------------------------------------------------------------------------------------------------
% 'plot_int_results' Method
%
% Pre-condition: 
% Post-condition: 
%
function [hdl] = plot_int_results(results)
    if iscell(results)
        titleStr = [];
        legendStr = {};
        annotYoffset = 0;
        [maxLen, idxMaxTime] = max(cell2mat(cellfun(@(c)(length(c.time)), results, 'UniformOutput', false)));
        maxTime = results{idxMaxTime}.time;
        markerFills = {[0 0 0], [1 1 1], [0 0 0], [1 1 1], [0 0 0], [1 1 1], [1 1 1]};
        markers='oovsd+d';
        for i = 1:length(results)
            if iscell(results{i}.filePath)
                [~, n, ~] = fileparts(results{i}.filePath{1});
            else
                [~, n, ~] = fileparts(results{i}.filePath);
            end
            titleStr = [titleStr, '|', n];
            legendStr{end+1} = strcat(results{i}.dnaType, ',n=', num2str(results{i}.numROI));
            marker=markers(mod(i,length(markers))+length(markers)*(mod(i,length(markers))==0));
            markerFill = markerFills{mod(i,length(markerFills)) + length(markerFills)*(mod(i,length(markerFills))==0)};
            errorbar(results{i}.time, results{i}.averages.intAvg, results{i}.averages.intSte, [marker,'-'], 'MarkerFaceColor', markerFill, 'color', 'k', 'linewidth', 2); hold on;
            xlim = [maxTime(1), maxTime(end)];
            ylim = [1.8 2.6];
            %set(gca, 'xlim', xlim);
            %set(gca, 'ylim', ylim);
            plot_annotations(gca, results{i}, 0, annotYoffset);
            %{
            axpos = get(gca, 'position');

            x0 = axpos(1);
            x1 = ((results{i}.time(results{i}.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
            x2 = ((results{i}.time(results{i}.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
            x3 = axpos(3) + axpos(1);
            y = 0.9 + annotYoffset;
            y1 = 0.97 + annotYoffset;
            annotation('line', [x1 x2], [y y], 'linewidth', 4);
            annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
            annotation('textbox', [0 y x0 y1-y], 'String', results{i}.dnaType, 'linestyle', 'none');
            annotation('textbox', [x0 y x1-x0 y1-y], 'String', results{i}.solBase, 'linestyle', 'none');
            annotation('textbox', [x1 y x2-x1 y1-y], 'String', results{i}.solA, 'linestyle', 'none');
            annotation('textbox', [x2 y x3-x2 y1-y], 'String', results{i}.solB, 'linestyle', 'none');
            
            %}
            annotYoffset = annotYoffset - 0.05;
        end
        legend(legendStr);
        legend('boxoff');
        
        xlabel('Time (min)');
        ylabel('Mean Intenisty');
        
        msgStyle = struct;
        msgStyle.Interpreter = 'tex';
        msgStyle.WindowStyle = 'replace';
        msgbox(strcat('\fontsize{12}',titleStr), 'Files Being Averaged', msgStyle);
    else
        titleStr = [];
        errorbar(results.time, results.averages.intAvg, results.averages.intSte, 'o-', 'MarkerFaceColor', 'k', 'color', 'k', 'linewidth', 2); hold on;
        [~, n, ~] = fileparts(results.filePath);
        titleStr = [titleStr, '|', n];
        title(titleStr);
        legend(strcat(results.dnaType, ',n=', num2str(results.numROI)));
        xlabel('Time (min)');
        ylabel('Mean Intensity');
        plot_annotations(gca, results, 0, 0);

        %{
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        axpos = get(gca, 'position');

        x0 = axpos(1);
        x1 = ((results.time(results.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x2 = ((results.time(results.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x3 = axpos(3) + axpos(1);
        y = 0.9;
        y1 = 0.97;
        annotation('line', [x1 x2], [y y], 'linewidth', 4);
        annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
        annotation('textbox', [x0 y x1-x0 y1-y], 'String', results.solBase, 'linestyle', 'none');
        annotation('textbox', [x1 y x2-x1 y1-y], 'String', results.solA, 'linestyle', 'none');
        annotation('textbox', [x2 y x3-x2 y1-y], 'String', results.solB, 'linestyle', 'none');
        %}
    end
    
    hdl = gca;

    
    
%% ----------------------------------------------------------------------------------------------------------------
% 'plot_red_results' Method
%
% Pre-condition: 
% Post-condition: 
%
function [hdl] = plot_red_results(results)
    if iscell(results)
        legendStr = {};
        titleStr = [];
        annotYoffset = 0;
        [maxLen, idxMaxTime] = max(cell2mat(cellfun(@(c)(length(c.time)), results, 'UniformOutput', false)));
        maxTime = results{idxMaxTime}.time;
        markerFills = {[0 0 0], [1 1 1], [0 0 0], [1 1 1], [0 0 0], [1 1 1], [1 1 1]};
        markers='oovsd+d';
        for i = 1:length(results)
            if iscell(results{i}.filePath)
                [~, n, ~] = fileparts(results{i}.filePath{1});
            else
                [~, n, ~] = fileparts(results{i}.filePath);
            end
            titleStr = [titleStr, '|', n];
            legendStr{end+1} = strcat(results{i}.dnaType, ',n=', num2str(results{i}.numROI));
            marker=markers(mod(i,length(markers))+length(markers)*(mod(i,length(markers))==0));
            markerFill = markerFills{mod(i,length(markerFills)) + length(markerFills)*(mod(i,length(markerFills))==0)};
            errorbar(results{i}.time, results{i}.averages.redAvg, results{i}.averages.redSte, [marker,'-'], 'MarkerFaceColor', markerFill, 'color', 'k', 'linewidth', 2); hold on;
            xlim = [maxTime(1), maxTime(end)];
            ylim = [1.8 2.6];
            %set(gca, 'xlim', xlim);
            %set(gca, 'ylim', ylim);
            plot_annotations(gca, results{i}, 0, annotYoffset);
            %{
            axpos = get(gca, 'position');

            x0 = axpos(1);
            x1 = ((results{i}.time(results{i}.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
            x2 = ((results{i}.time(results{i}.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
            x3 = axpos(3) + axpos(1);
            y = 0.9 + annotYoffset;
            y1 = 0.97 + annotYoffset;
            annotation('line', [x1 x2], [y y], 'linewidth', 4);
            annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
            annotation('textbox', [0 y x0 y1-y], 'String', results{i}.dnaType, 'linestyle', 'none');
            annotation('textbox', [x0 y x1-x0 y1-y], 'String', results{i}.solBase, 'linestyle', 'none');
            annotation('textbox', [x1 y x2-x1 y1-y], 'String', results{i}.solA, 'linestyle', 'none');
            annotation('textbox', [x2 y x3-x2 y1-y], 'String', results{i}.solB, 'linestyle', 'none');
            
            %}
            annotYoffset = annotYoffset - 0.05;
        end
        legend(legendStr);
        legend('boxoff');
        
        xlabel('Time (min)');
        ylabel('Mean Red Intensity');
        
        msgStyle = struct;
        msgStyle.Interpreter = 'tex';
        msgStyle.WindowStyle = 'replace';
        msgbox(strcat('\fontsize{12}',titleStr), 'Files Being Averaged', msgStyle);
        
    else
        titleStr = [];
        errorbar(results.time, results.averages.redAvg, results.averages.redSte, 'o-', 'MarkerFaceColor', 'k', 'color', 'k', 'linewidth', 2); hold on;
        [~, n, ~] = fileparts(results.filePath);
        titleStr = [titleStr, '|', n];
        title(titleStr);
        legend(strcat(results.dnaType, ',n=', num2str(results.numROI)));
        xlabel('Time (min)');
        ylabel('Mean Red Intensity');
        plot_annotations(gca, results, 0, 0);

        %{
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        axpos = get(gca, 'position');

        x0 = axpos(1);
        x1 = ((results.time(results.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x2 = ((results.time(results.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x3 = axpos(3) + axpos(1);
        y = 0.9;
        y1 = 0.97;
        annotation('line', [x1 x2], [y y], 'linewidth', 4);
        annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
        annotation('textbox', [x0 y x1-x0 y1-y], 'String', results.solBase, 'linestyle', 'none');
        annotation('textbox', [x1 y x2-x1 y1-y], 'String', results.solA, 'linestyle', 'none');
        annotation('textbox', [x2 y x3-x2 y1-y], 'String', results.solB, 'linestyle', 'none');
        %}
    end
    
    hdl = gca;
    
    
%% ----------------------------------------------------------------------------------------------------------------
% 'plot_notm_lt_results' Method
%
% Pre-condition: 
% Post-condition: 
%
function [hdl] = plot_norm_lt_results(results)
if iscell(results)
    titleStr = [];
    legendStr = {};
    annotYoffset = 0;
    [maxLen, idxMaxTime] = max(cell2mat(cellfun(@(c)(length(c.time)), results, 'UniformOutput', false)));
    maxTime = results{idxMaxTime}.time;
    markerFills = {[0 0 0], [1 1 1], [0 0 0], [1 1 1], [0 0 0], [1 1 1], [1 1 1]};
    markers='oovsd+d';
    for i = 1:length(results)
        if iscell(results{i}.filePath)
                [~, n, ~] = fileparts(results{i}.filePath{1});
            else
                [~, n, ~] = fileparts(results{i}.filePath);
            end
        titleStr = [titleStr, '|', n];
        legendStr{end+1} = strcat(results{i}.dnaType, ',n=', num2str(results{i}.numROI));
        marker=markers(mod(i,length(markers))+length(markers)*(mod(i,length(markers))==0));
        markerFill = markerFills{mod(i,length(markerFills)) + length(markerFills)*(mod(i,length(markerFills))==0)};
        errorbar(results{i}.time, results{i}.averages.tauNormAvg, results{i}.averages.tauNormSte, [marker,'-'], 'MarkerFaceColor', markerFill, 'color', 'k', 'linewidth', 2); hold on;
        xlim = [maxTime(1), maxTime(end)];
        ylim = [1.8 2.6];
        %set(gca, 'xlim', xlim);
        %set(gca, 'ylim', ylim);
        %axpos = get(gca, 'position');
        
        plot_annotations(gca, results{i}, 0, annotYoffset);
        
        %{

        x0 = axpos(1);
        x1 = ((results{i}.time(results{i}.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x2 = ((results{i}.time(results{i}.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x3 = axpos(3) + axpos(1);
        y = 0.9 + annotYoffset;
        y1 = 0.97 + annotYoffset;
        annotation('line', [x1 x2], [y y], 'linewidth', 4);
        annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
        annotation('textbox', [0 y x0 y1-y], 'String', results{i}.dnaType, 'linestyle', 'none');
        annotation('textbox', [x0 y x1-x0 y1-y], 'String', results{i}.solBase, 'linestyle', 'none');
        annotation('textbox', [x1 y x2-x1 y1-y], 'String', results{i}.solA, 'linestyle', 'none');
        annotation('textbox', [x2 y x3-x2 y1-y], 'String', results{i}.solB, 'linestyle', 'none');
        set(gca, 'xlim', xlim);
        set(gca, 'ylim', ylim);
        
        %}
        
        annotYoffset = annotYoffset - 0.05;
    end
    legend(legendStr);
    legend('boxoff');

    xlabel('Time (min)');
    ylabel('Mean Norm Lifetime');
    
    msgStyle = struct;
    msgStyle.Interpreter = 'tex';
    msgStyle.WindowStyle = 'replace';
    msgbox(strcat('\fontsize{12}',titleStr), 'Files Being Averaged', msgStyle);
else
    titleStr = [];
    errorbar(results.time, results.averages.tauNormAvg, results.averages.tauNormSte, 'o-', 'MarkerFaceColor', 'k', 'color', 'k', 'linewidth', 2); hold on;
    if (iscell(results.filePath))
        titleStr = results.filePath{0};
    else
        [~, titleStr, ~] = fileparts(results.filePath);
    end
    title(titleStr);
    legend(strcat(results.dnaType, ',n=', num2str(results.numROI)));
    legend('boxoff');
    xlabel('Time (min)');
    ylabel('Mean Norm Lifetime');
    
    plot_annotations(gca, results, 0, 0);

    %{
    xlim = get(gca, 'xlim');
    ylim = get(gca, 'ylim');
    axpos = get(gca, 'position');

    x0 = axpos(1);
    x1 = ((results.time(results.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
    x2 = ((results.time(results.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
    x3 = axpos(3) + axpos(1);
    y = 0.9;
    y1 = 0.97;
    annotation('line', [x1 x2], [y y], 'linewidth', 4);
    annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
    annotation('textbox', [x0 y x1-x0 y1-y], 'String', results.solBase, 'linestyle', 'none');
    annotation('textbox', [x1 y x2-x1 y1-y], 'String', results.solA, 'linestyle', 'none');
    annotation('textbox', [x2 y x3-x2 y1-y], 'String', results.solB, 'linestyle', 'none');
    %}
end

hdl = gca;


%% ----------------------------------------------------------------------------------------------------------------
% 'plot_norm_int_results' Method
%
% Pre-condition: 
% Post-condition: 
%
function [hdl] = plot_norm_int_results(results)
if iscell(results)
    titleStr = [];
    legendStr = {};
    annotYoffset = 0;
    [maxLen, idxMaxTime] = max(cell2mat(cellfun(@(c)(length(c.time)), results, 'UniformOutput', false)));
    maxTime = results{idxMaxTime}.time;
    markerFills = {[0 0 0], [1 1 1], [0 0 0], [1 1 1], [0 0 0], [1 1 1], [1 1 1]};
    markers='oovsd+d';
    for i = 1:length(results)
        if iscell(results{i}.filePath)
                [~, n, ~] = fileparts(results{i}.filePath{1});
            else
                [~, n, ~] = fileparts(results{i}.filePath);
            end
        titleStr = [titleStr, '|', n];
        legendStr{end+1} = strcat(results{i}.dnaType, ',n=', num2str(results{i}.numROI));
        marker=markers(mod(i,length(markers))+length(markers)*(mod(i,length(markers))==0));
        markerFill = markerFills{mod(i,length(markerFills)) + length(markerFills)*(mod(i,length(markerFills))==0)};
        errorbar(results{i}.time, results{i}.averages.intNormAvg, results{i}.averages.intNormSte, [marker,'-'], 'MarkerFaceColor', markerFill, 'color', 'k', 'linewidth', 2); hold on;
        xlim = [maxTime(1), maxTime(end)];
        ylim = [1.8 2.6];
        %set(gca, 'xlim', xlim);
        %set(gca, 'ylim', ylim);
        plot_annotations(gca, results{i}, 0, annotYoffset);
        %{
        
        axpos = get(gca, 'position');

        x0 = axpos(1);
        x1 = ((results{i}.time(results{i}.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x2 = ((results{i}.time(results{i}.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x3 = axpos(3) + axpos(1);
        y = 0.9 + annotYoffset;
        y1 = 0.97 + annotYoffset;
        annotation('line', [x1 x2], [y y], 'linewidth', 4);
        annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
        annotation('textbox', [0 y x0 y1-y], 'String', results{i}.dnaType, 'linestyle', 'none');
        annotation('textbox', [x0 y x1-x0 y1-y], 'String', results{i}.solBase, 'linestyle', 'none');
        annotation('textbox', [x1 y x2-x1 y1-y], 'String', results{i}.solA, 'linestyle', 'none');
        annotation('textbox', [x2 y x3-x2 y1-y], 'String', results{i}.solB, 'linestyle', 'none');
        
        %}
        annotYoffset = annotYoffset - 0.05;
    end
    legend(legendStr);
    legend('boxoff');

    xlabel('Time (min)');
    ylabel('Mean Norm Int');
    
    msgStyle = struct;
    msgStyle.Interpreter = 'tex';
    msgStyle.WindowStyle = 'replace';
    msgbox(strcat('\fontsize{12}',titleStr), 'Files Being Averaged', msgStyle);
else
    titleStr = [];
    errorbar(results.time, results.averages.intNormAvg, results.averages.intNormSte, 'o-', 'MarkerFaceColor', 'k', 'color', 'k', 'linewidth', 2); hold on;
    [~, n, ~] = fileparts(results.filePath);
    titleStr = [titleStr, '|', n];
    title(titleStr);
    legend(strcat(results.dnaType, ',n=', num2str(results.numROI)));
    xlabel('Time (min)');
    ylabel('Mean Norm Int');

    plot_annotations(gca, results, 0, 0);
    %{
    xlim = get(gca, 'xlim');
    ylim = get(gca, 'ylim');
    axpos = get(gca, 'position');

    x0 = axpos(1);
    x1 = ((results.time(results.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
    x2 = ((results.time(results.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
    x3 = axpos(3) + axpos(1);
    y = 0.9;
    y1 = 0.97;
    annotation('line', [x1 x2], [y y], 'linewidth', 4);
    annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
    annotation('textbox', [x0 y x1-x0 y1-y], 'String', results.solBase, 'linestyle', 'none');
    annotation('textbox', [x1 y x2-x1 y1-y], 'String', results.solA, 'linestyle', 'none');
    annotation('textbox', [x2 y x3-x2 y1-y], 'String', results.solB, 'linestyle', 'none');
    %}
end

hdl = gca;


%% ----------------------------------------------------------------------------------------------------------------
% 'plot_norm_red_results' Method
%
% Pre-condition: 
% Post-condition: 
%
function [hdl] = plot_norm_red_results(results)
if iscell(results)
    titleStr = [];
    legendStr = {};
    annotYoffset = 0;
    [maxLen, idxMaxTime] = max(cell2mat(cellfun(@(c)(length(c.time)), results, 'UniformOutput', false)));
    maxTime = results{idxMaxTime}.time;
    markerFills = {[0 0 0], [1 1 1], [0 0 0], [1 1 1], [0 0 0], [1 1 1], [1 1 1]};
    markers='oovsd+d';
    for i = 1:length(results)
        if iscell(results{i}.filePath)
                [~, n, ~] = fileparts(results{i}.filePath{1});
            else
                [~, n, ~] = fileparts(results{i}.filePath);
            end
        titleStr = [titleStr, '|', n];
        legendStr{end+1} = strcat(results{i}.dnaType, ',n=', num2str(results{i}.numROI));
        marker=markers(mod(i,length(markers))+length(markers)*(mod(i,length(markers))==0));
        markerFill = markerFills{mod(i,length(markerFills)) + length(markerFills)*(mod(i,length(markerFills))==0)};
        errorbar(results{i}.time, results{i}.averages.redNormAvg, results{i}.averages.redNormSte, [marker,'-'], 'MarkerFaceColor', markerFill, 'color', 'k', 'linewidth', 2); hold on;
        xlim = [maxTime(1), maxTime(end)];
        ylim = [1.8 2.6];
        %set(gca, 'xlim', xlim);
        %set(gca, 'ylim', ylim);
        %axpos = get(gca, 'position');
        plot_annotations(gca, results{i}, 0, annotYoffset);
        %{
        x0 = axpos(1);
        x1 = ((results{i}.time(results{i}.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x2 = ((results{i}.time(results{i}.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
        x3 = axpos(3) + axpos(1);
        y = 0.9 + annotYoffset;
        y1 = 0.97 + annotYoffset;
        annotation('line', [x1 x2], [y y], 'linewidth', 4);
        annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
        annotation('textbox', [0 y x0 y1-y], 'String', results{i}.dnaType, 'linestyle', 'none');
        annotation('textbox', [x0 y x1-x0 y1-y], 'String', results{i}.solBase, 'linestyle', 'none');
        annotation('textbox', [x1 y x2-x1 y1-y], 'String', results{i}.solA, 'linestyle', 'none');
        annotation('textbox', [x2 y x3-x2 y1-y], 'String', results{i}.solB, 'linestyle', 'none');
        
        %}
        annotYoffset = annotYoffset - 0.05;
    end
    legend(legendStr);
    legend('boxoff');

    xlabel('Time (min)');
    ylabel('Mean Norm Red Int');
    
    msgStyle = struct;
    msgStyle.Interpreter = 'tex';
    msgStyle.WindowStyle = 'replace';
    msgbox(strcat('\fontsize{12}',titleStr), 'Files Being Averaged', msgStyle);
else
    titleStr = [];
    errorbar(results.time, results.averages.redNormAvg, results.averages.redNormSte, 'o-', 'MarkerFaceColor', 'k', 'color', 'k', 'linewidth', 2); hold on;
    [~, n, ~] = fileparts(results.filePath);
    titleStr = [titleStr, '|', n];
    title(titleStr);
    legend(strcat(results.dnaType, ',n=', num2str(results.numROI)));
    xlabel('Time (min)');
    ylabel('Mean Norm Red Int');
    
    plot_annotations(gca, results, 0, 0);

    %{
    xlim = get(gca, 'xlim');
    ylim = get(gca, 'ylim');
    axpos = get(gca, 'position');

    x0 = axpos(1);
    x1 = ((results.time(results.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
    x2 = ((results.time(results.washStart) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1);
    x3 = axpos(3) + axpos(1);
    y = 0.9;
    y1 = 0.97;
    annotation('line', [x1 x2], [y y], 'linewidth', 4);
    annotation('line', [x2 x3], [y y], 'linewidth', 4, 'linestyle', ':');
    annotation('textbox', [x0 y x1-x0 y1-y], 'String', results.solBase, 'linestyle', 'none');
    annotation('textbox', [x1 y x2-x1 y1-y], 'String', results.solA, 'linestyle', 'none');
    annotation('textbox', [x2 y x3-x2 y1-y], 'String', results.solB, 'linestyle', 'none');
    %}
end

hdl = gca;


%% ----------------------------------------------------------------------------------------------------------------
% 'plot_annotations' Method
%
% Pre-condition: 
% Post-condition: 
%
function plot_annotations(axis, results, xOffset, yOffset)
    xlim = get(axis, 'xlim');
    axpos = get(axis, 'position');
    try
        yBottom = 0.9+yOffset;
        yTop = 0.97+yOffset;
        xStart = axpos(1)+xOffset;
        xPrev = ((results.time(results.numBase) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1)+xOffset;
        annotation('line', [xStart xPrev], [yBottom yBottom], 'linewidth', 4, 'linestyle', ':');
        annotation('textbox', [xStart yBottom xPrev-xStart yTop-yBottom], 'String', results.solBase, 'linestyle', 'none');
        
        nextStyle = '-';
        for i = 2:size(results.solutions, 1)
            pt = results.solutions{i, 2};
            x = ((results.time(pt) - xlim(1)) / diff(xlim)) * axpos(3) + axpos(1)+xOffset;
            
            if (mod(i,2) == 0)
                annotation('line', [xPrev x], [yBottom yBottom], 'linewidth', 4, 'linestyle', nextStyle);
                nextStyle = ':';
            else
                annotation('line', [xPrev x], [yBottom yBottom], 'linewidth', 4, 'linestyle', nextStyle);
                nextStyle = '-';
            end
            
            annotation('textbox', [xPrev yBottom x-xPrev yTop-yBottom], 'String', results.solutions{i-1, 1}, 'linestyle', 'none');
            xPrev = x;
        end
        xEnd = axpos(3) + axpos(1)+xOffset;
        annotation('line', [xPrev xEnd], [yBottom yBottom], 'linewidth', 4, 'linestyle', nextStyle);
        annotation('textbox', [xPrev yBottom xEnd-xPrev yTop-yBottom], 'String', results.solutions{end, 1}, 'linestyle', 'none');
    catch
        warndlg('Not enough information to plot annotations', 'Annotation Error', 'replace');
    end

    
%% GUI Init Methods -----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------
function inputDNAType_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputSolBase_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function inputNumBase_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% File Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'menuOpen' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuOpen_Callback(~, ~, handles)
global FILE_PATH;
global FILE_NAME;
global FILE_TYPE;
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;


[fileCount, filePaths, fileData] = open_roi_file_dlg();
if fileCount > 0
    if fileCount > 1
        fileData = combine_roi_files(fileData);
        [filePath, fileNames] = multiple_fileparts(filePaths);
    end
    
    
    if is_raw_file_data(fileData)
        fileType = ROIFileType.Raw;
        expInfo = make_exp_info_struct();
    elseif is_prep_file_data(fileData)
        fileType = ROIFileType.Prepared;
    elseif is_avg_file_data(fileData)
        fileType = ROIFileType.Averaged;
    end
    update_app_file_info(filePath, fileNames, fileType);
    
    
    
    
end

[name, path] = uigetfile('*.mat', 'Multiselect', 'on');

if ~isequal(name, 0) && ~isequal(path, 0)    
    cd(path);
    filename = fullfile(path, name);
    
    if iscell(filename)
        % Allowed groups: prep files, averages files
        
        %%{
        expInfo = {};
        roiCounts = [];
        baselineData = [];
        % washoutData = [];
        timeData = {};
        tauData = {};
        intData = {};
        redData = {};        
        
        results = {};
        
        CURRENT_ROI_DATA = [];
        for i = 1:length(filename)
            currentFile = filename{i};
            load(currentFile);
            if exist('prepData', 'var')
                FILE_TYPE = 'prep';
                expInfo{end+1} = prepData;
                
                roiCounts = [roiCounts, prepData.numROI];
                baselineData = [baselineData, prepData.numBase];
                
                % washoutData = [washoutData, prepData.washStart];
                timeData{end+1} = prepData.alladj(:, 1);
                for j = 1:prepData.numROI
                    tauData{end+1} = prepData.alladj(:, 1+j);
                    intData{end+1} = prepData.alladj(:, 1+prepData.numROI+j);
                    redData{end+1} = prepData.alladj(:, 1+2*prepData.numROI+j);
                end
                
                CURRENT_ROI_DATA = append_roi_data(CURRENT_ROI_DATA, timeData{end}, tauData{end}, intData{end}, redData{end});
            elseif exist('averages', 'var')
                FILE_TYPE = 'avg';
                results{end+1} = load(currentFile);
            end
        end
        
        if strcmp(FILE_TYPE, 'prep')        
            %{
            [numBase, timeIdx] = max(baselineData);
            washStart = mode(washoutData);
            numExp = size(timeData, 2);
            adjTimeData = {};
            adjTauData = {};
            adjIntData = {};
            adjRedData = {};

            roiOffset = 0;
            for i = 1:numExp
                nExpROI = roiCounts(i);
                nExpBase = baselineData(i);
                startExpWash = washoutData(i);

                for j = 1:nExpROI
                    if nExpBase < numBase %earlier
                        adjTimeData = [adjTimeData, [nan(numBase - nExpBase, 1); timeData{i}]];
                        adjTauData = [adjTauData, [nan(numBase - nExpBase, 1); tauData{roiOffset+j}]];
                        adjIntData = [adjIntData, [nan(numBase - nExpBase, 1); intData{roiOffset+j}]];
                        adjRedData = [adjRedData, [nan(numBase - nExpBase, 1); redData{roiOffset+j}]];
                    else
                        adjTimeData = [adjTimeData, timeData{i}];
                        adjTauData = [adjTauData, tauData{roiOffset+j}];
                        adjIntData = [adjIntData, intData{roiOffset+j}];
                        adjRedData = [adjRedData, redData{roiOffset+j}];
                    end

                    if startExpWash < washStart %earlier
                        adjTimeData{end} = fix_roi_time([adjTimeData{end}(1:startExpWash); nan(washStart - startExpWash, 1); adjTimeData{end}(startExpWash+1:end)]);
                        adjTauData{end} = [adjTauData{end}(1:startExpWash); nan(washStart - startExpWash, 1); adjTauData{end}(startExpWash+1:end)];%fix_roi_values([adjTauData{end}(1:startExpWash); nan(washStart - startExpWash, 1); adjTauData{end}(startExpWash+1:end)]);
                        adjIntData{end} = [adjIntData{end}(1:startExpWash); nan(washStart - startExpWash, 1); adjIntData{end}(startExpWash+1:end)];%fix_roi_values([adjIntData{end}(1:startExpWash); nan(washStart - startExpWash, 1); adjIntData{end}(startExpWash+1:end)]);
                        adjRedData{end} = [adjRedData{end}(1:startExpWash); nan(washStart - startExpWash, 1); adjRedData{end}(startExpWash+1:end)];%fix_roi_values([adjRedData{end}(1:startExpWash); nan(washStart - startExpWash, 1); adjRedData{end}(startExpWash+1:end)]);
                    elseif startExpWash > washStart %later
                        adjTimeData{end} = adjTimeData{end}(1:end-(startExpWash-washStart));
                        adjTauData{end} = [adjTauData{end}(1:washStart); adjTauData{end}(startExpWash:end)];
                        adjIntData{end} = [adjIntData{end}(1:washStart); adjIntData{end}(startExpWash:end)];
                        adjRedData{end} = [adjRedData{end}(1:washStart); adjRedData{end}(startExpWash:end)];
                    end            
                end

                roiOffset = roiOffset + nExpROI;
            end

            [maxLen, idxMaxLen] = max(cellfun(@length, adjTimeData));
            padFun = @(v)([v(1:min(maxLen, length(v))); nan(maxLen-length(v),1)]);
            adjTimeData = adjTimeData{idxMaxLen};
            adjTauData = cell2mat(cellfun(padFun, adjTauData, 'UniformOutput', false));
            adjIntData = cell2mat(cellfun(padFun, adjIntData, 'UniformOutput', false));
            adjRedData = cell2mat(cellfun(padFun, adjRedData, 'UniformOutput', false));     
            %}

            FILE_PATH = filename;
            [~, FILE_NAME, ~] = fileparts(filename{1});
            %CURRENT_ROI_DATA = [adjTimeData, adjTauData, adjIntData, adjRedData];
            ADJ_ROI_DATA = CURRENT_ROI_DATA;
            
            
            update_exp_info(expInfo, handles);
            % set(handles.inputNumBase, 'String', num2str(numBase));
            % set(handles.inputWashStart, 'String', num2str(washStart));

            set(handles.mainFig, 'Name', strcat(fileName,'...','[',FILE_TYPE,']'));
            set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
            
            
        elseif strcmp(FILE_TYPE, 'avg')
            timeData = {};
            tauData = {};
            intData = {};
            redData = {};
            for i = 1:length(results)
                timeData{end+1} = results{i}.time;
                tauData{end+1} = [results{i}.averages.tauAvg, results{i}.averages.tauSte, results{i}.averages.tauNormAvg, results{i}.averages.tauNormSte];
                intData{end+1} = [results{i}.averages.intAvg, results{i}.averages.intSte, results{i}.averages.intNormAvg, results{i}.averages.intNormSte];
                redData{end+1} = [results{i}.averages.redAvg, results{i}.averages.redSte, results{i}.averages.redNormAvg, results{i}.averages.redNormSte];
            end
            
            [maxLen, idxMaxTime] = max(cellfun(@length, timeData));
            timeData = timeData{idxMaxTime};
            padFun = @(v)([v(1:min(maxLen, length(v)), :); nan(maxLen-size(v,1),size(v,2))]);
            tauData = cell2mat(cellfun(padFun, tauData, 'UniformOutput', false));
            intData = cell2mat(cellfun(padFun, intData, 'UniformOutput', false));
            redData = cell2mat(cellfun(padFun, redData, 'UniformOutput', false)); 
            
            FILE_PATH = filename;
            [~, FILE_NAME, ~] = fileparts(filename{1});
            CURRENT_ROI_DATA = [timeData, tauData, intData, redData];
            ADJ_ROI_DATA = {CURRENT_ROI_DATA, results};
            
            update_exp_info(results, handles);
            
            set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
        end
        %%}
    else
        % Single files: raw files, prep file, averages file
        
        load(filename);
        if exist('averages', 'var')
            FILE_PATH = filename;
            [~, FILE_NAME, ~] = fileparts(filename);
            FILE_TYPE = 'avg';
            
            results = load(filename);
            CURRENT_ROI_DATA = [results.time, results.averages.tauAvg, results.averages.tauSte, results.averages.tauNormAvg, results.averages.tauNormSte, results.averages.intAvg, results.averages.intSte, results.averages.intNormAvg, results.averages.intNormSte, results.averages.redAvg, results.averages.redSte, results.averages.redNormAvg, results.averages.redNormSte];
            ADJ_ROI_DATA = {CURRENT_ROI_DATA, results};
            
            update_exp_info(results, handles);
            set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
        elseif exist('prepData', 'var')
            choice = questdlg('Which data should be loaded?', 'Choose Data', 'Raw Data', 'Prepared Data', 'Prepared Data');
            if strcmp(choice, 'Raw Data')
                roiFileData = reformat_roi_file(filename, 'ROI');
                FILE_PATH = filename;
                [~, FILE_NAME, ~] = fileparts(filename);
                FILE_TYPE = 'raw';
                CURRENT_ROI_DATA = roiFileData.raw.all;
                ADJ_ROI_DATA = CURRENT_ROI_DATA;
            elseif strcmp(choice, 'Prepared Data')
                FILE_PATH = filename;
                [~, FILE_NAME, ~] = fileparts(filename);
                FILE_TYPE = 'prep';
                CURRENT_ROI_DATA = prepData.alladj;
                ADJ_ROI_DATA = CURRENT_ROI_DATA;
                update_exp_info(prepData, handles);
            end
            set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
            set(handles.mainFig, 'Name', strcat(FILE_NAME,'[', FILE_TYPE,']'));
        else
            formatStr = 'ROI2';
            idxFormat = strfind(filename, formatStr);

            if idxFormat            
                roiFileData = reformat_roi_file(filename, 'ROI');
                if isempty(roiFileData)
                    errordlg('This file is not a valid ROI file');
                    return;
                end

                FILE_PATH = filename;
                [~, FILE_NAME, ~] = fileparts(filename);
                FILE_TYPE = 'raw';
                CURRENT_ROI_DATA = roiFileData.raw.all;
                ADJ_ROI_DATA = CURRENT_ROI_DATA;

                set(handles.mainFig, 'Name', strcat(FILE_NAME,'[', FILE_TYPE,']'));
                set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
            end        
        end
    end
    
    
end
update_ui(handles);
update_current_data(handles);
set(handles.dataTable, 'Data', CURRENT_ROI_DATA);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuSave' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuSave_Callback(~, ~, handles)
global FILE_PATH;
global FILE_NAME;
global FILE_TYPE;
global ADJ_ROI_DATA;

if strcmp(FILE_TYPE, 'raw')
    numBase = str2double(get(handles.inputNumBase, 'String'));
    
    if isnan(numBase)
        warndlg('Please input the number of baseline points before saving');
        return;
    end
    
    load(FILE_PATH);
    formatStr = 'ROI2';
    idxFormat = strfind(FILE_NAME, formatStr);
    structName = FILE_NAME(1:idxFormat+length(formatStr)-1);
    
    numROI = (size(ADJ_ROI_DATA, 2) - 1) / 3;
    enabledROIs = roi_is_enabled(1:numROI, handles);
    
    if find(~enabledROIs)
        choice = questdlg('You have disabled some ROIs. Save all ROIs or leave out disabled ROIs?', 'Save/Prepare File', 'Save All', 'Save Enabled Only', 'Save Enabled Only');
        if strcmp(choice, 'Save All')
            enabledROIs = 1:numROI;
        elseif strcmp(choice, 'Save Enabled Only')
            enabledROIs = find(enabledROIs);
        else
            return;
        end
    else
        enabledROIs = find(enabledROIs);
    end
    
    prepData = struct;
    tauData = ADJ_ROI_DATA(:, 2:1+numROI);
    intData = ADJ_ROI_DATA(:, 2+numROI:1+2*numROI);
    redData = ADJ_ROI_DATA(:, 2+2*numROI:1+3*numROI);
    tauData = tauData(:, enabledROIs);
    intData = intData(:, enabledROIs);
    redData = redData(:, enabledROIs);

    
    time = ADJ_ROI_DATA(:, 1);
    time = ((time - time(1)) * 60 * 24);
    time = time - time(numBase);
    prepData.alladj = [time, tauData, intData, redData];    
    tmp = prepData.alladj(:, 2:end);
    tmp(tmp == 0) = nan;
    prepData.alladj(:, 2:end) = tmp;
    prepData.numROI = length(enabledROIs);
    
    prepData.numBase = numBase;
    prepData.dnaType = get(handles.inputDNAType, 'String');
    prepData.solBase = get(handles.inputSolBase, 'String');
    prepData.solutions = get(handles.solutionTable, 'Data');
        
    uisave({structName, 'prepData'}, strcat(FILE_NAME, 'PREP'));    
elseif strcmp(FILE_TYPE, 'prep')    
    numBase = str2double(get(handles.inputNumBase, 'String'));
    
    if isnan(numBase)
        warndlg('Input a single valid value for the number of baseline pts');
        return;
    end
    
    numROI = (size(ADJ_ROI_DATA, 2) - 1) / 3;
    enabledROIs = logical(roi_is_enabled(1:numROI, handles));
    if find(~enabledROIs)
        choice = questdlg('You have disabled some ROIs. Average all ROIs or leave out disabled ROIs?', 'Save Averages', 'Average All', 'Average Enabled Only', 'Average Enabled Only');
        if strcmp(choice, 'Average All')
            enabledROIs = 1:numROI;
        elseif strcmp(choice, 'Average Enabled Only')
            enabledROIs = find(enabledROIs);
        else
            return;
        end
    else
        enabledROIs = find(enabledROIs);
    end
    
    
    time = ADJ_ROI_DATA(:, 1);
    tauData = ADJ_ROI_DATA(:, 2:1+numROI);
    intData = ADJ_ROI_DATA(:, 2+numROI:1+2*numROI);
    redData = ADJ_ROI_DATA(:, 2+2*numROI:1+3*numROI);
    tauData = tauData(:, enabledROIs);
    intData = intData(:, enabledROIs);
    redData = redData(:, enabledROIs);
    
    tauNorm = tauData;
    intNorm = intData;
    redNorm = redData;
    
    for i = 1:length(enabledROIs)
        tauCoef = numBase / nansum(tauData(1:numBase, i));
        intCoef = numBase / nansum(intData(1:numBase, i));
        redCoef = numBase / nansum(redData(1:numBase, i));
        
        tauNorm(:, i) = tauData(:, i) * tauCoef;
        intNorm(:, i) = intData(:, i) * intCoef;
        redNorm(:, i) = redData(:, i) * redCoef;
    end
    
    averages = struct;
    averages.tauAvg = nanmean(tauData, 2);
    averages.tauSte = nanstd(tauData, 0, 2) ./ size(tauData, 2) .^ 0.5;
    averages.intAvg = nanmean(intData, 2);
    averages.intSte = nanstd(intData, 0, 2) ./ size(intData, 2) .^ 0.5;
    averages.redAvg = nanmean(redData, 2);
    averages.redSte = nanstd(redData, 0, 2) ./ size(redData, 2) .^ 0.5;
    
    averages.tauNormAvg = nanmean(tauNorm, 2);
    averages.tauNormSte = nanstd(tauNorm, 0, 2) ./ size(tauNorm, 2) .^ 0.5;
    averages.intNormAvg = nanmean(intNorm, 2);
    averages.intNormSte = nanstd(intNorm, 0, 2) ./ size(intNorm, 2) .^ 0.5;
    averages.redNormAvg = nanmean(redNorm, 2);
    averages.redNormSte = nanstd(redNorm, 0, 2) ./ size(redNorm, 2) .^ 0.5;
    
    dnaType = get(handles.inputDNAType, 'String');
    solBase = get(handles.inputSolBase, 'String');
    solutions = get(handles.solutionTable, 'Data');
    numROI = length(enabledROIs);
    
    uisave({'FILE_PATH','FILE_NAME','numBase','numROI','time','averages','dnaType','solBase','solutions'}, strcat(FILE_NAME,'AVG'));
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuClose' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuClose_Callback(~, ~, handles)
choice = questdlg('Close current file?', 'Close File', 'Yes', 'No', 'No');
if strcmp(choice, 'Yes')
    clear_global_vars();
    update_ui(handles);
end


%% Data Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Selection Callback
%
% Pre-condition: 
% Post-condition: 
%
function dataTable_CellSelectionCallback(~, eventdata, ~)
global TABLE_SELECTION;
TABLE_SELECTION = eventdata.Indices;


%% ----------------------------------------------------------------------------------------------------------------
% 'dataTable' Cell Edit Callback
%
% Pre-condition: 
% Post-condition: 
%
function dataTable_CellEditCallback(~, eventdata, handles)
% hObject    handle to dataTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global CURRENT_ROI_DATA;
CURRENT_ROI_DATA(eventdata.Indices) = NewData;
set(handles.dataTable, 'Data', CURRENT_ROI_DATA);




%% ----------------------------------------------------------------------------------------------------------------
% 'menuFix' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuFix_Callback(~, ~, handles)
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;

time = ADJ_ROI_DATA(:,1);
fixedTime = fix_roi_time(time);
if ~isempty(fixedTime)
    ADJ_ROI_DATA(:, 1) = fixedTime;
end

numROI = (size(ADJ_ROI_DATA,2)-1)/3;
allFixed = true;
for i = 1:numROI
    fixedTau = fix_roi_values(ADJ_ROI_DATA(:,1+i));
    fixedInt = fix_roi_values(ADJ_ROI_DATA(:,1+numROI+i));
    fixedRed = fix_roi_values(ADJ_ROI_DATA(:,1+2*numROI+i));
    
    if isempty(fixedTau) || isempty(fixedInt) || isempty(fixedRed)
        hToggleMenu = findall(allchild(handles.menuToggleROI),'Label',strcat('ROI',num2str(i)));
        if strcmp(get(hToggleMenu,'Checked'),'on')
            toggleROI_Callback(hToggleMenu, [], {i,handles});
        end
        allFixed = false;
    else
        ADJ_ROI_DATA(:,1+i) = fixedTau;
        ADJ_ROI_DATA(:,1+numROI+i) = fixedInt;
        ADJ_ROI_DATA(:,1+2*numROI+i) = fixedRed;
    end    
end

if allFixed
    msgbox('Fixed all data'); 
else
    warndlg('Could not fix all values');
end

update_current_data(handles);
set(handles.dataTable, 'Data', CURRENT_ROI_DATA);



%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleAdjustedTime' Callback
%
% Pre-condition: 
% Post-condition: 
%
function btnToggleAdjustedTime_Callback(hObject, ~, handles)
global CURRENT_ROI_DATA;

numBase = str2double(get(handles.inputNumBase, 'String'));
if ~isnan(numBase)
    update_current_data(handles);
    set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
else
    set(hObject, 'Value', 0);
    warndlg('Please input the number of baseline points');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnToggleNormVals' Callback
%
% Pre-condition: 
% Post-condition: 
%
function btnToggleNormVals_Callback(~, ~, handles)
global FILE_TYPE;
global CURRENT_ROI_DATA;

numBase = str2double(get(handles.inputNumBase, 'String'));
hMenuBtn = handles.menuToggleNormVals;
if ~isnan(numBase) || strcmp(FILE_TYPE, 'avg')
    if strcmp(get(hMenuBtn, 'Checked'), 'off')
        set(hMenuBtn, 'Checked', 'on');
    else
        set(hMenuBtn, 'Checked', 'off');
    end
    update_current_data(handles);
    set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
else
    warndlg('Please input the number of baseline points');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuToggleNormVals' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuToggleNormVals_Callback(hObject, ~, handles)
global FILE_TYPE;
global CURRENT_ROI_DATA;

numBase = str2double(get(handles.inputNumBase, 'String'));
if ~isnan(numBase) || strcmp(FILE_TYPE, 'avg')
    if strcmp(get(hObject, 'Checked'), 'off')
        set(hObject, 'Checked', 'on');
    else
        set(hObject, 'Checked', 'off');
    end
    update_current_data(handles);
    set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
else
    warndlg('Please input the number of baseline points');
end



%% ----------------------------------------------------------------------------------------------------------------
% 'toggleROI' Callback
%
% Pre-condition: 
% Post-condition: 
%
function toggleROI_Callback(src, ~, args)
global CURRENT_ROI_DATA;
roiIdx = args{1};
handles = args{2};
if strcmp(get(src, 'Checked'), 'on')
    set(src, 'Checked', 'off');
else
    set(src, 'Checked', 'on');
end
update_current_data(handles);
set(handles.dataTable, 'Data', CURRENT_ROI_DATA);


%% ----------------------------------------------------------------------------------------------------------------
% 'menuEnableSelectedROI' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuEnableSelectedROI_Callback(~, ~, handles)
% hObject    handle to menuEnableSelectedROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CURRENT_ROI_DATA;
global TABLE_SELECTION;

if (isempty(TABLE_SELECTION))
    warndlg('Please select a cell with a corresponding column');
else
    cols = TABLE_SELECTION(:, 2);
    numROI = (size(CURRENT_ROI_DATA, 2) - 1) / 3;
    rois = unique(mod(cols-1, numROI)); % [t][1, 2, 3][1, 2, 3]
    rois(rois==0) = numROI;

    menuItems = allchild(handles.menuToggleROI);
    for i = 1:numROI
        for m = 1:length(menuItems)
            menuLbl = get(menuItems(m), 'Label');
            if (strcmp(menuLbl, strcat('ROI', num2str(i))))
                if (ismember(i, rois))
                    set(menuItems(m), 'Checked', 'on');
                else
                    set(menuItems(m), 'Checked', 'off');
                end
            end
        end
    end

    update_current_data(handles);
    set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnEnableROI' Callback
%
% Pre-condition: 
% Post-condition: 
%
function btnEnableROI_Callback(~, ~, handles)
menuEnableSelectedROI_Callback(handles.menuEnableSelectedROI, [], handles);



%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowAbove' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuAddRowAbove_Callback(~, ~, handles)
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;
global TABLE_SELECTION;

if ~isempty(TABLE_SELECTION)
    row = TABLE_SELECTION(1);
    count = size(ADJ_ROI_DATA, 2);
    ADJ_ROI_DATA = [ADJ_ROI_DATA(1:row-1, :); zeros(1, count); ADJ_ROI_DATA(row:end, :)];
    update_current_data(handles);
    set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
else
    warndlg('Please select a row');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuAddRowBelow' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuAddRowBelow_Callback(~, ~, handles)
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;
global TABLE_SELECTION;

if ~isempty(TABLE_SELECTION)
    row = TABLE_SELECTION(1);
    count = size(ADJ_ROI_DATA, 2);
    ADJ_ROI_DATA = [ADJ_ROI_DATA(1:row, :); zeros(1, count); ADJ_ROI_DATA(row+1:end, :)];
    update_current_data(handles);
    set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
else
    warndlg('Please select a row');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuZeroRow' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuZeroRow_Callback(~, ~, handles)
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;
global TABLE_SELECTION;

if ~isempty(TABLE_SELECTION)
    row = TABLE_SELECTION(1);
    count = size(ADJ_ROI_DATA, 2);
    ADJ_ROI_DATA(row, :) = zeros(1, count);
    update_current_data(handles);
    set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
else
    warndlg('Please select a row');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuDeleteRow' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuDeleteRow_Callback(~, ~, handles)
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;
global TABLE_SELECTION;

if ~isempty(TABLE_SELECTION)
    choice = questdlg('Keep time values?', 'Delete Row', 'Yes', 'No', 'Cancel', 'Yes');
    if strcmp(choice, 'Yes')
        row = TABLE_SELECTION(1);
        time = ADJ_ROI_DATA(:, 1);
        ADJ_ROI_DATA(row, :) = [];
        ADJ_ROI_DATA(:, 1) = time(1:end-1);
        update_current_data(handles);
        set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
    elseif strcmp(choice, 'No')
        row = TABLE_SELECTION(1);
        ADJ_ROI_DATA(row, :) = [];
        update_current_data(handles);
        set(handles.dataTable, 'Data', CURRENT_ROI_DATA);
    end
else
    warndlg('Please select a row');
end

%% Plot Menu Methods ----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------




%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAll' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuPlotAll_Callback(~, ~, handles)
global FILE_NAME;
global CURRENT_ROI_DATA;

numROI = (size(CURRENT_ROI_DATA, 2) - 1) / 3;
time = CURRENT_ROI_DATA(:, 1);
tauData = CURRENT_ROI_DATA(:, 2:1+numROI);
intData = CURRENT_ROI_DATA(:, 2+numROI:1+2*numROI);
redData = CURRENT_ROI_DATA(:, 2+2*numROI:1+3*numROI);

tauPlot = [];
intPlot = [];
redPlot = [];

legendStr = {};
for i = 1:numROI
    if roi_is_enabled(i,handles)
        legendStr{end+1} = strcat('ROI', num2str(i));
        tauPlot = [tauPlot, tauData(:, i)];
        intPlot = [intPlot, intData(:, i)];
        redPlot = [redPlot, redData(:, i)];
    end
end

info = [];
if strcmp(get(handles.menuShowAnnots, 'Checked'), 'on')
   info = get_exp_info(handles);
   info.time = time;
end

%% LT Plot
if strcmp(get(handles.menuShowLifetime, 'Checked'), 'on')
    figure('Name', strcat(FILE_NAME,'|Lifetime'));
    plot(time, tauPlot, 'o-');
    if ~isempty(info)
        plot_annotations(gca, info, 0, 0);
    end
    xlabel('Time');
    ylabel('Lifetime');
    title(FILE_NAME);
    legend(legendStr);
    legend('boxoff');
end
%% Int Plot
if strcmp(get(handles.menuShowGreen, 'Checked'), 'on')
    figure('Name', strcat(FILE_NAME,'|Green Intensity'));
    plot(time, intPlot, 'o-');
    if ~isempty(info)
        plot_annotations(gca, info, 0, 0);
    end
    xlabel('Time');
    ylabel('Intensity');
    title(FILE_NAME);
    legend(legendStr);
    legend('boxoff');
end
%% Red Plot
if strcmp(get(handles.menuShowRed, 'Checked'), 'on')
    figure('Name', strcat(FILE_NAME,'|Red Intensity'));
    plot(time, redPlot, 'o-');
    if ~isempty(info)
        plot_annotations(gca, info, 0, 0);
    end
    xlabel('Time');
    ylabel('Red Intensity');
    title(FILE_NAME);
    legend(legendStr);
    legend('boxoff');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotSelected' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuPlotSelected_Callback(~, ~, handles)
global FILE_NAME;
global CURRENT_ROI_DATA;
global TABLE_SELECTION;

if ~isempty(TABLE_SELECTION)
    cols = unique(TABLE_SELECTION(:, 2));
    cols(cols == 1) = [];
    
    if isempty(cols)
        warndlg('Please select columns containing data values');
    else
        
        
        figure('Name', FILE_NAME);
        numROI = (size(CURRENT_ROI_DATA, 2) - 1) / 3;
        time = CURRENT_ROI_DATA(:, 1);
        legendStr = {};
        for i = 1:length(cols)
            roiIdx = cols(i) - 1;
            if roi_is_enabled(roiIdx,handles)
                if roiIdx <= numROI
                    legendStr{end+1} = strcat('tau@ROI',num2str(mod(roiIdx, numROI)+numROI*(roiIdx==numROI)));
                elseif roiIdx <= 2*numROI
                    legendStr{end+1} = strcat('int@ROI',num2str(mod(roiIdx, numROI)));
                else
                    legendStr{end+1} = strcat('red@ROI',num2str(mod(roiIdx, numROI)));
                end
            end
        end
        plot(time, CURRENT_ROI_DATA(:, cols), 'o-');
        xlabel('Time');
        legend(legendStr);
        title(FILE_NAME);
        
        info = [];
        if strcmp(get(handles.menuShowAnnots, 'Checked'),'on')
            info = get_exp_info(handles);
            info.time = time;
            plot_annotations(gca, info, 0, 0);
        end
    end
    
else
    warndlg('Please select columns to plot');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuPlotAvg' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuPlotAvg_Callback(~, ~, handles)
global FILE_NAME;
global FILE_TYPE;
global FILE_PATH;
global CURRENT_ROI_DATA;
global ADJ_ROI_DATA;

if strcmp(FILE_TYPE, 'avg')
    results = ADJ_ROI_DATA{2};
    if (~iscell(results) && iscell(results.filePath))
        results.filePath = strcat(results.filePath{1}, '...', results.filePath{end});
    end
    if strcmp(get(handles.menuShowLifetime, 'Checked'), 'on')
        figure();
        if strcmp(get(handles.menuToggleNormVals, 'Checked'), 'on')
            plot_norm_lt_results(results);
        else
            plot_lt_results(results);
        end
    end
    if strcmp(get(handles.menuShowGreen, 'Checked'), 'on')
        figure();
        if strcmp(get(handles.menuToggleNormVals, 'Checked'), 'on')
            plot_norm_int_results(results);
        else
            plot_int_results(results);
        end
    end
    if strcmp(get(handles.menuShowRed, 'Checked'), 'on')
        figure();
        if strcmp(get(handles.menuToggleNormVals, 'Checked'), 'on')
            plot_norm_red_results(results);
        else
            plot_red_results(results);
        end
    end
else
    numROI = (size(CURRENT_ROI_DATA, 2) - 1) / 3;
    enabledROIs = logical(roi_is_enabled(1:numROI, handles));
    numEnabled = length(find(enabledROIs));

    time = CURRENT_ROI_DATA(:, 1);
    tauData = CURRENT_ROI_DATA(:, 2:1+numROI);
    intData = CURRENT_ROI_DATA(:, 2+numROI:1+2*numROI);
    redData = CURRENT_ROI_DATA(:, 2+2*numROI:1+3*numROI); 
    tauData = tauData(:, enabledROIs);
    intData = intData(:, enabledROIs);
    redData = redData(:, enabledROIs);

    meanTau = nanmean(tauData, 2);
    steTau = nanstd(tauData, 0, 2) ./ size(tauData,2) .^ 0.5;
    meanInt = nanmean(intData, 2);
    steInt = nanstd(intData, 0, 2) ./ size(intData,2) .^ 0.5;
    meanRed = nanmean(redData, 2);
    steRed = nanstd(redData, 0, 2) ./ size(redData,2) .^ 0.5;

    info = [];
    if strcmp(get(handles.menuShowAnnots,'Checked'),'on')
        info = get_exp_info(handles);
        info.time = time;
    end

    %%LT plot
    if strcmp(get(handles.menuShowLifetime, 'Checked'), 'on')
        figure();
        errorbar(time, meanTau, steTau, 'o-', 'MarkerFaceColor', 'k', 'color', 'k');
        xlabel('Time');
        ylabel('Mean Lifetime');
        if ~isempty(info)
            plot_annotations(gca, info, 0, 0);
        end
        legend(strcat('n=',num2str(numEnabled)));
        title(FILE_NAME);
    end
    if strcmp(get(handles.menuShowGreen, 'Checked'), 'on')
        figure();
        errorbar(time, meanInt, steInt, 'o-', 'MarkerFaceColor', 'k', 'color', 'k');
        xlabel('Time');
        ylabel('Mean Intenisty');
        if ~isempty(info)
            plot_annotations(gca, info, 0, 0);
        end
        legend(strcat('n=',num2str(numEnabled)));
        title(FILE_NAME);
    end
    if strcmp(get(handles.menuShowRed, 'Checked'), 'on')
        figure();
        errorbar(time, meanRed, steRed, 'o-', 'MarkerFaceColor', 'k', 'color', 'k');
        xlabel('Time');
        ylabel('Mean Red Intenisty');
        if ~isempty(info)
            plot_annotations(gca, info, 0, 0);
        end
        legend(strcat('n=',num2str(numEnabled)));
        title(FILE_NAME);
    end
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowAnnots' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuShowAnnots_Callback(hObject, ~, handles)

numBase = str2double(get(handles.inputNumBase,'String'));
solutions = get(handles.solutionTable, 'Data');

if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    if isnan(numBase) || isempty(solutions)
        warndlg('Please set the number of baseline points and add at least one solution to see annotaions');
    else
        set(hObject, 'Checked', 'on');
    end
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowLifetime' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuShowLifetime_Callback(hObject, ~, ~)
if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    set(hObject, 'Checked', 'on');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowGreen' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuShowGreen_Callback(hObject, ~, ~)
if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    set(hObject, 'Checked', 'on');
end


%% ----------------------------------------------------------------------------------------------------------------
% 'menuShowRed' Callback
%
% Pre-condition: 
% Post-condition: 
%
function menuShowRed_Callback(hObject, ~, ~)
if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    set(hObject, 'Checked', 'on');
end

%% Experiment Info Methods ----------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

%% ----------------------------------------------------------------------------------------------------------------
% 'btnAddSolution' Callback
%
% Pre-condition: 
% Post-condition: 
%
function btnAddSolution_Callback(~, ~, handles)
solutions = get(handles.solutionTable, 'Data');
numSolutions = size(solutions, 1);
resizedData = cell(numSolutions + 1, 2);
resizedData(1:numSolutions, :) = solutions(1:numSolutions, :);
set(handles.solutionTable, 'Data', resizedData);


%% TODO -----------------------------------------------------------------------------------------------------------
% 'btnRemoveSolution' Callback
%
% Pre-condition: 
% Post-condition: 
%
function btnRemoveSolution_Callback(~, ~, handles)


%% ----------------------------------------------------------------------------------------------------------------
% 'solutionTable' Cell Edit Callback
%
% Pre-condition: 
% Post-condition: 
%
function solutionTable_CellEditCallback(hObject, eventdata, ~)
% hObject    handle to solutionTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global CURRENT_ROI_DATA;

solutions = get(hObject, 'Data');
numSolutions = size(solutions, 1);
row = eventdata.Indices(1);
isTiming = (eventdata.Indices(2)==2);
if (isTiming)
    solName = solutions(row, 1);
else
    solName = eventdata.PreviousData;
end
numPts = size(CURRENT_ROI_DATA,1);

if (isTiming && isnan(eventdata.NewData)) || (~isTiming && isempty(eventdata.NewData))
    choice = questdlg(strcat('Delete solution #', num2str(row), ': ', solName, '?'), 'Delete Solution', 'Yes', 'No', 'No');
    if (strcmp(choice, 'Yes'))
        resizedData = cell(numSolutions-1,2);
        resizedData(1:row-1,:) = solutions(1:row-1,:);
        resizedData(row:numSolutions-1, :) = solutions(row+1:numSolutions, :);
        set(hObject, 'Data', resizedData);
    elseif (strcmp(choice, 'No'))
        if (isTiming)
            solutions{row, 2} = eventdata.PreviousData;
        else
            solutions{row, 1} = eventdata.PreviousData;
        end
        set(hObject, 'Data', solutions);
    end
elseif (isTiming && (eventdata.NewData < 1 || eventdata.NewData > numPts))
    solutions{row, 2} = eventdata.PreviousData;
    set(hObject, 'Data', solutions);
    warndlg(strcat('Please input a timing from 1 to', ' ', num2str(numPts)), 'Invalid Timing');
elseif (isTiming)
    [sortedTimes, indices] = sort([solutions{:, 2}]);
    solutions(:, 1) = solutions(indices, 1);
    solutions(:, 2) = solutions(indices, 2);
    set(hObject, 'Data', solutions);
end


%% ----------------------------------------------------------------------------------------------------------------
% 'btnImportInfo' Callback
%
% Pre-condition: 
% Post-condition: 
%
function btnImportInfo_Callback(~, ~, handles)
[name, path] = uigetfile('*.docx');

if ~isequal(name, 0) && ~isequal(path, 0)
    wordApp = actxserver('Word.Application');
    wordDoc = wordApp.Documents.Open(fullfile(path, name));
    msgStyle.Interpreter = 'tex';
    msgStyle.WindowStyle = 'non-modal';
    msgbox(['\fontsize{14}',wordDoc.Content.Text], msgStyle);
    docTxt = lower(wordDoc.Content.Text);
    wordDoc.Close;
    wordApp.Quit;

    [~, docName, ~] = fileparts(lower(name));

    idxDNA = strfind(docTxt, 'no');
    endIdxDNA = strfind(docTxt, 'cells are');
    try
        dna = docTxt(idxDNA + length('nommddyy'):endIdxDNA(1) -1);
    catch
        dna = ' ';
    end

    idxSolStart = strfind(docTxt, 'start with');
    endIdxSolStart = strfind(docTxt, 'img');
    endIdxSolStart = endIdxSolStart(endIdxSolStart > idxSolStart(1));
    try
        solStart = docTxt(idxSolStart + length('start with'):endIdxSolStart(1)-1);
    catch
        solStart = ' ';
    end


    idxPts = strfind(docTxt, 'after img');
    endIdxPts = strfind(docTxt, 'start');
    endIdxPts = endIdxPts(endIdxPts > idxPts(1));
    try
        nBase = docTxt(idxPts(1)+length('after img'):endIdxPts(1)-1);
        if isnan(str2double(nBase))
            nBase = ' ';
        end
    catch
        nBase = ' ';
    end
    try
        startWash = docTxt(idxPts(2)+length('after img'):endIdxPts(end)-1);
        if isnan(str2double(startWash))
            startWash = ' ';
        end
    catch
        startWash = ' ';
    end

    endIdxSol = strfind(docTxt, 'after img');
    endIdxSol = endIdxSol(endIdxSol > idxPts(1));
    try
        solA = docTxt(endIdxPts(1)+length('start'):endIdxSol(1)-1);
    catch
        solA = ' ';
    end
    try
        solB = docTxt(endIdxPts(2)+length('start'):endIdxSol(end)-1);
    catch
        solB = ' ';
    end

    
    solStart = strrep(strrep(strrep(strrep(solStart, 'mm', 'mM'), 'calcium', 'Ca'), 'hbss', 'HBSS'), 'um', 'uM');
    solA = strrep(strrep(strrep(strrep(strrep(solA, 'mm', 'mM'), 'calcium', 'Ca'), 'hbss', 'HBSS'), 'egta', 'EGTA'), 'um', 'uM');
    solB = strrep(strrep(strrep(strrep(strrep(solB, 'mm', 'mM'), 'calcium', 'Ca'), 'hbss', 'HBSS'), 'egta', 'EGTA'), 'um', 'uM');
    
    set(handles.inputDNAType, 'String', dna);
    set(handles.inputSolBase, 'String', solStart);
    set(handles.inputSolA, 'String', solA);
    set(handles.inputSolB, 'String', solB);
    set(handles.inputNumBase, 'String', nBase);
    set(handles.inputWashStart, 'String', startWash);
end

%% Tools Menu Methods ---------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

function menuSPC_Callback(~, ~, ~)
spc_drawInit;
function menuImstack_Callback(~, ~, ~)
h_imstack;
function menuStatsIB_Callback(~, ~, ~)
stats_IB_061020

%% MISC -----------------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------
function menuFile_Callback(~, ~, ~)
function menuData_Callback(~, ~, ~)
function menuToggle_Callback(~, ~, ~)
function menuToggleROI_Callback(~, ~, ~)
function menuRow_Callback(~, ~, ~)
function inputDNAType_Callback(~, ~, ~)
function inputSolBase_Callback(~, ~, ~)
function inputNumBase_Callback(~, ~, ~)
function menuPlot_Callback(~, ~, ~)
function menuTools_Callback(~, ~, ~) 
%#ok<*DEFNU>
