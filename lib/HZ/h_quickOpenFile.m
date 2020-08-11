function h_quickOpenFile(filestr)

global h_img;

h = h_findobj('Tag','h_imstack');
handles = guihandles(h);

try
    if exist(filestr) == 2
        [h_img.data,h_img.header] = h_openTif(filestr);
        set(handles.currentFileName,'String',filestr);
        [xlim,ylim,zlim] = h_getLimits(handles);
        set(handles.zStackControlLow,'String', num2str(zlim(1)));
        set(handles.zStackControlHigh,'String', num2str(zlim(2)));
%         h_zstackQuality;
        set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
        h_getCurrentImg;
%         h_greenControlQuality;
%         h_redControlQuality;
        h_replot('fast');
%         h_roiQuality;
%         h_updateInfo(guihandles(fnameobj));
    else
        disp('Not a valid file name');
    end
end
