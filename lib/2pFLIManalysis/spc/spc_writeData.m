function spc_writeData
    global state;

    if  state.spc.acq.uncageBox & state.init.eom.showBoxArray(2)
        fileName = [state.files.fullFileName '_glu.tif'];
    else
        fileName = [state.files.fullFileName '.tif'];
    end
    [pathstr,name,ext,versn] = fileparts(fileName);
    
    if exist([pathstr, '\spc']) ~= 7
        mkdir (pathstr, '\spc');
    end
    spc_filename = [pathstr, '\spc\', name, '.tif']; 
    
    state.spc.files.fullFileName = spc_filename;
    state.spc.files.maxfullFileName = [pathstr, '\spc\', name, '_max.tif']; 
    
    if state.internal.zSliceCounter == 0 % if its the first frame of first channel, then overwrite...
        spc_saveAsTiff(spc_filename, 0);  %1 =append
	else
        spc_saveAsTiff(spc_filename, 1);
	end	

