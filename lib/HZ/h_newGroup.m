function h_newGroup(handles)

global h_img;

flag = 1;

[fname,fpath] = uiputfile('*.grp','Please specify a group name.');
if fname == 0
    return;
elseif isempty(strfind(fname,'.'))
    fname = [fname,'.grp'];
end
        
if exist([fpath,fname])
    load([fpath,fname],'-mat');
    for i = 1:length(groupFiles)
        [pathname, filename] = h_analyzeFilename(groupFiles(1).name);
        groupInfoFile = fullfile(pathname,'Analysis',[filename(1:end-4),'_grp.mat']);
        if exist(groupInfoFile)
            delete(groupInfoFile);
        end
    end
end

groupFiles = [];
save([fpath,fname],'groupFiles');
set(handles.currentGroupInfo,'String',['Active Group: ',fname],'FontSize',9);
h_img.activeGroup.groupName = fname;
h_img.activeGroup.groupPath = fpath;
h_img.activeGroup.groupFiles = groupFiles;
h_updateInfo(handles);


% currentFilename = get(handles.currentFileName,'String');
% groupFiles = dir(currentFilename);


% [pathname, filename] = h_analyzeFilename(currentFilename);
% if ~(exist([pathname,'Analysis'])==7)
%     currpath = pwd;
%     cd (pathname);
%     mkdir('Analysis');
%     cd (currpath);
% end
% groupInfoFile = [pathname,'Analysis\',filename(1:end-4),'_grp.mat'];
% save(groupInfoFile,'groupName');
