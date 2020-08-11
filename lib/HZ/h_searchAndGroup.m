function h_searchAndGroup(handles)

h = h_findobj('Tag','h_imstack');

pathname = get(handles.pathName,'String');
basename = get(handles.fileBasename,'String');
fileExtension = get(handles.fileExtensionOpt,'String');
if get(handles.searchSubdirOpt,'Value')
    searchOpt = '/s';
else
    searchOpt = '';
end
fileNumbers = get(handles.fileNumbers,'String');
if strcmp(lower(fileNumbers),'all')
    str = {'*'};
else
    numbers = eval(['[',fileNumbers,']']);
    str = {};
    for i = 1:length(numbers)
        str1 = '000';
        str2 = num2str(numbers(i));
        str1(end-length(str2)+1:end) = str2;
        str(i,1) = {str1};
    end
end

files = [];
for i = 1:length(str)
    filename = [basename,str{i},'*',fileExtension];
    files = [files;h_dir(fullfile(pathname,filename),searchOpt)];
end

I = [];
for i = 1:length(files)
    if strfind(files(i).name,'max.')
        I = [I,i];
    end
end

maxOpt = get(handles.maxOpt,'Value');    
if maxOpt
    files = files(I);
else
    files(I) = [];
end

for i = 1:length(files)
    h_addToCurrentGroup(files(i).name);
end
h_updateInfo(guihandles(h));
close(handles.h_searchForGroupGUI);