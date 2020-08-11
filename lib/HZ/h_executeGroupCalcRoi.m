function h_executeGroupCalcRoi(handles)

global h_img

set(handles.pauseGroupCalc,'Enable','on');

imobj = findobj(handles.imageAxes,'Type','image');
% h_img.oldimg = get(imobj,'CData');

currentFilename = get(handles.currentFileName,'String');

if ~isfield(h_img,'activeGroup')
    h_openGroup(h_img.imgGroupInfo.groupName, h_img.imgGroupInfo.groupPath, h_img.currentHandles);
end

if isempty(strmatch(lower(currentFilename),lower({h_img.activeGroup.groupFiles.name}')))
    disp('Current image group and active group not match!');
    return;
else
    %%%%%%%%%%% Get ROIs %%%%%%%%%%%%%%%%%%%%%%%%%%%
    roiobj = [sort(findobj(handles.h_imstack,'Tag', 'HROI'));findobj(handles.h_imstack,'Tag','HBGROI')];
    for j = 1:length(roiobj)
        roi(j) = get(roiobj(j), 'UserData');
    end
    
    
    
    %%%%%%%%%%%%% Calc one by one %%%%%%%%%%%%%%%%%%%%%%%%%%
    montage = h_montageSize(length(h_img.activeGroup.groupFiles));
    fig = figure('Name', h_img.activeGroup.groupName);

    for i = 1:length(h_img.activeGroup.groupFiles)
        h_img.oldimg = get(imobj,'CData');
        
        h_quickOpenFile(h_img.activeGroup.groupFiles(i).name);
%         for j = 1:length(roiobj)
%             set(roiobj(j),'UserData',roi(j),'XData',roi(j).roi.xi,'YData',roi(j).roi.yi);
%         end
        %         h_twoStepAutoPosition(handles);
        h_autoPosition(handles);
        pause(5);
        h_img.lastCalcROI = h_executecalcRoi(handles);
        
        F = getframe(handles.imageAxes);
        figure(fig);
        subplot(montage(1),montage(2),i)
        colormap(F.colormap);
        img = image(F.cdata);
        set(gca,'XTickLabel', '', 'YTickLabel', '', 'XTick',[],'YTick',[]);
        [pname,filename,fExt] = fileparts(h_img.activeGroup.groupFiles(i).name);
        xlabel(filename);
        
%         Aout(i) = h_img.lastCalcROI;
    end
end

[pname,filename,fExt] = fileparts(currentFilename);
h_openFile([filename,fExt],pname);

for j = 1:length(roiobj)
    set(roiobj(j),'UserData',roi(j),'XData',roi(j).roi.xi,'YData',roi(j).roi.yi);
    x = (min(roi(j).roi.xi) + max(roi(j).roi.xi))/2;
    y = (min(roi(j).roi.yi) + max(roi(j).roi.yi))/2;
    set(roi(j).texthandle,'UserData',roi(j),'Position',[x,y]);
end

set(handles.pauseGroupCalc,'Enable','off');

%     
%     time = horzcat(Aout.time);
%     ratio = horzcat(Aout.ratio);
%     
%     figure;
%     hold on;
%     time = (time - min(time))*24*60;
%     cstr = {'red', 'blue', 'green', 'magenta', 'cyan', 'black'};
%     for i = 1:length(roiobj)
%         plot(time,A(i).ratio,'-o','Color', cstr{i});
%     end
%     xlabel('Time (min)');
%     ylabel('Green/Red ratio');
%     title(basename,'FontSize',14);
%     hold off;


            
