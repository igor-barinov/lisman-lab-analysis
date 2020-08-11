function h_dragLSRoi_WindowButtonMotionFcn

global h_img

point1 = get(gca,'CurrentPoint');
UserData = get(gco,'UserData');
% I = find(UserData.ROIHandles==gco);
I = UserData.ROIHandles==gco;
UserData.roi_pos(I) = point1(1);
set(gco,'XData',[point1(1),point1(1)],'UserData',UserData);

otherPairedROI = UserData.ROIHandles(~I);
UserData2 = get(otherPairedROI, 'UserData');
I2 = UserData2.ROIHandles==gco;
UserData2.roi_pos(I2) = point1(1);
set(otherPairedROI,'UserData',UserData);

