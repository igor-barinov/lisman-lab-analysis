function h_autoGroupMontage

global h_img

handles = h_img.currentHandles;

currentFilename = get(handles.currentFileName,'String');
labelText = get(handles.labelText,'String');

try
    numbers = eval(['[',labelText,']']);
    if length(numbers) > 1
        [filepath, filename, fExt] = fileparts(currentFilename);
        if strcmp('max',lower(filename(end-2:end)))
            basename = filename(1:end-6);
            max = 1;
        else
            basename = filename(1:end-3);
            max = 0;
        end
        for i = 1:length(numbers)
            str1 = '000';
            str2 = num2str(numbers(i));
            str1(end-length(str2)+1:end) = str2;
            if max
                files{i} = fullfile(filepath,[basename, str1, 'max.tif']);
            else
                files{i} = fullfile(filepath,[basename, str1, '.tif']);
            end
        end
    else
        error;
    end
catch
    if isfield(h_img,'activeGroup') & ~isempty(h_img.activeGroup.groupFiles)
        try
            if length(labelText) > 5 & strcmp(lower(labelText(1:5)),'every')
                sparse_factor = eval(labelText(6:end));
            else
                sparse_factor = 1;
            end
        catch
            sparse_factor = 1;
        end
        files = {h_img.activeGroup.groupFiles(1:sparse_factor:end).name};
    else
        files = {};
    end
end

%%%%%%%%% make montage  %%%%%%%%%%%%%%%%%%%

fig_mon = h_executeNewMontage_Callback;
UserData.montageSize = h_montageSize(length(files));
set(fig_mon,'UserData',UserData);

for i = 1:length(files)
    h_quickOpenFile(files{i});
    try
        h_loadAnalyzedRoiData(handles);
    end
    
    h_addImageToMontage(handles);
    [pname,fname] = fileparts(files{i});
    xlabel(fname,'FontSize',8);
%     if exist('fig') == 1
%         delete(fig);
%     end
end

%%%%%%%  Re-Open the original file  %%%%%%%%%%%%%%%%%%%%%
if length(files)>0
    [pname,fname,fExt] = fileparts(currentFilename);
    h_openfile([fname,fExt],pname);
    try
        h_loadAnalyzedRoiData(handles);
    end
end