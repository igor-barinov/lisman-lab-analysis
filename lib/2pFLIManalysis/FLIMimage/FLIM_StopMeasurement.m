function error1 = FLIM_StopMeasurement

global state;

error1 = 0;
state.spc.internal.ifstart = 0;
out1=calllib('spcm32','SPC_stop_measurement',state.spc.acq.module);
if out1 < 0
    error = FLIM_get_error_string (out1);    
    disp(['Error during stop measurement:', error]);
    error1 = 1;
end