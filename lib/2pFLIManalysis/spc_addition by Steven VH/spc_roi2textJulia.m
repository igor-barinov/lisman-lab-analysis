function [ info  ] = spc_roi2text( filename )
%SPC_ROI2TEXT Summary of this function goes here
%   Detailed explanation goes here

g = load(filename,'-mat');

fn = fieldnames(g);


N = length( getfield( getfield(g,fn{1}), 'roiData') );

M_tau_m = zeros(N, size(  getfield(getfield( getfield(g,fn{1}),'roiData'),'green_mean'),2));
M_green = zeros(N, size(  getfield(getfield( getfield(g,fn{1}),'roiData'),'green_mean'),2));
M_red = zeros(N, size(  getfield(getfield( getfield(g,fn{1}),'roiData'),'green_mean'),2));
Abstime = zeros(N, size(  getfield(getfield( getfield(g,fn{1}),'roiData'),'green_mean'),2));

%BGM_tau_m = zeros(N, size(  getfield(getfield( getfield(g,fn{1}),'roiData'),'green_mean'),2));
BGM_green = zeros(N, size(  getfield(getfield( getfield(g,fn{1}),'roiData'),'green_mean'),2));
BGM_red = zeros(N, size(  getfield(getfield( getfield(g,fn{1}),'roiData'),'green_mean'),2));


roiData = getfield(getfield(g,fn{1}),'roiData');
bgData = getfield(getfield(g,fn{1}),'bgData');
analyzeData = getfield(getfield(g,fn{1}),'analyzeData');

    %BGM_tau_m(1,:) = bgData.tau_m;
    BGM_green(1,:) = bgData.green_mean;
    BGM_red(1,:) = bgData.red_mean;
    
    roiTime(1,:) = analyzeData.time;        %JZ


for i=1:N,
    M_tau_m(i,:) = roiData(i).tau_m;
    M_green(i,:) = roiData(i).green_mean;
    M_red(i,:) = roiData(i).red_mean;
    Abstime(i,:) = roiData(i).time/(60);    
end

dlmwrite([filename '_tau_m.txt'], M_tau_m', 'delimiter','\t');
dlmwrite([filename '_green.txt'], M_green', 'delimiter','\t');
dlmwrite([filename '_red.txt'], M_red', 'delimiter','\t');
dlmwrite([filename '_ABstime.txt'], Abstime', 'delimiter','\t');
dlmwrite([filename '_roiTime.txt'], roiTime', 'delimiter','\t');        %JZ

%dlmwrite([filename '_BG_tau_m.txt'], BGM_tau_m', 'delimiter','\t');
dlmwrite([filename '_BG_green.txt'], BGM_green', 'delimiter','\t');
dlmwrite([filename '_BG_red.txt'], BGM_red', 'delimiter','\t');


