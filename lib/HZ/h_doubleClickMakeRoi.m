function h_doubleClickMakeRoi

handles = guihandles(gca);

UserData = get(gca,'UserData');
t0 = clock;
if ~isfield(UserData,'timeLastClick') | ~(etime(t0,UserData.timeLastClick) < 0.3)
    UserData.timeLastClick = t0;
    set(gca,'UserData',UserData);
    return;
else
    rmfield(UserData,'timeLastClick');
    set(gca,'UserData',UserData);
    
    UserData = get(handles.roiControl,'UserData');
    shape = UserData.roiShapeOpt.String{UserData.roiShapeOpt.Value};
    Roi_size = 16;
    UserData = [];
    
    % axes(h_findobj('Tag','spc_IntensityAxes'));
    % if strcmp(get(gca,'Tag'),'spc_IntensityAxes')
    switch lower(shape)
        case {'round'}
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = min(point1,point2);             % calculate locations
            offset = abs(point1-point2);
            if offset(1)<2&offset(2)<2
                offset = [Roi_size, Roi_size];
            end
            ROI = [p1, offset(1), offset(2)];
            theta = [0:1/40:1]*2*pi;
            xr = ROI(3)/2;
            yr = ROI(4)/2;
            xc = ROI(1) + ROI(3)/2;
            yc = ROI(2) + ROI(4)/2;
            UserData.roi.xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
            UserData.roi.yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;
        case {'square'}
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = min(point1,point2);             % calculate locations
            offset = abs(point1-point2);
            if offset(1)<2&offset(2)<2
                offset = [Roi_size, Roi_size];
            end
            UserData.roi.xi = [p1(1),p1(1)+offset(1),p1(1)+offset(1),p1(1),p1(1)];
            UserData.roi.yi = [p1(2),p1(2),p1(2)+offset(2),p1(2)+offset(2),p1(2)];
        case {'roipoly'}
            [BW,UserData.roi.xi,UserData.roi.yi] = roipoly;
        otherwise
            return;
    end
    hold on;
    h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
    set(h,'ButtonDownFcn', 'h_dragRoi2', 'Tag', 'HROI', 'Color','red', 'EraseMode','xor');
    hold off;
    i = length(findobj(h_findobj(gcf,'Tag','HROI')));
    x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
    y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
    UserData.texthandle = text(x,y,num2str(i),'HorizontalAlignment',...
        'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiText2');
    UserData.number = i;
    UserData.ROIhandle = h;
    UserData.timeLastClick = clock;
    set(h,'UserData',UserData);
    set(UserData.texthandle,'UserData',UserData);
    
end
