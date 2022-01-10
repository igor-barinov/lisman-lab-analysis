function spc_initGlobalParams()
    global spc gui;
    spc.SPCdata.scan_rout_x = 3;
    spc.SPCdata.resolution=64; %number of channels;
    spc.datainfo.scan_rx = 3;
    spc.datainfo.scan_x = 128;
    spc.datainfo.scan_y = 128*spc.SPCdata.scan_rout_x;
    spc.stack.image1{1}=zeros(spc.SPCdata.resolution, spc.datainfo.scan_y, spc.datainfo.scan_x);
    spc.size=size(spc.stack.image1{1});
    spc.SPCdata.line_compression = 0;
%     for i = 1:3
%         spc.fit(i).range = [1,spc.SPCdata.resolution];
%         spc.fit(i).lifetime_limit = [1.7, 2.4];
%         spc.fit(i).lutlim = [0, 30];
%         spc.fit(i).t_offset = 1.0;
%         spc.fit(i).beta0 = [1,0,1,0,0,0];
%         spc.fit(i).fixtau = [0,0,0,0,0,0];
%     end
    spc.fitIsNew = false;
    spc.switches.logscale = 1;
    spc.SPCdata.scan_size_x = spc.datainfo.scan_x;
    spc.datainfo.psPerUnit = 200;
    spc.switches.imagemode = 2;

    spc.switches.polyline_radius = 6;
    spc.switches.roi = {};
    gui.spc.proChannel = 1;
    gui.spc.scanChannel = 2;
    spc.switches.noSPC = 0;
    spc.switches.maxAve = 0;
    spc.switches.redImg = 0;
    spc.lifetimeMap = zeros(1,spc.SPCdata.resolution);

    for j = 1:3
        spc.fit(j).t_offset = 0;
        spc.fit(j).range = [5, 51];
        spc.fit(j).curve = zeros(spc.fit(j).range(2) - spc.fit(j).range(1) + 1, 1);
        spc.fit(j).beta0 = [1000, 16.42, 1000, 5.56, 7.24,  0.6199, 0];
        spc.fit(j).fixtau = false(1, 6);
        spc.fit(j).lutlim = [10, 30];
        spc.fit(j).lifetime_limit = [1.4, 2.7];
    end
end