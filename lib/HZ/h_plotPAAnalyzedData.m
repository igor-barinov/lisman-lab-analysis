function h_plotPAAnalyzedData(handles)

global h_img

fig = findobj('Tag','h_imstackPlot','Selected','on');
if isempty(fig)
    fig = figure('Tag','h_imstackPlot','ButtonDownFcn','h_selectCurrentPlot');
    h_selectCurrentPlot;
end
figure(fig);
set(fig,'Name',['PA Analysis for ',get(handles.currentFileName,'String')]);

holdOpt = get(handles.paHoldOnOpt,'Value');
if holdOpt
    hold on;
else
    hold off;
end

plotRoiOpt = get(handles.paPlotRoiOpt,'String');
if ~isempty(strfind(lower(plotRoiOpt),'all'))
    rois = 1:length(h_img.lastPaAnalysis.roi);
else
    rois = eval(['[',plotRoiOpt,']']);
    rois = rois(rois<=length(h_img.lastPaAnalysis.roi));
end

plotChannelOpt = get(handles.paPlotChannelOpt,'Value');

if ~isempty(h_img.lastPaAnalysis.PA_frames)
    time = h_img.lastPaAnalysis.time - h_img.lastPaAnalysis.time(h_img.lastPaAnalysis.PA_frames(1));  
else
    time = h_img.lastPaAnalysis.time - h_img.lastPaAnalysis.time(1);
end
x = time(end)*1.02;

UserData = get(handles.morePlotOpt,'UserData');
if isfield(UserData,'lineStyle')
    lineStyle = UserData.lineStyle;
else
    lineStyle = '-';
end


if plotChannelOpt==1 | plotChannelOpt == 3
    data = cell2mat({h_img.lastPaAnalysis.green{rois}}')';
    h = plot(time,data,lineStyle,'ButtonDownFcn','h_selectLine');
    set(gca, 'ButtonDownFcn','h_unSelectLine');
    if isfield(UserData,'lineColor') & isempty(strfind(lower(UserData.lineColor),'auto'))
        set(h,'Color',UserData.lineColor);
    elseif plotChannelOpt == 3
        set(h,'Color','blue');
    end
    hold on;
    for i = 1:length(rois)
        text(x,data(end,i),num2str(rois(i)));
    end
    xlabel('Time (s)');
    ylabel('Intensity');
end

if plotChannelOpt==2 | plotChannelOpt == 3
    data = cell2mat({h_img.lastPaAnalysis.red{rois}}')';
    h = plot(time,data,lineStyle,'ButtonDownFcn','h_selectLine');
    set(gca, 'ButtonDownFcn','h_unSelectLine');
    if isfield(UserData,'lineColor') & isempty(strfind(lower(UserData.lineColor),'auto'))
        set(h,'Color',UserData.lineColor);
    elseif plotChannelOpt == 3
        set(h,'Color','red');
    end
    for i = 1:length(rois)
        text(x,data(end,i),num2str(rois(i)));
    end
    xlabel('Time (s)');
    ylabel('Intensity');
end

if plotChannelOpt==4
    data = (cell2mat({h_img.lastPaAnalysis.green{rois}}')')./(cell2mat({h_img.lastPaAnalysis.red{rois}}')');
    h = plot(time,data,lineStyle,'ButtonDownFcn','h_selectLine');
    set(gca, 'ButtonDownFcn','h_unSelectLine');
    if isfield(UserData,'lineColor') & isempty(strfind(lower(UserData.lineColor),'auto'))
        set(h,'Color',UserData.lineColor);
    end
    for i = 1:length(rois)
        text(x,data(end,i),num2str(rois(i)));
    end
    xlabel('Time (s)');
    ylabel('G/R ratio');
end

if plotChannelOpt==5
    data = (cell2mat({h_img.lastPaAnalysis.green{rois}}')')./(cell2mat({h_img.lastPaAnalysis.red{rois}}')');
    for i = 1:size(data,2)
        ydata = data(:,i);
        baseline = mean(ydata(1:h_img.lastPaAnalysis.PA_frames(1)-1));
        %         amplitude = max(ydata) - baseline;
        amplitude = ydata(h_img.lastPaAnalysis.PA_frames(end)+1) - baseline;
        data(:,i) = (ydata - baseline) / amplitude;
    end
    
    h = plot(time,data,lineStyle,'ButtonDownFcn','h_selectLine');
    set(gca, 'ButtonDownFcn','h_unSelectLine');
    if isfield(UserData,'lineColor') & isempty(strfind(lower(UserData.lineColor),'auto'))
        set(h,'Color',UserData.lineColor);
    end
    for i = 1:length(rois)
        text(x,data(end,i),num2str(rois(i)));
    end
    xlabel('Time (s)');
    ylabel('G/R ratio');
end

if plotChannelOpt==6
    data = [];
    for i = 1:length(rois)
        ydata = h_img.lastPaAnalysis.green{i}./mean(h_img.lastPaAnalysis.red{i}(1:h_img.lastPaAnalysis.PA_frames(1)-1));
        baseline = mean(ydata(1:h_img.lastPaAnalysis.PA_frames(1)-1));
        amplitude = max(ydata) - baseline;
        ydata = (ydata - baseline) / amplitude;
        data = vertcat(data,ydata);
    end
    h = plot(time,data,lineStyle,'ButtonDownFcn','h_selectLine');
    set(gca, 'ButtonDownFcn','h_unSelectLine');
    if isfield(UserData,'lineColor') & isempty(strfind(lower(UserData.lineColor),'auto'))
        set(h,'Color',UserData.lineColor);
    end
    for i = 1:length(rois)
        text(x,data(end,i),num2str(rois(i)));
    end
    xlabel('Time (s)');
    ylabel('G/R ratio');
end

if plotChannelOpt==7
    data = [];
    numOfBaseline = 2;
    for i = 1:length(rois)
        green = h_img.lastPaAnalysis.green{i} - h_img.lastPaAnalysis.green{i}(1);
        red = h_img.lastPaAnalysis.red{i} - h_img.lastPaAnalysis.red{i}(1);
        data = vertcat(data,green(numOfBaseline+1:end)./red(numOfBaseline+1:end));
    end
    h = plot(time(numOfBaseline+1:end),data,lineStyle,'ButtonDownFcn','h_selectLine');
    set(gca, 'ButtonDownFcn','h_unSelectLine');
    if isfield(UserData,'lineColor') & isempty(strfind(lower(UserData.lineColor),'auto'))
        set(h,'Color',UserData.lineColor);
    end
    for i = 1:length(rois)
        text(x,data(end,i),num2str(rois(i)));
    end
    xlabel('Time (s)');
    ylabel('G/R ratio');
end

set(handles.xLimSetting,'String','Auto');
set(handles.yLimSetting,'String','Auto');


hold off;
