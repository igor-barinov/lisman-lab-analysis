function h_addImageToMontage(handles)

global h_img

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
%     F = getframe(handles.imageAxes); 
    
    figure(fig);
    h = subplot(siz(1),siz(2),pos2);
    subplot_pos = get(h,'Position');
    delete(h);
    c = copyobj(handles.imageAxes,fig);
    map = colormap(handles.imageAxes);
    set(c, 'Position', subplot_pos,'XTickLabel', '', 'YTickLabel', '', 'XTick',[],'YTick',[], 'UserData', UserData,'ButtonDownFcn','h_resetCurrentPos');
    colormap(c,map);
    c_children = get(c,'Children');
    set(c_children,'ButtonDownFcn','h_resetCurrentPos');
    axes(c);
    axis square;
    
    
%     colormap(F.colormap);
%     img = image(F.cdata);
%     set(gca,'XTickLabel', '', 'YTickLabel', '', 'XTick',[],'YTick',[], 'UserData', UserData,'ButtonDownFcn','h_resetCurrentPos');
%     set(img,'ButtonDownFcn','h_resetCurrentPos');
    
    pos2 = pos2 + 1;
    if pos2 > siz(1) * siz(2)
        pos2 = siz(2)*siz(1);
    end
    pos(1) = ceil(pos2 / siz(2));
    pos(2) = pos2 - (pos(1) - 1) * siz(2);
    set(handles.currentRow, 'String',num2str(pos(1)));
    set(handles.currentColumn,'String', num2str(pos(2)));
    h_img.state.montageControls.currentRow.String = num2str(pos(1));
    h_img.state.montageControls.currentColumn.String = num2str(pos(2));
end