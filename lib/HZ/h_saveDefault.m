function h_saveDefault(handles)

global h_img

Default.greenLimitTextLow.String = get(handles.greenLimitTextLow,'String');
Default.greenLimitTextHigh.String = get(handles.greenLimitTextHigh,'String');
Default.redLimitTextLow.String = get(handles.redLimitTextLow,'String');
Default.redLimitTextHigh.String = get(handles.redLimitTextHigh,'String');
Default.imageMode.Value = get(handles.imageMode,'Value');
Default.viewingAxisControl.Value = get(handles.viewingAxisControl,'Value');
Default.ratioBetweenAxes.String = get(handles.ratioBetweenAxes,'String');
Default.maxProjectionOpt.Value = get(handles.maxProjectionOpt,'Value');
Default.smoothImage.Value = get(handles.smoothImage,'Value');
Default.roiControl.UserData = get(handles.roiControl,'UserData');
Default.groupPlot.UserData = get(handles.groupPlot,'UserData');
Default.paAnalysis.UserData = get(handles.paAnalysis,'UserData');
Default.fittingControls.UserData = get(handles.fittingControls,'UserData');
Default.state = h_img.state;


% if exist('C:\MATLAB6p5\work\haining\Roi_Analysis')==7
%     pname = 'C:\MATLAB6p5\work\haining\Roi_Analysis';
% elseif exist('C:\MATLAB6p5p2\work\haining\Roi_Analysis')==7
%     pname = 'C:\MATLAB6p5p2\work\haining\Roi_Analysis';
% else
%     D = h_dir('C:\MATLAB6p5\work\h_imstack.m','/s');
%     pname = fileparts(D(1).name);
% end
FID = fopen('h_imstack.m');
filename = fopen(FID);
fclose(FID);
pname = fileparts(filename);

currentPath = pwd;
cd (pname);
save h_imstackDefault.mat Default;
cd (currentPath);
