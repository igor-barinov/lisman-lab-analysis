function h_zoomIn(handles)

global h_img

try
    h = findobj(h_img.currentHandles.imageAxes,'Tag', 'zoomInBox');
    if isempty(h)
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = floor(point1(1,1:2));              % extract x and y
        point2 = floor(point2(1,1:2));
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);
    else
        UserData = get(h,'UserData');
        p1 = [UserData.roi.xi(1), UserData.roi.yi(1)];
        offset = [UserData.roi.xi(3)-UserData.roi.xi(1), UserData.roi.yi(3) - UserData.roi.yi(1)];
        delete(h);
    end
        
    
    imgObj = h_img.currentHandles.imageAxes;
    set(imgObj,'XLim',[p1(1),p1(1)+offset(1)],'YLim',[p1(2),p1(2)+offset(2)]);
    [xlim,ylim,zlim] = h_getLimits(handles);
    UData = get(handles.lineScanAnalysis,'UserData');
    if isfield(UData,'lineScanDisplay') & UData.lineScanDisplay.Value
        ylim = [0,size(h_img.greenimg,1)]+0.5;
    end
    
    if diff(xlim)>offset(1)
        set(handles.moveHorizontal,'Enable','on');
        xstep = min([0.1*offset(1)/(diff(xlim)-offset(1)),0.1],1);
        xvalue = (p1(1)-xlim(1))/(diff(xlim)-offset(1));
        set(handles.moveHorizontal,'Value',xvalue,'SliderStep',xstep);
    end
    
    if diff(ylim)>offset(2)
        set(handles.moveVertical,'Enable','on');
        ystep = min([0.1*offset(2)/(diff(ylim)-offset(2)),0.1],1);
        yvalue = 1 - (p1(2)-ylim(1))/(diff(ylim)-offset(2));
        set(handles.moveVertical,'Value',yvalue,'SliderStep',ystep);
    end
catch
    disp('Zoom error');
end