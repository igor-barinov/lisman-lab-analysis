function h_resetCurrentPos

try
UserData = get(gca,'UserData');
h = h_findobj('Tag','addToMontage');
handles = guihandles(h);
pos2 = UserData.subplotNumber;
siz(1) = str2num(get(handles.rowNumber,'String'));
siz(2) = str2num(get(handles.columnNumber,'String'));
pos(1) = ceil(pos2 / siz(2));
pos(2) = pos2 - (pos(1) - 1) * siz(2);
set(handles.currentRow, 'String',num2str(pos(1)));
set(handles.currentColumn,'String', num2str(pos(2)));
end