function yphys_showImageTraces(flag);
global state;
global yphys;
global gh;

if ~nargin
    flag = 1;
end

if isfield (gh, 'yphys')
    fh = gh.yphys.calcium;
else
    gh.yphys.calcium = figure;
    fh = gh.yphys.calcium;
end

if ~ishandle (fh)
    gh.yphys.calcium = figure;
else
    figure(fh);
end
%color_a = {'green', 'red', 'white', 'cyan', 'magenda'};
roiobj = findobj('Tag', 'ROI');

nRoi = length(roiobj);

if isfield(yphys.image, 'average')
    if sum(isnan(yphys.image.average.ratio))
        yphys.image.average.ratio = [];
    else
        yphys.image.average.ratio = yphys.image.average.ratio* 0;
    end
	for i=yphys.image.aveImage
        try
            if all(size(yphys.image.average.ratio) == size(yphys.image.intensity{i}.ratio))
                yphys.image.average.ratio = yphys.image.intensity{i}.ratio + yphys.image.average.ratio;
            else
                yphys.image.average.ratio = yphys.image.intensity{i}.ratio;
            end
        catch
            yphys.image.average.ratio = yphys.image.intensity{i}.ratio;
        end
	end
	if length(yphys.image.aveImage) >= 1
        yphys.image.average.ratio =  yphys.image.average.ratio/length(yphys.image.aveImage);
	
	else
        yphys.image.average.ratio = 0;
	end
else
    yphys.image.average.ratio = 0;
end

if isfield(yphys.image, 'intensity')
    if length(yphys.image.intensity) > 0
        if yphys.image.currentImage <= length(yphys.image.intensity)
            a1=yphys.image.intensity{yphys.image.currentImage};
            tSize = size(a1.redMean);
            nRoi = tSize(2);
        else
            nRoi = 0;
        end
    end

else
    nRoi = 0;
end


figure(fh); 
color_a = {'green', 'red', 'black', 'cyan', 'magenda'};
hold off;
for j = 1 :nRoi
    subplot(2,3,1);
    if j==1
        hold off
    end
    plot(a1.greenMean(:, j), '-o', 'color', color_a{j});
    title('Green channel');
    hold on;
    subplot(2,3,2);
    
    if j == 1
        hold off
    end
    plot(a1.redMean(:, j), '-o', 'color', color_a{j});
    title('Red channel');
    hold on;
        subplot(2,3,4);
        title('Ratio');
    if j == 1
        hold off
    end
    plot(a1.ratio(:, j), '-o', 'color', color_a{j});
    hold on;
        subplot(2,3,5);
    if j == 1
        hold off
    end
    if length(yphys.image.average.ratio)>2
        plot(yphys.image.average.ratio(:, j), '-o', 'color', color_a{j});
    end
    title('Averaged ratio');
    hold on;
end;


roiobj = findobj('Tag', 'ROI');
nRoi = length(roiobj);
for j = 1:nRoi
    spc_roi{j} = get(gh.yphys.figure.roiCalcium(j), 'Position');
end
    delete(roiobj);
pwdstr = yphys.image.pathstr(1:end-4);
numstr = '000';
numstr1 = num2str(yphys.image.currentImage);
numstr(end-length(numstr1)+1:end) = numstr1;

