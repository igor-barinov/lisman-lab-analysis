function h_autoPositionZoomBox

global h_img;

handles = h_img.currentHandles;

reference = h_img.oldimg.image(:,:,1);
currentimg = get(findobj(handles.imageAxes,'Type','image'),'CData');
newimg = currentimg(:,:,1);
if ~isempty(reference)
    offset = h_corr(reference,newimg);
    [x_lim,y_lim,z_lim] = h_getLimits(handles);
    
    XLim = h_img.oldimg.XLim;
    newXLim = XLim + offset(1);
    horizontalValue = (newXLim(1) - 0.5) / (diff(x_lim) - diff(newXLim));
    
    YLim = h_img.oldimg.YLim;
    newYLim = YLim + offset(2);
    verticalValue = 1 - (newYLim(1) - 0.5) / (diff(y_lim) - diff(newYLim));

    %     disp([XLim, newXLim, horizontalValue]);

    set(handles.moveHorizontal,'Value', horizontalValue);
    set(handles.moveVertical,'Value', verticalValue);
    set(handles.imageAxes,'XLim',newXLim,'YLim',newYLim);

%     horizontal = get(handles.moveHorizontal,'Value');
%     relativeXOffset = offset(1) / (diff(x_lim) - diff(XLim));
%     newHorizontal = horizontal + offset;
%     set(handles.moveHorizontal,'Value', newHorizontal);
%     h_resetZoomBox(handles);
end

