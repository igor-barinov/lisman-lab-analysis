function spc_alignFrames
global spc gui
%global tmp

spc.page = 1;
set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
spc_redrawSetting(1);
saveProject = spc.project;

for i=2:spc.stack.nStack
%     set(gui.spc.spc_main.spc_page, 'String', num2str(i));
%     spc_redrawSetting(1);
    project1 = spc.stack.project(:, :, i);
    C = xcorr2(saveProject, project1);
    [value1, index1] = max(C(:));
    [siz_x, siz_y] = size(C);
    index_x = floor(index1 / siz_y) + 1;
    index_y = index1 - (index_x-1) * siz_y;
    shift_x = index_x - (siz_x + 1)/2;
    shift_y = index_y - (siz_y + 1)/2;
    spc_shiftSPC2([shift_y, shift_x], i);
%     tmp.shiftX(i) = shift_x;
%     tmp.shiftY(i) = shift_y;
end


end


function spc_shiftSPC2(shift, imageN)

global spc

sizR = size(spc.state.img.redMax);
siz = size(spc.imageMod);
if shift(1) > 0
    spc.stack.image1{imageN}(:, 1+shift(1):siz(2), :) = spc.stack.image1{imageN}(:, 1:siz(2)-shift(1), :);
    spc.state.img.redImg(1+shift(1):sizR(1), :, imageN) = spc.state.img.redImg(1:sizR(1)-shift(1), :, imageN);
else
    shift(1) = -shift(1);
    spc.stack.image1{imageN}(:, 1:siz(2)-shift(1), :) = spc.stack.image1{imageN}(:, 1+shift(1):siz(2), :);
    spc.state.img.redImg(1:sizR(1)-shift(1), :, imageN) = spc.state.img.redImg(1+shift(1):sizR(1), :, imageN);
end


if shift(2) > 0
    spc.stack.image1{imageN}(:, :, 1+shift(2):siz(3)) = spc.stack.image1{imageN}(:, :, 1:siz(3)-shift(2));
    spc.state.img.redImg(:, 1+shift(2):sizR(2), imageN) = spc.state.img.redImg(:, 1:sizR(2)-shift(2), imageN);
else
    shift(2) = -shift(2);
    spc.stack.image1{imageN}(:, :, 1:siz(3)-shift(2), :) = spc.stack.image1{imageN}(:, :, 1+shift(2):siz(3));
    spc.state.img.redImg(:, 1:sizR(2)-shift(2), imageN) = spc.state.img.redImg(:, 1+shift(2):sizR(2), imageN);
end
end