function fig = h_executeNewMontage_Callback

global h_img;

handles = h_img.currentHandles;

fig = figure('Tag','h_imstackMontage','ButtonDownFcn','h_selectCurrentMontage','Name','h_imstackMontage');
siz(1) = str2num(get(handles.rowNumber,'String'));
siz(2) = str2num(get(handles.columnNumber,'String'));
UserData.montageSize = siz;
set(fig,'UserData',UserData);
h_selectCurrentMontage;
set(handles.currentRow,'String',1);
set(handles.currentColumn,'String',1);

