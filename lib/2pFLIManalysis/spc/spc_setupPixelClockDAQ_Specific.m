%function spc_setupPixelClockDAQ_Specific(state_val);
function spc_setupPixelClockDAQ_Specific;
global state;
global gh;


% if state.spc.init.spc_on == 1
%     dataoutput = spc_makeDataOutput;
%     channelindex = [state.spc.init.spc_lineChannelIndex, state.spc.init.spc_frameChannelIndex, state.spc.init.spc_pixelChannelIndex];
%     clock_str = {'line_clock', 'frame_clock', 'pixel_clock'};    
%     for i = 1:length(channelindex)
% 		str1 = (clock_str{i});
%         stopchannel(state.acq.dm, str1);
%         if strcmp(state_val, 'grab')
%             GrabData = repmat(dataoutput(:, i), state.acq.numberOfFrames, 1);
%             putDaqData(state.acq.dm, str1, GrabData);            
%             SetAOProperty(state.acq.dm, str1, 'RepeatOutput', 0);
%         elseif strcmp(state_val, 'focus')
%             putDaqData(state.acq.dm, str1, dataoutput(:, i));
%             SetAOProperty(state.acq.dm, str1, 'RepeatOutput', (state.internal.numberOfFocusFrames -1));
%         end
%         setAOProperty(state.acq.dm, str1, 'SampleRate', state.acq.outputRate);
%      end
% setAOProperty (state.acq.dm, 'line_clock', 'SamplesOutputFcnCount', length(state.spc.acq.spc_DataOutput)*state.acq.numberOfFrames);
% if state.spc.acq.spc_image
%             setAOProperty(state.acq.dm, 'SamplesOutputFcn', '');
%             set(gh.UserFcnGUI.UserFcnOn, 'Value', 1);
%             genericCallback(gh.UserFcnGUI.UserFcnOn);
%             str =  'spc_userFLIMacq.m';
%             if sum(strcmp(state.UserFcnGUI.UserFcnSelected, str))
%             else
%                 if isempty(state.UserFcnGUI.UserFcnSelected)
%                     state.UserFcnGUI.UserFcnSelected={str};
%                 elseif iscellstr(state.UserFcnGUI.UserFcnSelected)
%                     state.UserFcnGUI.UserFcnSelected{length(state.UserFcnGUI.UserFcnSelected)+1}=...
%                         str;
%                 end
%            set(gh.UserFcnGUI.UserFcnSelected,'String',state.UserFcnGUI.UserFcnSelected);
% 
%      else
%          setAOProperty(state.acq.dm, 'line_clock', 'SamplesOutputFcn', 'spc_endAcquisition');
%      end 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%TEMPORAL WORKAROUND
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if state.spc.init.spc_on == 1
        %Specific Settings

        if  state.spc.acq.uncageBox & state.spc.acq.uncageEveryXFrame > 1 & state.init.pockelsOn
		    spc_nRepeat = state.acq.numberOfFrames/state.spc.acq.uncageEveryXFrame-1;
        else
            spc_nRepeat = state.acq.numberOfFrames-1;
        end
        
        state.spc.acq.spc_DataOutput = spc_makeDataOutput(1);
        
        set(state.spc.init.spc_ao, 'RepeatOutput', spc_nRepeat);
        set(state.spc.init.spc_ao, 'SamplesOutputFcnCount', length(state.spc.acq.spc_DataOutput(:,1))*(spc_nRepeat+1));
        set(state.spc.init.spc_ao, 'SampleRate', state.acq.outputRate);
        
        set(state.spc.init.pockels_ao, 'RepeatOutput', spc_nRepeat);
        set(state.spc.init.pockels_ao, 'SamplesOutputFcnCount', length(state.spc.acq.spc_DataOutput(:,1))*(spc_nRepeat+1));
        set(state.spc.init.pockels_ao, 'SampleRate', state.acq.outputRate);

        set(state.spc.init.spc_aoF, 'RepeatOutput', (state.internal.numberOfFocusFrames-1)); 
        set(state.spc.init.spc_aoF, 'SampleRate', state.acq.outputRate);

        if state.spc.acq.spc_image
            set(state.spc.init.spc_ao, 'SamplesOutputFcn', '');
            set(state.spc.init.pockels_ao, 'SamplesOutputFcn', '');
            set(gh.UserFcnGUI.UserFcnOn, 'Value', 1);
            genericCallback(gh.UserFcnGUI.UserFcnOn);
            str =  'spc_userFLIMacq.m';
            if sum(strcmp(state.UserFcnGUI.UserFcnSelected, str))
            else
                if isempty(state.UserFcnGUI.UserFcnSelected)
                    state.UserFcnGUI.UserFcnSelected={str};
                elseif iscellstr(state.UserFcnGUI.UserFcnSelected)
                    state.UserFcnGUI.UserFcnSelected{length(state.UserFcnGUI.UserFcnSelected)+1}=...
                        str;
                end
                set(gh.UserFcnGUI.UserFcnSelected,'String',state.UserFcnGUI.UserFcnSelected);
            end
        else
            set(state.spc.init.spc_ao, 'SamplesOutputFcn', 'spc_endAcquisition');
        end

end