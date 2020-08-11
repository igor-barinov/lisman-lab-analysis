function [opentime, shutter_range] = h_findShutterOpen(LSdata)

LSdata2 = diff(smooth(LSdata,5));
[slope,opentime] = max(LSdata2);
opentime = opentime(1);

I = find(LSdata2(1:opentime)<0);
shutter_range(1) = I(end);
I = find(LSdata2(opentime:end)<0);
shutter_range(2) = I(1)+opentime;


