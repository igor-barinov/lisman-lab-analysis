function h_selectLine

global h_img;

h = findobj(gca,'Type','Line');
set(h,'Selected','off','LineWidth',0.5,'MarkerSize',6);
set(gco,'Selected','on','LineWidth',1.5,'MarkerSize',6);

try
    ss_selectCurrentPlot;
end

t0 = clock;
h_gco = gco;
UserData = get(h_gco,'UserData');
if isfield(UserData,'timeLastClick') & etime(t0,UserData.timeLastClick) < 0.3
    point1 = get(gca,'CurrentPoint');
    point1 = point1(1,1:2);
    xdata = get(h_gco,'XData');
    ydata = get(h_gco,'YData');
    deltaX = abs(xdata-point1(1));
    [x,I] = min(deltaX);
    dist1 = h_calcDistance(point1,[xdata(I),ydata(I)]);
    if I > 1
        dist2 = h_calcDistance(point1,[xdata(I-1),ydata(I-1)]);
    else
        dist2 = Inf;
    end
    if I < length(xdata)
        dist3 = h_calcDistance(point1,[xdata(I+1),ydata(I+1)]);
    else
        dist3 = Inf;
    end
    if dist2>3*dist1 & dist3>3*dist1
%         [pname,fname,fExt] = fileparts(UserData.groupFiles(I).name);
%         h_openFile([fname,fExt],pname);
        
        [newPath,newFilename] = h_analyzeFilename(UserData.groupFiles(I).name);
        if exist(UserData.groupFiles(I).name,'file')
            h_openFile(newFilename,newPath);
        elseif exist(fullfile(fileparts(h_img.activeGroup.groupPath(1:end-1)), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,fileparts(h_img.activeGroup.groupPath(1:end-1)));
        elseif exist(fullfile(h_img.activeGroup.groupPath(1:end-1), newFilename),'file') %in case the entire folder is moved
            h_openFile(newFilename,h_img.activeGroup.groupPath(1:end-1));
        elseif exist(newFilename,'file')
            h_openFile(newFilename,pwd);
        end
    end
end
UserData.timeLastClick = t0;
set(h_gco,'UserData',UserData);