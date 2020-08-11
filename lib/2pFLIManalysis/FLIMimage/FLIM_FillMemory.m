function FLIM_FillMemory

global state;

%block = state.spc.acq.SPCMemConfig.blocks_per_frame*state.spc.acq.SPCMemConfig.frames_per_page;

    
switch state.spc.acq.SPCdata.mode
	case {0,1}
		for i=0:state.spc.acq.SPCMemConfig.blocks_per_frame-1
            out1=calllib('spcm32','SPC_fill_memory',state.spc.acq.module,i,0,0);
			if out1 ~= 0
                error = FLIM_get_error_string (out1);    
                disp(['Memory filling error:', error]);
                return;
			end
		end
    case {2,3}   
        out1=calllib('spcm32','SPC_fill_memory',state.spc.acq.module,-1,0,0);
        filled = 1;
    	if out1 ~= 0
            for i=1:1000
                pause(0.05);
                filled = FLIM_ifmemoryfilled;
                if filled
                    break
                end
            end
		end
        if ~filled
            disp('Memory was not filled !!!');
        else
           % disp('Memory was successfully filled');
        end
    otherwise
end

