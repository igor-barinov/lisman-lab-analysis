function FLIM_SaveIniFile(hObject,handles,filename)

global state;

SPCdata = state.spc.acq.SPCdata;

f=fopen(filename,'w');

fprintf(f,';      SPCM initialisation file\r\n');
fprintf(f,';      Created by FLIMimage v1.0 on %i-%i-%i %i:%i:%i\r\n\r\n',fix(clock));

fprintf(f,'[spc_base]\r\n\r\n');
fprintf(f,'simulation= 0\r\n');
fprintf(f,'pci_bus_no= -1\r\n');
fprintf(f,'pci_card_no= -1\r\n\r\n');

fprintf(f,'[spc_module]\r\n\r\n');

%fprintf(f,'base_adr= %.3f\r\n',SPCdata.base_adr);
%fprintf(f,'init= %.10f\r\n',SPCdata.init);
fprintf(f,'cfd_limit_low= %.10f\r\n',SPCdata.cfd_limit_low);
%fprintf(f,'cfd_limit_high= %.10f\r\n',SPCdata.cfd_limit_high);
fprintf(f,'cfd_zc_level= %.10f\r\n',SPCdata.cfd_zc_level);
%fprintf(f,'cfd_holdoff= %.10f\r\n',SPCdata.cfd_holdoff);
fprintf(f,'sync_zc_level= %.10f\r\n',SPCdata.sync_zc_level);
fprintf(f,'sync_holdoff= %.10f\r\n',SPCdata.sync_holdoff);
fprintf(f,'sync_threshold= %.10f\r\n',SPCdata.sync_threshold);
fprintf(f,'tac_range= %.10f\r\n',SPCdata.tac_range);
fprintf(f,'sync_freq_div= %.10f\r\n',SPCdata.sync_freq_div);
fprintf(f,'tac_gain= %.10f\r\n',SPCdata.tac_gain);
fprintf(f,'tac_offset= %.10f\r\n',SPCdata.tac_offset);
fprintf(f,'tac_limit_low= %.10f\r\n',SPCdata.tac_limit_low);
fprintf(f,'tac_limit_high= %.10f\r\n',SPCdata.tac_limit_high);
fprintf(f,'adc_resolution= %.10f\r\n',SPCdata.adc_resolution);

fprintf(f,'ext_latch_delay= %.10f\r\n',SPCdata.ext_latch_delay);
fprintf(f,'collect_time= %.10f\r\n',SPCdata.collect_time);
%fprintf(f,'display_time= %.10f\r\n',SPCdata.display_time);
fprintf(f,'repeat_time= %.10f\r\n',SPCdata.repeat_time);
fprintf(f,'stop_on_time= %.10f\r\n',SPCdata.stop_on_time);
fprintf(f,'stop_on_ovfl= %.10f\r\n',SPCdata.stop_on_ovfl);
fprintf(f,'dither_range= %.10f\r\n',SPCdata.dither_range);
fprintf(f,'count_incr= %.10f\r\n',SPCdata.count_incr);
%fprintf(f,'mem_bank= %.10f\r\n',SPCdata.mem_bank);
fprintf(f,'dead_time_comp= %.10f\r\n',SPCdata.dead_time_comp);
%fprintf(f,'scan_control= %.10f\r\n',SPCdata.scan_control);
%fprintf(f,'routing_mode= %.10f\r\n',SPCdata.routing_mode);
%fprintf(f,'tac_enable_hold= %.10f\r\n',SPCdata.tac_enable_hold);
%fprintf(f,'pci_card_no= %.10f\r\n',SPCdata.pci_card_no);
fprintf(f,'mode= %.10f\r\n',SPCdata.mode);
%fprintf(f,'test_eep= %.10f\r\n',SPCdata.test_eep);

fprintf(f,'scan_size_x= %d\r\n',SPCdata.scan_size_x);
fprintf(f,'scan_size_y= %d\r\n',SPCdata.scan_size_y);
fprintf(f,'scan_rout_x= %d\r\n',SPCdata.scan_rout_x);
fprintf(f,'scan_rout_y= %d\r\n',SPCdata.scan_rout_y);
fprintf(f,'scan_polarity= %df\r\n',SPCdata.scan_polarity);
fprintf(f,'scan_flyback= %d\r\n',SPCdata.scan_flyback);
fprintf(f,'scan_borders= %d\r\n',SPCdata.scan_borders);
fprintf(f,'pixel_clock= %d\r\n',SPCdata.pixel_clock);
fprintf(f,'line_compression= %d\r\n',SPCdata.line_compression);
fprintf(f,'trigger= %d\r\n',SPCdata.trigger);
fprintf(f,'pixel_time= %.3e\r\n',SPCdata.pixel_time);
fprintf(f,'ext_pixclk_div= %d\r\n',SPCdata.ext_pixclk_div);
fprintf(f,'rate_count_time= %.10f\r\n',SPCdata.rate_count_time);
%fprintf(f,'macro_time_clk= %.10f\r\n',SPCdata.macro_time_clk);
fprintf(f,'add_select= %d\r\n',SPCdata.add_select);
%fprintf(f,'adc_zoom= %.10f\r\n',SPCdata.adc_zoom);

fclose(f);