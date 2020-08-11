function Aout = h_getOldImg

global h_img

try
    handles = h_img.currentHandles;
    imageModes = get(handles.imageMode,'String');
    currentImageMode = imageModes{get(handles.imageMode,'Value')};
    switch currentImageMode
        case {'Green'}
            oldimg = h_img.greenimg;
        case {'Red',}
            oldimg = h_img.redimg;
        case {'Overlay'}
            climitg(1) = str2num(get(handles.greenLimitTextLow,'String'));
            climitg(2) = str2num(get(handles.greenLimitTextHigh,'String'));
            climitr(1) = str2num(get(handles.redLimitTextLow,'String'));
            climitr(2) = str2num(get(handles.redLimitTextHigh,'String'));
            oldimg = h_merge2color(h_img.greenimg,h_img.redimg,0,climitg,climitr);
        case {'Overlay (G/M)'}
            climitg(1) = str2num(get(handles.greenLimitTextLow,'String'));
            climitg(2) = str2num(get(handles.greenLimitTextHigh,'String'));
            climitr(1) = str2num(get(handles.redLimitTextLow,'String'));
            climitr(2) = str2num(get(handles.redLimitTextHigh,'String'));
            oldimg = h_merge2color(h_img.greenimg,h_img.redimg,0,climitg,climitr);
            oldimg(:,:,3) = oldimg(:,:,1);
        case {'G Saturation','R Saturation','G/R ratio'}
            oldimg = h_img.redimg;
    end
catch
    oldimg = [];
end

Aout.image = oldimg;
Aout.XLim = get(handles.imageAxes,'XLim');
Aout.YLim = get(handles.imageAxes,'YLim');
