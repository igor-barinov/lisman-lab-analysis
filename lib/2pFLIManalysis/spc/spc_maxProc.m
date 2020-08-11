function spc_maxProc
global spc;
global state;
global spc_max;

if state.acq.numberOfZSlices > 1    
	if state.internal.zSliceCounter == 0 % if its the first frame of first channel, then overwrite...
        spc_max = spc;
    else   
        index = (spc.project <= spc_max.project);
		siz = size(index);
		
		index = repmat (index(:), [1,spc.size(1)]);
		index = reshape(index, siz(1), siz(2), spc.size(1));
		index = permute(index, [3,1,2]);
        index = index(:);
		spc_max.imageMod = index .* spc_max.imageMod(:) + (1-index) .* spc.imageMod(:);
        
        spc_max.imageMod = reshape(spc_max.imageMod, spc.size(1), spc.size(2), spc.size(3));
        spc_max.project = reshape(sum(spc_max.imageMod, 1), spc.size(2), spc.size(3));
        %spc_max.imageMod = spc_max.image;
        spc = spc_max;
    end
else
    %spc_max = spc;
end

try
    spc_redrawSetting;
catch
end