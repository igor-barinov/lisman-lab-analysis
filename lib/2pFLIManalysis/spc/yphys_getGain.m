function yphys_getGain
global state;
global gh;

if state.yphys.acq.multiclamp
    if isfield(gh.yphys, 'scope')
        vclamp = get(gh.yphys.scope.vclamp, 'Value');
        gainP = get(gh.yphys.scope.gain, 'Value');
    else
        vclamp = 1;
        gainP = 1;
    end
    state.yphys.acq.cclamp = ~vclamp;
    putvalue(state.yphys.init.vclampLine, vclamp);
    gainArray = [1,2,5,10,20,50,100];
    boardGain = gainArray(gainP);
    set(state.yphys.init.phys_data, 'InputRange', [-10, 10]/boardGain);
    %get(state.yphys.init.phys_data, 'InputRange')
else
    %stop(state.yphys.init.phys_setting);
    start(state.yphys.init.phys_setting);
    pause(0.02);
    if get(state.yphys.init.phys_setting, 'SamplesAvailable')
        data = getdata(state.yphys.init.phys_setting);
        mean(data, 1);
        state.yphys.acq.cclamp = (data(1, 2) > 4);
        gaindial = round(2*data(1,1));
        switch gaindial
            case 4
                gain = 0.5;
            case 5
                gain = 1;
            case 6
                gain = 2;
            case 7
                gain = 5;
            case 8
                gain = 10;
            case 9
                gain = 20;
            case 10
                gain = 50;
            case 11
                gain = 100;
            case 12
                gain = 200;
            case 13
                gain = 500;
            otherwise
                disp(num2str(gaindial));
                gain = 100;
        end
        state.yphys.acq.gainC = gain;
        state.yphys.acq.gainV = gain;
    else
        pause(0.02);
        disp('Could not get Gain');
    end
end