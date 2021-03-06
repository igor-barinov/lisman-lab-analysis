function h_addFileToGroup(filename,groupName)

if ~iscell(filename)
    filename = {filename};
end

currentGroupName = groupName;

if exist(groupName)
    load(groupName,'-mat');
else
    groupFiles = [];
end

for i = 1:length(filename)
    [pname,fname,fExt] = fileparts(filename{i});
    
    if isempty(groupFiles)
        groupFiles = h_dir(filename{i});
    elseif isempty(strmatch(filename{i},{groupFiles.name}','exact'))
        groupFiles(end+1) = h_dir(filename{i});
    end
    
    if ~(exist(fullfile(pname,'Analysis'))==7)
        currpath = pwd;
        cd (pname);
        mkdir('Analysis');
        cd (currpath);
    end
    
    currentGroupFiles = groupFiles;
    groupInfoFile = fullfile(pname,'Analysis',[fname,'_grp.mat']);
    if exist(groupInfoFile)
        load (groupInfoFile);
        if ~strcmp(groupName,currentGroupName)
            try
                load (groupName,'-mat');
                I = strmatch(filename{i},{groupFiles.name}','exact');
                groupFiles(I) = [];
                save(groupName,'groupFiles');
            end
        end
    end
    groupName = currentGroupName;
    groupFiles = currentGroupFiles;
    save(groupInfoFile,'groupName');
    
end
[time, index] = sortrows({groupFiles.date}');
groupFiles = groupFiles(index);
save(groupName,'groupFiles');    
