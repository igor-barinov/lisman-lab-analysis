function yphys_stimclosereq;
global state
global spc
global gh

yphys_setting = state.yphys.acq;

fid = fopen('flim.ini');
[fileName,permission, machineormat] = fopen(fid);
[pathstr,name,ext,versn] = fileparts(fileName);
fclose(fid);

save([pathstr, '\yphys_init.mat'], 'yphys_setting');

closereq;