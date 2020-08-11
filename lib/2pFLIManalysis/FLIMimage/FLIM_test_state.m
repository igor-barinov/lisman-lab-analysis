function status = FLIM_test_state;
global state;

status=0;
[out status]=calllib('spcm32','SPC_test_state',state.spc.acq.module,status);
