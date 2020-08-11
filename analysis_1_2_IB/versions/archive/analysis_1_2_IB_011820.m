%% ******************************* GUIDE FUNCTIONS - DO NOT EDIT


function varargout = analysis_1_2_IB_011820(varargin)
% ANALYSIS_1_2_IB_011820 MATLAB code for analysis_1_2_IB_011820.fig
%      ANALYSIS_1_2_IB_011820, by itself, creates a new ANALYSIS_1_2_IB_011820 or raises the existing
%      singleton*.
%
%      H = ANALYSIS_1_2_IB_011820 returns the handle to a new ANALYSIS_1_2_IB_011820 or the handle to
%      the existing singleton*.
%
%      ANALYSIS_1_2_IB_011820('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_1_2_IB_011820.M with the given input arguments.
%
%      ANALYSIS_1_2_IB_011820('Property','Value',...) creates a new ANALYSIS_1_2_IB_011820 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_1_2_IB_011820_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_1_2_IB_011820_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysis_1_2_IB_011820

% Last Modified by GUIDE v2.5 11-Jun-2020 14:37:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_1_2_IB_011820_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_1_2_IB_011820_OutputFcn, ...
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
function analysis_1_2_IB_011820_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysis_1_2_IB_011820 (see VARARGIN)

% Choose default command line output for analysis_1_2_IB_011820
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
clear_global_vars();
update_ui(handles);

function varargout = analysis_1_2_IB_011820_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% ******************************* Global Functions

function clear_global_vars()
global filePath; %string w/ full file path
global fileName; %string w/ file name
global fileType; %string w/ file type (raw, prep, avg)    
global currentData; %matrix w/ data being displayed
global adjData; %matrix w/ adjusted data
global tableSelection; %indices of selected table cells
filePath = [];
fileName = [];
fileType = [];
currentData = [];
adjData = [];
tableSelection = [];
function update_ui(handles)
global fileType;
global currentData;

if isempty(fileType) % No data loaded
    %% Disable 'File' Menu controls
    set(handles.menuSave, 'Enable', 'off');
    set(handles.menuClose, 'Enable', 'off');
    %% Clear/Disable 'Info' Panel controls
    set(findall(handles.panelInfo, '-property', 'Enable'), 'Enable', 'off');
    set(findall(handles.panelInfo, 'Style', 'Edit'), 'String', '');
    set(handles.solutionTable, 'Data', cell(6, 2));
    %% Disable 'Data' menu controls
    set(handles.menuData, 'Enable', 'off');
    %% Disable 'Plot' menu controls
    set(handles.menuPlot, 'Enable', 'off');
    %% Clear table
    set(handles.dataTable, 'ColumnName', {});
    set(handles.dataTable, 'Data', {});
elseif strcmp(fileType, 'avg')
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
    
    numAvg = (size(currentData,2)-1) / 12;
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
    if strcmp(fileType, 'prep')
        set(handles.btnToggleAdjustedTime, 'Enable', 'off');
    else
        set(handles.btnToggleAdjustedTime, 'Enable', 'on');
    end
    
    %% Update 'Toggle ROI' controls w/ new number of ROIs + Update table's column labels
    numROI = (size(currentData, 2) - 1) / 3;
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
function update_current_data(handles)
global fileType;
global currentData;
global adjData;

%% Fill in enabled ROIs + normalize if necessary
if strcmp(fileType, 'avg')
    vals = adjData{1};
    %% Clear current data
    currentData = nan(size(vals));
    currentData(:, 1) = vals(:, 1);
    for i = 2:4:size(vals,2)
        if strcmp(get(handles.menuToggleNormVals, 'Checked'), 'on')
            currentData(:, i+2) = vals(:, i+2);
            currentData(:, i+3) = vals(:, i+3);
        else
            currentData(:, i) = vals(:, i);
            currentData(:, i+1) = vals(:, i+1);
        end
    end
else
    %% Clear current data
    currentData = nan(size(adjData));
    %% Get # of base pts + toggle adjtime
    numBase = str2double(get(handles.inputNumBase,'String'));
    if get(handles.btnToggleAdjustedTime, 'Value') == 1
        time = adjData(:, 1);
        time = (time) * 60 * 24;
        time = time - time(numBase);
        currentData(:, 1) = time;
    else
        currentData(:, 1) = adjData(:, 1);
    end

    numROI = (size(adjData,2)-1)/3;
    for i = 1:numROI
        if roi_is_enabled(i, handles)
            currentData(:, [1+i,1+numROI+i,1+2*numROI+i]) = adjData(:, [1+i,1+numROI+i,1+2*numROI+i]);
            if strcmp(get(handles.menuToggleNormVals, 'Checked'), 'on')
                normalize_roi(i, numBase)
            end
        end
    end
end
function [state] = roi_is_enabled(roiIdx, handles)
if strcmp(get(handles.menuToggleROI, 'Enable'), 'off')
    state = ones(1, length(roiIdx));
else
    state = [];
    for i = 1:length(roiIdx)
        hToggleMenu = findall(allchild(handles.menuToggleROI),'Label',strcat('ROI',num2str(roiIdx(i))));
        state = [state, strcmp(get(hToggleMenu,'Checked'),'on')];
    end
end
function normalize_roi(roiIdx, numBase)
global currentData;
%% Get coefficients for normaliztion based on # of base pts
numROI = (size(currentData,2)-1)/3;
tauCoef = (ones(1, length(roiIdx)) * numBase) ./ nansum(currentData(1:numBase, 1+roiIdx), 1);
intCoef = (ones(1, length(roiIdx)) * numBase) ./ nansum(currentData(1:numBase, 1+numROI+roiIdx), 1);
redCoef = (ones(1, length(roiIdx)) * numBase) ./ nansum(currentData(1:numBase, 1+2*numROI+roiIdx), 1);
%% Normalize data at given indices
currentData(:, 1+roiIdx) = currentData(:, 1+roiIdx).*repmat(tauCoef, size(currentData,1), 1);
currentData(:, 1+numROI+roiIdx) = currentData(:, 1+numROI+roiIdx).*repmat(intCoef, size(currentData,1), 1);
currentData(:, 1+2*numROI+roiIdx) = currentData(:, 1+2*numROI+roiIdx).*repmat(redCoef, size(currentData,1), 1);
function [info] = get_exp_info(handles)
%% Compile experiment info based on ui entries
info = struct;
info.dnaType = get(handles.inputDNAType, 'String');
info.solBase = get(handles.inputSolBase, 'String');
info.numBase = str2double(get(handles.inputNumBase, 'String'));
info.solutions = get(handles.solutionTable, 'Data');
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

    
%% ******************************* GUI Init Functions

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


%% ******************************* File Menu Functions

function menuFile_Callback(~, ~, ~)
function menuOpen_Callback(hObject, eventdata, handles)
global filePath;
global fileName;
global fileType;
global currentData;
global adjData;

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
        
        currentData = [];
        for i = 1:length(filename)
            currentFile = filename{i};
            load(currentFile);
            if exist('prepData', 'var')
                fileType = 'prep';
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
                
                currentData = append_roi_data(currentData, timeData{end}, tauData{end}, intData{end}, redData{end});
            elseif exist('averages', 'var')
                fileType = 'avg';
                results{end+1} = load(currentFile);
            end
        end
        
        if strcmp(fileType, 'prep')        
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

            filePath = filename;
            [~, fileName, ~] = fileparts(filename{1});
            %currentData = [adjTimeData, adjTauData, adjIntData, adjRedData];
            adjData = currentData;
            
            
            update_exp_info(expInfo, handles);
            % set(handles.inputNumBase, 'String', num2str(numBase));
            % set(handles.inputWashStart, 'String', num2str(washStart));

            set(handles.mainFig, 'Name', strcat(fileName,'...','[',fileType,']'));
            set(handles.dataTable, 'Data', currentData);
            
            
        elseif strcmp(fileType, 'avg')
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
            
            filePath = filename;
            [~, fileName, ~] = fileparts(filename{1});
            currentData = [timeData, tauData, intData, redData];
            adjData = {currentData, results};
            
            update_exp_info(results, handles);
            
            set(handles.dataTable, 'Data', currentData);
        end
        %%}
    else
        % Single files: raw files, prep file, averages file
        
        load(filename);
        if exist('averages', 'var')
            filePath = filename;
            [~, fileName, ~] = fileparts(filename);
            fileType = 'avg';
            
            results = load(filename);
            currentData = [results.time, results.averages.tauAvg, results.averages.tauSte, results.averages.tauNormAvg, results.averages.tauNormSte, results.averages.intAvg, results.averages.intSte, results.averages.intNormAvg, results.averages.intNormSte, results.averages.redAvg, results.averages.redSte, results.averages.redNormAvg, results.averages.redNormSte];
            adjData = {currentData, results};
            
            update_exp_info(results, handles);
            set(handles.dataTable, 'Data', currentData);
        elseif exist('prepData', 'var')
            choice = questdlg('Which data should be loaded?', 'Choose Data', 'Raw Data', 'Prepared Data', 'Prepared Data');
            if strcmp(choice, 'Raw Data')
                roiFileData = reformat_roi_file(filename, 'ROI');
                filePath = filename;
                [~, fileName, ~] = fileparts(filename);
                fileType = 'raw';
                currentData = roiFileData.raw.all;
                adjData = currentData;
            elseif strcmp(choice, 'Prepared Data')
                filePath = filename;
                [~, fileName, ~] = fileparts(filename);
                fileType = 'prep';
                currentData = prepData.alladj;
                adjData = currentData;
                update_exp_info(prepData, handles);
            end
            set(handles.dataTable, 'Data', currentData);
            set(handles.mainFig, 'Name', strcat(fileName,'[', fileType,']'));
        else
            formatStr = 'ROI2';
            idxFormat = strfind(filename, formatStr);

            if idxFormat            
                roiFileData = reformat_roi_file(filename, 'ROI');
                if isempty(roiFileData)
                    errordlg('This file is not a valid ROI file');
                    return;
                end

                filePath = filename;
                [~, fileName, ~] = fileparts(filename);
                fileType = 'raw';
                currentData = roiFileData.raw.all;
                adjData = currentData;

                set(handles.mainFig, 'Name', strcat(fileName,'[', fileType,']'));
                set(handles.dataTable, 'Data', currentData);
            end        
        end
    end
    
    
