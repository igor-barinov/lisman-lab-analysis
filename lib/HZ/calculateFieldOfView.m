function [XfieldOfView, YfieldOfView] = calculateFieldOfView(ScanImageZoom)

% calculates field of view in um for given ScanImageZoom
% A.Sobczyk <sobczyk@cshl.edu>

set(0, 'DefaultFigureColor', 'w');


% Haining July 8, 2010
magnification = [ 4 10 20 40 80];
xscale = [ 83.0 34.3 17.25 8.35 4.2];
yscale = [ 84.8 33.05 17.25 8.75 4.45]; 
    

% chris june 20,2005
% magnification = [2 4 10 50 70 140];
% xscale=[157.2 78.7 32 6.045 5.13 2.69];
% yscale=[161.3 83.3 33.27 6.858 5.28 2.74];


% shane July 7,2010
% magnification = [2 4 10 20 50 70 140];
% xscale=[179.0 86.7 34.8 16.77 8.4 8.3 4.5];
% yscale=[184.8 95.8 42.3 25.1 11.9 8.9 4.9];


mag2 = 1./magnification;
zoomInverse = 1 / ScanImageZoom;

beta0 = [1 0];
linfitX = polyfit(mag2, xscale, 1);
linfitY = polyfit(mag2, yscale, 1);

fieldX = linfitX(1) * zoomInverse + linfitX(2);
fieldY = linfitY(1) * zoomInverse + linfitY(2);

if nargout<1
    fprintf('For ScanImage zoom %i, fields of view are:',round(ScanImageZoom));
    fprintf('   X: %.3f um',fieldX);
    fprintf('   Y: %.3f um\n\t',fieldY);
end

XfieldOfView = fieldX;
YfieldOfView = fieldY;
