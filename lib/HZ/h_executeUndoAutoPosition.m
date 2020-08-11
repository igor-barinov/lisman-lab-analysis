function h_executeUndoAutoPosition

global h_img

roi = h_img.temp.savedRoiPos;
for i = 1:length(roi)
    set(roi(i).ROIhandle, 'XData',roi(i).roi.xi,'YData',roi(i).roi.yi,'UserData',roi(i));
    x = (max(roi(i).roi.xi) + min(roi(i).roi.xi))/2;
    y = (max(roi(i).roi.yi) + min(roi(i).roi.yi))/2;
    set(roi(i).texthandle, 'Position',[x,y]);
end
    

