function [ydata, time] = h_plotGroupFcn(handles)

global h_img
fig = findobj('Tag','h_imstackPlot','Selected','on');
if isempty(fig)
    fig = figure('Tag','h_imstackPlot','ButtonDownFcn','h_selectCurrentPlot');
    h_selectCurrentPlot;
end
fig = fig(1);
figure(fig);
plottools; % AZ
holdOpt = get(handles.holdOnOpt,'Value');
if holdOpt
    hold on;
else
    hold off;
end

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

% for i = 1:length({Aout.timestr}) %Nicko
%          timetest(1,i) = datenum({Aout(1,i).timestr})*24*60;
% end
% time = timetest - min(timetest);


% bleedthrough = 0.045;%for Dale's rig tdTomato
% bleedthrough = 0.035;%for Dale's rig DsRed (guessing)
% bleedthrough = 0.025;%for Dale's rig tdTomato in culture slice
% bleedthrough = 0.010;%for Dale's rig tdTomato 2013-05-27 (guessing
bleedStr = get(handles.bleedthrough,'string');
bleedValue = get(handles.bleedthrough,'value');
bleedStr = bleedStr{bleedValue};
pointer1 = strfind(bleedStr,'%');
if ~isempty(pointer1)
    bleedNumStr = bleedStr(6:pointer1-1);
    bleedthrough = str2double(bleedNumStr) * 0.01;
else
    bleedthrough = 0;
end

baselinePos = eval(['[',get(handles.baselinePos,'String'),']']);

time = time - time(baselinePos(end));

plotOpt = get(handles.plotDataOpt,'Value');

plotRoiOpt = get(handles.plotRoiOpt,'String');

% if ~isempty(strfind(lower(plotRoiOpt),'all'))
%     rois = 1:length(Aout(1).roi);
% else
%     rois = eval(['[',plotRoiOpt,']']);
%     rois = rois(rois<=length(Aout(1).roi));
% end

roiGrp = h_analyzeRoiStr(plotRoiOpt, length(Aout(1).roi));