end
update_ui(handles);
update_current_data(handles);
set(handles.dataTable, 'Data', currentData);
function menuSave_Callback(hObject, eventdata, handles)
global filePath;
global fileName;
global fileType;
global adjData;

if strcmp(fileType, 'raw')
    numBase = str2double(get(handles.inputNumBase, 'String'));
    
    if isnan(numBase)
        warndlg('Please input the number of baseline points before saving');
        return;
    end
    
    load(filePath);
    formatStr = 'ROI2';
    idxFormat = strfind(fileName, formatStr);
    structName = fileName(1:idxFormat+length(formatStr)-1);
    
    numROI = (size(adjData, 2) - 1) / 3;
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
    tauData = adjData(:, 2:1+numROI);
    intData = adjData(:, 2+numROI:1+2*numROI);
    redData = adjData(:, 2+2*numROI:1+3*numROI);
    tauData = tauData(:, enabledROIs);
    intData = intData(:, enabledROIs);
    redData = redData(:, enabledROIs);

    
    time = adjData(:, 1);
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
        
    uisave({structName, 'prepData'}, strcat(fileName, 'PREP'));    
elseif strcmp(fileType, 'prep')    
    numBase = str2double(get(handles.inputNumBase, 'String'));
    
    if isnan(numBase)
        warndlg('Input a single valid value for the number of baseline pts');
        return;
    end
    
    numROI = (size(adjData, 2) - 1) / 3;
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
    
    
    time = adjData(:, 1);
    tauData = adjData(:, 2:1+numROI);
    intData = adjData(:, 2+numROI:1+2*numROI);
    redData = adjData(:, 2+2*numROI:1+3*numROI);
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
    
    uisave({'filePath','fileName','numBase','numROI','time','averages','dnaType','solBase','solutions'}, strcat(fileName,'AVG'));
