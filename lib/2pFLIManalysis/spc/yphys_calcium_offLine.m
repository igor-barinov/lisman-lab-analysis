function Aout = yphys_calcium_offLine (inAverage)
global state;
global yphys;
global gh;

if ~nargin
    inAverage = 0;
end

color_a = {'green', 'red', 'white', 'cyan', 'magenda'};
%fh = 402;

roiobj = findobj('Tag', 'ROI');

nRoi = length(roiobj);

data = yphys.image.imageData;
header = yphys.image.imageHeader;
num = yphys.image.currentImage;

roiobj = findobj('Tag', 'ROI');
nRoi = length(roiobj);


if nRoi > 0
	for j = 1:nRoi %RoiCounter = 1:nRoi
        ROI = get(gh.yphys.figure.roiCalcium(j), 'Position');
        theta = [0:1/20:1]*2*pi;
        xr = ROI(3)/2;
        yr = ROI(4)/2;
        xc = ROI(1) + ROI(3)/2;
        yc = ROI(2) + ROI(4)/2;
        x1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc);
        y1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc);
        siz = size(data);
        ROIreg = roipoly(ones(siz(1), siz(2)), x1, y1);
        %figure; image(ROIreg);
        
		for i= 1: header.acq.numberOfFrames
            greenim = data(:,:,i*2-1);
            redim = data(:,:, i*2);
            greenCrop = greenim(ROIreg);
            redCrop = redim(ROIreg);
            greenMean(i, j) = mean(greenCrop(:));
            redMean(i, j) = mean(redCrop(:));
            greenSum(i, j) = sum(greenCrop(:));
            redSum(i, j) = sum(redCrop(:));
	
		end
        %evalc(['Aout.position', num2str(j), '=ROI']);
        greenMean(:, j) = greenMean(:, j) - greenMean(1, j);
        redMean(:, j) = redMean(:, j) - redMean(1, j);
        greenSum(:, j) = greenSum(:, j) - greenSum(1, j);
        redSum(:, j) = redSum(:, j) - redSum(1, j);
        Aout.ratio(:, j) = greenSum(:, j)/mean(redSum(3:end, j), 1);
        Aout.position{j} = ROI;
	
	end
	
	Aout.greenMean = greenMean;
	Aout.redMean = redMean;
	Aout.greenSum = greenSum;
	Aout.redSum = redSum;
	yphys.image.intensity{num} = Aout;
    
    if inAverage
        if ~isfield(yphys.image, 'aveImage')
            yphys.image.aveImage = num;
		end
		if isempty(find(yphys.image.aveImage == num))
            yphys.image.aveImage = [yphys.image.aveImage, num];
		end
		
		yphys.image.average.ratio = Aout.ratio .* 0;
		siz = size(yphys.image.average.ratio);
		Num = zeros(siz(2), 1);
		for i=yphys.image.aveImage
            siz2 = size(yphys.image.intensity{i}.ratio);
            if siz(2) > siz2(2)
                sizN = siz2(2);
            else
                sizN = siz(2);
            end
            yphys.image.average.ratio(:,1:sizN)  = yphys.image.intensity{i}.ratio(:, 1:sizN) + yphys.image.average.ratio(:, 1:sizN);
            Num(1:sizN) = Num(1:sizN) + ones(sizN, 1);
		end
		for i=1:siz(2)
            yphys.image.average.ratio(:,i) =  yphys.image.average.ratio(:,i)/Num(i);
		end
		
		filenamestr = [yphys.image.baseName, '_intensity'];
		evalc([filenamestr, '=yphys.image.intensity']);
		
        if exist(yphys.image.pathstr)
    		cd(yphys.image.pathstr);
        else
            yphys.image.pathstr = pwd;
            cd(yphys.image.pathstr);
        end
		save(filenamestr, filenamestr);
		
        if isfield(state, 'yphys')
    		filenamestr2 = ['e', num2str(state.yphys.acq.epochN), 'p', num2str(state.yphys.acq.pulseN), '_int'];
        else
            filenamestr2 = 'avg_intensity';
        end
        
		saveAverage.average = yphys.image.average;
		saveAverage.aveImage = yphys.image.aveImage;
		evalc([filenamestr2, '=saveAverage']);
		save(filenamestr2, filenamestr2);
    end
	%evalc([state.files.baseName, '_int = A1']);
	%save([state.files.baseName, '_int'], [state.files.baseName, '_int']);
end


yphys_showImageTraces(0);

