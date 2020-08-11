function a = yphys_mkPulse(rate, nstim, dwell, Dheight, delay, sLength, tag);
global state;
global gh;

nSample = state.yphys.acq.outputRate*sLength/1000;
OneStim = round(state.yphys.acq.outputRate/rate);
a(1:OneStim) = 0;
Pulsephase = round(state.yphys.acq.outputRate*dwell/1000);
a(1:Pulsephase) = +Dheight;
%a(Pulsephase+1:2*Pulsephase) = -Dheight;
a = a(:);
a = repmat(a, nstim, 1);
blank = zeros(state.yphys.acq.outputRate*delay/1000, 1);
a = [blank; a];

if length(a) < nSample
    a = [a; zeros((nSample - length(a)), 1)];
else
    a = a(1:nSample);
end

state.yphys.acq.stimPulse = a;
try
    if strcmp(tag, 'ap')
        set(gh.yphys.pulsePlot1, 'XData', (1:length(a))/state.yphys.acq.outputRate*1000, 'YData', a);
    elseif strcmp(tag, 'stim')
        set(gh.yphys.pulsePlot2, 'XData', (1:length(a))/state.yphys.acq.outputRate*1000, 'YData', a);
    elseif strcmp(tag, 'uncage')
        set(gh.yphys.pulsePlot3, 'XData', (1:length(a))/state.yphys.acq.outputRate*1000, 'YData', a);
    else
        set(gh.yphys.pulsePlot1, 'XData', (1:length(a))/state.yphys.acq.outputRate*1000, 'YData', a);
    end
catch
    disp('Error in yphys_mkpulse');
end