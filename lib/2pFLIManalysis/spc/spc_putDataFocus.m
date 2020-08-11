function spc_putDataFocus
global state;

if state.spc.init.spc_on == 1;
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
            start(objs(objCounter));
            stop(objs(objCounter));
        end
	end
    putdata(state.init.ao2F, rotateMirrorData(1/state.acq.zoomFactor*state.acq.mirrorDataOutputOrg));
    focusData = spc_makeDataOutput(1);
    putdata(state.spc.init.spc_aoF, focusData(:, 1:4));
    %pause(0.01);
end