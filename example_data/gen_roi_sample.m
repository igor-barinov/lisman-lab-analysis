function [sample] = gen_roi_sample(nBase, baseline, start, postStart, washout)
    baseline = ones(nBase, 1) * baseline;
    start = ones(nBase, 1) * start;
    postStart = ones(nBase, 1) * postStart;
    washout = ones(nBase, 1) * washout;

    sample = [baseline; start; postStart; washout];
end