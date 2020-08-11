function h_autoPAPosition(handles)

global h_img;

h_saveCurrentRoiPos(handles);
reference = h_img.oldimg(:,:,1);
currentimg = h_img.data(:,:,2);
newimg = currentimg(:,:,1);
if ~isempty(reference)
    offset = h_corr(reference,newimg);  
    roiobj = [sort(findobj(handles.h_imstack,'Tag', 'HROI'));findobj(handles.h_imstack,'Tag','HBGROI')];
    h_moveRoi(roiobj,[offset(2),offset(1)]);
%     roiobj = sort(findobj(handles.imageAxes,'Tag', 'HROI'));
%     n_roi = length(roiobj);
%     for i = 1:n_roi
%         UserData = get(roiobj(i),'UserData');
%         UserData.roi.xi = UserData.roi.xi + offset(2);
%         UserData.roi.yi = UserData.roi.yi + offset(1);
%         set(roiobj(i),'UserData',UserData,'XData',UserData.roi.xi,'YData',UserData.roi.yi);
%         x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
%         y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
%         set(UserData.texthandle,'Position',[x,y],'UserData',UserData);
%     end
%     bgroiobj = findobj(handles.imageAxes,'Tag', 'HBGROI');
%     if ~isempty(bgroiobj)
%         UserData = get(bgroiobj,'UserData');
%         UserData.roi.xi = UserData.roi.xi + offset(2);
%         UserData.roi.yi = UserData.roi.yi + offset(1);
%         set(bgroiobj,'UserData',UserData,'XData',UserData.roi.xi,'YData',UserData.roi.yi);
%         x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
%         y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
%         set(UserData.texthandle,'Position',[x,y],'UserData',UserData);
%     end
    h_roiQuality;
end
