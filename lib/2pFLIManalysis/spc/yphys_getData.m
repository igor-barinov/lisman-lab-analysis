function yphys_getData;
global state;
global gh;

if state.yphys.acq.uncage
    closeShutter;
end
set(gh.yphys.stimScope.start, 'Enable', 'Off');

if get(state.yphys.init.phys_input, 'SamplesAvailable')
	data1 = getdata(state.yphys.init.phys_input);

%figure(200);
    if state.yphys.acq.cclamp
        gain = state.yphys.acq.gainC;
    else
        gain = state.yphys.acq.gainV;
    end
	rate = state.yphys.acq.inputRate;
    
    yphys_header = ['yphys_', state.files.baseName];
    if ~isfield (state.yphys.acq, 'phys_counter')
        state.yphys.acq.phys_counter = 1;
    end
    if state.yphys.acq.phys_counter == 1;
        filenames=dir(fullfile(state.files.savePath, '\spc\yphys*.mat'));
        b=struct2cell(filenames);
        [sorted, whichfile] = sort(datenum(b(2, :)));
        if prod(size(filenames)) ~= 0
		    newest = whichfile(end);
		    filename = filenames(newest).name;
            pos1 = strfind(filename, '.');
            state.yphys.acq.phys_counter = str2num(filename(pos1-3:pos1-1))+1;
        else
            state.yphys.acq.phys_counter = 1;
        end
    else
        state.yphys.acq.phys_counter =  state.yphys.acq.phys_counter + 1;
    end
  
	t = 1:length(data1);
	state.yphys.acq.data = [t(:)/rate*1000, data1(:, 1)/gain];

	
    if get(state.yphys.init.acq_ai, 'SamplesAvailable')
        uncage = 1;
          data2 = getdata(state.yphys.init.acq_ai);
         state.yphys.acq.intensity1 = mean(data2(state.yphys.acq.data_On(1):state.yphys.acq.data_On(2), 1));
         state.yphys.acq.intensity2 = mean(data2(state.yphys.acq.data_On(1):state.yphys.acq.data_On(2), 2));
         stop(state.yphys.init.acq_ai);
    else
        uncage = 0;
    end
	
	if isfield(state, 'files')
        numchar = num2str(state.yphys.acq.phys_counter);
        for i=1:3-length(numchar)
            numchar = ['0', numchar];
        end
		filen = ['yphys', numchar];
		evalc([filen, '= state.yphys.acq']);
		filedir = [state.files.savePath, 'spc\'];
        
        if uncage
            global ysum;
            if state.yphys.acq.phys_counter == 1
                ysum = [];
            end
            ysum.intensity1(state.yphys.acq.phys_counter) = state.yphys.acq.intensity1;
            ysum.intensity2(state.yphys.acq.phys_counter) = state.yphys.acq.intensity2 ;
             ysum.Xorg(state.yphys.acq.phys_counter) = state.yphys.acq.XYorg(1);
             ysum.Yorg(state.yphys.acq.phys_counter) = state.yphys.acq.XYorg(2);
             ysum.Xvol(state.yphys.acq.phys_counter) = state.yphys.acq.XYvol{1}(1);
             ysum.Yvol(state.yphys.acq.phys_counter) = state.yphys.acq.XYvol{1}(2);
            %%%%%%%%%%%%
            %Temporal
%             fh = gh.yphys.intensity_graph;
%             if ~ishandle (fh)
%                 gh.yphys.intensity_graph = figure;
%             else
%                 figure(fh);
%             end
%             plot(ysum.Xvol, ysum.intensity1, '-o');
        end
		
        if get(gh.yphys.stimScope.saveCheck, 'Value')
			if exist(filedir)
				cd(filedir);
				save(filen, filen);
            else
                cd ([filedir, '\..\']);
                mkdir('spc');
                cd(filedir);
                save(filen, filen);
			end
            pause(0.3);
            if exist(filen)
                %disp('loading average ....');
                yphys_loadYphys([filedir, filen, '.mat']);
                yphys_averageData;
            end
        end
	end
end

state.yphys.internal.waiting = 0;
set(gh.yphys.stimScope.start, 'Enable', 'On');
