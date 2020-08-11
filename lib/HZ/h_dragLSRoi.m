function h_dragLSRoi

global h_img

t0 = clock;
UserData = get(gco,'UserData');
if isfield(UserData,'timeLastClick') & etime(t0,UserData.timeLastClick) < 0.3
    delete(UserData.ROIHandles);
    return;
else
    UserData.timeLastClick = t0;
    set(UserData.ROIHandles,'UserData',UserData);
end

set(h_img.currentHandles.h_imstack,'WindowButtonMotionFcn','h_dragLSRoi_WindowButtonMotionFcn',...
    'WindowButtonUpFcn', 'h_dragLSRoi_WindowButtonUpFcn');