end
function menuClose_Callback(hObject, eventdata, handles)
choice = questdlg('Close current file?', 'Close File', 'Yes', 'No', 'No');
if strcmp(choice, 'Yes')
    clear_global_vars();
    update_ui(handles);
end


%% ******************************* Data Menu Functions

function dataTable_CellSelectionCallback(hObject, eventdata, handles)
global tableSelection;
tableSelection = eventdata.Indices;
function dataTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to dataTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global currentData;
currentData(eventdata.Indices) = NewData;
set(handles.dataTable, 'Data', currentData);

function menuData_Callback(~, ~, ~)
function menuFix_Callback(hObject, eventdata, handles)
global currentData;
global adjData;

time = adjData(:,1);
fixedTime = fix_roi_time(time);
if ~isempty(fixedTime)
    adjData(:, 1) = fixedTime;
end

numROI = (size(adjData,2)-1)/3;
allFixed = true;
for i = 1:numROI
    fixedTau = fix_roi_values(adjData(:,1+i));
    fixedInt = fix_roi_values(adjData(:,1+numROI+i));
    fixedRed = fix_roi_values(adjData(:,1+2*numROI+i));
    
    if isempty(fixedTau) || isempty(fixedInt) || isempty(fixedRed)
        hToggleMenu = findall(allchild(handles.menuToggleROI),'Label',strcat('ROI',num2str(i)));
        if strcmp(get(hToggleMenu,'Checked'),'on')
            toggleROI_Callback(hToggleMenu, [], {i,handles});
        end
        allFixed = false;
    else
        adjData(:,1+i) = fixedTau;
        adjData(:,1+numROI+i) = fixedInt;
        adjData(:,1+2*numROI+i) = fixedRed;
    end    
