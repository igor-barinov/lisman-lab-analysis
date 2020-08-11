function FLIM_ConfigureMemory

global state;

data=libstruct('s_SPCMemConfig');
data.max_block_no=0;

switch state.spc.acq.SPCdata.mode
	case 0,  
        [out1 state.spc.acq.SPCMemConfig]=calllib('spcm32','SPC_configure_memory',state.spc.acq.module,state.spc.acq.SPCdata.adc_resolution,0,data);
	case {2,3},
       %[out1 state.spc.acq.SPCMemConfig]=calllib('spcm32','SPC_configure_memory',state.spc.acq.module,state.spc.acq.SPCdata.adc_resolution,0,data);
       [out1 state.spc.acq.SPCMemConfig]=calllib('spcm32','SPC_configure_memory',state.spc.acq.module,-1,0,data);
    otherwise
end

if out1 ~= 0
    error = FLIM_get_error_string (out1);    
    disp(['Memory config error:', error]);
end