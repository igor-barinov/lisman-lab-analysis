function [baseline,I] = h_autofindLSbaseline(LSdata)

[slope,I] = max(diff(smooth(LSdata,5)));

I = 1:I*0.9;
baseline = mean(LSdata(I));