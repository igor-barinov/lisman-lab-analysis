function h_executeChangeGroupDataPath(handles)

global h_img;

formerpath = lower(get(handles.formerPath,'String'));
currentpath = lower(get(handles.currentPath,'String'));
I = strmatch(formerpath,lower({h_img.activeGroup.groupFiles.name}'));
for i = I'
    h_img.activeGroup.groupFiles(i).name = [currentpath,h_img.activeGroup.groupFiles(i).name(length(formerpath)+1:end)];
    if exist(h_img.activeGroup.groupFiles(i).name)
        [pname,fname,fExt] = fileparts(h_img.activeGroup.groupFiles(i).name);
        if ~(exist(fullfile(pname,'Analysis'))==7)
            currpath = pwd;
            cd (pathname);
            mkdir('Analysis');
            cd (currpath);
        end
        groupInfoFile = fullfile(pname,'Analysis',[fname,'_grp.mat']);
        if exist(groupInfoFile)
            load (groupInfoFile);
            if ~strcmp(groupName,[h_img.activeGroup.groupPath,h_img.activeGroup.groupName])
                try
                    load (groupName,'-mat');
                    I = strmatch(filename,{groupFiles.name}','exact');
                    groupFiles(I) = [];
                    save(groupName,'groupFiles');
                end
            end
        end
        groupName = [h_img.activeGroup.groupPath,h_img.activeGroup.groupName];
        save(groupInfoFile,'groupName');
    end
end

disp([num2str(length(I)), ' files changed']);

groupFiles = h_img.activeGroup.groupFiles;
save([h_img.activeGroup.groupPath,h_img.activeGroup.groupName],'groupFiles');
