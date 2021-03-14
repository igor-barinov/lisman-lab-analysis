% input   = [ base1,    base2,  ...
%             start1,   start2, ...
%             post1,    post2,  ...
%             wash1,    wash1,  ... ]
%
function file_with_constants(filename, dataPath, lengths, constants)
    timeFile = [dataPath, 'roi_time.mat'];
    s = load(timeFile, 'time');
    timeData = s.('time');
    
    pointCounts = sum(lengths, 1);
    maxPointCount = max(pointCounts);
    roiCount = size(lengths, 2);
    
    emptyROIs = NaN(maxPointCount, roiCount);
    ROIs = emptyROIs;
    for i = 1:roiCount
        baseline = ones(lengths(1, i), 1) * constants(1, i);
        start = ones(lengths(2, i), 1) * constants(2, i);
        post = ones(lengths(3, i), 1) * constants(3, i);
        wash = ones(lengths(4, i), 1) * constants(4, i);
        
        nPoints = pointCounts(i);
        ROIs(1:nPoints, i) = [baseline; start; post; wash];
    end
    
    roiData = ROITable(timeData(1:maxPointCount), ROIs, emptyROIs, emptyROIs);
    
    savedFile = [dataPath, filename];
    RawFile.save(savedFile, roiData);
end