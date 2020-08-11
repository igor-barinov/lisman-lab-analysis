function yphys_getData_patch;
global state;
global gh;
if get(state.yphys.init.phys_input, 'SamplesAvailable') >= get(state.yphys.init.phys_input, 'SamplesPerTrigger')
    data1 = getdata(state.yphys.init.phys_input);
    
    if state.yphys.acq.cclamp
        gain = state.yphys.acq.gainC;
    else
        gain = state.yphys.acq.gainV;
    end
	rate = state.yphys.acq.inputRate;
    data2 = data1(:, 1)/gain;
    t = 1:length(data2);
	%plot(t/rate*1000, data2);
    if ishandle(gh.yphys.patchPlot)
	    set(gh.yphys.patchPlot, 'XData', t/rate*1000, 'YData', data2);
    else
        %yphys_patch;% stop function
    end
    state.yphys.acq.data = [t(:)/rate*1000, data2(:)];
    yphys_updateGUI;
    %catch
else
    %disp('XXX');
end

   stop(state.yphys.init.phys_input);