function h_saveCurrentRoiPos(handles)

global h_img

roiobj = sort(findobj(handles.imageAxes,'Tag', 'HROI'));
bgroiobj = sort(findobj(handles.imageAxes,'Tag', 'HBGROI'));
UserData = get([roiobj;bgroiobj],'UserData');
if iscell(UserData)
    UserData = cell2mat(UserData);
end
roi = UserData;

h_img.temp.savedRoiPos = roi;
