function out=h_findThInd(y, pkInd, th, delta)


while (pkInd > 0) & (pkInd <= length(y)) & (y(pkInd) > th) 
    pkInd=pkInd+delta;
end
out=pkInd-delta;