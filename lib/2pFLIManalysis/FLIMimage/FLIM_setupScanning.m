function error = FLIM_setupScanning (focus)

global state;
global gh;

if ~isfield(gh, 'mainControls')
    error = 0;
    return;
end

error = 0;

state.spc.acq.SPCdata.scan_borders = 0;
state.spc.acq.SPCdata.scan_polarity = 0;
state.spc.acq.SPCdata.trigger = 2;
state.spc.acq.SPCdata.pixel_clock = state.spc.acq.spc_pixel;

if focus
    state.spc.acq.SPCdata.collect_time = state.internal.numberOfFocusFrames*state.acq.linesPerFrame*state.acq.msPerLine;
else
%     state.acq.averaging = 1;
%     state.standardMode.averaging = 1;
%     set(gh.standardModeGUI.averageFrames, 'Value', 1)
    state.spc.acq.SPCdata.mode = 2;
    state.spc.acq.SPCdata.collect_time = state.acq.numberOfFrames*state.acq.linesPerFrame*state.acq.msPerLine;
end

if state.acq.pixelsPerLine < 257 & state.acq.linesPerFrame < 257
    state.spc.acq.SPCdata.scan_size_x = state.acq.pixelsPerLine;
    state.spc.acq.SPCdata.scan_size_y = state.acq.linesPerFrame;
else
    beep;
    disp('Error: change pixelsPerLine and state.acq.linesPerFrame to < 256');
    error = 1;
    return;
end

state.spc.acq.SPCdata.pixel_time = 1/(state.acq.inputRate/state.acq.binFactor);
state.spc.acq.SPCdata.line_compression = 1;

if state.spc.acq.spc_binning == 1
     binfactor = state.spc.acq.binFactor;
     state.spc.acq.SPCdata.scan_size_x  =  floor(state.spc.acq.SPCdata.scan_size_x / binfactor) ;
     state.spc.acq.SPCdata.scan_size_y  =  floor(state.spc.acq.SPCdata.scan_size_y / binfactor) ;
     state.spc.acq.SPCdata.pixel_time = state.spc.acq.SPCdata.pixel_time * binfactor;
     state.spc.acq.SPCdata.line_compression = binfactor;
     state.spc.acq.SPCdata.scan_borders = state.spc.acq.SPCdata.scan_borders/binfactor;
     
end


FLIM_setParameters;