function valueMax = Nick_Analysis
%global yphys 
%global windowsize


%set windows for analyis
windowsize = 10;
baseLine = [0.1, 9]; %ms  baseline window in ms (from to)%
timewindow = [16, 18]; % ms peak  window in ms (from to) %originally [12, 20]]

% set dir
a = dir('yphys*.mat');
f1 = ones(windowsize, 1)/windowsize;

for i=1:length(a)
    load(a(i).name);
    data1 = eval(a(i).name(1:end-4));
    data_yphys = data1.data(:,2); 
    
    %%%

    figure(11); plot(data1.data(:,1),data_yphys);
    hold on;
    meanpeak = mean(data_yphys(timewindow(1):timewindow(2)));
    x1 = [timewindow(1),timewindow(1)]; x2 = [timewindow(2),timewindow(2)];
    ymin = meanpeak - 10; ymax = meanpeak + 50;
    y = [ymin, ymax];
    plot(x1, y,'g-'); plot(x2, y,'g-');
    uicontrol('style','text','Position',[400 45 120 20],'String',a(i).name);
    %hold off;
    %%%
    
    outputRate = data1.outputRate/1000;
    data_yphys = data_yphys - mean(data_yphys(baseLine(1)*outputRate : baseLine(2)*outputRate)); 
    data2 = imfilter(data_yphys, f1, 'replicate');
    data3 = data2(timewindow(1)*outputRate : timewindow(2)*outputRate);
    %valueMax(i) = max(data3); 
    valueMax(i) = mean(data3);
    
    figure (12); plot (valueMax);
    hold on
    
end

