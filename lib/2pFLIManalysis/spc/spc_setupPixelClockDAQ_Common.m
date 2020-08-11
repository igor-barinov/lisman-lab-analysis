function spc_setupPixelClockDAQ_Common;
global state;

% if state.spc.init.spc_on == 1
%     channelindex = [state.spc.init.spc_lineChannelIndex, state.spc.init.spc_frameChannelIndex, state.spc.init.spc_pixelChannelIndex];
%     clock_str = {'line_clock', 'frame_clock', 'pixel_clock'};
%     for i = 1:length(channelindex)
% 		str1 = (clock_str{i});
% 		try
% 			nameOutputChannel(state.acq.dm, state.spc.init.spc_boardIndex, channelindex(i), str1);
% 			enableChannel(state.acq.dm, str1);
% 			setAOProperty(state.acq.dm, str1, 'TriggerType', 'HWDigital');
% 			setAOProperty(state.acq.dm, str1, 'TransferMode', state.init.transferMode);
%             setAOProperty(state.acq.dm, str1, 'SampleRate',  state.acq.outputRate);
%             state.init.eom.grabLaserList = [state.init.eom.grabLaserList, ', ', str1];
%             state.init.eom.focusLaserList = [state.init.eom.focusLaserList, ', ', str1];
% 		catch
% 		end
% 	end
% end
     
%%%%%%%%%%%%%%%%%%%%%%%
%TEMPORAL WORKAROUND
%%%%%%%%%%%%%%%%%%%%%%%
a = daqfind('Tag', 'spc');
if length(a) > 0
	for i=1:length(a);
        stop(a{i});
        delete(a{i}); 
    end
end
    if state.spc.init.spc_on == 1
		state.spc.init.spc_ao = analogoutput('nidaq',state.spc.init.spc_boardIndex);
        state.spc.init.pockels_ao = analogoutput ('nidaq', state.spc.init.spc_boardIndex);
		state.spc.init.spc_aoF = analogoutput('nidaq',state.spc.init.spc_boardIndex);			 % 1 refers to the NIDAQ MIO64 Board

        set(state.spc.init.spc_aoF, 'Tag', 'spc');        
        set(state.spc.init.spc_ao, 'Tag', 'spc');
        set(state.spc.init.pockels_ao, 'Tag', 'spc');

        state.spc.init.spc_lineChannel = addchannel(state.spc.init.spc_ao, state.spc.init.spc_lineChannelIndex);	
        state.spc.init.spc_frameChannel = addchannel(state.spc.init.spc_ao, state.spc.init.spc_frameChannelIndex);
        state.spc.init.spc_pixelChannel = addchannel(state.spc.init.spc_ao, state.spc.init.spc_pixelChannelIndex);
        if state.init.pockelsOn == 1
            state.spc.init.pockelsChannel = addchannel(state.spc.init.spc_ao, state.spc.init.pockelsChannelIndex);
            state.spc.init.pockelsChannel2 = addchannel(state.spc.init.spc_ao, state.spc.init.pockelsChannel2Index);
            state.spc.init.pockelsChannel3 = addchannel(state.spc.init.spc_ao, state.spc.init.pockelsChannel3Index);
            addchannel(state.spc.init.pockels_ao, state.spc.init.pockelsChannelIndex);
            addchannel(state.spc.init.pockels_ao, state.spc.init.pockelsChannel2Index);
            addchannel(state.spc.init.pockels_ao, state.spc.init.pockelsChannel3Index);

        end
        if state.spc.acq.spc_pixel
		    set(state.spc.init.spc_ao, 'SampleRate', state.spc.acq.spc_outputRate);
        else
            set(state.spc.init.spc_ao, 'SampleRate', state.acq.outputRate);
        end
		set(state.spc.init.spc_ao, 'TriggerType', 'HWDigital');	
        set(state.spc.init.spc_ao, 'TransferMode', 'SingleDMA');
        
        set(state.spc.init.pockels_ao, 'SampleRate', state.acq.outputRate);
		set(state.spc.init.pockels_ao, 'TriggerType', 'HWDigital');	
        set(state.spc.init.pockels_ao, 'TransferMode', 'SingleDMA');
        

		state.spc.init.spc_lineChannelF = addchannel(state.spc.init.spc_aoF, state.spc.init.spc_lineChannelIndex);	
        state.spc.init.spc_frameChannelF = addchannel(state.spc.init.spc_aoF, state.spc.init.spc_frameChannelIndex);
        state.spc.init.spc_pixelChannelF = addchannel(state.spc.init.spc_aoF, state.spc.init.spc_pixelChannelIndex);
        if state.init.pockelsOn == 1
            state.spc.init.pockelsChannelF = addchannel(state.spc.init.spc_aoF, state.spc.init.pockelsChannelIndex);
            %state.spc.init.pockelsChannel2F = addchannel(state.spc.init.spc_aoF, state.spc.init.pockelsChannel2Index);          
        end
        if state.spc.acq.spc_pixel
		    set(state.spc.init.spc_aoF, 'SampleRate', state.spc.acq.spc_outputRate);
        else
            set(state.spc.init.spc_aoF, 'SampleRate', state.acq.outputRate);
        end
		set(state.spc.init.spc_aoF, 'TriggerType', 'HWDigital');
        set(state.spc.init.spc_aoF, 'TransferMode', 'singleDMA');
        %set(state.spc.init.spc_aoF, 'TransferMode', 'doubleDMA');
        
        %set(state.spc.init.pockels_ao, 'SampleRate', state.acq.outputRate);
        
        %stop(state.init.dio);
       % state.spc.init.spc_dio = digitalio('nidaq', state.spc.init.spc_triggerBoardIndex);
        %state.spc.init.spc_line = addline(state.init.dio,
        %state.spc.init.spc_lineIndex, 'out');
        %start(state.init.dio);
           
        
	end