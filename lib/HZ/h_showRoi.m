function h_showRoi

roiobj = sort(h_findobj('Tag', 'ROI'));
n_roi = length(roiobj);

for j = 1:n_roi
    set(roiobj(j), 'Visible', 'Off'); 
    set(roiobj(j), 'Visible', 'On');
end
