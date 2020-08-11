function [newAdj] = modify_adj_data(currentAdj, start, last, avgTau, steTau, avgInt, steInt, avgRed, steRed)
    newAdj = currentAdj;
    nROI = (size(newAdj, 2) - 1) / 3;
    newTau = gen_roi_sample(nROI, last-start+1, avgTau, steTau);
    newInt = gen_roi_sample(nROI, last-start+1, avgInt, steInt);
    newRed = gen_roi_sample(nROI, last-start+1, avgRed, steRed);
    newTau = repmat(newTau, 1, nROI);
    newInt = repmat(newInt, 1, nROI);
    newRed = repmat(newRed, 1, nROI);
    newAdj(start:last, 2:end) = [newTau, newInt, newRed];
end