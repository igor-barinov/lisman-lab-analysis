function filled = FLIM_ifmemoryfilled;

global state;
status=0;
[out status]=calllib('spcm32','SPC_test_state',state.spc.acq.module,status);

a=dec2bin(double(status));

a = ['0000000000000000000', a];
    
Notfilled = num2str(a(end-13));

if Notfilled == 1
    filled = 0;
else
    filled = 1;
end