function value = Nick_Analysis
%global yphys 
%global windowsize


%set windows for analyis
windowsize = 10;
baseLine = [0.1, 9]; %ms  baseline window in ms (from to)
timewindow = [12, 20];% ms peak  window in ms (from to)

% set dir
a = dir('yphys*.mat');
f1 = ones(windowsize, 1)/windowsize;

for i=1:length(a)
    load(a(i).name);
    data1 = eval(a(i).name(1:end-4));
    data_yphys = data1.data(:,2);
    outputRate = data1.outputRate/1000;
    data_yphys = data_yphys - mean(data_yphys(baseLine(1)*outputRate : baseLine(2)*outputRate)); 
    data2 = imfilter(data_yphys, f1, 'replicate');
    data3 = data2(timewindow(1)*outputRate : timewindow(2)*outputRate);
    value(i) = max(data3);   
end

