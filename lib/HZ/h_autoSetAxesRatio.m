function h_autoSetAxesRatio

global h_img

handles = h_img.currentHandles;
header = h_img.header;
dispAxes = get(handles.viewingAxisControl,'Value');

try
    zoom = header.acq.zoomhundreds*100 + header.acq.zoomtens*10 + header.acq.zoomones;
catch
    zoom = header.acq.zoomFactor;
end
[XfieldOfView, YfieldOfView] = calculateFieldOfView(zoom);
xPixelLength = XfieldOfView/header.acq.pixelsPerLine;
yPixelLength = YfieldOfView/header.acq.linesPerFrame;


switch dispAxes
    case {1}
        viewingAxis = 3;
        str = '1:1';
    case {2}
        viewingAxis = 1;
        ratio = round(abs(header.acq.zStepSize) / xPixelLength *10)/10;
        str = ['1:',num2str(ratio)];
    case {3}
        viewingAxis = 2;
        ratio = round(abs(header.acq.zStepSize) / yPixelLength *10)/10;
        str = ['1:',num2str(ratio)];
end

set(handles.ratioBetweenAxes,'String',str);