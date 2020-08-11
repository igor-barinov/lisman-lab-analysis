function h_replot(mode)

global h_img;

handles = h_img.currentHandles;

if ~exist('mode', 'var')||isempty(mode)
    mode = 'slow';
end

imageModes = get(handles.imageMode,'String');
currentImageMode = imageModes{get(handles.imageMode,'Value')};
axes(handles.imageAxes);
try
    map = h_img.temp.currentColorMap;
catch
    map = gray(64);
end
colormap(map);
c = findobj(handles.imageAxes,'Type','image');
if ~strcmp(mode,'fast')
    h_getCurrentImg;
end


switch currentImageMode
    case {'Green'}
        climitg(1) = str2num(get(handles.greenLimitTextLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitTextHigh,'String'));
        if isempty(c)
            axes(handles.imageAxes);
            imagesc(h_img.greenimg,climitg,'ButtonDownFcn','h_doubleClickMakeRoi');
            axis image;
        else
            set(c,'CData',h_img.greenimg,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
        end            
        set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climitg,'ButtonDownFcn','h_doubleClickMakeRoi');
    case {'Red'}
        climitr(1) = str2num(get(handles.redLimitTextLow,'String'));
        climitr(2) = str2num(get(handles.redLimitTextHigh,'String'));
        if isempty(c)
            axes(handles.imageAxes);
            imagesc(h_img.redimg,climitr,'ButtonDownFcn','h_doubleClickMakeRoi');
            axis image;
        else
            set(c,'CData',h_img.redimg,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
        end            
        set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climitr,'ButtonDownFcn','h_doubleClickMakeRoi');
    case {'Overlay'}
        climitg(1) = str2num(get(handles.greenLimitTextLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitTextHigh,'String'));
        climitr(1) = str2num(get(handles.redLimitTextLow,'String'));
        climitr(2) = str2num(get(handles.redLimitTextHigh,'String'));
        colorim = h_merge2color(h_img.greenimg,h_img.redimg,0,climitg,climitr);
        gamma = str2num(get(handles.gamma,'String'));
        if gamma~=1
            colorim = imadjust(colorim,[],[],gamma);
        end
        if isempty(c)
            axes(handles.imageAxes);
            image(colorim,'ButtonDownFcn','h_doubleClickMakeRoi');
            axis image;
        else
            set(c,'CData',colorim,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
        end            
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn','h_doubleClickMakeRoi' );
    case {'Overlay (G/M)'}
        climitg(1) = str2num(get(handles.greenLimitTextLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitTextHigh,'String'));
        climitr(1) = str2num(get(handles.redLimitTextLow,'String'));
        climitr(2) = str2num(get(handles.redLimitTextHigh,'String'));
        colorim = h_merge2color(h_img.greenimg,h_img.redimg,0,climitg,climitr);
        gamma = str2num(get(handles.gamma,'String'));
        if gamma~=1
            colorim = imadjust(colorim,[],[],gamma);
        end
        colorim(:,:,3) = colorim(:,:,1);%magenta is red and blue.
        if isempty(c)
            axes(handles.imageAxes);
            image(colorim,'ButtonDownFcn','h_doubleClickMakeRoi');
            axis image;
        else
            set(c,'CData',colorim,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
        end            
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn','h_doubleClickMakeRoi' );
    case {'G Saturation'}
        climitg(1) = str2num(get(handles.greenLimitTextLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitTextHigh,'String'));
%         map = [zeros(1,63),1;zeros(1,64);0:1/63:1-1/63,0]';
%         map1 = jet(64);
%         map = vertcat(map1(1:38,:),[1,0,0]);
        map = gray(64);
        map(end,:) = [1,0,0];
        if isempty(c)
            axes(handles.imageAxes);
            h = imagesc(h_img.greenimg,climitg,'ButtonDownFcn','h_doubleClickMakeRoi');
            axis image;
        else
            set(c,'CData',h_img.greenimg,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
        end     
        colormap(handles.imageAxes,map);
        set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climitg,'ButtonDownFcn','h_doubleClickMakeRoi');
    case {'R Saturation'}
        climitr(1) = str2num(get(handles.redLimitTextLow,'String'));
        climitr(2) = str2num(get(handles.redLimitTextHigh,'String'));
        map = gray(64);
        map(end,:) = [1,0,0];
        if isempty(c)
            axes(handles.imageAxes);
            h = imagesc(h_img.redimg,climitr,'ButtonDownFcn','h_doubleClickMakeRoi');
            axis image;
        else
            set(c,'CData',h_img.redimg,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
        end     
        colormap(handles.imageAxes,map);
        set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climitr,'ButtonDownFcn','h_doubleClickMakeRoi');
    case {'G/R ratio'}
        climitg(1) = str2num(get(handles.greenLimitTextLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitTextHigh,'String'));
        climitr(1) = str2num(get(handles.redLimitTextLow,'String'));
        climitr(2) = str2num(get(handles.redLimitTextHigh,'String'));
        ratioImg = ((h_img.greenimg-climitg(1))/diff(climitg))./((h_img.redimg-climitr(1))/diff(climitr));
        ratioImg(h_img.redimg<=3*climitr(1)) = nan;
        climit = h_climit(ratioImg,0.001,0.999);
        rgbimage = ss_makeRGBLifetimeMap(ratioImg,[climit(2),climit(1)], h_img.redimg,climitr);
        if isempty(c)
            axes(handles.imageAxes);
            image(rgbimage,'ButtonDownFcn','h_doubleClickMakeRoi');
            axis image;
        else
            set(c,'CData',rgbimage,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
        end            
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn','h_doubleClickMakeRoi' );

%         if isempty(c)
%             axes(handles.imageAxes);
%             h = imagesc(ratioImg,'ButtonDownFcn','h_doubleClickMakeRoi');
%         else
%             set(c,'CData',ratioImg,'CDataMapping','scaled','ButtonDownFcn','h_doubleClickMakeRoi');
%         end     
%         colormap(jet);
%         set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climit,'ButtonDownFcn','h_doubleClickMakeRoi');
end

% axis image;

%%%%%%%%%%%%%%
UserData = get(handles.lineScanAnalysis,'UserData');
if isfield(UserData,'lineScanDisplay') & UserData.lineScanDisplay.Value
    YLim = [0,size(h_img.greenimg,1)]+0.5;
    set(handles.imageAxes,'YLim',YLim);
end
    
