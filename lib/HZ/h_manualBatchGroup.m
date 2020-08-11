function h_manualBatchGroup(basename,groupNumbers)

global h_img;

handles = h_img.currentHandles;
pname = pwd;

if ~iscell(groupNumbers)
    groupNumbers = {groupNumbers};
end

if ~(exist(fullfile(pname,'Analysis'))==7)
    mkdir('Analysis');
end

for i = 1:length(groupNumbers)        
    groupName = fullfile(pname,'Analysis',[basename,'pos',num2str(i),'.grp']);
    for j = 1:length(groupNumbers{i})
        str1 = '000';
        str2 = num2str(groupNumbers{i}(j));
        str1(end-length(str2)+1:end) = str2;
        files(j) = h_dir([basename,str1,'.tif']);
    end
    h_addFileToGroup({files.name}',groupName);
    clear('files');
end
        
% if isfield(h_img,'activeGroup')
%     h_openGroup(h_img.activeGroup.groupName, h_img.activeGroup.groupPath, handles)
% end

h_updateInfo(handles);