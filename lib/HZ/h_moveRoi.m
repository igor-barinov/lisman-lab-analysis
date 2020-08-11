function h_moveRoi(h, offset)

UserData = get(h,'UserData');
if iscell(UserData)
    UserData = cell2mat(UserData);
end


for i = 1:length(h)
    UserData(i).roi.xi = UserData(i).roi.xi + offset(1);
    UserData(i).roi.yi = UserData(i).roi.yi + offset(2);
    x = (max(UserData(i).roi.xi) + min(UserData(i).roi.xi))/2;
    y = (max(UserData(i).roi.yi) + min(UserData(i).roi.yi))/2;
    set(UserData(i).ROIhandle,'XData',UserData(i).roi.xi,'YData',UserData(i).roi.yi,'UserData',UserData(i));
    set(UserData(i).texthandle, 'Position', [x,y],'UserData',UserData(i));
end