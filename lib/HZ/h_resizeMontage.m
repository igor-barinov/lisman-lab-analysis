function h_resizeMontage(handles)

fig = h_findobj('Tag','h_imstackMontage','Selected','on');
axesobj = get(fig,'Children');
siz(1) = str2num(get(handles.rowNumber,'String'));
siz(2) = str2num(get(handles.columnNumber,'String'));
if length(axesobj)==1
    pos = get(axesobj,'Position');
else
    pos = cell2mat(get(axesobj,'Position'));
end
pos(:,2) = 1 - pos(:,2);
[Y,I] = sortrows(pos,[2,1]);
axesobj = axesobj(I);
tempfig = figure('Visible','off');
for i = 1:length(axesobj)
    h = subplot(siz(1),siz(2),i);
    pos = get(h,'Position');
    set(axesobj(i),'Position',pos);
    UserData.subplotNumber = i;
    set(axesobj(i),'UserData',UserData);
end
UData = get(fig,'UserData');
UData.montageSize = siz;
set(fig,'UserData',UData);
delete(tempfig);