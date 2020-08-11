function [Aout, header] = opentif(filename)

global spc gui

%h = waitbar(0,'Opening Tif image...', 'Name', 'Open TIF Image', 'Pointer', 'watch');
fileInfo = imfinfo(filename);
frames = length(fileInfo);
imWidth = fileInfo(1).Width;
imHeight = fileInfo(1).Height;
state.imageProc.colorMap = 0;
header = fileInfo(1).ImageDescription;
Aout = ones(imWidth, imHeight, frames);
for i = 1:frames
        Aout(:,:,i) = imread(filename, i);
end

evalc(header);

if ~spc.switches.noSPC
    pixelshift = 5;
else
    pixelshift = 0;
end
spc.switches.pixelshift = pixelshift;
if state.acq.numberOfChannelsSave == 2
    state.img.greenImg = Aout(:,:,1:2:frames-1);
    state.img.greenImg(:, pixelshift:end, :) = state.img.greenImg(:, 1:end-pixelshift+1, :);
    state.img.redImg = Aout (:,:,2:2:frames);
    state.img.redImg(:, pixelshift:end, :) = state.img.redImg(:, 1:end-pixelshift+1, :);
    state.img.greenMax = max(state.img.greenImg, [], 3);
    state.img.redMax = max(state.img.redImg, [], 3);
    
%     state.img.greenMax(:, pixelshift :end) = state.img.greenMax(:, 1:end-pixelshift+1);
%     %state.img.greenMax = medfilt2(state.img.greenMax, [3,3]);
%     state.img.redMax (:, pixelshift :end) = state.img.redMax(:, 1:end-pixelshift+1);  %Shift by !
%     %state.img.redMax = medfilt2(state.img.redMax, [3,3]);  %Median for red fluorescence;

else
    state.img.greenImg = Aout;
    state.img.greenImg(:, pixelshift:end, :) = state.img.greenImg(:, 1:end-pixelshift+1, :);
    state.img.redImg = Aout;
    state.img.redImg(:, pixelshift:end, :) = state.img.redImg(:, 1:end-pixelshift+1, :);
    state.img.greenMax = max(state.img.greenImg, [], 3);
    state.img.redMax = max(state.img.redImg, [], 3);
    %state.img.redMax = medfilt2(state.img.redMax, [3,3]);  %Median for red fluorescence;
end

spc.stack.nStack = 4;
%spc.stack.nStack = size(state.img.greenImg, 3);
set(gui.spc.spc_main.slider1, 'max', spc.stack.nStack);
set(gui.spc.spc_main.slider1, 'min', 1);
set(gui.spc.spc_main.minSlider, 'max', spc.stack.nStack);
set(gui.spc.spc_main.minSlider, 'min', 1);
if spc.stack.nStack > 1
    set(gui.spc.spc_main.slider1, 'sliderstep', [1/(spc.stack.nStack-1), 1/(spc.stack.nStack-1)]);
    set(gui.spc.spc_main.minSlider, 'sliderstep', [1/(spc.stack.nStack-1), 1/(spc.stack.nStack-1)]);
    set(gui.spc.spc_main.slider1, 'value', spc.stack.nStack);
    set(gui.spc.spc_main.minSlider, 'value', 1);
else
    set(gui.spc.spc_main.slider1, 'sliderstep', [1,1]);
    set(gui.spc.spc_main.minSlider, 'sliderstep', [1,1]);
    set(gui.spc.spc_main.slider1, 'value', 1);
    set(gui.spc.spc_main.minSlider, 'value', 1);
end
set(gui.spc.spc_main.spc_page, 'String', num2str([1:spc.stack.nStack]));
spc.page = [1:spc.stack.nStack];
spc.state = state;


