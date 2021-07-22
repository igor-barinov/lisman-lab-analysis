function [ps] = spc_picoseconds(units)
    global spc;
    
    ps = units * spc.datainfo.psPerUnit / 1000;
end