end

if allFixed
    msgbox('Fixed all data'); 
else
    warndlg('Could not fix all values');
end

update_current_data(handles);
set(handles.dataTable, 'Data', currentData);
function menuStats_Callback(hObject, eventdata, handles)
global currentData;
global tableSelection;

if (isempty(tableSelection))
    warndlg('Please select at least one row');
else
    rows = unique(tableSelection(:, 1));
    cols = unique(tableSelection(:, 2));
    cols = cols(cols ~= 1);
    if (isempty(cols))
        warndlg('Please select a column besides the time column');
    else
        n = numel(rows);
        means = zeros(1, numel(cols));
        stderrs = ones(1, numel(cols));
        for i = 1:numel(cols)
            means(i) = mean(currentData(rows, cols(i)));
            stderrs(i) = std(currentData(rows, cols(i)))/ sqrt(n);
        end
    end
    
    if (numel(cols) == 2)
    else
        warndlg('Cannot display significance for multiple columns. Select 2 columns to see statistical significance');
    end
end

function menuToggle_Callback(hObject, eventdata, handles)
function btnToggleAdjustedTime_Callback(hObject, eventdata, handles)
global currentData;

numBase = str2double(get(handles.inputNumBase, 'String'));
if ~isnan(numBase)
    update_current_data(handles);
    set(handles.dataTable, 'Data', currentData);
else
    set(hObject, 'Value', 0);
    warndlg('Please input the number of baseline points');
end
function btnToggleNormVals_Callback(hObject, eventdata, handles)
global fileType;
global currentData;

numBase = str2double(get(handles.inputNumBase, 'String'));
hMenuBtn = handles.menuToggleNormVals;
if ~isnan(numBase) || strcmp(fileType, 'avg')
    if strcmp(get(hMenuBtn, 'Checked'), 'off')
        set(hMenuBtn, 'Checked', 'on');
    else
        set(hMenuBtn, 'Checked', 'off');
    end
    update_current_data(handles);
    set(handles.dataTable, 'Data', currentData);
else
    warndlg('Please input the number of baseline points');
end
function menuToggleNormVals_Callback(hObject, eventdata, handles)
global fileType;
global currentData;

