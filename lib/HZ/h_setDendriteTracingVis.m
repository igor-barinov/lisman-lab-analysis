function h_setDendriteTracingVis

global h_img;

handles = h_img.currentHandles;

tracingMarkObj = h_findobj(handles.h_imstack,'tag','h_tracingMark');
tracingMarkTextObj = h_findobj(handles.h_imstack,'tag','h_tracingMarkText');
skeletonObj = h_findobj(handles.h_imstack,'tag','h_dendriteSkeleton');
roiobj = sort(findobj(handles.h_imstack,'Tag', 'HROI'));
bgroiobj = findobj(handles.h_imstack,'Tag','HBGROI');
imgObj = h_findobj(handles.imageAxes, 'type', 'image');

if h_img.state.dendriteTracing.showTracingMark.value
    set(tracingMarkObj, 'visible', 'on');
    if h_img.state.dendriteTracing.showMarkNumber.value
        set(tracingMarkTextObj, 'visible', 'on');
    else
        set(tracingMarkTextObj, 'visible', 'off');
    end
else
    set(tracingMarkObj, 'visible', 'off');
    set(tracingMarkTextObj, 'visible', 'off');
end

if h_img.state.dendriteTracing.showSkeleton.value
    set(skeletonObj, 'visible', 'on');
else
    set(skeletonObj, 'visible', 'off');
end 

if h_img.state.dendriteTracing.showImage.value
    set(imgObj, 'visible', 'on');
else
    set(imgObj, 'visible', 'off');
end 

if h_img.state.dendriteTracing.showROI.value
    set(roiobj, 'visible', 'on');
    UData = get(roiobj,'UserData');
    if ~isempty(UData)
        if iscell(UData)
            UData = cell2mat(UData);
        end
        textHandles = [UData.texthandle];
        set(textHandles, 'visible', 'on');
    end
    set(bgroiobj, 'visible', 'on');
    UData = get(bgroiobj,'UserData');
    if ~isempty(UData)
        textHandles = UData.texthandle;
        set(textHandles, 'visible', 'on');
    end
else
    set(roiobj, 'visible', 'off');
    UData = get(roiobj,'UserData');
    if ~isempty(UData)
        if iscell(UData)
            UData = cell2mat(UData);
        end
        textHandles = [UData.texthandle];
        set(textHandles, 'visible', 'off');
    end
    set(bgroiobj, 'visible', 'off');
    UData = get(bgroiobj,'UserData');
    if ~isempty(UData)
        textHandles = UData.texthandle;
        set(textHandles, 'visible', 'off');
    end
end 