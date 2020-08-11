function Yphys_uncage;
%dwell in milisecond.
global state;

if state.acq.scaleYShift ~= 0 | state.acq.scaleXShift ~=0 | state.acq.scanRotation ~= 0
    beep;
    beep;
    disp('Offset has to be zero');
    return;
end
global state;
global gh;

param = state.yphys.acq.pulse{3,state.yphys.acq.pulseN};
rate = param.freq;
nstim = param.nstim;
dwell = param.dwell;
ampc = param.amp;
delay = param.delay;
sLength = param.sLength;

%Uncaging setup;
yphys_getGain;

%%%%%%%%%%%%%%%%%%%
amp2 = 5;
pockelsOutput2 = yphys_mkPulse(rate, nstim, dwell, amp2, delay, sLength, 'uncage');
%Temporal output2 to define length and so on.

%%%%%%%%%%%%%%%%%%%%%%%%

pockelsOutput3_tmp = amp2 - yphys_mkPulse(rate, nstim, dwell+10, amp2, delay-6, sLength, 'uncage');
pockelsOutput3 = amp2*ones(length(pockelsOutput2), 1);
pockelsOutput3(1:length(pockelsOutput3_tmp)) = pockelsOutput3_tmp;
openregion = find(amp2 - pockelsOutput3);
pockelsOutput3(openregion(1):openregion(end)) = 0;
pockelsOutput3 = pockelsOutput3(1:length(pockelsOutput2));


laserP = 1;
uncageP = 2;
state.yphys.acq.uncaging_amp = ampc;
%amp = state.init.eom.lut(uncageP, state.init.eom.boxPowerArray(uncageP)) - state.init.eom.lut(uncageP, state.init.eom.min(uncageP));
amp = state.init.eom.lut(uncageP, ampc) - state.init.eom.lut(uncageP, state.init.eom.min(uncageP));
% if amp < 0
%     beep;
%     disp('Power has to be bigger than baseline');
%     return;
% end
pockelsOutput2 = yphys_mkPulse(rate, nstim, dwell, amp, delay, sLength, 'uncage');
pockelsOutput2 = pockelsOutput2 + state.init.eom.lut(uncageP, state.init.eom.min(uncageP));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~state.yphys.acq.cclamp & sLength > 200
        phys_output = zeros(length(pockelsOutput2), 1);
        phys_output_dep = yphys_mkPulse(50, 1, 50, -5/20, 10, 100, 'ap');
        depstart=length(phys_output)-length(phys_output_dep);
        phys_output(depstart+1:end) = phys_output_dep;
else
    phys_output = zeros(length(pockelsOutput2), 1);
end
set(gh.yphys.pulsePlot1, 'XData', (1:length(phys_output))/state.yphys.acq.outputRate*1000, 'YData', phys_output);
set(state.yphys.init.phys_patch, 'TriggerType', 'HwDigital');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input setting.
%get(state.yphys.init.phys_input);
set(state.yphys.init.phys_input, 'TriggerType', 'HwDigital');
set(state.yphys.init.phys_input, 'SamplesPerTrigger', round(length(pockelsOutput2)*state.yphys.acq.inputRate/state.yphys.acq.outputRate));
set(state.yphys.init.phys_input, 'StopFcn', 'yphys_getData');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Image acquisition

set(state.yphys.init.acq_ai, 'SamplesPerTrigger', round(length(pockelsOutput2)*state.yphys.acq.inputRate / state.yphys.acq.outputRate));
state.yphys.acq.data_On = [delay * state.yphys.acq.inputRate/1000, (delay+dwell)*state.yphys.acq.inputRate/1000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Put pockels value to zero

putsample (state.yphys.init.laser_ao, state.init.eom.lut(laserP, state.init.eom.min(laserP)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(state.yphys.init.scan_ao, 'SampleRate', state.yphys.acq.outputRate);

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

putsample(state.yphys.init.scan_ao, XYvol{roiN});
pause(0.1);


scanOutX = XYvol{1}(1)*ones(length(pockelsOutput2), 1);
scanOutY = XYvol{1}(2)*ones(length(pockelsOutput2), 1);
switchPosition = find(diff(pockelsOutput2 > mean(pockelsOutput2)));
for roiN = 2:NofRoi;
    if length(switchPosition) >= (roiN-1)*2
		scanOutX(switchPosition(2*(roiN-1)):end) = XYvol{roiN}(1);
		scanOutY(switchPosition(2*(roiN-1)):end) = XYvol{roiN}(2);
    end
end

%figure; plot(scanOutX); hold on; plot(scanOutY); plot(pockelsOutput2);

state.yphys.acq.scanOutput = [scanOutX,scanOutY];
putdata(state.yphys.init.scan_ao, state.yphys.acq.scanOutput);
start(state.yphys.init.scan_ao);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(state.yphys.init.pockels_ao, 'SampleRate', state.yphys.acq.outputRate);
%set(state.yphys.init.pockels_ao, 'SamplesPerTrigger', length(a));

% try
%     get(gh.yphys.stimPlot, 'XData');
% catch
%     figure(200);
%     gh.yphys.stimPlot = plot(zeros(32,1));
% end
state.yphys.acq.uncagePercentPulses = yphys_mkPulse(rate, nstim, dwell, ampc, delay, sLength, 'uncage');

state.yphys.acq.uncageOutputData = [pockelsOutput2(:), pockelsOutput3(:)];
state.yphys.acq.physOutputData = phys_output;

putdata(state.yphys.init.pockels_ao, [pockelsOutput2(:), pockelsOutput3(:)]);
putdata(state.yphys.init.phys_patch, phys_output);

start([state.yphys.init.pockels_ao, state.yphys.init.phys_input, state.yphys.init.acq_ai]);
start(state.yphys.init.phys_patch);

%figure; plot([pockelsOutput2(:), pockelsOutput3(:)]);
%start([state.yphys.init.pockels_ao, state.yphys.init.phys_input]);

%start(state.yphys.init.phys);

%state.spc.yphys.triggertime = datenum(now);
OpenShutter;
diotrigger;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   