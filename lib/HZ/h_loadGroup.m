function Aout = h_loadGroup(groupName,analysisNumber)

if ~(exist('analysisNumber')==1)
    analysisNumber = [];
end
[pname,fname,fExt] = fileparts(groupName);
if isempty(fExt)
    groupName = [groupName,'.grp'];
end
load (groupName,'-mat');

try
    for i = 1:length(groupFiles)
        [pathname, filename] = h_analyzeFilename(groupFiles(i).name);
        if analysisNumber == 1
            analysisNumber = [];
        end
        dataFilename = fullfile(pathname,'Analysis',[filename(1:end-4),'_zroi',num2str(analysisNumber),'.mat']);
        if exist(dataFilename)
            data = load(dataFilename);
            Aout(i) = data.Aout;
        else
            error;
        end
    end
catch
    error(['ERROR! Current File is ',filename]);
end
