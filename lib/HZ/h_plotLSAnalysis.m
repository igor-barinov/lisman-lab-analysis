function h_plotLSAnalysis

global h_img

handles = h_img.currentHandles;


fnameobj = h_findobj(handles.h_imstack, 'Tag','currentFileName');
filename = get(fnameobj,'String');
fig = figure('Name',['Line Scan Analysis for ',filename],'Tag','LSAnalysisPlot');
cstr = {'red', 'blue', 'green', 'magenta', 'cyan', 'black'};

%h_img.lastLSAnalysis.time=h_img.lastLSAnalysis.time/60;%(nicko)
try
    for i = 1:length(h_img.lastLSAnalysis.roi)
        subplot(2,1,1); %(nicko)
        %subplot(3,1,1);
        hold on;
        axis([0 30000 -1000 50000]);%(nicko)
        %h_img.lastLSAnalysis.time=h_img.lastLSAnalysis.time*60;%(nicko)
        if get(handles.subtractBackground,'Value') && length(h_img.lastLSAnalysis.roi)>1 && i==1
            continue; % if subtract background is checked, don't plot background -- AZ
        else
            plot(h_img.lastLSAnalysis.time,h_img.lastLSAnalysis.roi(i).green, '-','Color',cstr{i});
        end
        title('Green');
        subplot(2,1,2);
        hold on;
        plot(h_img.lastLSAnalysis.time,h_img.lastLSAnalysis.roi(i).red,'-','Color',cstr{i});
        title('Red');
        %subplot(3,1,3);
        %hold on;
        %plot(h_img.lastLSAnalysis.time,h_img.lastLSAnalysis.roi(i).ratio,'-','Color',cstr{i});
        %title('ratio');
    end
catch
    delete(fig);
end

