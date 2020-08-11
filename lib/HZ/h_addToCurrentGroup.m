function h_addToCurrentGroup(filename)

global h_img

if isfield(h_img,'activeGroup') & ~isempty(h_img.activeGroup)
    if isempty(h_img.activeGroup.groupFiles)
        h_img.activeGroup.groupFiles = h_dir(filename);
    else
        for i = 1:length(h_img.activeGroup.groupFiles)
            [pname, fname] = h_analyzeFilename(h_img.activeGroup.groupFiles(i).name);
            groupFileNames(i) = {fname};
        end
        [pathname2, filename2] = h_analyzeFilename(filename);
        if isempty(strmatch(filename2,groupFileNames,'exact'))
            h_img.activeGroup.groupFiles(end+1) = h_dir(filename);
        end
    end
    [time, index] = sortrows({h_img.activeGroup.groupFiles.date}');
    h_img.activeGroup.groupFiles = h_img.activeGroup.groupFiles(index);
    groupFiles = h_img.activeGroup.groupFiles;
    save([h_img.activeGroup.groupPath,h_img.activeGroup.groupName],'groupFiles');
    [pname,fname,fExt] = fileparts(filename);
    if ~(exist(fullfile(pname,'Analysis'))==7)
        currpath = pwd;
        cd (pname);
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
    groupName = fullfile(h_img.activeGroup.groupPath,h_img.activeGroup.groupName);
    save(groupInfoFile,'groupName');
end
