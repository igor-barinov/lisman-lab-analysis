function    [XYvol, error] = yphys_scanVoltage(roiN)
global gh;
global state;
error = 0;
Correction_scale = 0.4;

%roiN = 1;
if length(gh.yphys.figure.yphys_roi) >= roiN
	if ~isempty(gh.yphys.figure.yphys_roi(roiN)) & ishandle(gh.yphys.figure.yphys_roi(roiN))
        
         im_size = size(get(state.internal.imagehandle(2), 'CData'));
         roi_pos = get(gh.yphys.figure.yphys_roi(roiN), 'Position');
         roi_pos([1, 3]) = roi_pos([1, 3]) / im_size(2);
         roi_pos([2, 4]) = roi_pos([2, 4]) / im_size(1);
         XYvol(1) = roi_pos(1) + 0.5*roi_pos(3);
         XYvol(2) = roi_pos(2) + 0.5*roi_pos(4);
         %XYvol(1) = (state.init.eom.powerBoxNormCoords(uncageP, 1)+0.5*state.init.eom.powerBoxNormCoords(uncageP, 3));
         %XYvol(2) = (state.init.eom.powerBoxNormCoords(uncageP, 2)+0.5*state.init.eom.powerBoxNormCoords(uncageP, 4));
        
         state.yphys.acq.XYorg = XYvol;
         
         %If Zoom > 30;
         XYvol(1) = XYvol(1) + state.acq.pockelsCellLineDelay*Correction_scale;
         %XYvol(1) = (state.acq.fillFraction)*XYvol(1) + state.acq.lineDelay*1.3;
         XYvol(1) = 2*(XYvol(1)-0.5)* state.acq.scanAmplitudeX;
         XYvol(2) = 2*(XYvol(2)-0.5)* state.acq.scanAmplitudeY;
         XYvol = (1/state.acq.zoomFactor*XYvol);
     else
         %beep;
         %disp('Error: choose ROI !');
         error = 1;
         XYvol = [0,0];
	end
	%XYvol = rotateMirrorData(1/state.acq.zoomFactor*XYvol);

else
    XYvol = [0, 0];
    error = 1;
end
   