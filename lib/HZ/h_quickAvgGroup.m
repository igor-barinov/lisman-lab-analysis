function Aout = h_quickAvgGroup(baseNames,groupNumbers,ptyY,ptyX,baseline,baselineMethod)

%%%%%%%%%% Initialization of variables

if ~(exist('groupNumbers')==1)|isempty(groupNumbers)
    groupNumbers = {'all'};
end

if ~(exist('ptyY')==1)|isempty(ptyY)
    ptyY = 'red';
end

if ~(exist('ptyX')==1)|isempty(ptyX)
    ptyX = 'time';
end

if ~(exist('baseline')==1)|isempty(baseline)
    baseline = 1:4;
end

if ~(exist('baselineMethod')==1)|isempty(baselineMethod)
    baselineMethod = 'divide';
end

p = '\haining\data';

if ~iscell(baseNames)
    baseNames = {baseNames};
end

if ~iscell(groupNumbers)
    groupNumbers = {groupNumbers};
end

if length(groupNumbers)<length(baseNames)
    groupNumbers(end+1:length(baseNames)) = {'all'};
end

%%%%%%%%%% Generate groupName List
groupNames = {};
for i = 1:length(baseNames)
    folderName = baseNames{i};
    while folderName(end)>'9'
        folderName = folderName(1:end-1);
    end
        
    pname = fullfile(p,folderName,'Analysis');
    
    if strcmp(lower(groupNumbers{i}),'all')|isempty(groupNumbers{i})
        d = h_dir(fullfile(pname,[baseNames{i},'*.grp']));
        groupNames = [groupNames;{d.name}'];
    else
        for j = 1:length(groupNumbers{i})
            groupName = fullfile(pname,[baseNames{i},'pos',num2str(groupNumbers{i}(j)),'.grp']);
            if exist(groupName) == 2
                groupNames = [groupNames;{groupName}];
            else
                disp([groupName, ' does not exist!']);
            end
        end
    end
end

I = [];
for i = 1:length(groupNames)
    if ~isempty(strfind(groupNames{i},'_max.grp'))
        I = [I,i];
    end
end
groupNames(I) = [];

if ~isempty(groupNames)
    disp(['Total ',num2str(length(groupNames)),' group(s).']);
    fig_on = 1;
    Aout = h_avgGroup(groupNames,ptyY,ptyX, baseline, fig_on);
else
    disp('No valid group name!');
end
    