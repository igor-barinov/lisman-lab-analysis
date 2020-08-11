function yphys_setup
global state;
global yphys;
global gh;

a = daqfind('Tag', 'yphys');
if length(a) > 0
	for i=1:length(a); 
        stop(a{i});
        delete(a{i}); 
    end
end

%%%%%%%%%%%%%%%%%%
yphys.aveString{1} = '';
yphys.filename = '';
yphys.data.data = [1:32, 1:2];
yphys.aveData = [1:32, 1:2];
%%%%%%%%%%%%%%%%%%
%Graphics

if ~isfield (gh.yphys, 'calcium')
    gh.yphys.calcium = 1;
end
if ~isfield (gh.yphys, 'intensity_graph')
    gh.yphys.intensity_graph = 1;
end
if ~isfield (gh.yphys, 'figure')
    gh.yphys.figure.yphys_roi = 1;
end
%%%%%%%

	state.yphys.init.mirrorOutputBoardIndex = 1;
	state.yphys.init.XMirrorChannelIndex = 0;
	state.yphys.init.YMirrorChannelIndex = 1;
	%%%
	state.yphys.init.eom.pockelsBoardIndex1 = 2;
	state.yphys.init.eom.pockelsBoardIndex2 = 2;
	state.yphys.init.eom.pockelsChannelIndex1 = 3;
	state.yphys.init.eom.pockelsChannelIndex2 = 4;
	state.yphys.init.eom.pockelsChannelIndex3 = 5;
	%%%
	state.yphys.init.acquisitionBoardIndex = 1;
	state.yphys.init.inputChannelIndex1 = 0;
	state.yphys.init.inputChannelIndex2 = 1;
    %%%%
    state.yphys.init.vclampBoardIndex = 3;
    state.yphys.init.vclampLineIndex = 1;
	%%%%
    state.yphys.init.triggerBoardIndex = 1;
    state.yphys.init.triggerLineIndex = 0;
    %%%.
	state.yphys.acq.inputRate = 1250000;
    %%%
    state.yphys.init.multiclamp = 1;
    state.yphys.acq.multiclamp = 1;

%%%%
%%%
state.yphys.init.phys_boardIndex = 3;
state.yphys.init.phys_patchChannelIndex = 0;
state.yphys.init.phys_stimChannelIndex = 1;
state.yphys.init.phys_dataIndex = 0;
state.yphys.init.phys_gainIndex = 1;
state.yphys.init.phys_viIndex = 2;
state.yphys.acq.gainV = 5/1000; %Output gain V / nA (/ 1000)
state.yphys.acq.gainC = 100/1000; %Output gain V / mV --- getting milivolt
state.yphys.acq.commandSensV = 20; %mV/V
state.yphys.acq.commandSensC = 2000; %pA/V
state.yphys.acq.inputRate = 10000;
state.yphys.acq.outputRate = 10000;
state.yphys.acq.cclamp = 0;

%%%%%%%%%%%%
%setting
state.yphys.init.phys_setting = analoginput('nidaq',state.yphys.init.phys_boardIndex);
set(state.yphys.init.phys_setting, 'SampleRate', state.yphys.acq.inputRate, 'Tag', 'yphys');
set(state.yphys.init.phys_setting, 'TriggerType', 'Immediate');
state.yphys.init.phys_gainChannel = addchannel(state.yphys.init.phys_setting, state.yphys.init.phys_gainIndex);
state.yphys.init.phys_viChannel = addchannel(state.yphys.init.phys_setting, state.yphys.init.phys_viIndex);
%warning off all;
set(state.yphys.init.phys_gainChannel, 'InputRange', [-10, 10]);
set(state.yphys.init.phys_viChannel, 'InputRange', [-10, 10]);
%warning on all;
set(state.yphys.init.phys_setting, 'SamplesPerTrigger', 100);

%%%%%%%%%%%%
%analoginput
state.yphys.init.phys_input = analoginput('nidaq',state.yphys.init.phys_boardIndex);
set(state.yphys.init.phys_input, 'SampleRate', state.yphys.acq.inputRate, 'Tag', 'yphys');
state.yphys.init.phys_data = addchannel(state.yphys.init.phys_input, state.yphys.init.phys_dataIndex);
set(state.yphys.init.phys_input, 'TriggerType', 'HwDigital');
%%%%%%%%%%%%

