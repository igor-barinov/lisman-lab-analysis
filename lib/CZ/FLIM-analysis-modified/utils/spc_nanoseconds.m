function [ns] = spc_nanoseconds(units)
    global spc;
    ns = units * 1000 / spc.datainfo.psPerUnit;
end