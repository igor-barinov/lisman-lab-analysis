function h_mergeTwoGroups(handles)

global h_img

[fname,pname] = uigetfile('*.grp','Select an group file to merge with');
if ~pname==0
    filestr = [pname, fname];
    if exist(filestr) == 2
        load(filestr,'-mat');
        groupName = [h_img.activeGroup.groupPath,h_img.activeGroup.groupName];
        for i = 1:length(groupFiles)
            [pathname, filename] = h_analyzeFilename(groupFiles(i).name);
            groupInfoFile = fullfile(pathname,'Analysis',[filename(1:end-4),'_grp.mat']);
            save(groupInfoFile,'groupName');
        end    
        h_img.activeGroup.groupFiles = [h_img.activeGroup.groupFiles,groupFiles];
        [time, index] = sortrows({h_img.activeGroup.groupFiles.date}');
        h_img.activeGroup.groupFiles = h_img.activeGroup.groupFiles(index);
        groupFiles = h_img.activeGroup.groupFiles;
        save([h_img.activeGroup.groupPath,h_img.activeGroup.groupName],'groupFiles');
        delete(filestr);
        h_updateInfo(handles);
    end
end


