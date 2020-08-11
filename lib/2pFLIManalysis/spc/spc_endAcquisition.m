function spc_endAcquisition;

global state;
global gh;


%%%%%%%%%%%%%%%%FLIM
spc_stopGrab;
spc_parkLaser;
%spc_putData;
if state.spc.acq.spc_dll
    FLIM_StopMeasurement;
end
%%%%%%%%%%%%%%%%%FLIM

stopGrab;
closeShutter;
parkLaser;

if state.internal.zSliceCounter + 1 == state.acq.numberOfZSlices | (state.spc.acq.uncageBox & state.init.eom.showBoxArray(2))
% Done Acquisition.

%%%%%%%%%%%%%%%FLIM
    if state.spc.init.spc_on & state.spc.acq.spc_dll
        FLIM_imageAcq;
        spc_writeData;
        spc_maxProc;
        if state.acq.numberOfZSlices > 1 %%%%%%%%%%%%%%%Max file is not required for Uncaging ??
            if state.spc.acq.uncageBox & state.init.eom.showBoxArray(2)
            else
                spc_saveAsTiff(state.spc.files.maxfullFileName, 0);
            end
        end
        set (state.spc.init.spc_ao, 'SamplesOutputFcn', '');
        set(gh.spc.FLIMimage.grab, 'String', 'GRAB');

        if strcmp(get(gh.spc.FLIMimage.loop, 'String'), 'LOOP')
            set(gh.spc.FLIMimage.focus, 'Visible', 'on');
            set(gh.spc.FLIMimage.grab, 'Visible', 'on');
            stop(state.spc.acq.mt);
            delete(state.spc.acq.mt);
        end
    end

%%%%%%%%%%%%%%%FLIM

	%if state.files.autoSave		% BSMOD - Check status of autoSave option
		%status=state.internal.statusString;
		%setStatusString('Writing data...');
		%setStatusString(status);
        state.files.fileCounter=state.files.fileCounter+1;
        if state.spc.init.spc_on == 1 & state.spc.acq.spc_dll ==0
            state.files.fileCounter=state.files.fileCounter+state.acq.numberOfZSlices-1;
        end
		updateGUIByGlobal('state.files.fileCounter');
		updateFullFileName(0);
        %end
    
	
	state.internal.zSliceCounter = state.internal.zSliceCounter + 1;
	updateGUIByGlobal('state.internal.zSliceCounter');
    
	if state.acq.numberOfZSlices > 1
		%mp285FinishMove(1);	% check that movement worked during stack
		if ~executeGoHome
            disp('ERROR DURING EXECUTEGOHOME');
            pause(0.1);
            mp285FinishMove(1);
        else
            mp285FinishMove(1);
        end      
	end				


	setStatusString('Ending Grab...');
	set(gh.mainControls.focusButton, 'Visible', 'On');
	set(gh.mainControls.startLoopButton, 'Visible', 'On');
	set(gh.mainControls.grabOneButton, 'String', 'GRAB');
	set(gh.mainControls.grabOneButton, 'Visible', 'On');
	turnOnMenus;
	setStatusString('');

    looping = strcmp(get(gh.spc.FLIMimage.loop, 'String'), 'STOP');   

    if looping
        set(gh.mainControls.grabOneButton, 'Visible', 'Off');
    	set(gh.mainControls.startLoopButton, 'Visible', 'Off');
    end

    %flushAOData;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FLIM
try
    spc_auto(1);
catch
    disp('Error during evaluating spc_auto(1)');
end

%%%%Reset uncaging setup
state.spc.acq.uncageBox = 0;
set(gh.spc.FLIMimage.Uncage, 'Value', 0);

% state.acq.numberOfFrames = state.standardMode.numberOfFrames;
% preAllocateMemory;
% alterDAQ_NewNumberOfFrames;
% state.init.eom.changed(:) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%
% %TEMPORAL WORKAROUND
% % 
% if isfield(state.spc.acq, 'twopos')
%     %state.files.fileCounter
%     if state.files.fileCounter < 3
%         state.spc.acq.twopos = 0;
%     end
%     if state.spc.acq.twopos == 1
% 		if get(gh.motorGUI.positionSlider, 'Value') == 2
%              spc_goto(1);
% 		elseif get(gh.motorGUI.positionSlider, 'Value') == 1
%              spc_goto(2);
% 		end
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield (state.spc.acq, 'twoPosition')
    if state.spc.acq.twoPosition
        posN = 2- (state.files.fileCounter-floor(state.files.fileCounter/2)*2);
        set(gh.motorGUI.positionSlider, 'Value', posN);
	    genericCallback(gh.motorGUI.positionSlider);
		global gh
		%figure(gh.motorGUI.figure1);
        state.motor.maxXYMove = 300;
		turnOffMotorButtons;
		gotoPosition;
		turnOnMotorButtons;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif state.internal.zSliceCounter < state.acq.numberOfZSlices - 1
% Between Acquisitions or ZSlices
	setStatusString('Next Slice...');

	if state.acq.numberOfZSlices > 1
		startMoveStackFocus; 	% start movement - focal plane down one step
	end    
%%%%%%%%%%%%%%%%%%%%%% FLIM
    if state.spc.init.spc_on & state.spc.acq.spc_dll
        FLIM_imageAcq;
        set(gh.spc.FLIMimage.focus,'Enable','Off');
        set(gh.spc.FLIMimage.grab,'Enable','Off');
        set(gh.spc.FLIMimage.loop,'Enable','Off');
        spc_writeData;
        spc_maxProc;
    end
%%%%%%%%%%%%%%%%%%%%%%%%


	state.internal.zSliceCounter = state.internal.zSliceCounter + 1;
	updateGUIByGlobal('state.internal.zSliceCounter');

	state.internal.frameCounter = 1;
	updateGUIByGlobal('state.internal.frameCounter');
	
	setStatusString('Acquiring...');

    %putDataGrab;
	spc_putData;
	
	mp285FinishMove(0);	% check that movement worked
    FLIM_FillMemory;
    FLIM_StartMeasurement;
    spc_startGrab;
        
    looping = strcmp(get(gh.spc.FLIMimage.loop, 'String'), 'STOP');   
    if looping
        set(gh.spc.FLIMimage.loop, 'enable', 'on');
    else
        set(gh.spc.FLIMimage.grab, 'enable', 'on');
    end
	if (strcmp(get(gh.mainControls.grabOneButton, 'String'), 'GRAB') ...
			& strcmp(get(gh.mainControls.grabOneButton, 'Visible'),'on'))
		set(gh.mainControls.grabOneButton, 'enable', 'off');
		set(gh.mainControls.grabOneButton, 'enable', 'on');
	elseif (strcmp(get(gh.mainControls.startLoopButton, 'String'), 'LOOP') ...
			& strcmp(get(gh.mainControls.startLoopButton, 'Visible'),'on'))
		set(gh.mainControls.startLoopButton, 'enable', 'off');
		state.internal.abort=1;
		set(gh.mainControls.startLoopButton, 'enable', 'on');
	else

		openShutter;
		spc_diotrigger;
	end
	
else
end



