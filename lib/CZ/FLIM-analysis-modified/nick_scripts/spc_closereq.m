function spc_closereq
global spcs
global spc
global gui

allHandles = fieldnames(gui.spc.figure);
for i = 1:numel(allHandles)
    h = gui.spc.figure.(allHandles{i});
    if ishandle(h)
        close(h);
    end
end


spcs = [];
spc = [];
closereq;