function [Aout,info] = h_OpenTif2(filename, frame_numbers)

Aout=uint16([]);
header=[];

if ~(exist('frame_numbers')==1)
    frame_numbers = [];
end


if ~(length(frame_numbers)==1 && frame_numbers == 0)
    h = waitbar(0,'Opening Tif image...', 'Name', 'Open TIF Image', 'Pointer', 'watch');
end
try
    info=imfinfo(filename);
    frames = length(info);
%     if isfield(info,'ImageDescription')
%         header=info(1).ImageDescription;
%         header=parseHeader(header);
%     else
%         header = [];
%     end
    if isempty(frame_numbers)
        frame_numbers = [1:frames];
    else
        frame_numbers = frame_numbers(frame_numbers<=frames);
        frame_numbers = frame_numbers(frame_numbers~=0);
    end
    
    j = 1;
    for i = frame_numbers
        waitbar(i/frames,h, ['Loading Frame Number ' num2str(i)]);    
        Aout(:,:,j) = imread(filename, i);
        if j == 1
            Aout = repmat(Aout(:,:,1),[1,1,length(frame_numbers)]);
        end
        j = j + 1;
    end
    
    if exist('h')==1 && ishandle(h)
        waitbar(1,h, 'Done');
        close(h);
    end
catch
    close(h);
    disp(['Cannot load file: ' filename ]);
end


