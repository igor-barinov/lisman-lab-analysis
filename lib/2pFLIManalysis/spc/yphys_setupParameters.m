function yphys_setupParameters
global state;
global gh;
handles = gh.yphys.stimScope;
Radio_on = Radiobutton_values(handles);
pulseN = str2num(get(handles.pulseN, 'String'));

stimtype = find(Radio_on);

for i=1:3
    try
		freq = state.yphys.acq.pulse{i, pulseN}.freq;
		nstim = state.yphys.acq.pulse{i, pulseN}.nstim;
		dwell = state.yphys.acq.pulse{i, pulseN}.dwell;
		amp = state.yphys.acq.pulse{i, pulseN}.amp;
		delay = state.yphys.acq.pulse{i, pulseN}.delay;
		sLength = state.yphys.acq.pulse{i, pulseN}.sLength;
    catch
        state.yphys.acq.pulse{i, pulseN}.freq = 50;
        state.yphys.acq.pulse{i, pulseN}.nstim = 1;
        state.yphys.acq.pulse{i, pulseN}.dwell = 100;
        state.yphys.acq.pulse{i, pulseN}.amp = 1;
        state.yphys.acq.pulse{i, pulseN}.delay = 50;
        state.yphys.acq.pulse{i, pulseN}.sLength = 250;
        freq = state.yphys.acq.pulse{i, pulseN}.freq;
		nstim = state.yphys.acq.pulse{i, pulseN}.nstim;
		dwell = state.yphys.acq.pulse{i, pulseN}.dwell;
		amp = state.yphys.acq.pulse{i, pulseN}.amp;
		delay = state.yphys.acq.pulse{i, pulseN}.delay;
		sLength = state.yphys.acq.pulse{i, pulseN}.sLength;
    end
    switch i
		case 1
            yphys_mkPulse(freq, nstim, dwell, amp, delay, sLength, 'ap');
		case 2
            yphys_mkPulse(freq, nstim, dwell, amp, delay, sLength, 'stim');
		case 3
            yphys_mkPulse(freq, nstim, dwell, amp, delay, sLength, 'uncage');
		otherwise
    end
end

freq = state.yphys.acq.pulse{stimtype, pulseN}.freq;
nstim = state.yphys.acq.pulse{stimtype, pulseN}.nstim;
dwell = state.yphys.acq.pulse{stimtype, pulseN}.dwell;
amp = state.yphys.acq.pulse{stimtype, pulseN}.amp;
delay = state.yphys.acq.pulse{stimtype, pulseN}.delay;
sLength = state.yphys.acq.pulse{stimtype, pulseN}.sLength;


set(handles.freq, 'String', num2str(freq));
set(handles.amp, 'String', num2str(amp));
set(handles.nstim, 'String', num2str(nstim));
set(handles.dwell, 'String', num2str(dwell));
set(handles.delay, 'String', num2str(delay));
set(handles.Length, 'String', num2str(sLength));
state.yphys.acq.radio_on = Radiobutton_values (handles);


%%%%%%%%%%%%%%%%%%%%%%%%
function on = Radiobutton_values (handles)

on(1) = get(handles.PatchRadio, 'Value');
on(2) = get(handles.StimRadio, 'Value');
on(3) = get(handles.UncageRadio, 'Value');