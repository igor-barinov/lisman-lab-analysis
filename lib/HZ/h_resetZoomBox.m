function h_resetZoomBox(handles)

global h_img;

[x_lim,y_lim,z_lim] = h_getLimits(handles);

horizontal = get(handles.moveHorizontal,'Value');
XLim = get(handles.imageAxes,'XLim');
XLim = XLim + horizontal*(diff(x_lim) - XLim(2) + XLim(1)) - XLim(1);
XLim = floor(XLim) + x_lim(1);

YLim = get(handles.imageAxes,'YLim');
vertical = 1 - get(handles.moveVertical,'Value');
YLim = YLim + vertical*(diff(y_lim) - YLim(2) + YLim(1)) - YLim(1);
YLim = floor(YLim) + y_lim(1);

set(handles.imageAxes,'XLim',XLim,'YLim',YLim);
