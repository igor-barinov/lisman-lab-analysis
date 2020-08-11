function h_saveMovie

global h_img

% handles = h_currentHandles;
% 
% if isfield(h_img.movie,'filename')&~isempty(h_img.movie.filename)
%     [pathname,filename,fExt] = fileparts(filename);
%     if strcmp(lower(fExt),'.avi')
%         filterindex = 2;
%     else
%         fileterindex = 1;
%     end
% else
%     [filename, pathname, filterindex] = uiputfile({'*.mat','MAT-file';'*.avi','AVI file'}, 'Save current movie as');
% end
% 
% if filename~=0
%     if filterindex==1
%         mov = h_img.movie

mov = h_img.movie.mov;
handles = h_img.currentHandles;

[fname, pname, filterindex] = uiputfile({'*.avi','AVI file'}, 'Please input a filename');

if fname ~= 0
    if filterindex==1
        if strcmp(fname(end-3:end),'.avi')
            filename = fullfile(pname,fname);
        else
            filename = fullfile(pname,[fname,'.avi']);
        end
        fps = str2num(get(handles.fpsOpt,'String'));
        movie2avi(mov,filename,'FPS',fps,'COMPRESSION','none');
    end
end