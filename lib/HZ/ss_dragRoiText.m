function ss_dragRoiText

UserData = get(gco,'UserData');
set(gcf,'CurrentObject',UserData.ROIhandle);
ss_dragroi;