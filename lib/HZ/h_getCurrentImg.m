function h_getCurrentImg

global h_img

handles = h_img.currentHandles;
siz = size(h_img.data);
siz(3) = siz(3)/2;
zLim(1) = str2num(get(handles.zStackControlLow,'String'));
zLim(2) = str2num(get(handles.zStackControlHigh,'String'));
UData = get(handles.lineScanAnalysis,'UserData');
if isfield(UData,'lineScanDisplay') & UData.lineScanDisplay.Value
    h_img.greenimg = permute(reshape(permute(h_img.data(:,:,2*zLim(1)-1:2:2*zLim(2)),[2,1,3]),[siz(2),siz(1)*(diff(zLim)+1)]),[2,1]);
    h_img.redimg = permute(reshape(permute(h_img.data(:,:,2*zLim(1):2:2*zLim(2)),[2,1,3]),[siz(2),siz(1)*(diff(zLim)+1)]),[2,1]);
else
    dispAxes = get(handles.viewingAxisControl,'Value');
    switch dispAxes
        case {1}
            viewingAxis = 3;
            h_img.greenimg = double(max(h_img.data(:,:,2*zLim(1)-1:2:2*zLim(2)),[],viewingAxis));
            h_img.redimg = double(max(h_img.data(:,:,2*zLim(1):2:2*zLim(2)),[],viewingAxis));
        case {2}
            viewingAxis = 1;
            h_img.greenimg = permute(double(max(h_img.data(zLim(1):zLim(2),:,1:2:end),[],viewingAxis)),[3,2,1]);
            h_img.redimg = permute(double(max(h_img.data(zLim(1):zLim(2),:,2:2:end),[],viewingAxis)),[3,2,1]);
        case {3}
            viewingAxis = 2;
            h_img.greenimg = permute(double(max(h_img.data(:,zLim(1):zLim(2),1:2:end),[],viewingAxis)),[3,1,2]);
            h_img.redimg = permute(double(max(h_img.data(:,zLim(1):zLim(2),2:2:end),[],viewingAxis)),[3,1,2]);
    end
end



filter_on = get(handles.smoothImage,'Value');

if filter_on
%     f = ones(3)/9;
%     f = ones(2)/4;
    f = [0.07 0.12 0.07; 0.12 0.24 0.12; 0.07 0.12 0.07];
    h_img.greenimg = filter2(f, h_img.greenimg);
    h_img.redimg = filter2(f, h_img.redimg);
end
