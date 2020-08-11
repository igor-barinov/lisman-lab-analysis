function spc_executeGrabOne;


	global state gh
    
    h = gh.mainControls.grabOneButton;
    state.internal.looping=0;
    
	val=get(h, 'String');
		
		if strcmp(val, 'GRAB')
            
            %stopGrab;
            spc_stopGrab;
            spc_stopFocus;
            spc_parkLaser;
            spc_setupPixelClockDAQ_Specific;
            spc_putData;
            
%             %Synch to Physiology software if applicable...
% 			if state.init.syncToPhysiology
%                 if isfield(state,'physiology') & isfield(state.physiology,'mainPhysControls') & isfield(state.physiology.mainPhysControls,'acqNumber')
%                     maxVal=max(state.physiology.mainPhysControls.acqNumber,...
%                         state.files.fileCounter);
%                     state.physiology.mainPhysControls.acqNumber=maxVal;
%                     state.files.fileCounter=maxVal;
%                     updateGUIByGlobal('state.physiology.mainPhysControls.acqNumber');
%                     updateGUIByGlobal('state.files.fileCounter');
%                 end
%             end

			if strcmp(get(gh.basicConfigurationGUI.figure1, 'Visible'), 'on') == 1
				beep;
				setStatusString('Close Configuration GUI');
				return
			end
			
            ok=savingInfoIsOK;
			if ok==0				
                return
			end
% 			
% 			if state.internal.updatedZoomOrRot | state.init.eom.changed(state.init.eom.scanLaserBeam) % need to reput the data with the approprite rotation and zoom.
% 				state.acq.mirrorDataOutput = rotateMirrorData(1/state.acq.zoomFactor*state.acq.mirrorDataOutputOrg);
% 				%flushAOData;
% 				state.internal.updatedZoomOrRot=0;
% 			end
				
			% Check if file exisits
			overwrite = checkFileBeforeSave([state.files.fullFileName '.tif']);
			if isempty(overwrite)
				return;
			elseif ~overwrite
                %TPMOD 2/6/02
                if state.files.autoSave	
				    disp('Overwriting Data!!');
                end
			end
			
% 			startZoom;
			if state.init.autoReadPMTOffsets
				startPMTOffsets;
			end
			MP285Flush;

			setStatusString('Acquiring Grab...');
			set(h, 'String', 'ABORT');
			set([gh.mainControls.focusButton gh.mainControls.startLoopButton], 'Visible', 'Off');
			turnOffMenus;
			
			if state.acq.numberOfZSlices > 1	
                state.internal.initialMotorPosition=updateMotorPosition;
			else
				state.internal.initialMotorPosition=[];
			end		

			resetCounters;
			state.internal.abortActionFunctions=0;
			
			updateGUIByGlobal('state.internal.frameCounter');
			updateGUIByGlobal('state.internal.zSliceCounter');
			
            updateCurrentROI;   %TPMOD 6/18/03
            
            %yphys_sendStimulation(50, 50, 2);

			spc_startGrab;
            if state.shutter.shutterDelay==0
			    openShutter;
            else
                state.shutter.shutterOpen=0;
            end
			spc_diotrigger;
                
		elseif strcmp(val, 'ABORT')

            state.spc.abortActionFunctions = 1;
            %beep;
            %disp('Now aborting');


            %TPMOD 7/7/03....
            if state.internal.roiCycleExecuting
                abortROICycle;
                return
            end
            
			state.internal.abortActionFunctions=1;

			closeShutter;
			%stopGrab;
            
			setStatusString('Aborting...');
			set(h, 'Enable', 'off');
			
			%parkLaser;

			spc_stopGrab;
            spc_parkLaser;
            %spc_putdata;            
            
			%flushAOData;
			executeGoHome;
			pause(.05);
			set(h, 'String', 'GRAB');
			set(h, 'Enable', 'on');
            turnOnMenus;
			set([gh.mainControls.focusButton gh.mainControls.startLoopButton], 'Visible', 'On');
			setStatusString('');
		else
			disp('executeGrabOneCallback: Grab One button is in unknown state'); 	% BSMOD - error checking
		end
