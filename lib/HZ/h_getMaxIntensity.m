function [maxIntensity, sliderSteps] = h_getMaxIntensity

% find the maximum intensity setting for both h_imstack2 and h_imstack2a as specified in handles.
global h_img

data = h_img.data;

maxIntensity = double(max(data(:)));

if isempty(maxIntensity) || maxIntensity < 1
    maxIntensity = 1;
    sliderSteps = [0.01, 0.1];
elseif maxIntensity < 2^8
    maxIntensity = 2^8 - 1;
    sliderSteps = [1/maxIntensity, 10/maxIntensity];
elseif maxIntensity < 2^12
    maxIntensity = 2^12 - 1;
    sliderSteps = [2/maxIntensity, 20/maxIntensity];
elseif maxIntensity < 2^13
    maxIntensity = 2^13 - 1;
    sliderSteps = [2/maxIntensity, 20/maxIntensity];
else
    maxIntensity = 2^16 - 1;
    sliderSteps = [100/maxIntensity, 1000/maxIntensity];
end