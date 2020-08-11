function h_openGroup(filename, pathname, handles)

global h_img;

if ~(exist('pathname')==1)|isempty(pathname)
    pathname = pwd;
end

try
    filestr = fullfile(pathname, filename);
    if exist(filestr) == 2
        load(filestr,'-mat');
        h_img.activeGroup.groupName = filename;
        h_img.activeGroup.groupPath = pathname;
        h_img.activeGroup.groupFiles = groupFiles;
        h_updateInfo(handles);
    else
        disp([filestr,' not exist!']);
    end
end