%%%%%%%%%%%%%
%analogouput
state.yphys.init.phys = analogoutput('nidaq',state.yphys.init.phys_boardIndex);
set(state.yphys.init.phys, 'SampleRate', state.yphys.acq.outputRate, 'Tag', 'yphys');
state.yphys.init.phys_stim = addchannel(state.yphys.init.phys, state.yphys.init.phys_stimChannelIndex);
set(state.yphys.init.phys, 'TriggerType', 'HwDigital');

%%%%%%%%%%%%%%%
%analogoutput patch
state.yphys.init.phys_patch = analogoutput('nidaq', state.yphys.init.phys_boardIndex);
set(state.yphys.init.phys_patch, 'RepeatOutput', 0, 'Tag', 'yphys');
set(state.yphys.init.phys_patch, 'SampleRate', state.yphys.acq.outputRate);
state.yphys.init.phys_patchChannel = addchannel(state.yphys.init.phys_patch, state.yphys.init.phys_patchChannelIndex);
set(state.yphys.init.phys_patch, 'TriggerType', 'HwDigital');

%%%%%%%%%%%%%%%%
%Scan
state.yphys.init.scan_ao = analogoutput('nidaq', state.yphys.init.mirrorOutputBoardIndex);
addchannel(state.yphys.init.scan_ao, state.yphys.init.XMirrorChannelIndex);
addchannel(state.yphys.init.scan_ao, state.yphys.init.YMirrorChannelIndex);
set(state.yphys.init.scan_ao, 'SampleRate', state.yphys.acq.outputRate);
set(state.yphys.init.scan_ao, 'Tag', 'yphys');
set(state.yphys.init.scan_ao, 'RepeatOutput', 0, 'Tag', 'yphys');
set(state.yphys.init.scan_ao, 'TriggerType', 'HwDigital');

%pockels-scanlaser
state.yphys.init.laser_ao = (analogoutput('nidaq', state.yphys.init.eom.pockelsBoardIndex1));
addchannel(state.yphys.init.laser_ao, state.yphys.init.eom.pockelsChannelIndex1);
%addchannel(state.yphys.init.laser_ao, state.spc.init.pockelsChannelIndex);
set(state.yphys.init.laser_ao, 'Tag', 'yphys');
set(state.yphys.init.laser_ao, 'TriggerType', 'HwDigital');

%pockels-uncage
state.yphys.init.pockels_ao = (analogoutput('nidaq', state.yphys.init.eom.pockelsBoardIndex2));
addchannel(state.yphys.init.pockels_ao, state.yphys.init.eom.pockelsChannelIndex2);
addchannel(state.yphys.init.pockels_ao, state.yphys.init.eom.pockelsChannelIndex3);
set(state.yphys.init.pockels_ao, 'Tag', 'yphys');
set(state.yphys.init.pockels_ao, 'TriggerType', 'HwDigital');

%Intensity
state.yphys.init.acq_ai = analoginput('nidaq', state.yphys.init.acquisitionBoardIndex);
addchannel(state.yphys.init.acq_ai, state.yphys.init.inputChannelIndex1);
addchannel(state.yphys.init.acq_ai, state.yphys.init.inputChannelIndex2);
set(state.yphys.init.acq_ai, 'TriggerType', 'HwDigital');
set(state.yphys.init.acq_ai, 'SampleRate', state.yphys.acq.inputRate, 'Tag', 'yphys');
%set(state.yphys.init.acq_ai, 'InputRange', [0, 10]);
%set(state.yphys.init.acq_ai, 'InputRange', [0, 10]);

%V-clamp
%%Vclamp
state.yphys.init.vclamp = digitalio('nidaq', state.yphys.init.vclampBoardIndex);
state.yphys.init.vclampLine = addline(state.yphys.init.vclamp, state.yphys.init.vclampLineIndex, 'out', 'TriggerOutput');
set(state.yphys.init.vclamp, 'Tag', 'yphys');

%%Trigger
if ~isfield(state, 'init')
    state.init.dio = digitalio('nidaq', state.yphys.init.triggerBoardIndex);
    state.init.triggerLine = addline(state.yphys.init.dio, state.yphys.init.triggerLineIndex, 'out', 'TriggerOutput');
end


%Timer

