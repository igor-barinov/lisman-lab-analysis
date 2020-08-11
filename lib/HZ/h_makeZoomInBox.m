function h_makeZoomInBox(factor)

global h_img

h = h_img.currentHandles.imageAxes;
delete(findobj(h, 'Tag', 'zoomInBox'));

xlim = get(h,'xlim');
ylim = get(h,'xlim');

offset(1) = diff(xlim)/factor;
offset(2) = diff(ylim)/factor;

p1(1) = (xlim(1)+xlim(2))/2-offset(1)/2;
p1(2) = (ylim(1)+ylim(2))/2-offset(2)/2;

UserData.roi.xi = [p1(1),p1(1)+offset(1),p1(1)+offset(1),p1(1),p1(1)];
UserData.roi.yi = [p1(2),p1(2),p1(2)+offset(2),p1(2)+offset(2),p1(2)];

hold on;
h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h,'ButtonDownFcn', 'h_dragZoomInBox', 'Tag', 'zoomInBox', 'Color','black', 'EraseMode','xor');
hold off;
UserData.timeLastClick = clock;
set(h,'UserData',UserData);
