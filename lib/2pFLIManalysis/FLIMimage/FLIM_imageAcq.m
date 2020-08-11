function FLIM_imageAcq;

global state;
global spc;
global gh;

pageNumber=0;


set(gh.spc.FLIMimage.status, 'String', 'Reading data'); 
set(gh.spc.FLIMimage.focus,'Enable','Off');
set(gh.spc.FLIMimage.grab,'Enable','Off');
set(gh.spc.FLIMimage.loop,'Enable','Off');

blocks_per_frame = state.spc.acq.SPCMemConfig.blocks_per_frame;
frames_per_page = state.spc.acq.SPCMemConfig.frames_per_page;
block_length = state.spc.acq.SPCMemConfig.block_length;

disp('Now reading data block ...');

memorysize =  block_length* blocks_per_frame*  frames_per_page;
image1(memorysize)=0.0;
%[out1 image1]=calllib('spcm32','SPC_read_data_page',state.spc.acq.module,0,0,image1);
[out1 image1]=calllib('spcm32','SPC_read_data_frame',state.spc.acq.module,0,0,image1);

scan_size_x = state.spc.acq.SPCdata.scan_size_y;
scan_size_y = state.spc.acq.SPCdata.scan_size_x;
res = 2^state.spc.acq.SPCdata.adc_resolution;


spc.SPCdata = state.spc.acq.SPCdata;
spc.size = [res, scan_size_x, scan_size_y];
spc.switches.peak = [-1, 4];
try 
    limit = spc.switches.lifetime_limit; 
catch
    limit = [2.4, 3.4];
end
try 
    range = spc.fit.range; 
catch
    range = [1, res];
end
spc.switches.lifetime_limit = limit;
spc.fit.background = 0;
image1 = (reshape(image1, res, scan_size_y, scan_size_x));
image1 = double(permute(image1, [1,3,2]));
spc.project = reshape(sum(image1, 1), scan_size_x, scan_size_y);
spc.lifetime= sum(sum(image1, 2),3);
spc.switches.imagemode = 1;
spc.switches.logscale = 1;
spc.fit.range = range;
spc.datainfo.time = datestr(clock, 13);
spc.datainfo.date = datestr(clock, 1);
spc.datainfo.cfd_ll = state.spc.acq.SPCdata.cfd_limit_low;
spc.datainfo.cfd_lh = state.spc.acq.SPCdata.cfd_limit_high;
spc.datainfo.cfd_zc = state.spc.acq.SPCdata.cfd_zc_level;
spc.datainfo.cfd_hf = state.spc.acq.SPCdata.cfd_holdoff;
spc.datainfo.syn_th = state.spc.acq.SPCdata.sync_threshold;
spc.datainfo.syn_zc = state.spc.acq.SPCdata.sync_zc_level;
spc.datainfo.syn_fd = state.spc.acq.SPCdata.sync_freq_div;
spc.datainfo.syn_hf = state.spc.acq.SPCdata.sync_holdoff;
spc.datainfo.scan_x = scan_size_x;
spc.datainfo.scan_y = scan_size_y;
spc.datainfo.col_t = state.spc.acq.SPCdata.collect_time;
spc.datainfo.pix_time =state.spc.acq.SPCdata.pixel_time;
spc.datainfo.incr = state.spc.acq.SPCdata.count_incr;
spc.datainfo.dither = state.spc.acq.SPCdata.dither_range;
spc.datainfo.tac_of =state.spc.acq.SPCdata.tac_offset;
spc.datainfo.tac_ll =state.spc.acq.SPCdata.tac_limit_low;
spc.datainfo.taclh = state.spc.acq.SPCdata.tac_limit_high;
spc.datainfo.tac_r = state.spc.acq.SPCdata.tac_range*1e-9;
spc.datainfo.tac_g = state.spc.acq.SPCdata.tac_gain;
spc.datainfo.adc_re = res;
spc.datainfo.psPerUnit = spc.datainfo.tac_r/spc.datainfo.tac_g/spc.datainfo.adc_re*1e12;
spc.datainfo.pulseInt = 13.233;

if (out1~=0)
    error = FLIM_get_error_string (out1);    
    disp(['error during reading data:', error]);
end

 spc.imageMod = image1; %reshape(image1, spc.size(1), spc.size(2)*spc.size(3));
 %spc.imageMod = spc.image;

set(gh.spc.FLIMimage.focus,'Enable','On');
set(gh.spc.FLIMimage.grab,'Enable','On');
set(gh.spc.FLIMimage.loop,'Enable','On');
spc_redrawSetting;