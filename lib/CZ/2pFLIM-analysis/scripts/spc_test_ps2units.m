function [output] = spc_test_resolution(input, type)
global spc;

if strcmp(type, 'units')
    output = input * (spc.datainfo.psPerUnit / 1000);
elseif strcmp(type, 'ps')
    output = input * (1000 / spc.datainfo.psPerUnit);
end
end