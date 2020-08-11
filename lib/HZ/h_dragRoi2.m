function h_dragRoi2;

%h_showRoi2;  Nicko
h_showRoi; %Nick o

point1 = get(gca,'CurrentPoint'); % button down detected
point1 = point1(1,1:2);              % extract x and y

roiobj = findobj(gcf,'Tag','HROI');
set(roiobj, 'Selected','off');
bgroiobj = findobj(gcf,'Tag','HBGROI');
set(bgroiobj, 'Selected','off');
% roeobj = findobj(gcf,'Tag','SSROE');
% set(roeobj, 'Selected','off');
set(gco,'Selected','on','SelectionHighlight','off');

t0 = clock;
UserData = get(gco,'UserData');
if isfield(UserData,'timeLastClick') & etime(t0,UserData.timeLastClick) < 0.3
    delete(gco);
    delete(UserData.texthandle);
    h = findobj(gcf,'Tag','HROI');
    if length(h) < length(roiobj)
        
        UserData = cell2mat(get(h,'UserData'));
        ind = [UserData.number];
        [Y I] = sort(ind);
        UserData = UserData(I);
        
        for i = 1:length(UserData)
            UserData(i).number = i;
            set(UserData(i).texthandle,'String',num2str(i),'UserData',UserData(i));
            set(UserData(i).ROIhandle,'UserData',UserData(i));
        end
    end
    return;
else
    UserData.timeLastClick = t0;
    set(gco,'UserData',UserData);
end

currentGcaUnit = get(gca,'Unit');
set(gca,'Unit','normalized');
rectFigure = get(gcf, 'Position');
rectAxes = get(gca, 'Position');
set(gca,'Unit',currentGcaUnit);

Xlimit = get(gca, 'XLim');
Ylimit = get(gca, 'Ylim');
Ylim = Ylimit(2)-Ylimit(1);
Xlim = Xlimit(2)-Xlimit(1);
xmag = (rectFigure(3)*rectAxes(3))/Xlim;  %pixel/screenpixel
xoffset =rectAxes(1)*rectFigure(3);
ymag = (rectFigure(4)*rectAxes(4))/Ylim;
yoffset = rectAxes(2)*rectFigure(4);

handles = guihandles(gca);
try
    lockROI = get(handles.lockROI(1),'Value');
catch
    UData = get(handles.roiControl,'UserData');
    lockROI = UData.lockROI.Value;
end
if lockROI
    h = [h_findobj(gca,'Tag','HROI');h_findobj(gca,'Tag','HBGROI')];
else
    h = gco;
end

for i = 1:length(h)
    UserData(i) = get(h(i),'UserData');
    RoiRect(i,:) = [min(UserData(i).roi.xi),min(UserData(i).roi.yi),...
            max(UserData(i).roi.xi)-min(UserData(i).roi.xi),max(UserData(i).roi.yi)-min(UserData(i).roi.yi)];
    rect1w = RoiRect(i,3)*xmag;
    rect1h = RoiRect(i,4)*ymag;
    rect1x = (RoiRect(i,1)-Xlimit(1))*xmag+xoffset;
    rect1y = (Ylimit(2) - RoiRect(i,2))*ymag + yoffset - rect1h;
    rects(i,:) = [rect1x, rect1y, rect1w, rect1h];
end

if length(h)==1 & point1(1)>(RoiRect(1)+3/4*RoiRect(3)) & point1(2)>(RoiRect(2)+3/4*RoiRect(4))
    finalRect = rbbox(rects);
else
    finalRect = dragrect(rects);
end

for i = 1:length(h)
    newRoiw = finalRect(i,3)/xmag;
    newRoih = finalRect(i,4)/ymag;
    newRoix = (finalRect(i,1) - xoffset)/xmag +Xlimit(1);
    newRoiy = Ylimit(2) - (finalRect(i,2) - yoffset + finalRect(i,4))/ymag;
    UserData(i).roi.xi = (UserData(i).roi.xi - RoiRect(i,1))/RoiRect(i,3)*newRoiw + newRoix;
    UserData(i).roi.yi = (UserData(i).roi.yi - RoiRect(i,2))/RoiRect(i,4)*newRoih + newRoiy;
    set(h(i),'XData',UserData(i).roi.xi,'YData',UserData(i).roi.yi,'UserData',UserData(i));
    set(UserData(i).texthandle, 'Position', [newRoix+newRoiw/2,newRoiy+newRoih/2],'UserData',UserData(i));
end

h_roiQuality;