function spc_putData
global state;


objs=[state.init.ao2, state.init.ao2F];
if state.init.pockelsOn == 1
    for beamCounter = 1:state.init.eom.numberOfBeams
        objs=[objs getfield(state.init,['ao'  num2str(beamCounter)])];
        if beamCounter==state.init.eom.scanLaserBeam
            objs=[objs getfield(state.init,['ao'  num2str(beamCounter) 'F'])];
        end
    end
end
if state.spc.init.spc_on == 1
    objs=[objs, getfield(state.spc.init, 'spc_ao')];
    objs=[objs, getfield(state.spc.init, 'spc_aoF')];
end
for objCounter=1:length(objs)
    if ~isempty(get(objs(objCounter),'SamplesAvailable')) & get(objs(objCounter),'SamplesAvailable')>0 & strcmp(get(objs(objCounter),'Running'),'Off')
        try; start(objs(objCounter)); catch ;end;
        stop(objs(objCounter));
    end
end

state.spc.internal.spc_outData = spc_makeDataOutput(1); %state.spc.acq.spc_takeFLIM);

putsample(state.spc.init.pockels_ao, state.spc.internal.spc_outData(1,4:6));

if state.spc.acq.spc_takeFLIM
    putdata(state.spc.init.spc_ao, state.spc.internal.spc_outData);
else
    putdata(state.spc.init.pockels_ao, state.spc.internal.spc_outData(:, 4:6));
end
putdata(state.init.ao2, spc_makeMirrorOutput);
