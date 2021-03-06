function Bout = h_determinBleedthroughUsingCorr

global h_img

handles = h_img.currentHandles;

plotOpt = get(handles.plotDataOpt,'Value');

plotRoiOpt = get(handles.plotRoiOpt,'String');

for i = 1:length(h_img.activeGroup.groupFiles)
    [pathname, filename] = h_analyzeFilename(h_img.activeGroup.groupFiles(i).name);
    roi_UData = get(handles.roiControl,'UserData');
    analysisNumber = roi_UData.analysisNumber.Value;
    if analysisNumber == 1
        analysisNumber = [];
    end
    dataFilename = fullfile(pathname,'Analysis',[filename(1:end-4),'_zroi',num2str(analysisNumber),'.mat']);
    if exist(dataFilename, 'file')
        data = load(dataFilename);
        Aout(i) = data.Aout;
    else
        dataFilename = fullfile(fileparts(h_img.activeGroup.groupPath(1:end-1)), 'Analysis',[filename(1:end-4),'_zroi',num2str(analysisNumber),'.mat']);
        if exist(dataFilename, 'file')
            data = load(dataFilename);
            Aout(i) = data.Aout;
        elseif exist(fullfile('Analysis',[filename(1:end-4),'_zroi',num2str(analysisNumber),'.mat']), 'file')
            dataFilename = fullfile('Analysis',[filename(1:end-4),'_zroi',num2str(analysisNumber),'.mat']);
            data = load(dataFilename);
            Aout(i) = data.Aout;     
        end
    end
end

try
    if isfield(Aout,'timestr')
        time = datenum({Aout.timestr})*24*60;
    else
        time = [Aout.time]*24*60;
    end
catch
    time = [Aout.time]*24*60;
end
time = time - min(time);

roiGrp = h_analyzeRoiStr(plotRoiOpt, length(Aout(1).roi));

roiVol = cell2mat({Aout.roiVol}');
plotIntOpt = get(handles.plotIntegration,'value');

rois = roiGrp{end};

ydata = cell2mat({Aout.green}');
red_ydata = cell2mat({Aout.red}');

if plotIntOpt
    ydata = ydata .* roiVol;
    red_ydata = red_ydata .* roiVol;
end

ydata = ydata(:,rois);
red_ydata = red_ydata(:,rois);



i = 1;
potentialBleedthrough = 0:0.0025:0.2;
for bleedthrough = potentialBleedthrough
    corrected_ydata =ydata - red_ydata.*bleedthrough;
    for j = 1:size(ydata,2)
        norm_ydata(:,j) = corrected_ydata(:,j)/corrected_ydata(1,j);
        norm_red_ydata(:,j) = red_ydata(:,j)/red_ydata(1,j);
    end
    [c, p] = corrcoef(norm_ydata, norm_red_ydata);
    coef(i) = c(1,2);
    pp(i) = p(1,2);
    i = i+1;
end

[min_coef, I] = min(abs(coef));
Bout.bleedthrough = potentialBleedthrough(I);
Bout.testedValue = potentialBleedthrough;
Bout.corrcoef = coef;
Bout.p = pp;
    


function roiGrp = h_analyzeRoiStr(str, roi_n)

if ~isempty(strfind(lower(str),'all'))
    roiGrp{1} = 1:roi_n;
else
    I = strfind(str,'/');
    I = horzcat(0,I, length(str)+1);
    for i = 1:length(I)-1
        roiGrp{i} = eval(['[',str(I(i)+1:I(i+1)-1),']']);
    end
end