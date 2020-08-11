function spc_startGrab;
global state;

%    list = delimitedList(state.init.eom.focusLaserList, ',');
%     offBeams = find(~ismember(state.init.eom.pockelsCellNames, list));
%     for i = 1 : length(offBeams)
%         putDaqSample(state.acq.dm, state.init.eom.pockelsCellNames{i}, state.init.eom.min(i));
%     end
    
    if state.spc.acq.spc_image
        if state.spc.acq.spc_takeFLIM
            start([state.spc.init.spc_ao, state.init.ao2, state.init.ai]);
        else
            start([state.spc.init.pockels_ao, state.init.ao2, state.init.ai]);
        end
    else
        start([state.spc.init.spc_ao, state.init.ao2]);
    end
