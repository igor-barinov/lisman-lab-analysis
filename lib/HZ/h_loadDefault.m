function h_loadDefault(handles)

global h_img;

% try
    %     if exist('C:\MATLAB6p5\work\haining\Roi_Analysis\h_imstackDefault.mat')==2
    %         load('C:\MATLAB6p5\work\haining\Roi_Analysis\h_imstackDefault.mat');
    %     elseif exist('C:\MATLAB6p5p2\work\haining\Roi_Analysis\h_imstackDefault.mat')==2
    %         load('C:\MATLAB6p5p2\work\haining\Roi_Analysis\h_imstackDefault.mat');
    %     else
    %         load('h_imstackDefault.mat');
    %     end

    FID = fopen('h_imstack.m');
    filename = fopen(FID);
    fclose(FID);
    pname = fileparts(filename);
    
    load(fullfile(pname,'h_imstackDefault.mat'));
    
    ss_setPara(handles.h_imstack,Default);
    h_img.state = Default.state;
    
    h_rehashSubfieldSetting;
    
    if isfield(h_img,'data')
        [xlim,ylim,zlim] = h_getLimits(handles);
        set(handles.zStackControlLow,'String', num2str(zlim(1)));
        set(handles.zStackControlHigh,'String', num2str(zlim(2)));
        h_zStackQuality;
        set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
        h_replot;
        h_roiQuality;
        h_updateInfo(guihandles(handles.h_imstack));
    end
% end