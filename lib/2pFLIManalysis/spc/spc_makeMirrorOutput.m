function mirrorOutput = spc_makeMirrorOutput
global state;
global gh;

mirrorOutput = rotateMirrorData(1/state.acq.zoomFactor*state.acq.mirrorDataOutputOrg);
%mirrorOutput = (1/state.acq.zoomFactor*state.acq.mirrorDataOutputOrg);
if ~state.spc.acq.uncageBox
    return;
end

if state.spc.acq.uncageBox & state.spc.acq.uncageEveryXFrame > 1 & state.init.pockelsOn
    mirrorOutput = repmat (mirrorOutput, [state.spc.acq.uncageEveryXFrame, 1]);
else
    return;
end


if state.acq.scaleYShift ~= 0 | state.acq.scaleXShift ~=0 | state.acq.scanRotation ~= 0
    beep;
    beep;
    disp('Offset has to be zero');
    return;
end


ActualRateOutput2 = get(state.init.ao2, 'SampleRate')/1000;  %%ms
XY = [0, 0];
errorS = 1;
NofRoi = 7;
for roiN = 1:NofRoi;
	[XY, err] = yphys_scanVoltage(roiN);
    XYvol{roiN} = XY;
    error(roiN) = err;
    if roiN == 1 & err == 1
        disp('You have to choose Roi1 !!!');
        return;
    elseif err
        XYvol{roiN} = XYvol{roiN-1};
    end
end

%XYvol
state.yphys.acq.uncage = 1;
state.yphys.acq.XYvol = XYvol;


%%%%%%%%%%%%%%%%%%%

para = state.yphys.acq.pulse{3, state.yphys.acq.pulseN};
nstim = para.nstim;
freq = para.freq;
dwell = para.dwell;
amp = para.amp;
delay = para.delay;
sLength = para.sLength;
%%%%%%%%%%%%%%%%%%%%
MirrorDelay = 4;
%switch1 = round(delay:delay+dwell)*ActualRateOutput2;

for roiN = 1:nstim
    PulsePos = round((delay+1000/freq*(roiN-1)-MirrorDelay)*ActualRateOutput2) : round((delay+1000/freq*(roiN-1)+dwell)*ActualRateOutput2);
    mirrorOutput(PulsePos, 1) = XYvol{roiN}(1);
    mirrorOutput(PulsePos, 2) = XYvol{roiN}(2);
end
        

%figure; plot(mirrorOutput(:, 1)); hold on; plot(mirrorOutput(:, 2));

return;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ActualRateOutput2 = get(state.init.ao2, 'SampleRate');

XYvol = [0, 0];
roiN = 1;
if state.spc.acq.uncageBox == 1  & state.init.eom.showBoxArray(2) == 1& state.init.pockelsOn
     im_size = size(get(state.internal.imagehandle(2), 'CData'));
     %roi_pos = get(gh.yphys.figure.yphys_roi(roiN), 'Position');
     roi_pos = get(state.init.eom.boxHandles(2, 1), 'Position');
     roi_pos([1, 3]) = roi_pos([1, 3]) / im_size(2);
     roi_pos([2, 4]) = roi_pos([2, 4]) / im_size(1);
     XYvol(1) = roi_pos(1) + 0.5*roi_pos(3);
     XYvol(2) = roi_pos(2) + 0.5*roi_pos(4);
     %XYvol(1) = (state.init.eom.powerBoxNormCoords(uncageP, 1)+0.5*state.init.eom.powerBoxNormCoords(uncageP, 3));
     %XYvol(2) = (state.init.eom.powerBoxNormCoords(uncageP, 2)+0.5*state.init.eom.powerBoxNormCoords(uncageP, 4));

     state.spc.acq.uncageXYorg = XYvol;
     
     %If Zoom > 30;
     XYvol(1) = XYvol(1) + state.acq.pockelsCellLineDelay*0.8;
     XYvol(1) = 2*(XYvol(1)-0.5)* state.acq.scanAmplitudeX;
     XYvol(2) = 2*(XYvol(2)-0.5)* state.acq.scanAmplitudeY;
     XYvol = (1/state.acq.zoomFactor*XYvol);
          
     pockelsOutput2 = state.spc.internal.spc_outData(:,5);

    MirrorStop = mean(pockelsOutput2) < pockelsOutput2;
	if length(MirrorStop)-sum(MirrorStop) > sum(MirrorStop)
        MirrorStop = (MirrorStop);
	else
       MirrorStop = (~MirrorStop);
	end
	aa = find(MirrorStop);
	startStop = aa(1)-state.internal.lengthOfXData*1;
    endStop = aa(end)+state.internal.lengthOfXData*0;
    mirrorOutput(startStop:endStop, 1) = XYvol(1);
    mirrorOutput(startStop:endStop, 2) = XYvol(2);
 else
     beep;
     disp('Error: choose ROI !');
     return;
end

