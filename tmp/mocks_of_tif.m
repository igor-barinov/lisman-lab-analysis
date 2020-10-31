function [A, B] = mocks_of_tif(filepath)
    fileInfo = imfinfo(filepath);
    nFrames = length(fileInfo);
    width = fileInfo(1).Width;
    height = fileInfo(1).Height;
    tif_data = ones(height, width, nFrames);
    
    red_frames = tif_data(:, :, 2:2:nFrames);
    avg_red_value = mean(red_frames, 'all');
    valueA = floor(avg_red_value);
    valueB = ceil(avg_red_value);
    
    A = ones(size(tif_data)) * valueA;
    B = ones(size(tif_data)) * valueB;
    
    [file_dir, ~, ~] = fileparts(filepath);
    path_to_A = fullfile(file_dir, 'A.tif');
    path_to_B = fullfile(file_dir, 'B.tif');
    tifA = Tiff(path_to_A, 'w');
    tifB = Tiff(path_to_B, 'w');
    tifA.setTag(fileInfo(1));
    tifB.setTag(fileInfo(1));
    tifA.write();
    tifB.write();
    close(tifA);
    close(tifB);
end
