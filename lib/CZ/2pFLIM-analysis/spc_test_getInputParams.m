function [beta, isFixed] = spc_test_getInputParams()
global gui;

handles = gui.spc.spc_main;

beta = zeros(1, 6);

beta(1) = str2double(get(handles.beta1, 'String'));
beta(2) = str2double(get(handles.beta2, 'String'));
beta(3) = str2double(get(handles.beta3, 'String'));
beta(4) = str2double(get(handles.beta4, 'String'));
beta(5) = str2double(get(handles.beta5, 'String'));
beta(6) = str2double(get(handles.beta6, 'String'));

isFixed = [0, get(handles.fixtau1, 'Value'), 0, get(handles.fixtau2, 'Value'), get(handles.fix_delta, 'Value'), get(handles.fix_g, 'Value') ];
end