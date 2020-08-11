function spc_makeRGBLifetimeMap(colormap1)
%0: gray scale, 1: Rainbow, 2: Red and blue, 3: modified rainbow, 4: modified rainbow 2
%colormap defined in spc_im2rgb.

global spc;
%Drawing


if isfield(spc, 'lifetimeMap')
    rgbimage = spc_im2rgb(spc.lifetimeMap, spc.switches.lifetime_limit, colormap1);
else
    spc_redrawSetting(1);
    return;
end
try 
    low = spc.switches.lutlim(1);
    high = spc.switches.lutlim(2);
catch
    try
        low = 0;
        high = spc.switches.threshold;
    catch
        maxim = max(max(spc.project, [], 1), [], 2);
        low = 0;
        high = maxim/6;
    end
    spc.switches.lutlim(1) = low;
    spc.switches.lutlim(2) = high;
end

if high-low > 0
    gray = (spc.project-low)/(high - low);
else
    gray = 0;
end
gray(gray > 1) = 1;
gray(gray < 0) = 0;
if colormap1 ~= 0  
    rgbimage(:,:,1)=rgbimage(:,:,1).*gray;
    rgbimage(:,:,2)=rgbimage(:,:,2).*gray;
    rgbimage(:,:,3)=rgbimage(:,:,3).*gray;
else  %colormap1 = grayscale.
    gray(gray > 0) = 1;
    gray1 = rgbimage(:,:,1).*gray;
    gray1(gray == 0) = 1;
    rgbimage(:,:,1)=gray1;
    rgbimage(:,:,2)=gray1;
    rgbimage(:,:,3)=gray1;
end
spc.rgbLifetime = rgbimage;
