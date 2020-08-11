function Aout = h_loadPAdata

global h_img;

for i = 1:length(h_img.activeGroup.groupFiles)
    [pathname, filename] = h_analyzeFilename(h_img.activeGroup.groupFiles(i).name);
    dataFilename = fullfile(pathname,'Analysis',[filename(1:end-4),'_roim.mat']);
    if exist(dataFilename)
        data = load(dataFilename);
        Aout(i) = data.Aout;
    end
end