numBase = str2double(get(handles.inputNumBase, 'String'));
if ~isnan(numBase) || strcmp(fileType, 'avg')
    if strcmp(get(hObject, 'Checked'), 'off')
        set(hObject, 'Checked', 'on');
    else
        set(hObject, 'Checked', 'off');
    end
    update_current_data(handles);
    set(handles.dataTable, 'Data', currentData);
else
    warndlg('Please input the number of baseline points');
end
function menuToggleROI_Callback(hObject, eventdata, handles)
function toggleROI_Callback(src, event, args)
global currentData;
roiIdx = args{1};
handles = args{2};
if strcmp(get(src, 'Checked'), 'on')
    set(src, 'Checked', 'off');
else
    set(src, 'Checked', 'on');
end
update_current_data(handles);
set(handles.dataTable, 'Data', currentData);
function menuEnableSelectedROI_Callback(hObject, eventdata, handles)
% hObject    handle to menuEnableSelectedROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currentData;
global tableSelection;

if (isempty(tableSelection))
    warndlg('Please select a cell with a corresponding column');
else
    cols = tableSelection(:, 2);
    numROI = (size(currentData, 2) - 1) / 3;
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
    set(handles.dataTable, 'Data', currentData);
end
function btnEnableROI_Callback(hObject, eventdata, handles)
menuEnableSelectedROI_Callback(handles.menuEnableSelectedROI, [], handles);
%{
TODO
%}

function menuRow_Callback(hObject, eventdata, handles)
function menuAddRowAbove_Callback(hObject, eventdata, handles)
global currentData;
global adjData;
global tableSelection;

if ~isempty(tableSelection)
    row = tableSelection(1);
    count = size(adjData, 2);
    adjData = [adjData(1:row-1, :); zeros(1, count); adjData(row:end, :)];
    update_current_data(handles);
    set(handles.dataTable, 'Data', currentData);
else
    warndlg('Please select a row');
end
function menuAddRowBelow_Callback(hObject, eventdata, handles)
global currentData;
global adjData;
global tableSelection;

if ~isempty(tableSelection)
    row = tableSelection(1);
    count = size(adjData, 2);
    adjData = [adjData(1:row, :); zeros(1, count); adjData(row+1:end, :)];
    update_current_data(handles);
    set(handles.dataTable, 'Data', currentData);
else
    warndlg('Please select a row');
end
function menuZeroRow_Callback(hObject, eventdata, handles)
global currentData;
global adjData;
global tableSelection;

if ~isempty(tableSelection)
    row = tableSelection(1);
    count = size(adjData, 2);
    adjData(row, :) = zeros(1, count);
    update_current_data(handles);
    set(handles.dataTable, 'Data', currentData);
else
    warndlg('Please select a row');
end
function menuDeleteRow_Callback(hObject, eventdata, handles)
global currentData;
global adjData;
global tableSelection;

if ~isempty(tableSelection)
    choice = questdlg('Keep time values?', 'Delete Row', 'Yes', 'No', 'Cancel', 'Yes');
    if strcmp(choice, 'Yes')
        row = tableSelection(1);
        time = adjData(:, 1);
        adjData(row, :) = [];
        adjData(:, 1) = time(1:end-1);
        update_current_data(handles);
        set(handles.dataTable, 'Data', currentData);
    elseif strcmp(choice, 'No')
        row = tableSelection(1);
        adjData(row, :) = [];
        update_current_data(handles);
        set(handles.dataTable, 'Data', currentData);
    end
else
    warndlg('Please select a row');
end

%% ******************************* Plot Menu Functions
function menuPlot_Callback(~, ~, ~)
function menuPlotAll_Callback(hObject, eventdata, handles)
global fileName;
global currentData;

numROI = (size(currentData, 2) - 1) / 3;
time = currentData(:, 1);
tauData = currentData(:, 2:1+numROI);
intData = currentData(:, 2+numROI:1+2*numROI);
redData = currentData(:, 2+2*numROI:1+3*numROI);

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
    figure('Name', strcat(fileName,'|Lifetime'));
    plot(time, tauPlot, 'o-');
    if ~isempty(info)
        plot_annotations(gca, info, 0, 0);
    end
    xlabel('Time');
    ylabel('Lifetime');
    title(fileName);
    legend(legendStr);
    legend('boxoff');
