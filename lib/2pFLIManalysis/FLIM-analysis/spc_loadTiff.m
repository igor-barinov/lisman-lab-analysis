function error = spc_loadTiff (fname);
global spc;
global gui;


error = 0;
finfo = imfinfo (fname);
header = finfo(1).ImageDescription;
pages = 1:length(finfo);
spc.stack.image1 = {};
stack_project = [];
if findstr(header, 'spc')
    evalc(header);
    spc.switches.noSPC = 0;
    spc.size = [spc.size(1), spc.SPCdata.scan_size_x, spc.SPCdata.scan_size_y];
    for i=1:length(pages)
        image1 = double(imread(fname, pages(i)));
        image1 = reshape(image1, spc.size);
        spc.stack.image1{i} = uint8(image1);
        stack_project = [stack_project, reshape(sum(image1, 1), spc.size(2), spc.size(3))];
    end
    size2 = size(image1);
    spc.stack.project = reshape(stack_project, spc.size(2), spc.size(3), length(pages));
    spc.stack.nStack = length(pages);
    set(gui.spc.spc_main.slider1, 'min', 1, 'max', spc.stack.nStack);
    set(gui.spc.spc_main.minSlider, 'min', 1, 'max', spc.stack.nStack);
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
    

else
    disp('This is not a spc file !!');
    error = 2;
    return;
end
spc.filename = fname;
spc.size = [spc.size(1), spc.SPCdata.scan_size_x, spc.SPCdata.scan_size_y];
spc.page = [1:spc.stack.nStack];


