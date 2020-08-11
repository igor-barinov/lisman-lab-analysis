function Aout = h_avgGroup(groupNames,propertyY,propertyX, baseline, fig_on)

if ~(exist('propertyX')==1)|isempty(propertyX)
    propertyX = 'time';
end

if ~(exist('baseline')==1)|isempty(baseline)
    baseline = [1:4];
end

if ~(exist('fig_on')==1)|isempty(fig_on)
    fig_on = 1;
end


if ~iscell(groupNames)
    groupNames = mat2cell(groupNames);
end

for i = 1:length(groupNames)
    data = h_loadGroup(groupNames{i});
    ydata{i} = cell2mat(eval(['{data.',propertyY,'}'])');
    if ~strcmp(lower(propertyX),'time')
        xdata{i} = cell2mat(eval(['{data.',propertyX,'}'])');
    else
        xdata{i} = datenum({data.timestr})*24*60;
    end
end

y_avg = [];y_sd = [];
for i = 1:size(ydata{1},2)
    y{i} = [];
    for j = 1:length(ydata)
        y{i} = [y{i},ydata{j}(:,i)./mean(ydata{j}(baseline,i))];
    end
    y_avg = [y_avg,mean(y{i},2)];
    y_sd = [y_sd,std(y{i},[],2)];
end
x_avg = [];x_sd = [];
for i = 1:size(xdata{1},2)
    x{i} = [];
    for j = 1:length(xdata)
        if strcmp(lower(propertyX),'time')
            x2 = xdata{j}(:,i);
        else
            x2 = xdata{j}(:,i)./mean(xdata{j}(baseline,i));
        end
        x{i} = [x{i},x2];
    end
    x_avg = [x_avg,mean(x{i},2)]; 
    x_sd = [x_sd,std(x{i},[],2)];
end
if strcmp(lower(propertyX),'time')
    x_avg = x_avg-x_avg(1);
end

Aout.y_byGroup = ydata;
Aout.y_byROI = y;
Aout.y_avg = y_avg;
Aout.y_sd = y_sd;
Aout.x_byGroup = xdata;
Aout.x_byROI = x;
Aout.x_avg = x_avg;
Aout.x_sd = x_sd;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cstr = {'red', 'blue', 'green', 'magenta', 'cyan', 'black'};

if fig_on
    figure;
    hold on;
    for i = 1:size(y_avg,2)
        ydata = y_avg(:,i);
        sd = y_sd(:,i);
        if size(x_avg,2)>1
            xdata = x_avg(:,i);
        else
            xdata = x_avg;
        end
        h = errorbar(xdata,ydata,sd/sqrt(length(groupNames)),'-o');
        set(h,'Color',cstr{i});
    end
end