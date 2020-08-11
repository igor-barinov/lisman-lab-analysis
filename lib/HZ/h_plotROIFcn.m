function h_plotROIFcn

global h_img;

handles = h_img.currentHandles;
h_loadAnalyzedRoiData(handles);
Aout = h_img.lastCalcROI;

fig = findobj('Tag','h_imstackPlot','Selected','on');
if isempty(fig)
    fig = figure('Tag','h_imstackPlot','ButtonDownFcn','h_selectCurrentPlot');
    h_selectCurrentPlot;
end
figure(fig);
set(fig,'Name',[get(handles.currentFileName,'String')]);

holdOpt = h_img.state.groupPlot.holdOnOpt.value;
if holdOpt
    hold on;
else
    hold off;
end

bleedthrough = 0.03;
plotOpt = h_img.state.roiControl.plotROIOpt.value;

switch plotOpt
    case 1
        red = [];
        for i = 1:length(Aout.red)
            red = [red,Aout.red(i)*sum(Aout.roi(i).BW(:))*length(Aout.roi(i).z)];
        end
        plot(red(1:2:end),Aout.ratio(1:2:end),'bo');
        hold on;
        plot(red(2:2:end),Aout.ratio(2:2:end),'ro');
        hold off
        xlabel('Red Intensity');
        ylabel('G/R ratio');
    case 2
        if mod(length(Aout.red),2)
            normalized_factor = Aout.red(end)/(h_img.header.acq.pixelTime*1e6);
        else
            normalized_factor = 1/(h_img.header.acq.pixelTime*1e6);
        end
        
        red = [];
        for i = 1:2:length(Aout.red)-1
            red = [red,Aout.red(i)*sum(Aout.roi(i).BW(:))*length(Aout.roi(i).z)/normalized_factor];
        end

%         red = Aout.red(1:2:end-1)*sum(Aout.roi.BW(:))*length(Aout.roi.z)/normalized_factor;
        SEI = log2((Aout.ratio(1:2:end-1)-bleedthrough)./(Aout.ratio(2:2:end)-bleedthrough));
        plot(red,SEI,'o');
        xlabel('Red Intensity');
        ylabel('Spine Enrichment Index');
end