function yphys_patchLoop;
global state;
a = state.yphys.acq.patchdata;
try
    stop(state.yphys.init.phys);
    stop(state.yphys.init.phys_input);
    stop(state.yphys.init.phys_setting);
    stop(state.yphys.init.phys_patch);
catch
end
yphys_getGain;
flushdata(state.yphys.init.phys_input);
putdata(state.yphys.init.phys_patch, a(:));
start([state.yphys.init.phys_patch, state.yphys.init.phys_input]);
state.spc.yphys.triggertime = datenum(now);
%trigger([state.yphys.init.phys_input, state.yphys.init.phys_patch]);
yphys_diotrigger;