end
%% Int Plot
if strcmp(get(handles.menuShowGreen, 'Checked'), 'on')
    figure('Name', strcat(fileName,'|Green Intensity'));
    plot(time, intPlot, 'o-');
    if ~isempty(info)
        plot_annotations(gca, info, 0, 0);
    end
    xlabel('Time');
    ylabel('Intensity');
    title(fileName);
    legend(legendStr);
    legend('boxoff');
end
%% Red Plot
if strcmp(get(handles.menuShowRed, 'Checked'), 'on')
    figure('Name', strcat(fileName,'|Red Intensity'));
    plot(time, redPlot, 'o-');
    if ~isempty(info)
        plot_annotations(gca, info, 0, 0);
    end
    xlabel('Time');
    ylabel('Red Intensity');
    title(fileName);
    legend(legendStr);
    legend('boxoff');
end
function menuPlotSelected_Callback(hObject, eventdata, handles)
global fileName;
global currentData;
global tableSelection;

if ~isempty(tableSelection)
    cols = unique(tableSelection(:, 2));
    cols(cols == 1) = [];
    
    if isempty(cols)
        warndlg('Please select columns containing data values');
    else
        
        
        figure('Name', fileName);
        numROI = (size(currentData, 2) - 1) / 3;
        time = currentData(:, 1);
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
        plot(time, currentData(:, cols), 'o-');
        xlabel('Time');
        legend(legendStr);
        title(fileName);
        
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
function menuPlotAvg_Callback(hObject, eventdata, handles)
global fileName;
global fileType;
global filePath;
global currentData;
global adjData;

if strcmp(fileType, 'avg')
    results = adjData{2};
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
    numROI = (size(currentData, 2) - 1) / 3;
    enabledROIs = logical(roi_is_enabled(1:numROI, handles));
    numEnabled = length(find(enabledROIs));

    time = currentData(:, 1);
    tauData = currentData(:, 2:1+numROI);
    intData = currentData(:, 2+numROI:1+2*numROI);
    redData = currentData(:, 2+2*numROI:1+3*numROI); 
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
        title(fileName);
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
        title(fileName);
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
        title(fileName);
    end
end
function menuShowAnnots_Callback(hObject, eventdata, handles)

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
function menuShowLifetime_Callback(hObject, eventdata, handles)
if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    set(hObject, 'Checked', 'on');
end
function menuShowGreen_Callback(hObject, eventdata, handles)
if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    set(hObject, 'Checked', 'on');
end
function menuShowRed_Callback(hObject, eventdata, handles)
if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    set(hObject, 'Checked', 'on');
end

%% ******************************* Exp Info Functions

function inputDNAType_Callback(hObject, eventdata, handles)
function inputSolBase_Callback(hObject, eventdata, handles)
function inputNumBase_Callback(hObject, eventdata, handles)
function btnAddSolution_Callback(hObject, eventdata, handles)
solutions = get(handles.solutionTable, 'Data');
numSolutions = size(solutions, 1);
resizedData = cell(numSolutions + 1, 2);
resizedData(1:numSolutions, :) = solutions(1:numSolutions, :);
set(handles.solutionTable, 'Data', resizedData);
function solutionTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to solutionTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global currentData;

solutions = get(hObject, 'Data');
numSolutions = size(solutions, 1);
row = eventdata.Indices(1);
isTiming = (eventdata.Indices(2)==2);
if (isTiming)
    solName = solutions(row, 1);
else
    solName = eventdata.PreviousData;
end
numPts = size(currentData,1);

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

function btnImportInfo_Callback(hObject, eventdata, handles)
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

%% ******************************* Tools Menu Functions
function menuTools_Callback(~, ~, ~) 
function menuSPC_Callback(~, ~, ~)
spc_drawInit;
function menuImstack_Callback(~, ~, ~)
h_imstack;

%#ok<*DEFNU>


% --------------------------------------------------------------------
function menuStatsIB_Callback(hObject, eventdata, handles)
% hObject    handle to menuStatsIB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stats_IB_061020