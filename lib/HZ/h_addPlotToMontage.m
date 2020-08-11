function h_addPlotToMontage(handles)

try 
    fig = h_findobj('Tag','h_imstackMontage','Selected','on');
    if isempty(fig)
        fig = h_executeNewMontage_Callback;
    end
   
    UserData = get(fig,'UserData');
    siz = UserData.montageSize;
    pos(1) = str2num(get(handles.currentRow,'String'));
    pos(2) = str2num(get(handles.currentColumn,'String'));
    pos2 = (pos(1) - 1) * siz(2) + pos(2);
    UserData = [];
    UserData.subplotNumber = pos2;
    
    h = findobj('Tag','h_imstackPlot','Selected','on');
    h_child = get(h,'Children');
    if isempty(h_child)
        h_child = gca;
    end
    
    figure(fig);
    h_subplot = subplot(siz(1),siz(2),pos2);
    position = get(h_subplot,'Position');
    delete(h_subplot);
    h_plot = copyobj(h_child,fig);
    set(h_plot,'Position',position);
    UserData.subplotNumber = pos2;
    set(h_plot,'UserData', UserData,'ButtonDownFcn','h_resetCurrentPos');

    pos2 = pos2 + 1;
    if pos2 > siz(1) * siz(2)
        pos2 = siz(2)*siz(1);
    end
    pos(1) = ceil(pos2 / siz(2));
    pos(2) = pos2 - (pos(1) - 1) * siz(2);
    set(handles.currentRow, 'String',num2str(pos(1)));
    set(handles.currentColumn,'String', num2str(pos(2)));
    
%     h = findobj('Tag','h_imstackPlot','Selected','on');
%     h_child = get(h,'Children');
%     siz(1) = str2num(get(handles.rowNumber,'String'));
%     siz(2) = str2num(get(handles.columnNumber,'String'));
%     pos(1) = str2num(get(handles.currentRow,'String'));
%     pos(2) = str2num(get(handles.currentColumn,'String'));
%     pos2 = (pos(1) - 1) * siz(2) + pos(2);
%     fig = h_findobj('Tag','h_imstackMontage','Selected','on');
%     figure(fig);
%     h_subplot = subplot(siz(1),siz(2),pos2);
%     position = get(h_subplot,'Position');
%     delete(h_subplot);
%     h_plot = copyobj(h_child,fig);
%     set(h_plot,'Position',position);
%     UserData.subplotNumber = pos2;
%     set(h_plot,'UserData', UserData,'ButtonDownFcn','h_resetCurrentPos');
%     pos2 = pos2 + 1;
%     if pos2 > siz(1) * siz(2)
%         pos2 = siz(2)*siz(1);
%     end
%     pos(1) = ceil(pos2 / siz(2));
%     pos(2) = pos2 - (pos(1) - 1) * siz(2);
%     set(handles.currentRow, 'String',num2str(pos(1)));
%     set(handles.currentColumn,'String', num2str(pos(2)));
end