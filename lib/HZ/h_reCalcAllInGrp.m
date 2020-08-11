function h_reCalcAllInGrp

global h_img;
handles = h_img.currentHandles;

for index = 1:length(h_img.activeGroup.groupFiles)
    %open file
    [newPath,newFilename] = h_analyzeFilename(h_img.activeGroup.groupFiles(index).name);
    if exist(h_img.activeGroup.groupFiles(index).name,'file')
        h_openFile(newFilename,newPath);
    elseif exist(fullfile(fileparts(h_img.activeGroup.groupPath(1:end-1)), newFilename),'file') %in case the entire folder is moved
        h_openFile(newFilename,fileparts(h_img.activeGroup.groupPath(1:end-1)));
    elseif exist(fullfile(h_img.activeGroup.groupPath(1:end-1), newFilename),'file') %in case the entire folder is moved
        h_openFile(newFilename,h_img.activeGroup.groupPath(1:end-1));
    elseif exist(newFilename,'file')
        h_openFile(newFilename,pwd);
    end
    
    %load analyzed ROI info
    h_loadAnalyzedRoiData(handles);
    
    %set z limit if available
    if isfield(h_img.lastCalcROI,'zLim')
        set(handles.zStackControlLow,'String',num2str(h_img.lastCalcROI.zLim(1)));
        set(handles.zStackControlHigh,'String',num2str(h_img.lastCalcROI.zLim(2)));        
        h_zStackQuality;
        h_replot;
    end
    
    drawnow;
    
    %recalc ROI
    h_img.lastCalcROI = h_executecalcRoi(handles);
end