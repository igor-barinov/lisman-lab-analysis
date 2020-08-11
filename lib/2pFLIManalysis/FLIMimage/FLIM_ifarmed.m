function armed = FLIM_ifarmed;

global state;
status=0;
[out status]=calllib('spcm32','SPC_test_state',state.spc.acq.module,status);

a=dec2bin(double(status));

a = ['0000000000000000000', a];
    
armed = num2str(a(end-7));