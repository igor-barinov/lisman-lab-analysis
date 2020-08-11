function spc_finalDataOutput = spc_makeDataOutput(takeFLIM)

global state
%Function that constructs the line and frame clock.
%Ryohei 9/17/2
%Modified 1/28/03 add pixel clock.

%ActualRateOutput1 = get(state.init.ao1, 'SampleRate');  %ao1 -> spc, pockels et al (fast board);
%lengthOfXData = round(state.acq.msPerLine*ActualRateOutput1);
a = state.spc.acq.spc_amplitude;
laserP = 1;
uncageP = 2;
if state.init.pockelsOn == 1
    state.init.eom.changed(state.init.eom.scanLaserBeam) = 1;
    state.spc.acq.spc_pixel = 0;
    pockelsOutput = makePockelsCellDataOutput(state.init.eom.scanLaserBeam, 1); %Flybackonly

    if state.spc.acq.uncageBox == 1
        if findobj('Tag', '1')
			para = state.yphys.acq.pulse{3, state.yphys.acq.pulseN};
			nstim = para.nstim;
			freq = para.freq;
			dwell = para.dwell;
			ampc = para.amp;
			delay = para.delay;
			sLength = para.sLength;

            ActualRateOutput2 = get(state.spc.init.spc_ao, 'SampleRate')/1000;
            pockelsOutput2 = state.init.eom.lut(uncageP, state.init.eom.min(uncageP))*ones(length(pockelsOutput)*state.spc.acq.uncageEveryXFrame, 1);
			amp = state.init.eom.lut(uncageP, ampc);
            for roiN=1:nstim
                PulsePos = round((delay+1000/freq*(roiN-1))*ActualRateOutput2) : round((delay+1000/freq*(roiN-1)+dwell)*ActualRateOutput2);
                pockelsOutput2(PulsePos) = amp;
            end
        else
            saveFrames = state.acq.numberOfFrames;
            saveStart = state.init.eom.startFrame;
            saveEnd = state.init.eom.endFrame;
            state.acq.numberOfFrames = 1;
            state.init.eom.startFrame = 1;
            state.init.eom.endFrame = 1;
            pockelsOutput2 = makePockelsCellDataOutput(2, 0);  %Pockels Cells Settings On.
            state.acq.numberOfFrames = saveFrames;
            state.init.eom.startFrame = saveStart;
            state.init.eom.endFrame = saveEnd;
        end
    else
        pockelsOutput2 = makePockelsCellDataOutput(2, 1); 
    end
    if state.acq.linescan
        pockelsOutput(1:lengthOfXData*20) = state.init.eom.lut(2, state.init.eom.min(2));          
    end
end

LineOutput = mean(pockelsOutput) < pockelsOutput;
if length(pockelsOutput)-sum(LineOutput) > sum(LineOutput)
    LineOutput = a * LineOutput;
else
    LineOutput = a * (~LineOutput);
end
startGood = find (~LineOutput);
startGood = startGood(1)-1;
frameOutput(length(pockelsOutput)) = 0;
frameOutput(1:startGood) = a;
endGood = find (~LineOutput);
endGood = endGood(end)+1;
frameOutput(endGood:end) = a;

%Pixel Output
if state.spc.acq.spc_pixel
	pixeltime = state.acq.pixelTime;
	binFactor = pixeltime*ActualRateOutput1;
	%PixelOn = zeros(binFactor, 1);
	%PixelOn(1) = a;
	%PixelLine = zeros(lengthOfXData,1); 
	%PixelLineGood = repmat(PixelOn, [state.acq.pixelsPerLine 1]);
	%PixelLine(startGoodLineData : startGoodLineData+length(PixelLineGood)-1) = PixelLineGood;
	PixelOn = zeros(binFactor, 1);
	PixelOn(1) = a;
	PixelLine = zeros(lengthOfXData,1); 
	NofPixels = floor(lengthOfXData/binFactor);
	PixelLine(1:NofPixels*binFactor) = repmat(PixelOn, [NofPixels 1]);
	
	
	PixelOutput = repmat(PixelLine, [state.acq.linesPerFrame 1]);      %Repeat same things 
else
    PixelOutput = frameOutput;
end


if state.spc.acq.uncageBox == 1
     %pokelsOutput2 = ones(length(pockelsOutput), 1) * min();
	pockelsOutput3 = mean(pockelsOutput2) < pockelsOutput2;
	if length(pockelsOutput3)-sum(pockelsOutput3) > sum(pockelsOutput3)
        pockelsOutput3 = a * (pockelsOutput3);
	else
        pockelsOutput3 = a * (~pockelsOutput3);
	end
	aa = find(pockelsOutput3);
    if aa
		startShutter = aa(1)-state.internal.lengthOfXData*6;
		endShutter = aa(end)+state.internal.lengthOfXData*0;
		pockelsOutput3(1:end) = a;
		pockelsOutput3(startShutter:endShutter)=0;
    end
else  

        pockelsOutput3=a*ones(length(pockelsOutput), 1);
end


if state.spc.acq.uncageBox
    %pockelsOutput = state.init.eom.lut(laserP, 10)*ones(length(pockelsOutput2), 1);
    pockelsOutput = repmat(pockelsOutput(:), [state.spc.acq.uncageEveryXFrame, 1]);
    LineOutput = repmat(LineOutput(:), [state.spc.acq.uncageEveryXFrame, 1]);
    frameOutput = repmat(frameOutput(:), [state.spc.acq.uncageEveryXFrame, 1]);
    PixelOutput = repmat(PixelOutput(:), [state.spc.acq.uncageEveryXFrame, 1]);
end


if state.init.pockelsOn == 1
    %pockelsOutput = makePockelsCellDataOutput;
    if takeFLIM
        spc_finalDataOutput = [LineOutput(:), frameOutput(:), PixelOutput(:), pockelsOutput(:), pockelsOutput2(:), pockelsOutput3(:)];
    else
        spc_finalDataOutput = [pockelsOutput(:), pockelsOutput2(:), pockelsOutput3(:)];
    end
else
    spc_finalDataOutput = [LineOutput(:), frameOutput(:), PixelOutput(:)];
end

%Second frame
% if state.spc.acq.uncageBox == 1  & state.init.eom.showBoxArray(2) == 1 & state.spc.acq.uncageEveryXFrame > 1 & state.init.pockelsOn
% 
% 		sec_pockelsOutput = pockelsOutput; %ones(length(pockelsOutput), 1)*state.init.eom.lut(1,min(state.init.eom.min(1)));
% 		sec_pockelsOutput2 = ones(length(pockelsOutput), 1)*state.init.eom.lut(2,min(state.init.eom.min(2)));
% 		sec_pockelsOutput3 = ones(length(pockelsOutput), 1)*a;
%     if takeFLIM   	
%         sec_finalOutput = [LineOutput(:), frameOutput(:), PixelOutput(:), sec_pockelsOutput(:), sec_pockelsOutput2(:), sec_pockelsOutput3(:)];
%         sec_finalOutput = repmat(sec_finalOutput, [state.spc.acq.uncageEveryXFrame-1, 1]);    
%         spc_finalDataOutput = [sec_finalOutput; spc_finalDataOutput];
%     else
%         sec_finalOutput = [sec_pockelsOutput(:), sec_pockelsOutput2(:), sec_pockelsOutput3(:)];
%         sec_finalOutput = repmat(sec_finalOutput, [state.spc.acq.uncageEveryXFrame-1, 1]);    
%         spc_finalDataOutput = [sec_finalOutput; spc_finalDataOutput];
% 
%     end
% end