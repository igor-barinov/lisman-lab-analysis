function yphys_stimLoopFcn
global state
global gh

%get(gh.yphys.stimScope);
if  state.yphys.internal.waiting 
    return;
end
set(gh.yphys.stimScope.start, 'Enable', 'Off');
nstim = state.yphys.acq.nstim;
freq = state.yphys.acq.freq;
dwell = state.yphys.acq.dwell;
amp = state.yphys.acq.amp;
delay = state.yphys.acq.delay;
sLength = state.yphys.acq.sLength;

ntrain = state.yphys.acq.ntrain;
interval = state.yphys.acq.interval;
theta = state.yphys.acq.theta;


ext = get(gh.yphys.stimScope.ext, 'value');
ap = get(gh.yphys.stimScope.ap, 'value'); %state.yphys.acq.ap;
uncage=get(gh.yphys.stimScope.Uncage, 'value');   %state.yphys.acq.uncage;
stim = get(gh.yphys.stimScope.Stim, 'value');


cycleSet = str2num(get(gh.yphys.stimScope.cycleSet, 'String'));
if ~isempty(cycleSet)
        cyclePos = mod(state.yphys.acq.phys_counter-1, length(cycleSet))+1;
        cycleStr = num2str(cycleSet(cyclePos));
        set(gh.yphys.stimScope.pulseN, 'String', cycleStr);
        yphys_setupParameters;
        yphys_generic;
        yphys_loadAverage;
else
        set(gh.yphys.stimScope.pulseN, 'String', num2str(state.yphys.acq.pulseN));
        state.yphys.acq.pulseN
        yphys_setupParameters;
        yphys_generic;
end
    
state.yphys.acq.loopCounter = state.yphys.acq.loopCounter + 1;
if ~uncage
	if theta & ap
        yphys_thetaAP(amp, nstim, delay, ext);
	else
        yphys_sendStim;
	end
else
    yphys_uncage;
end

set(gh.yphys.stimScope.counter, 'String', ['Looping: ', num2str(state.yphys.acq.loopCounter), '/', num2str(state.yphys.acq.ntrain)]);

if state.yphys.acq.loopCounter >= state.yphys.acq.ntrain
        stop(state.yphys.timer.stim_timer);
        delete(state.yphys.timer.stim_timer);
        set(gh.yphys.stimScope.start, 'String', 'Start');
end
%toc;
set(gh.yphys.stimScope.start, 'Enable', 'On');
