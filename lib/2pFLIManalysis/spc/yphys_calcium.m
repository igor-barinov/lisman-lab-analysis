function Aout = yphys_calcium(num)
global state;
global yphys;
global gh;

color_a = {'green', 'red', 'white', 'cyan', 'magenda'};
%fh = 402;

roiobj = findobj('Tag', 'ROI');

nRoi = length(roiobj);

if ~nargin
    if isfield(state, 'acq')
        num = state.files.fileCounter-1;
    else
        num = 1;
    end
end

str1 = '000';
str2 = num2str(num);
str1(end-length(str2)+1:end) = str2;

if ~isfield(state, 'acq')
    state.files.savePath = pwd;
end
if ~isfield(state, 'files')
    state.files.baseName = 'y146bs';
end

try
    filename = [state.files.savePath,'\', state.files.baseName, str1, '.tif'];
catch
    filename = 'a';
end
if ~isfield(yphys, 'image')
    yphys.image.aveImage = [];
    yphys.image.currentSlice = 3;
    yphys.image.intensity = {};
end

if exist(filename)
    [data, header]=genericOpenTif(filename);
    yphys.image.filename = filename;
    yphys.image.currentImage = num;
else
    [fname,pname] = uigetfile('*.tif','Select tiff file');
    cd (pname);
    filestr = [pname, fname];
    [filepath, basename, filenumber, max1, spc] = spc_AnalyzeFilename(filestr);
    state.files.savePath = filepath;
    state.files.baseName = basename;
    yphys.image.currentImage = filenumber;
    [data, header]=genericOpenTif(filestr);
end

yphys.image.imageData = data;
yphys.image.imageHeader = header;
yphys.image.baseName = state.files.baseName;

if isfield(yphys.image, 'pathstr')
	if ~strcmp(yphys.image.pathstr, [state.files.savePath, 'spc'])
        yphys.image.pathstr = [state.files.savePath, 'spc'];
        %yphys.image.intensity = {};
	end
else
    yphys.image.pathstr = [state.files.savePath, 'spc'];
end

yphys_calcium_offLine(0);

%return;