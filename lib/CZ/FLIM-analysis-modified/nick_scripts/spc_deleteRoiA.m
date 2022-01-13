function spc_deleteRoiA;
global spc
global gui

for i = 1:length(gui.spc.figure.roiB)
    hA = gui.spc.figure.roiA(i);
    hB = gui.spc.figure.roiB(i);
    hC = gui.spc.figure.roiC(i);
    
    if ~ishandle(hA) || ~ishandle(hB) || ~ishandle(hC)
        continue;
    end
    
    if ~isa(hA, 'matlab.graphics.primitive.Rectangle')
        set(hA, 'color', 'cyan');
        set(hB, 'color', 'cyan');
        set(hC, 'color', 'cyan');
    end
end


spc.roipoly = spc.project * 0 + 1;


tagA = get(gco, 'Tag');
Texts = findobj('Tag', tagA);
RoiNstr = tagA(6:end);
Rois = findobj('Tag', ['RoiA', RoiNstr]);

for j = 1:length(Rois)
    delete(Rois(j));
end
for j = 1:length(Rois)
    delete(Texts(j));
end

% exists = ishandle(gui.spc.figure.roiB);
% gui.spc.figure.roiB(~exists) = [];



% try
%     spc.fit.spc_roi(str2num(RoiNstr)) = [];
% end