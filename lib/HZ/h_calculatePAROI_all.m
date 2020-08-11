function h_calculatePAROI_all

global h_img

handles = h_img.currentHandles;

imobj = findobj(handles.imageAxes,'Type','image');
% h_img.oldimg = get(imobj,'CData');

currentFilename = get(handles.currentFileName,'String');

if isempty(strmatch(lower(currentFilename),lower({h_img.activeGroup.groupFiles.name}')))
    disp('Current image group and active group not match!');
    return;
else
    %%%%%%%%%%% Get ROIs %%%%%%%%%%%%%%%%%%%%%%%%%%%
    roiobj = [sort(findobj(handles.h_imstack,'Tag', 'HROI'));findobj(handles.h_imstack,'Tag','HBGROI')];
    for j = 1:length(roiobj)
        roi(j) = get(roiobj(j), 'UserData');
    end
    [x_start,x_end,y_start,y_end,z_start,z_end, line] = h_autogetRoi(h_img.header);
    
    %%%%%%%%%%%%% Calc one by one %%%%%%%%%%%%%%%%%%%%%%%%%%
    montage = h_montageSize(length(h_img.activeGroup.groupFiles));
    fig = figure('Name', h_img.activeGroup.groupName);
    for i = 1:length(h_img.activeGroup.groupFiles)
        h_quickOpenFile(h_img.activeGroup.groupFiles(i).name);
        [x_start2,x_end2,y_start2,y_end2,z_start2,z_end2, line2] = h_autogetRoi(h_img.header);
        offset = [(x_start2-x_start),(y_start2-y_start)];
        h_moveroi(roiobj,offset);
        pause(3);
        h_img.lastPaAnalysis = h_calculatePAROI(handles);
        F = getframe(handles.imageAxes);
        figure(fig);
        subplot(montage(1),montage(2),i)
        colormap(F.colormap);
        img = image(F.cdata);
        set(gca,'XTickLabel', '', 'YTickLabel', '', 'XTick',[],'YTick',[]);
        [pname,filename,fExt] = fileparts(h_img.activeGroup.groupFiles(i).name);
        xlabel(filename);
        x_start = x_start2;
        y_start = y_start2;
    end
end
