function out = FLIM_enable_sequencer (enable)
global state;

out = calllib('spcm32', 'SPC_enable_sequencer', state.spc.acq.module, enable);

if (out~=0)
    error = FLIM_get_error_string (out);    
    disp(['error during enabling sequencer:', error]);
end