function spc_abortCurrent;

global state;
global gh;




spc_stopGrab;
spc_stopFocus;
spc_parkLaser;
%spc_putData;

objs=[state.init.ao2F state.init.ao2];
if state.init.pockelsOn == 1
    for beamCounter = 1:state.init.eom.numberOfBeams
        objs=[objs getfield(state.init,['ao'  num2str(beamCounter)])];
        if beamCounter==state.init.eom.scanLaserBeam
            objs=[objs getfield(state.init,['ao'  num2str(beamCounter) 'F'])];
        end
    end
end
for objCounter=1:length(objs)
    if ~isempty(get(objs(objCounter),'SamplesAvailable')) & get(objs(objCounter),'SamplesAvailable')>0 & strcmp(get(objs(objCounter),'Running'),'Off')
        stop(objs(objCounter));
    end
end
%abortCurrent;


if state.spc.acq.spc_dll
    FLIM_StopMeasurement;
end
try
    stop(state.spc.acq.mt);
    delete(state.spc.acq.mt);
catch
end
try
    stop(state.spc.acq.timer.looptimer);
    delete(state.spc.acq.timer.looptimer);
catch
end
set(gh.spc.FLIMimage.grab, 'String', 'GRAB');
set(gh.spc.FLIMimage.focus, 'String', 'FOCUS');
set(gh.spc.FLIMimage.loop, 'String', 'LOOP');
set(gh.spc.FLIMimage.grab, 'Visible', 'on');
set(gh.spc.FLIMimage.focus, 'Visible', 'on');
set(gh.spc.FLIMimage.loop, 'Visible', 'on');
set(gh.mainControls.focusButton, 'Visible', 'On');
set(gh.mainControls.startLoopButton, 'Visible', 'On');
set(gh.mainControls.grabOneButton, 'Visible', 'On');
set(gh.mainControls.focusButton, 'Enable', 'On');
set(gh.mainControls.startLoopButton, 'Enable', 'On');
set(gh.mainControls.grabOneButton, 'Enable', 'On');
set(gh.spc.FLIMimage.grab, 'Enable', 'on');
set(gh.spc.FLIMimage.focus, 'Enable', 'on');
set(gh.spc.FLIMimage.loop, 'Enable', 'on');

abortCurrent;