if flag
    [data, header] = genericOpenTif([pwdstr, '\', yphys.image.baseName, numstr, '.tif']);
    yphys.image.imageData = data;
    yphys.image.imageHeader =header;
    yphys.image.pathstr = [pwdstr, '\spc'];
end

data = yphys.image.imageData;
header = yphys.image.imageHeader;


siz = size(data);
if isfield(yphys.image, 'currentSlice')
    if yphys.image.currentSlice > siz(3)/2;
        yphys.image.currentSlice = siz(3)/2;
    elseif yphys.image.currentSlice < 1
        yphys.image.currentSlice = 1;
    end
else
    yphys.image.currentSlice = siz(3)/2;
end
slice = yphys.image.currentSlice;
figure(fh); 
subplot(2,3,3);
roi_context = uicontextmenu;
image(data(:,:,2*(slice-1)+1), 'CDataMapping','scaled', 'UIContextMenu', roi_context);
set(gca,'XTickLabel', '');
set(gca, 'YTickLabel', '');
colormap(gray);
subplot(2,3,6);
image(data(:,:,2*slice), 'CDataMapping','scaled', 'UIContextMenu', roi_context);
set(gca,'XTickLabel', '');
set(gca, 'YTickLabel', '');
item1 = uimenu(roi_context, 'Label', 'make new roi', 'Callback', 'r_makeRoi');
item2 = uimenu(roi_context, 'Label', 'Analyze current image', 'Callback', 'yphys_calcium_offLine');
item3 = uimenu(roi_context, 'Label', 'DeleteRois', 'Callback', 'delete(findobj(''Tag'', ''ROI''))');

for j=1:nRoi
    gh.yphys.figure.roiCalcium(j) = rectangle('Position', spc_roi{j}, 'EdgeColor', color_a{j}, 'ButtonDownFcn', 'r_dragRoi', 'Tag', 'ROI', 'Curvature', [1 1]);
end


obj1 = findobj('Tag', 'Fig402Button');
if isempty(obj1)
	gh.yphys.figure.preButtonb1 = uicontrol('Style','pushbutton','Units','normalized', 'Position',[.0 .07 .05 .05], 'String','<', 'Tag', 'Fig402Button', 'CallBack', 'yphys_moveToImage(1)');
	gh.yphys.figure.postButtonb2 = uicontrol('Style','pushbutton','Units','normalized', 'Position',[.05 .07 .05 .05], 'String', '>', 'Tag', 'Fig402Button', 'CallBack', 'yphys_moveToImage(2)');
    gh.yphys.figure.preButtonb3 = uicontrol('Style','pushbutton','Units','normalized', 'Position',[0.85 0.95 .035 .035], 'String','<', 'Tag', 'Fig402Button', 'CallBack', 'yphys_moveToImage(5)');
	gh.yphys.figure.postButtonb4 = uicontrol('Style','pushbutton','Units','normalized', 'Position',[0.95 0.95 .035 .035], 'String', '>', 'Tag', 'Fig402Button', 'CallBack', 'yphys_moveToImage(6)');
end
obj2 = findobj('Tag', 'Fig402Text');
if isempty(obj2)
    uicontrol('Style','text','Units','normalized', 'Position',[.775 .95 .05 0.035], 'String','Slice', 'Tag', 'Fig402Text');
end

try
    delete(gh.yphys.figure.currentImageText);
    delete(gh.yphys.figure.averageInFigure, gh.yphys.figure.epochPulse);
    delete(gh.yphys.figure.slice);
end
gh.yphys.figure.currentImageText = uicontrol('style', 'edit', 'Units','normalized', 'Position',[.0175 .005 .075 .05], 'String', num2str(yphys.image.currentImage), ...
    'CallBack', 'yphys_moveToImage(3)');
gh.yphys.figure.averageInFigure = uicontrol('style', 'edit', 'Units','normalized', 'Position',[.225 .005 .45 0.05], 'String', num2str(yphys.image.aveImage), ...
    'CallBack', 'yphys_moveToImage(4)');
if isfield(state, 'yphys')
    str1 = ['e', num2str(state.yphys.acq.epochN), 'p', num2str(state.yphys.acq.pulseN), '_int'];
else
    str1 = '';
end
gh.yphys.figure.epochPulse = uicontrol('style', 'text', 'Units','normalized', 'Position',[.1 .005 .1 0.05], 'String', str1);
gh.yphys.figure.slice = uicontrol('style', 'text', 'Units','normalized', 'Position',[.8925 .95 .05 0.035], 'String', num2str(yphys.image.currentSlice));

gh.yphys.figure.baseName = uicontrol('style', 'edit', 'Units','normalized', 'Position',[.7 .005 .075 .05], 'String', state.files.baseName, ...
    'CallBack', 'global state; state.files.baseName = get(gco, ''String'');');
gh.yphys.figure.loadButton = uicontrol('style', 'pushbutton', 'Units','normalized', 'Position',[.8 .005 .075 .05], 'String', 'Load', ...
    'CallBack', 'global state; state.files.baseName = ''a''; yphys_calcium');
set(gh.yphys.figure.baseName, 'String', state.files.baseName);