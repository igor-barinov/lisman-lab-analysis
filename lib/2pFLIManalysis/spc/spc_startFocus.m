function spc_startFocus
global gh state

% Function that will start the DAQ devices running for Focus (ao1F, ao2F, aiF).
%
% Written by: Thomas Pologruto
% Cold Spring Harbor Labs
% February 7, 2001

%Ryohei 9/17/02 added state.init.spc_on

list = delimitedList(state.init.eom.focusLaserList, ',');
    offBeams = find(~ismember(state.init.eom.pockelsCellNames, list));
    for i = 1 : length(offBeams)
        putDaqSample(state.acq.dm, state.init.eom.pockelsCellNames{i}, state.init.eom.min(i));
end

if state.init.pockelsOn == 1
    start([state.spc.init.spc_aoF state.init.ao2F state.init.aiF]);
else
	start([state.spc.init.spc_aoF state.init.ao2F state.init.aiF]);
end
 