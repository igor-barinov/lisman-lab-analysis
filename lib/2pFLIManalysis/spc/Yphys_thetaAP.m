function Yphys_thetaAP(AmpFactor, nstimIn, delaytime, ext);
%dwell in milisecond.

global state;

if ~nargin
    AmpFactor = 1;
end


rate = 100; %Burst rate.
Amplitude = 1000*AmpFactor; %pA
outputRate = state.yphys.acq.outputRate; %2000; %dwell = 0.5ms.
pulsedwell = 2; %msecond
pulsewidth = pulsedwell/1000*outputRate;
thetatime = 0.2;
nstim=10;

if nargin < 2
	delaytime = 250; %msecond
    ext = 0;
    nstimIn=5; %#stimulation in each burst.
end

yphys_setup;
yphys_getGain;

if ~state.yphys.acq.cclamp
    disp('Set to Current Clamp !!!');
    return;
end

set(state.yphys.init.phys_patch, 'SampleRate', outputRate);
set(state.yphys.init.phys_patch, 'RepeatOutput', 0); 
%samplelength = ceil(state.acq.outputRate*seconds);
binfactor = round(outputRate/ rate);
a = zeros(binfactor, 1);
a(1:pulsewidth) = Amplitude/2000;

a = repmat(a, nstimIn, 1);
blank = zeros(outputRate*thetatime-length(a), 1);
a= [blank; a];

a = repmat(a, nstim, 1);
blank = zeros(round(delaytime*outputRate/1000), 1);
a = [blank; a; blank];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input setting.
set(state.yphys.init.phys_input, 'SamplesPerTrigger', round(length(a)*state.yphys.acq.inputRate/state.yphys.acq.outputRate));
set(state.yphys.init.phys_input, 'StopFcn', 'yphys_getData');
%set(state.yphys.init.phys_input, 'SamplesAcquiredFcn', 'yphys_getData');

%Output setting;
    if ext
		set(state.yphys.init.phys_patch, 'TriggerType', 'HwDigital');
        set(state.yphys.init.phys_input, 'TriggerType', 'HwDigital');
    else
		set(state.yphys.init.phys_patch, 'TriggerType', 'Manual');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

putdata(state.yphys.init.phys_patch, a(:));

start([state.yphys.init.phys_patch, state.yphys.init.phys_input]);
state.yphys.acq.triggertime = datenum(now);

if ~ext
	trigger([state.yphys.init.phys_input, state.yphys.init.phys_patch]);
end
    %