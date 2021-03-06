function h_autoSelectLSRoi

global h_img

handles = h_img.currentHandles;

delete(findobj(handles.imageAxes,'Tag','LSROI'));

ROI_num = get(handles.numberOfROI,'Value');
boundaryThresh = 0.1*get(handles.roiBoundaryThresh,'Value');
roiSelectionChannelOpt = get(handles.roiSelectionChannelOpt,'Value');

if get(handles.lineScanDisplay,'Value')
    zLim(1) = str2num(get(handles.zStackControlLow,'String'));
    zLim(2) = str2num(get(handles.zStackControlHigh,'String'));
else
    zLim = [1,size(h_img.data,3)/2];
end    

y = sum(sum(h_img.data(:,:,(2*zLim(1)-mod(roiSelectionChannelOpt,2)):2:2*zLim(2)),1),3);
[peaks,valleys,error]=h_findPeaks(y,ROI_num);
roi_pos = h_findROIboundary(y,peaks,valleys,boundaryThresh);
if length(peaks)<ROI_num
    roi_pos([1,2],end+1:ROI_num) = length(y);
end
ydata = get(handles.imageAxes,'YLim');
% xdata = horzcat(roi_pos(:),roi_pos(:));
axes(handles.imageAxes);
hold on;
cstr(1,:) = {'magenta','green','white','blue'};
for i = 1:ROI_num
    h(1,1) = plot([roi_pos(1,i),roi_pos(1,i)],ydata,'-');
    h(2,1) = plot([roi_pos(2,i),roi_pos(2,i)],ydata,'-');
    UserData.number = i;
    UserData.ROIHandles = h;
    UserData.roi_pos = roi_pos(:,i);
    set(h,'Tag','LSROI','UserData',UserData,'ButtonDownFcn', 'h_dragLSRoi','LineWidth',2,'Color',cstr{i});
end
hold off