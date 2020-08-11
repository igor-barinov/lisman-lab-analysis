function h_resetXYLimit(handles)

fig = findobj('Tag','h_imstackPlot','Selected','on');
axesobj = findobj(fig,'type','Axes');

xlimStr = get(handles.xLimSetting,'String');
if strcmp(lower(xlimStr),'auto')
    set(axesobj,'XLimMode','auto');
else
    xlim = eval(['[',xlimStr,']']);
    if length(xlim) == 2
        set(axesobj,'XLim',xlim);
    elseif length(xlim)>2
        set(axesobj,'XTick',xlim)
    end
end

ylimStr = get(handles.yLimSetting,'String');
if strcmp(lower(ylimStr),'auto')
    set(axesobj,'YLimMode','auto');
else
    ylim = eval(['[',ylimStr,']']);
    if length(ylim) == 2
        set(axesobj,'YLim',ylim);
    elseif length(ylim)>2
        set(axesobj,'YTick',ylim)
    end
end