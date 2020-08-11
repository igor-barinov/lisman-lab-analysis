function h_updateInfo(handles)

global h_img;

currentFilename = get(handles.currentFileName,'String');
[pname, fname] = h_analyzeFilename(currentFilename);
if isempty(pname)
    pname = pwd;
end
analysisNumber = h_img.state.analysisNumber.Value;
if analysisNumber == 1
    analysisNumber = [];
end

if isfield(handles, 'analyzedInfo')

%     roiFilename = fullfile(pname,'Analysis',[fname(1:end-4),'_zroi',num2str(analysisNumber),'.mat']);
%     if exist(roiFilename)
%         set(handles.analyzedInfo,'String','Pre-Analyzed!','ForegroundColor','red');
%         set(handles.loadAnalyzedRoiData,'Enable','on');
%     else
%         set(handles.analyzedInfo,'String','Not-Analyzed.','ForegroundColor','black');
%         set(handles.loadAnalyzedRoiData,'Enable','off');
%     end
    roiFilename = fullfile(pname,'Analysis',[fname(1:end-4),'_zroi*.mat']);
    roiFiles = h_dir(roiFilename);
    if ~isempty(roiFiles)
        numStr = 'A';
        for i = 1:length(roiFiles)
            [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
            pos = strfind(roiFilesName,'_zroi');
            num = roiFilesName(pos+5:end);%find out analysis number (string).
            if isempty(num)
                num = '1';
            end
            numStr = [numStr, '#', num, ' '];
        end
        set(handles.analyzedInfo,'String',[numStr, 'analyzed!'],'ForegroundColor','red');
        set(handles.loadAnalyzedRoiData,'Enable','on');
    else
        set(handles.analyzedInfo,'String','Not-Analyzed.','ForegroundColor','black');
        set(handles.loadAnalyzedRoiData,'Enable','off');
    end
end

if isfield(handles, 'paAnalysisInfo')
    roiFilename = fullfile(pname,'Analysis',[fname(1:end-4),'_roim.mat']);
    if exist(roiFilename)
        set(handles.paAnalysisInfo,'String','Pre-Analyzed!','ForegroundColor','red');
        set(handles.loadAnalyzedPARoiData,'Enable','on');
    else
        set(handles.paAnalysisInfo,'String','Not-Analyzed.','ForegroundColor','black');
        set(handles.loadAnalyzedPARoiData,'Enable','off');
    end
end


if isfield(handles,'imgGroupInfo')
    groupFilename = fullfile(pname,'Analysis',[fname(1:end-4),'_grp.mat']);
    if exist(groupFilename)
        load(groupFilename);
    end
    if exist('groupName') & ~isempty(groupName)
        [h_img.imgGroupInfo.groupPath,h_img.imgGroupInfo.groupName] = h_analyzeFilename(groupName);
        set(handles.imgGroupInfo,'String',['Image grouped in ',h_img.imgGroupInfo.groupName]);
        set(handles.loadCurrentImgGroup,'Enable','on');
    else
        set(handles.imgGroupInfo,'String','Image un-grouped');
        set(handles.loadCurrentImgGroup,'Enable','off');
        h_img.imgGroupInfo = [];
    end
end

if isfield(h_img,'activeGroup') & ~isempty(h_img.activeGroup.groupName)
    set(handles.currentGroupInfo,'String',['Group: ',h_img.activeGroup.groupName,...
        '  (',num2str(length(h_img.activeGroup.groupFiles)),')'],'FontSize',9);
    set(handles.openFirstInGroup,'Enable','on');
    set(handles.openPreviousInGroup,'Enable','on');
    set(handles.openNextInGroup,'Enable','on');
    set(handles.openLastInGroup,'Enable','on');
else
    set(handles.currentGroupInfo,'String','Group: None','FontSize',9);
    set(handles.openFirstInGroup,'Enable','off');
    set(handles.openPreviousInGroup,'Enable','off');
    set(handles.openNextInGroup,'Enable','off');
    set(handles.openLastInGroup,'Enable','off');
end

if isfield(handles, 'tracingDataInfo')
    roiFilename = fullfile(pname,'Analysis',[fname(1:end-4),'_tracing*.mat']);
    roiFiles = h_dir(roiFilename);
    if ~isempty(roiFiles)
        numStr = 'A';
        for i = 1:length(roiFiles)
            [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
            pos = strfind(roiFilesName,'_tracing');
            num = roiFilesName(pos+8:end);%find out analysis number (string).
            if isempty(num)
                num = '1';
            end
            numStr = [numStr, '#', num, ' '];
        end
        set(handles.tracingDataInfo,'String',[numStr, 'tracing data available!'],'ForegroundColor','red');
        set(handles.loadTracingData,'Enable','on');
    else
        set(handles.tracingDataInfo,'String','No tracing data.','ForegroundColor','black');
        set(handles.loadTracingData,'Enable','off');
    end
end
% end