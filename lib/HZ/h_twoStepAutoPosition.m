function h_twoStepAutoPosition(handles);

global h_img;

reference = h_img.oldimg(:,:,1);
currentimg = get(findobj(handles.imageAxes,'Type','image'),'CData');
newimg = currentimg(:,:,1);
if ~isempty(reference)
    offset = h_corr(reference,newimg);    
    roiobj = sort(findobj(handles.imageAxes,'Tag', 'HROI'));
    n_roi = length(roiobj);
    for i = 1:n_roi
        UserData = get(roiobj(i),'UserData');
        pos = [min(UserData.roi.xi),min(UserData.roi.yi),max(UserData.roi.xi)-min(UserData.roi.xi),max(UserData.roi.yi)-min(UserData.roi.yi)];
        
        localRefx1 = round(max(pos(1)-0.5*pos(3),1));
        localRefx2 = round(min(pos(1)+ 1.5 * pos(3),size(reference,2)));
        localRefy1 = round(max(pos(2)-0.5*pos(4),1));
        localRefy2 = round(min(pos(2)+ 1.5 * pos(4),size(reference,1)));
        
%         pos(1) = pos(1) + offset(2);
%         pos(2) = pos(2) + offset(1);
        localImgx1 = localRefx1 + offset(2);
        localImgx2 = localRefx2 + offset(2);
        localImgy1 = localRefy1 + offset(1);
        localImgy2 = localRefy2 + offset(1);
        
        % Correct the local frame that could be out of image
        dx = min([localRefx1,localImgx1,0.5]) - 0.5;
        localRefx1 = round(localRefx1 - dx);
        localRefx2 = round(localRefx2 - dx);
        localImgx1 = round(localImgx1 - dx);
        localImgx2 = round(localImgx2 - dx);

        dy = min([localRefy1,localImgy1,0.5]) - 0.5;
        localRefy1 = round(localRefy1 - dy);
        localRefy2 = round(localRefy2 - dy);
        localImgy1 = round(localImgy1 - dy);
        localImgy2 = round(localImgy2 - dy);
        
        localRef = reference([localRefy1:localRefy2],[localRefx1:localRefx2]);
        localImg = newimg([localImgy1:localImgy2],[localImgx1:localImgx2]);
        local_offset = h_corr(localRef,localImg);
%         pos(1) = pos(1) + local_offset(2);
%         pos(2) = pos(2) + local_offset(1);
        UserData.roi.xi = UserData.roi.xi + offset(2) + local_offset(2);
        UserData.roi.yi = UserData.roi.yi + offset(1) + local_offset(1);
        set(roiobj(i),'UserData',UserData,'XData',UserData.roi.xi,'YData',UserData.roi.yi);
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        set(UserData.texthandle,'Position',[x,y],'UserData',UserData);
    end
    bgroiobj = findobj(handles.imageAxes,'Tag', 'HBGROI');
    if ~isempty(bgroiobj)
%         pos = get(bgroiobj,'Position');
%         pos(1) = pos(1) + offset(2);
%         pos(2) = pos(2) + offset(1);
        UserData = get(roiobj(i),'UserData');
        UserData.roi.xi = UserData.roi.xi + offset(2);
        UserData.roi.yi = UserData.roi.yi + offset(1);
        set(bgroiobj,'UserData',UserData);
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        set(UserData.texthandle,'Position',[x,y],'UserData',UserData);
    end
    h_roiQuality;
end
