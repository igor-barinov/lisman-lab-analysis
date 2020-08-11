function h_reverseROIOrder

global h_img

handles = h_img.currentHandles;

roiObj = h_findobj(handles.imageAxes,'Tag','HROI');

UData = cell2mat(get(roiObj,'UserData'));

ind = [UData.number];
[Y I] = sort(ind);
UData = UData(I);

for i = 1:length(UData)
    newInd = length(UData) - i + 1;
    UData(i).number = newInd;
    set(UData(i).ROIhandle,'UserData',UData(i));
    set(UData(i).texthandle,'String',num2str(newInd),'UserData',UData(i));
end
