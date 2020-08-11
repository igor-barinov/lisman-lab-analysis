function openImage

global h_img;

handles = h_img.currentHandles;

try
    if ~isempty(strfind(get(handles.currentFileName,'String'),'currentFileName'))...
            & isempty(strfind(lower(pwd), fullfile('haining','data')))
        cd (fullfile('c:', 'haining', 'data'));
    end
end
[fname,pname] = uigetfile('*.tif','Select an imaging file to open');
h_openFile(fname,pname);