roiVol = cell2mat({Aout.roiVol}');
plotIntOpt = get(handles.plotIntegration,'value');

for ii = 1:length(roiGrp)
    rois = roiGrp{ii};
    if ii>1
        hold on
    end


    switch plotOpt
        case {1}
            ydata = cell2mat({Aout.red}');
            if plotIntOpt
                ydata = ydata .* roiVol;
            end
            ydata = ydata(:,rois);
            for i = 1:size(ydata,2)
                ydata(:,i) = ydata(:,i)/mean(ydata(baselinePos,i));
            end
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Normalized Red Intensity');
            title(['Normalized Red Intensity for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Red Intensity for ',h_img.activeGroup.groupName]);
        case (2)
            ydata = cell2mat({Aout.green}');
            red_ydata = cell2mat({Aout.red}');
            ydata = ydata - red_ydata * bleedthrough;
            if plotIntOpt
                ydata = ydata .* roiVol;
            end
            ydata = ydata(:,rois);
            for i = 1:size(ydata,2)
                ydata(:,i) = ydata(:,i)/mean(ydata(baselinePos,i));
            end
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Normalized Green Intensity');
            title(['Normalized Green Intensity for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Green Intensity for ',h_img.activeGroup.groupName]);
        case {3}
            ydata = cell2mat({Aout.green}');
            if plotIntOpt
                ydata = ydata .* roiVol;
            end
            ydata = ydata(:,rois);
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Green Intensity');
            title(['Green Intensity for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Green Intensity for ',h_img.activeGroup.groupName]);
            
         case {4}
            ydata = cell2mat({Aout.red}');
            if plotIntOpt
                ydata = ydata .* roiVol;
            end
            ydata = ydata(:,rois);
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Red Intensity');
            title(['Red Intensity for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Red Intensity for ',h_img.activeGroup.groupName]);
             
        
         case {5}
              ydata = cell2mat({Aout.ratio}');
            ydata = ydata(:,rois);
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Green/Red Ratio');
            title(['Green/Red Ratio for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Green/Red Ratio for ',h_img.activeGroup.groupName]);
             
        case {6}
             ydata = cell2mat({Aout.ratio}');
            ref = mean(ydata(baselinePos,end));
            ydata = ydata(:,rois)/ref;
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Normalized Green/Red Ratio');
            title(['Normalized Green/Red Ratio for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Normalized Green/Red Ratio for ',h_img.activeGroup.groupName]);
            
           
            %     case 7
            %         ydata = cell2mat({Aout.red}');
            %         ydata = ydata(:,rois);
            %     case 8
            %
            %
        case (9)
            if isempty(strfind(lower(plotRoiOpt),'all'))
                rois1 = sort([rois,rois+1]);
            else
                rois1 = rois;
                rois = rois1(1:2:end-1);
            end
            ydata1 = cell2mat({Aout.ratio}');
            ydata1 = ydata1(:,rois1);
            ydata = log2((ydata1(:,1:2:end-1)-bleedthrough)./(ydata1(:,2:2:end)-bleedthrough));
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('SEI');
            title(['SEI ',h_img.activeGroup.groupName]);
            set(fig,'Name',['SEI ',h_img.activeGroup.groupName]);
       case {10}
            ydata = cell2mat({Aout.ratio}');
            for i = 1:size(ydata,1)
                ydata(i,:) = ydata(i,:)/mean(ydata(baselinePos,end));
            end
            ydata = ydata(:,rois);
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Normalized Green/Red Ratio');
            title(['Normalized Green/Red Ratio for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Normalized Green/Red Ratio for ',h_img.activeGroup.groupName]);
        
        case (11) %rough programming Haining 2013-05-13; modified by nikolaio
            %fig_r = figure(1457); %red plot
            fig_r = fig;
            set(fig_r,'Tag','h_imstackPlot','ButtonDownFcn','h_selectCurrentPlot');
            if ii==1
                if holdOpt
                    hold on;
                else
                    hold off;
                end
            else
                hold on;
            end
            ydata = cell2mat({Aout.red}');
            if plotIntOpt
                ydata = ydata .* roiVol;
            end
            ydata = ydata(:,rois);
            for i = 1:size(ydata,2)
                ydata(:,i) = ydata(:,i)/mean(ydata(baselinePos,i));
            end
            h = h_plotGroupFcn_plot(time,ydata,handles);
%             set(h,'color',UserData.lineColor);
            set(h,'color','red');
            xlabel('Time (min)');
            ylabel('Normalized Red Intensity');
            title(['Normalized Red Intensity for ',h_img.activeGroup.groupName]);
            set(fig_r,'Name',['Red Intensity for ',h_img.activeGroup.groupName]);

            LineData.groupFiles = h_img.activeGroup.groupFiles;
            LineData.timeLastClick = clock;
            set(h,'UserData',LineData);

            x = time(end)*1.02;
            if get(handles.averageOpt,'Value')
                y = mean(ydata(end,:));
                text(x,y,['avg',num2str(rois)]);
            else
                for i = 1:length(rois)
                    y = ydata(end,i);
                    text(x,y,num2str(rois(i)));
                end
            end
%             set(handles.xLimSetting,'String','Auto');
%             set(handles.yLimSetting,'String','Auto');
            if ii == length(roiGrp)
                hold off;
            end
            hold on;
            figure(fig); %green plot
            h_selectCurrentPlot;
            ydata = cell2mat({Aout.green}');
            red_ydata = cell2mat({Aout.red}');
            ydata = ydata - red_ydata * bleedthrough;
            if plotIntOpt
                ydata = ydata .* roiVol;
            end
            ydata = ydata(:,rois);
            for i = 1:size(ydata,2)
                ydata(:,i) = ydata(:,i)/mean(ydata(baselinePos,i));
            end
            h = h_plotGroupFcn_plot(time,ydata,handles);
            set(h,'color','green');
            xlabel('Time (min)');
            ylabel('Normalized Green and Red Intensity');
            title(['Normalized Green and Red Intensity for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Green Intensity for ',h_img.activeGroup.groupName]);
        case 12
            ydata = cell2mat({Aout.green}');
            red_ydata = cell2mat({Aout.red}');
            ydata = ydata - red_ydata * bleedthrough;
            if plotIntOpt
                ydata = ydata .* roiVol;
                red_ydata = red_ydata.* roiVol;
            end
            ydata = ydata(:,rois);
            red_ydata = red_ydata (:,rois);
            for i = 1:size(ydata,2)
                ydata(:,i) = ydata(:,i)/(mean(red_ydata(baselinePos,i))*0.025*3);% 3X baseline bleedthrough; on dale's rig bleed through is 3.75%.
            end
            h = h_plotGroupFcn_plot(time,ydata,handles);
            xlabel('Time (min)');
            ylabel('Normalized Green Intensity');
            title(['Normalized Green Intensity for ',h_img.activeGroup.groupName]);
            set(fig,'Name',['Green Intensity for ',h_img.activeGroup.groupName]);
    end

    h_copy(horzcat(time, ydata)');%to copy the data to clipboard
    %******add by cong
    results.time = time;
    results.redInt = ydata;
    save([filename(1:end-10) '.mat'],'results');
    %*end
    LineData.groupFiles = h_img.activeGroup.groupFiles;
    LineData.timeLastClick = clock;
    set(h,'UserData',LineData);


    x = time(end)*1.02;
    if get(handles.averageOpt,'Value')
        y = mean(ydata(end,:));
        text(x,y,['avg',num2str(rois)]);
    else
        for i = 1:length(rois)
            y = ydata(end,i);
            text(x,y,num2str(rois(i)));
        end
    end
%     set(handles.xLimSetting,'String','Auto');
%     set(handles.yLimSetting,'String','Auto');

end

h_resetXYLimit(handles);

hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = h_plotGroupFcn_plot(time,ydata,handles)

UserData = get(handles.morePlotOpt,'UserData');
if isfield(UserData,'lineStyle')
    lineStyle = UserData.lineStyle;
else
    lineStyle = '-o';
end

if get(handles.averageOpt,'Value')
    errorBarOpt = get(handles.errorBarOpt,'Value');
    switch errorBarOpt
        case {1}
            h = plot(time,mean(ydata,2),lineStyle);
        case {2}
            h = errorbar(time,mean(ydata,2),std(ydata,0,2),lineStyle);
        case {3}
            h = errorbar(time,mean(ydata,2),std(ydata,0,2)/sqrt(size(ydata,2)),lineStyle);
    end
    set(h,'ButtonDownFcn','h_selectLine');
else
    h = plot(time,ydata,lineStyle,'ButtonDownFcn','h_selectLine');
end

set(gca, 'ButtonDownFcn','h_unSelectLine');

if isfield(UserData,'lineColor') & isempty(strfind(lower(UserData.lineColor),'auto'))
    set(h,'Color',UserData.lineColor);
end

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
