function [peaks,valleys,error]=h_findPeaks(y,ROI_num);

peakLocation      =   [];
valleyLocation       =   [];
nSmooth     =   10;     %scale over which max should dominate

%criteria: 
% find peaks
maxInd      =   find(imregionalmax(y));

% > 10% of max
maxInd      =   maxInd(find(y(maxInd) > 0.1*max(y)));

% make sure max is not local noise
for i = 1 : length(maxInd)
    if (maxInd(i)+nSmooth) <= length(y) & (maxInd(i)-nSmooth) >= 1
       if y(maxInd(i)) >= max(y((maxInd(i)-nSmooth):(maxInd(i)+nSmooth)))   
            peakLocation=[peakLocation, maxInd(i)];
        end
    end
end

[a, maxInd] =   max(y(peakLocation));
maxLoc      =   peakLocation(maxInd);
%peakLocation

if length(peakLocation) < ROI_num
    disp('WARNING: cannot find required number of ROIs');
    ROI_num = length(peakLocation);
    error=1;
end

% Original Karel's procedure
%if length(peakLocation) < ROI_num
%    disp('WARNING: cannot find required number of peaks');
%    lsainfo.ROIparamaters.ROIs = length(peakLocation);
%    lsa_update;
%end

out(1:ROI_num)   =   0;
out(1)           =   maxLoc;
switch ROI_num
    case 2
        if maxInd==1
            out(2)=peakLocation(maxInd+1);
        elseif maxInd == length(peakLocation)
            out(2)=peakLocation(maxInd-1);
        else
            out(2)=max(peakLocation(maxInd-1), peakLocation(maxInd+1));
        end
    case 3
        if maxInd==1
            out(2:3)=peakLocation(2:3);
        elseif maxInd == length(peakLocation)
            out(2:3)=peakLocation((maxInd-2):(maxInd-1));
        else
            out(2:3)=[peakLocation(maxInd-1), peakLocation(maxInd+1)];
        end
    otherwise
end
out                         =   sort(out);
peaks  =   out;

%---------------------------------
% modified procedure for finding valleys - simply minimum between peaks

for i=1:ROI_num-1
    minInd      =   out(i);
    minValue    =   y(minInd);
    for k=out(i) : out(i+1)
        if y(k)<minValue
            minValue=y(k);
            minInd=k;
        end
    end
    valleyLocation(i)=minInd;
end
%imageData.profileValleys(i)=valleyLocation;
valleys=valleyLocation;

% disp(peakLocation);
% disp(valleyLocation);

error=0;

%---------------------------------
% Original Karel's procedure

% TODO: should the criterion be that the number of valleys has to be one less
%than the number of peaks? interdigitated?

%z=-(imageData.profile-max(imageData.profile));
    %'here'                    ta linia byla komentarzem!
    %z=z(min(out):max(out));   ta linia byla komentarzem!
%minInd=find(imregionalmax(z));
%minInd=minInd(find(z(minInd)<(max(z)-0.1*max(z))));
%for i=1:length(minInd)
%    if (minInd(i)+nSmooth) <= length(y) & (minInd(i)-nSmooth) >= 1
%        if z(minInd(i)) >= max(z((minInd(i)-nSmooth):(minInd(i)+nSmooth)))   
%            valleyLocation=[valleyLocation, minInd(i)];    
%        end
%    end
%end
    %valleyLocation                     ta linia byla komentarzem!
%imageData.profileValleys=valleyLocation;
