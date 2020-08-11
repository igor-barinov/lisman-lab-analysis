function h_drawARuler

global h_img

handles = h_img.currentHandles;
axes(handles.imageAxes);
[CX,CY,C,xi,yi] = IMPROFILE;
xi = xi(1:2);
yi = yi(1:2);
% 
% [xi,I] = sort(xi(1:2));
% yi = yi(I);


header = h_img.header;
zoom = header.acq.zoomhundreds*100 + header.acq.zoomtens*10 + header.acq.zoomones;
[XfieldOfView, YfieldOfView] = calculateFieldOfView(zoom);
xPixelLength = XfieldOfView/header.acq.pixelsPerLine;
yPixelLength = YfieldOfView/header.acq.linesPerFrame;

alpha = atan(((yi(2)-yi(1)) * yPixelLength)/((xi(2)-xi(1)) * xPixelLength));

leng = sqrt(((yi(2)-yi(1)) * yPixelLength)^2 + ((xi(2)-xi(1)) * xPixelLength)^2)

strings = get(handles.rulerMarkingOpt,'String');
rulerMarkingOpt = strings{get(handles.rulerMarkingOpt,'Value')};
if ~strcmp(rulerMarkingOpt,'Mark')
    rulerMarking = str2num(rulerMarkingOpt(1:2));
    i = 1:floor(leng/rulerMarking);
    xi = [xi(1),xi(1) + sign(xi(2)-xi(1))*i*rulerMarking*cos(alpha)/xPixelLength,xi(2)];
    yi = [yi(1),yi(1) + sign(xi(2)-xi(1))*i*rulerMarking*sin(alpha)/yPixelLength,yi(2)];
else
    rulerMarking = NaN;
end

axes(handles.imageAxes);
hold on;
plot(xi,yi,'b.-','EraseMode','xor','MarkerSize',5,'ButtonDownFcn','h_rulerButtonDownFcn','Tag','HRuler');
hold off;