function spc_stopGrab;

global state;
global gh;


stop([state.init.ao1, state.init.ao2, state.init.ai, state.spc.init.spc_ao, state.spc.init.pockels_ao]);

if state.init.pockelsOn == 1
    
	while ~strcmp([state.init.ai.Running getAOField(state.acq.dm, state.init.eom.scanLaserName, 'Running') ...
                state.init.ao2.Running], ['Off' 'Off' 'Off'])
	end
    
    %After focusing, set the power to whatever is selected by the user. - TO21604c
%     for i = 1 : state.init.eom.numberOfBeams
%         if ~isempty(state.init.eom.lut)
%             putDaqSample(state.acq.dm, state.init.eom.pockelsCellNames{i}, state.init.eom.lut(i, state.init.eom.maxPower(i)));
%         end
%     end
else
	stop([state.init.ao2 state.init.ai]);
    
	while ~strcmp([state.init.ai.Running  state.init.ao2.Running], ['Off' 'Off'])
	end	
end
