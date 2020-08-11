function yphys_makeRoi(i);
global state
global spc
global gh

axes(state.internal.axis(1));

ind = find(gca==state.internal.axis);
if isempty(ind)
    return;
end
pa = findobj('Tag', num2str(i));
if size(pa) > 0
	for j = 1:size(pa)
        delete(pa(j));
    end
end
%figure(gcf);
waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = min(point1,point2);             % calculate locations
offset = abs(point1-point2);         % and dimensions
%rectangle('Position', [p1, offset]);
yphys_roi = round([p1, offset]);
axes(state.internal.axis(1));
gh.yphys.figure.yphys_roi(i) = rectangle('Position', yphys_roi, 'EdgeColor', 'cyan', 'ButtonDownFcn', 'yphys_dragRoi', 'Tag', num2str(i));
gh.yphys.figure.yphys_roiText(i) = text(yphys_roi(1)-3, yphys_roi(2)-3, num2str(i), 'Tag', num2str(i), 'ButtonDownFcn', 'yphys_roiDelete');
set(gh.yphys.figure.yphys_roiText(i), 'Color', 'Red');

axes(state.internal.axis(2));
gh.yphys.figure.yphys_roi2(i) = rectangle('Position', yphys_roi, 'EdgeColor', 'cyan', 'ButtonDownFcn', 'yphys_dragRoi', 'Tag', num2str(i));
gh.yphys.figure.yphys_roiText2(i) = text(yphys_roi(1)-3, yphys_roi(2)-3, num2str(i), 'Tag', num2str(i), 'ButtonDownFcn', 'yphys_roiDelete');
set(gh.yphys.figure.yphys_roiText2(i), 'Color', 'Red');

%figure(101);
%gh.yphys.figure.yphys_roiA(i) = rectangle('Position', yphys_roi, 'EdgeColor', 'cyan', 'ButtonDownFcn', 'yphys_dragRoi', 'Tag', num2str(i));
