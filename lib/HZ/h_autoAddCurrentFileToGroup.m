function h_autoAddCurrentFileToGroup

global h_img state;

% currentFilename = get(handles.currentFileName,'String');
% [pname,fname,fExt] = fileparts(currentFilename);
pname = state.files.savePath;
basename = state.files.baseName;
str1 = '000';
str2 = num2str(state.files.fileCounter-1);
str1(end-length(str2)+1:end) = str2;
% filename1 = [basename, str1, 'max.tif'];
fname = [basename, str1, '.tif'];

pos = state.motor.position;
groupName = fullfile(pname,'Analysis',[basename,'pos',num2str(pos),'.grp']);

if ~(exist(fullfile(pname,'Analysis'))==7)
    currpath = pwd;
    cd (pname);
    mkdir('Analysis');
    cd (currpath);
end

h_addFileToGroup(fullfile(pname,fname),groupName);

if isfield(h_img,'activeGroup')
    h_openGroup(h_img.activeGroup.groupName, h_img.activeGroup.groupPath, h_img.currentHandles);
    h_updateInfo(h_img.currentHandles);
end



