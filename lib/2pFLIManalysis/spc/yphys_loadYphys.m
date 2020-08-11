function yphys_loadYphys (filestr)%opens yphpys file with the standard name format yphys%03.mat
global yphys %declares that it will share same copy of yphys and gh variables
global gh

if ~nargin
     pwdstr = pwd;
     if ~strcmp(pwdstr(end-2:end), 'spc')
         pwdstr = [pwdstr, '\spc'];
     end
     filenames=dir([pwd, '\yphys*']);
     b=struct2cell(filenames);
     [sorted, whichfile] = sort(datenum(b(2, :)));
     if prod(size(filenames)) ~= 0
		  newest = whichfile(end);
		  filename = filenames(newest).name;
          filestr = [pwd, '\', filename];
     end
end

if exist(filestr) == 2
	load(filestr);
	
	yphys.filename = filestr;
	[pathstr,filenamestr,extstr] = fileparts(filestr);
	evalc(['yphys.data = ', filenamestr]);
    
  
	num = str2num(filenamestr(end-2: end));
	nstr = num2str(num);
	set(gh.yphys.stimScope.fileN, 'String', nstr);
	
    yphys_dispEphys;
end