function FLIM_Measurement(hObject,handles)

global state;
global gh;

%set(hObject,'Enable','off');
state.internal.abortActionFunctions = 0;
tag = get(hObject, 'Tag');
focus = strcmp(tag, 'focus');

status = [0, 0];  %1 == starting from now
if strcmp(get(hObject, 'String'), 'FOCUS')
    status  = [1, 0];
elseif strcmp(get(hObject, 'String'), 'GRAB')
    status = [0, 1];
end

if isfield(gh, 'mainControls')
    set(gh.mainControls.grabOneButton, 'Visible', 'off');
    set(gh.mainControls.startLoopButton, 'Visible', 'off');
    set(gh.mainControls.focusButton, 'Visible', 'off');
    ismainControls = 1;
else
    state.spc.acq.SPCdata.mode = 0;
    ismainControls = 0;
end

if sum(status)
    set(hObject,'String','STOP');
    if focus
        set(handles.grab, 'Visible', 'off');
    else
        set(handles.focus, 'Visible', 'off');
    end
    try
        stop(state.spc.acq.mt);
        delete(state.spc.acq.mt);
    end
    FLIM_ConfigureMemory;
    FLIM_SetPage;
    
    switch state.spc.acq.SPCdata.mode
        case {0,1}
            out = FLIM_enable_sequencer (0);           
            FLIM_FillMemory;
            FLIM_StartMeasurement;
            if ismainControls
                spc_executeFocus;
            end
            if ~isfield(gh.spc, 'single_plot')
                gh.spc.single_plot = figure;
            end
            if ~ishandle(gh.spc.single_plot)
                gh.spc.single_plot=figure;
            end
            set(gh.spc.single_plot,'Name','Measurement Results');
            try
                delete(state.spc.acq.mtSingle);
            end
            state.spc.acq.mtSingle=timer('TimerFcn','FLIM_TimerFunction','ExecutionMode','fixedSpacing','Period',2.0);
            start(state.spc.acq.mtSingle);
        case {2,3}
            out = FLIM_enable_sequencer (1);            
            FLIM_FillMemory;
            FLIM_StartMeasurement;
            if focus
                spc_executeFocus;
            else
                spc_executeGrabOne;     
            end
            state.spc.acq.mt=timer('TimerFcn','FLIM_image_timer','ExecutionMode','fixedSpacing','Period',1);
            start(state.spc.acq.mt);            
        otherwise
    end
else
    if ismainControls
        if focus
            spc_executeFocus;
        else
            spc_executeGrabOne;
        end
    end
    
    if state.spc.acq.SPCdata.mode == 0 | state.spc.acq.SPCdata.mode == 1
        try
            stop(state.spc.acq.mtSingle);
            delete(state.spc.acq.mtSingle);
        end
    else
        try
            stop(state.spc.acq.mt);
            delete(state.spc.acq.mt);
        end
    end
    
    error1= FLIM_StopMeasurement;
    if error1
        return;
    end;
    [armed, measuring, waiting, timerout1] = FLIM_decode_test_state (0);
    if armed
        i = 0;
        while armed | i < 10
            i = i+1;
            pause(0.1);
        end
    end
    
    if state.spc.acq.SPCdata.mode == 2 | state.spc.acq.SPCdata.mode == 3
        if focus
            if state.spc.acq.spc_takeFLIM
                FLIM_imageAcq;
                spc_redrawSetting(1);
            end
        end
    end
    set (state.spc.init.spc_ao, 'SamplesOutputFcn', '');
    if focus
        set(hObject,'String','FOCUS');
	else
        set(hObject,'String','GRAB');
    end
    set(gh.spc.FLIMimage.status, 'String', 'Waiting for next operation');    
    set(hObject,'Enable','on');
    set(handles.focus, 'Visible', 'on');
    set(handles.grab, 'Visible', 'on');
    set(gh.spc.FLIMimage.loop,'Visible','On');
    set(gh.spc.FLIMimage.focus,'Enable','On');
    set(gh.spc.FLIMimage.grab,'Enable','On');
    set(gh.spc.FLIMimage.loop,'Enable','On');
    
    if  ismainControls
        set(gh.mainControls.focusButton, 'Visible', 'On');
        set(gh.mainControls.startLoopButton, 'Visible', 'On');
        set(gh.mainControls.grabOneButton, 'Visible', 'On');
        set(gh.mainControls.focusButton, 'Enable', 'On');
        set(gh.mainControls.startLoopButton, 'Enable', 'On');
        set(gh.mainControls.grabOneButton, 'Enable', 'On');
    end
end
