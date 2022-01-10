function spc_selectRoi(varargin)
    global spc;
    
    if nargin > 0 % ROI to select is specified
        Rois = varargin{1};
        lineX = get(Rois(1), 'XData');
        lineY = get(Rois(1), 'YData');
        
        imgSize = size(spc.project);
        selectedROI = roipoly([1 imgSize(1)], [1 imgSize(2)], spc.project, lineX, lineY);
    else
        selectedROI = roipoly();
        
    end
    
    spc.roipoly = selectedROI;
    
    spc_redrawSetting(1);
end
