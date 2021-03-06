function beta0 = spc_initialValue_double
global spc;
global gui;

handles = gui.spc.spc_main;

% try
	beta0(1)=str2num(get(handles.beta1, 'String'));
	beta0(2)=str2num(get(handles.beta2, 'String'));
	beta0(3)=str2num(get(handles.beta3, 'String'));
	beta0(4)=str2num(get(handles.beta4, 'String'));
	beta0(5)=str2num(get(handles.beta5, 'String'));
    beta0(6)=str2num(get(handles.beta6, 'String'));
	beta0(2) = beta0(2)*1000/spc.datainfo.psPerUnit;
	beta0(4) = beta0(4)*1000/spc.datainfo.psPerUnit;
	beta0(5) = beta0(5)*1000/spc.datainfo.psPerUnit;
    beta0(6) = beta0(6)*1000/spc.datainfo.psPerUnit;
% catch
% end

fix2 = get(handles.fixtau1, 'Value');
fix4 = get(handles.fixtau2, 'Value');
% fix5 = get(handles.fix_g, 'Value', fixtau(5));
% fix6 = get(handles.fix_delta, 'Value', fixtau(6));
    
range = spc.fit.range;

if beta0(1) <= 10 || beta0(2) <= 0.1*1000/spc.datainfo.psPerUnit || beta0(2) >=10*1000/spc.datainfo.psPerUnit
    b1 = max(spc.lifetime(range(1):1:range(2)));
    b2 = sum(spc.lifetime(range(1):1:range(2)))/b1;
    beta0(1) = b1*0.5;
    beta0(3) = b1*0.5;
    if ~fix2
        beta0(2) = b2*1.2;
    end
    if ~fix4
        beta0(4) = b2*0.3;
    end
	disp('Bad lifetime fit1 ?'); 
	%beta0
    % set(gui.spc.spc_main.fixtau1, 'value', 0);
    % set(gui.spc.spc_main.fixtau2, 'value', 0);
end

if beta0(3) <= 10 || beta0(4) <= 0.1*1000/spc.datainfo.psPerUnit || beta0(4) >=10*1000/spc.datainfo.psPerUnit
    b1 = beta0(1);
    b2 = beta0(2);
    beta0(1) = b1*0.4;
    beta0(3) = b1*0.4;
    if ~fix2
        beta0(2) = b2*1.2;
    end
    if ~fix4
        beta0(4) = b2*0.4;
    end
	disp('Bad lifetime fit2 ?'); 
	%beta0
    % set(gui.spc.spc_main.fixtau1, 'value', 0);
    % set(gui.spc.spc_main.fixtau2, 'value', 0);
end
if beta0(5) <= 0*1000/spc.datainfo.psPerUnit || beta0(5) >= 6*1000/spc.datainfo.psPerUnit 
    beta0(5) = 1000/spc.datainfo.psPerUnit;
end
if beta0(6) <= 0.02*1000/spc.datainfo.psPerUnit || beta0(6) > 0.5*1000/spc.datainfo.psPerUnit
    beta0(6) = 0.11*1000/spc.datainfo.psPerUnit;
end