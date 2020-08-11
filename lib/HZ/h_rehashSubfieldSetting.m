function h_rehashSubfieldSetting

global h_img;

if isfield(h_img, 'currentHandles')
    handles = h_img.currentHandles;

    % currentFilename = get(handles.currentFileName,'String');
    % [pname, fname] = h_analyzeFilename(currentFilename);


    UData = get(handles.roiControl,'UserData');
    set(handles.lockROI, 'value', UData.lockROI.Value);

    if isfield(handles, 'analyzedInfo')
        ss_setPara(handles.roiControl,UData);
        h_setParaAccordingToState('roiControl');
    end

    if isfield(handles, 'paAnalysisInfo')
        UData = get(handles.paAnalysis,'UserData');
        ss_setPara(handles.paAnalysis,UData);
    end

    if isfield(handles,'plotDataOpt')
        UData = get(handles.groupPlot,'UserData');
        ss_setPara(handles.groupPlot,UData);
        h_setParaAccordingToState('groupPlot');
    end

    if isfield(handles,'fittingOpt')
        UData = get(handles.fittingControls,'UserData');
        ss_setPara(handles.fittingControls,UData);
        h_setParaAccordingToState('fittingControls');
    end
    
    if isfield(handles,'makeTracingMark')
        UData = get(handles.dendriteTracing,'UserData');
        ss_setPara(handles.dendriteTracing,UData);
        h_setParaAccordingToState('dendriteTracing');
    end
end



