function d = h_roiDistance(roi_1,roi_2, x_pixelSize, y_pixelSize, zStepSize)

for i = 1:length(roi_1)
    x1 = mean([max(roi_1(i).xi),min(roi_1(i).xi)]);
    x2 = mean([max(roi_2(i).xi),min(roi_2(i).xi)]);
    y1 = mean([max(roi_1(i).yi),min(roi_1(i).yi)]);
    y2 = mean([max(roi_2(i).yi),min(roi_2(i).yi)]);
    z1 = mean(roi_1(i).z);
    z2 = mean(roi_2(i).z);
    d(i) = sqrt(((x1-x2)^2 * x_pixelSize^2+ (y1-y2)^2 * y_pixelSize^2) + (z1-z2)^2 * zStepSize^2);
end

