function FLIM_TimerFunctionRates

global state;
global gh;

if state.spc.acq.spc_image
	if ~state.spc.internal.ifstart
		data=libstruct('s_rate_values');
		data.sync_rate=0;
		[out1 data]=calllib('spcm32','SPC_read_rates',state.spc.acq.module,data);
		
		data.sync_rate=strrep(sprintf('%.3e',data.sync_rate),'e+00',' e+');
		data.cfd_rate=strrep(sprintf('%.3e',data.cfd_rate),'e+00',' e+');
		data.tac_rate=strrep(sprintf('%.3e',data.tac_rate),'e+00',' e+');
		data.adc_rate=strrep(sprintf('%.3e',data.adc_rate),'e+00',' e+');
		
		globalHandles = gh.spc.FLIMimage;
		
		set(globalHandles.edit2,'String',data.sync_rate);
		set(globalHandles.edit3,'String',data.cfd_rate);
		set(globalHandles.edit4,'String',data.tac_rate);
		set(globalHandles.edit5,'String',data.adc_rate);
	end
else
    	data=libstruct('s_rate_values');
		data.sync_rate=0;
		[out1 data]=calllib('spcm32','SPC_read_rates',state.spc.acq.module,data);
		
		data.sync_rate=strrep(sprintf('%.3e',data.sync_rate),'e+00',' e+');
		data.cfd_rate=strrep(sprintf('%.3e',data.cfd_rate),'e+00',' e+');
		data.tac_rate=strrep(sprintf('%.3e',data.tac_rate),'e+00',' e+');
		data.adc_rate=strrep(sprintf('%.3e',data.adc_rate),'e+00',' e+');
		
		globalHandles = gh.spc.FLIMimage;
		
		set(globalHandles.edit2,'String',data.sync_rate);
		set(globalHandles.edit3,'String',data.cfd_rate);
		set(globalHandles.edit4,'String',data.tac_rate);
		set(globalHandles.edit5,'String',data.adc_rate);
end
