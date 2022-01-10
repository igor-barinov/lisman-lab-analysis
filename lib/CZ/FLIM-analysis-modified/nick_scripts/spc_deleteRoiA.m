function spc_deleteRoiA
global spc
global gui

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

exists = ishandle(gui.spc.figure.roiB);
gui.spc.figure.roiB(~exists) = gobjects;
spc.fit(gui.spc.proChannel).selectedROI(~exists) = false;



% try
%     spc.fit.spc_roi(str2num(RoiNstr)) = [];
% end