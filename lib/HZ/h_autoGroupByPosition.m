function h_autoGroupByPosition(handles)

global h_img;

currentFilename = get(handles.currentFileName,'String');
[pname,fname,fExt] = fileparts(currentFilename);

if ~isempty(pname)
    cd(pname);
    files = h_dir('*.tif');
    for i = 1:length(files)
        [d,header(i)] = h_opentif(files(i).name,0);
    end
    
    if isfield(header(1).motor,'position');
        
        for i = 1:length(files)
            pos = header(i).motor.position;
            [filepath, filename] = fileparts(files(i).name);
            if strcmp(lower(filename(end-2:end)),'max')
                max = 1;
                basename = filename(1:end-6);
            else
                max = 0;
                basename = filename(1:end-3);
            end
            
            if max
                groupName{i} = fullfile(filepath,'Analysis',[basename,'pos',num2str(pos),'_max.grp']);
            else
                groupName{i} = fullfile(filepath,'Analysis',[basename,'pos',num2str(pos),'.grp']);
            end
        end
    else
        I = [];J = [];
        for i = 1:length(files)
            if strfind(files(i).name,'max.tif')
                I = [I,i];
            else
                J = [J,i];
            end
        end
        header1 = header(I);
        files1 = files(I);
        header2 = header(J);
        files2 = files(J);
        if ~isempty(header1)
            for i = 1:length(header1)
                xy(i,:) = [header1(i).motor.absXPosition,header1(i).motor.absYPosition];
            end
            Y = pdist(xy);
            Z = LINKAGE(Y);
            T = CLUSTER(Z,'CUTOFF',1);
            for i = 1:length(header1)
                pos = T(i);
                [filepath, filename] = fileparts(files1(i).name);
                basename = filename(1:end-6);
                groupName1{i} = fullfile(filepath,'Analysis',[basename,'pos',num2str(pos),'_max.grp']);
            end
        else
            groupName1 = [];
        end
        
        for i = 1:length(header2)
            xy(i,:) = [header2(i).motor.absXPosition,header2(i).motor.absYPosition];
        end
        Y = pdist(xy);
        Z = LINKAGE(Y);
        T = CLUSTER(Z,'CUTOFF',1);
        for i = 1:length(header2)
            pos = T(i);
            [filepath, filename] = fileparts(files2(i).name);
            basename = filename(1:end-3);
            groupName2{i} = fullfile(filepath,'Analysis',[basename,'pos',num2str(pos),'.grp']);
        end
        
        groupName = [groupName1,groupName2];
        files = [files1;files2];
        %             if strcmp(lower(filename(end-2:end)),'max')
        %                 max = 1;
        %                 basename = filename(1:end-6);
        %             else
        %                 max = 0;
        %                 basename = filename(1:end-3);
        %             end
        %             
        %             if max
        %                 groupName{i} = fullfile(filepath,'Analysis',[basename,'pos',num2str(pos),'_max.grp']);
        %             else
        %                 groupName{i} = fullfile(filepath,'Analysis',[basename,'pos',num2str(pos),'.grp']);
        %             end
    end
end


if ~(exist(fullfile(pname,'Analysis'))==7)
    currpath = pwd;
    cd (pname);
    mkdir('Analysis');
    cd (currpath);
end

k = 0;
while ~isempty(files)
    I = strmatch(groupName{1},groupName,'exact');
    h_addFileToGroup({files(I).name}',groupName{1});
    groupName(I) = [];
    files(I) = [];
    k = k+1;
end
disp(['Total ',num2str(k),' groups']);

if isfield(h_img,'activeGroup')
    h_openGroup(h_img.activeGroup.groupName, h_img.activeGroup.groupPath, handles)
end

h_updateInfo(handles);