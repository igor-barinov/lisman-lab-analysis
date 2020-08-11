function h_openFile(filename,pathname)

global h_img;

handles = h_img.currentHandles;

if ~(exist('pathname')==1)
    pathname = pwd;
end

try
    cd (pathname);
    filestr = fullfile(pathname, filename);
    fnameobj = handles.currentFileName;
    if exist(filestr) == 2
        h = h_findobj('Tag','imageAxes');
        handles = h_img.currentHandles;
        h_img.oldimg = h_getOldImg;
        h_img.data = []; %to free up memory
        [h_img.data,h_img.header, err] = h_OpenTif(filestr);
        if err
            [h_img.data,h_img.header] = h_OpenTif2(filestr);
        end
        set(fnameobj,'String',filestr);
        [xlim,ylim,zlim] = h_getLimits(handles);
        set(handles.zStackControlLow,'String', num2str(zlim(1)));
        set(handles.zStackControlHigh,'String', num2str(zlim(2)));
        h_zStackQuality;
        set(h(1),'XLim',xlim,'YLim',ylim);
        h_getCurrentImg;
        h_greenControlQuality;
        h_redControlQuality;
        h_replot('fast');
        h_roiQuality;
        h_updateInfo(guihandles(fnameobj));
    else
        disp('Not a valid file name');
    end
end
