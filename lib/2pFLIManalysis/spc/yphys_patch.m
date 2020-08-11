function yphys_patch;
global state;
global gh;

out = timerfind('Tag', 'patch');

if isobject(out)
    stop(out);
    delete(out);
    notimer = 0;
else
    notimer = 1;
end


if notimer
    yphys_setup;
    yphys_getGain;
    pause(0.2);
	if state.yphys.acq.cclamp
        state.yphys.acq.cphase = [state.yphys.acq.cwidth, state.yphys.acq.cwidth, state.yphys.acq.cwidth];    
		phase = state.yphys.acq.cphase*state.yphys.acq.outputRate/1000;
        a=zeros(phase(1), 1);
		a = [a; ones(phase(2), 1)];
		a = [a; zeros(phase(3), 1)];
        a = a*state.yphys.acq.camplitude/state.yphys.acq.commandSensC;
        timerperiod = state.yphys.acq.cperiod;
	else
        state.yphys.acq.vphase = [state.yphys.acq.vwidth, state.yphys.acq.vwidth, state.yphys.acq.vwidth];
		phase = state.yphys.acq.vphase*state.yphys.acq.outputRate/1000;    
        a=zeros(phase(1), 1);
		a = [a; ones(phase(2), 1)];
		a = [a; zeros(phase(3), 1)];
		a = a*state.yphys.acq.vamplitude/state.yphys.acq.commandSensV;
        timerperiod = state.yphys.acq.vperiod;
	end
    state.yphys.acq.patchdata = a; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    yphys_settingSpecific_patch;
    try
        axes (gh.yphys.scope.trace);
        gh.yphys.patchPlot = plot(zeros(32,1));
    end
    state.yphys.acq.patchAxes = gh.yphys.scope.trace;
    xlabel(gh.yphys.scope.trace, 'Time (ms)')
    if state.yphys.acq.cclamp
        ylabel(gh.yphys.scope.trace, 'Voltage (mV)');
    else
        ylabel(gh.yphys.scope.trace, 'Current (pA)');
    end
    %set(gca, 'ButtonDownFcn', 'yphys_Patch');
    set(gh.yphys.scope.start, 'String', 'STOP');
    state.yphys.timer.patch_timer = timer('TimerFcn','yphys_patchLoop','ExecutionMode','fixedSpacing','Period',timerperiod, 'Tag','patch');    
    start(state.yphys.timer.patch_timer);
else
    stop(state.yphys.init.phys);
    stop(state.yphys.init.phys_patch);
    stop(state.yphys.init.phys_input);
    stop(state.yphys.init.phys_setting);
    %putdata(state.yphys.init.phys_patch, zeros(50,1));
    %start(state.yphys.init.phys_patch);
    %trigger(state.yphys.init.phys_patch);
    %yphys_diotrigger;
    %axes(state.yphys.acq.patchAxes);
%     if get(state.yphys.init.phys_input, 'SamplesAvailable') >= get(state.yphys.init.phys_input, 'SamplesPerTrigger')
%         data1 = getdata(state.yphys.init.phys_input);
%     end
    set(gh.yphys.scope.start, 'String', 'START');
    try
        stop(state.yphys.timer.patch_timer);
    end
    delete(state.yphys.timer.patch_timer);
end



function yphys_settingSpecific_patch
global state;
a=state.yphys.acq.patchdata;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(state.yphys.init.phys_patch, 'SampleRate', state.yphys.acq.outputRate);
set(state.yphys.init.phys_patch, 'RepeatOutput', 0); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input setting.
set(state.yphys.init.phys_input, 'SampleRate', state.yphys.acq.inputRate);
state.yphys.init.phys_data = addchannel(state.yphys.init.phys_input, state.yphys.init.phys_dataIndex);
set(state.yphys.init.phys_input, 'SamplesPerTrigger', round(length(a)*state.yphys.acq.inputRate/state.yphys.acq.outputRate));
set(state.yphys.init.phys_input, 'StopFcn', 'yphys_getData_patch');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%