function h_setupVariableField(h, handles)

global h_img

width = 0.375;
height = 4/11;
UserData = get(handles.h_imstack,'UserData');
if isfield(UserData,'temporaryObj')
    delete(UserData.temporaryObj);
end
obj = get(h,'Children');
set(obj,'Units','normalized','Visible','off');
C = copyobj(obj,handles.h_imstack);
for i = 1:length(C)
    pos = get(C(i),'Position');
    pos(1) = 1-width+width*pos(1);
    pos(2) = height*pos(2);
    pos(3) = width*pos(3);
    pos(4) = height*pos(4);
    set(C(i),'Position',pos);
end
set(C,'Visible','on');
UserData.temporaryObj = C;
% UserData.currentActiveButton = h;
set(handles.h_imstack,'UserData',UserData);
delete(h);
h_showRoi;
h_updateInfo(guihandles(handles.h_imstack));
h_img.currentHandles = guihandles(handles.h_imstack);
