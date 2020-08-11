function h_greenControlQuality

global h_img;

handles = h_img.currentHandles;

[maxIntensity, sliderSteps] = h_getMaxIntensity;

hgLim1 = h_findobj(handles.h_imstack,'Tag','greenLimitTextLow');
hgLim2 = h_findobj(handles.h_imstack,'Tag','greenLimitTextHigh');
climitg(1) = str2num(get(hgLim1(1),'String'));
climitg(2) = str2num(get(hgLim2(1),'String'));

if climitg(1)<0
    climitg(1) = 0;
end

if climitg(2)<0
    climitg(2) = 0;
end

% if climitg(1)>maxIntensity
%     climitg(1) = maxIntensity;
% end
% 
% if climitg(2)>maxIntensity
%     climitg(2) = maxIntensity;
% end

climitg = sort(climitg);
climitg = round(climitg);

try
set(hgLim1(1),'String',num2str(climitg(1)));
set(hgLim2(1),'String',num2str(climitg(2)));
% set(h_findobj('Tag','greenLimit1'),'SliderStep',[10/maxIntensity,0.1]);
% set(h_findobj('Tag','greenLimit2'),'SliderStep',[10/maxIntensity,0.1]);
set(h_findobj(handles.h_imstack, 'Tag','greenLimit1'),'Value',climitg(1)/maxIntensity, 'SliderStep',sliderSteps);
set(h_findobj(handles.h_imstack, 'Tag','greenLimit2'),'Value',climitg(2)/maxIntensity, 'SliderStep',sliderSteps);
end
