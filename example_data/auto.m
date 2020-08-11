fields = fieldnames(normal5_ROI2.roiData);
for i = 1:5
    for f=1:numel(fields)
        field = fields{f};
        val = getfield(normal5_ROI2.roiData(i), field);
        val(21:end) = [];
        normal5_ROI2.roiData(i) = setfield(normal5_ROI2.roiData(i), field, val);
    end
end