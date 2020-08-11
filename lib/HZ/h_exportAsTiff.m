function h_exportAsTiff

global h_img

handles = h_img.currentHandles;

pname = uigetdir(pwd,'Please pick a directory for exporting the files.');

if pname==0
    return;
end

currentDir = pwd;
cd(pname);

zLim(1) = str2num(get(handles.zStackControlLow,'String'));
zLim(2) = str2num(get(handles.zStackControlHigh,'String'));

currentFilename = get(handles.currentFileName,'String');
[filepath,filename] = fileparts(currentFilename);

for i = zLim(1):zLim(2)
    fnameg = [filename,'z',num2str(i),'g.tif'];
    fnamer = [filename,'z',num2str(i),'r.tif'];
    green = h_img.data(:,:,2*i-1);
    red = h_img.data(:,:,2*i);
    imwrite(green,fnameg);
    imwrite(red,fnamer);
end

cd(currentDir);
    
