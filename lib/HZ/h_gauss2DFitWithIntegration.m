function Aout = h_gauss2DFitWithIntegration(img, mu0, sigma0, fig_on)

%fitting two D gaussium with integration.
%mu0 and sigma0 are both vectors each containing two values in [x, y] and
%in pixels.
%Pixel # start from 1

global siz gridSize;

siz = size(img);
sumAlongX = sum(img(:,(-1:1)+round(siz(2)/2)), 2)';
sumAlongY = sum(img((-1:1)+round(siz(1)/2),:), 1);
if ~exist('mu0','var')||isempty(mu0)
    mu0(1) = sum(sumAlongY.*(1:siz(2)))/sum(sumAlongY);
    mu0(2) = sum(sumAlongX.*(1:siz(1)))/sum(sumAlongX);
end

if ~exist('sigma0','var')||isempty(sigma0)
    sigma0(1) = 1.4 * sqrt(sum(((1:siz(2)) - mu0(1)).^2.*sumAlongY)/sum(sumAlongY));
    sigma0(2) = 1.4 * sqrt(sum(((1:siz(1)) - mu0(2)).^2.*sumAlongX)/sum(sumAlongX));
    while any(~isreal(sigma0))
        img = img - mean(img(img<0));%min(img(:));
        sumAlongX = sum(img, 2)';
        sumAlongY = sum(img, 1);
        sigma0(1) = 1.4 * sqrt(sum(((1:siz(2)) - mu0(1)).^2.*sumAlongY)/sum(sumAlongY));
        sigma0(2) = 1.4 * sqrt(sum(((1:siz(1)) - mu0(2)).^2.*sumAlongX)/sum(sumAlongX));
    end
end

if ~exist('fig_on','var')||isempty(fig_on)
    fig_on = 0;
end

baseline0 = min(img(:));

height0 = max(img(:)) - baseline0;

beta0 = [mu0(1) mu0(2) sigma0(1) sigma0(2) height0 baseline0];

xdata = 1:prod(siz);%not really used. Just to meet the requirements.
gridSize = 1;

[beta,r,J,converge] = h_nlinfit(xdata,img(:),@h_gauss2DWithIntegration,beta0);

Aout.mu = beta(1:2);
Aout.sigma = beta(3:4);
Aout.height = beta(5);
Aout.baseline = beta(6);
gridSize = 0.1;
Xind = 1:gridSize:siz(2);
Yind = (1:gridSize:siz(1));
Aout.img = reshape(h_gauss2DWithIntegration(beta, xdata), [length(Yind), length(Xind)]);
Aout.converge = converge;
try
    if converge
        xCenterPos = (-1:1)+round(beta(1));
        Aout.intAlongXCenter = sum(img(:,xCenterPos),2)';
        ind = [find(Xind==xCenterPos(1)), find(Xind==xCenterPos(2)), find(Xind==xCenterPos(3))];
        Aout.fitAlongXCenter = sum(Aout.img(:,ind),2)';
        Aout.Yind = Yind;
        yCenterPos = (-1:1)+round(beta(2));
        Aout.intAlongYCenter = sum(img(yCenterPos,:),1);
        ind = [find(Yind==yCenterPos(1)), find(Yind==yCenterPos(2)), find(Yind==yCenterPos(3))];
        Aout.fitAlongYCenter = sum(Aout.img(ind,:),1);
        Aout.Xind = Xind;
    else
        Aout.intAlongXCenter = nan;
        Aout.fitAlongXCenter = nan;
        Aout.Yind = nan;
        Aout.intAlongYCenter = nan;
        Aout.fitAlongYCenter = nan;
        Aout.Xind = nan;
    end
catch
    Aout.converge = 0;
    Aout.intAlongXCenter = nan;
    Aout.fitAlongXCenter = nan;
    Aout.Yind = nan;
    Aout.intAlongYCenter = nan;
    Aout.fitAlongYCenter = nan;
    Aout.Xind = nan;
end

if fig_on
    figure(987),
    bar(Aout.intAlongXCenter);hold on;plot(Yind, Aout.fitAlongXCenter);hold off;
    title('Fit along Y @ X center');
    
    figure(986),
    bar(Aout.intAlongYCenter);hold on;plot(Xind, Aout.fitAlongYCenter);hold off;
    title('Fit along X @ Y center');
end

clear global siz;

function img = h_gauss2DWithIntegration(beta, xdata)

global siz gridSize

Xind = 1:gridSize:siz(2);
Yind = (1:gridSize:siz(1));

% Xind2 = zeros(length(Yind), length(Xind));
% Yind2 = Xind2;
% for i = 1:length(Xind)
%     Yind2(:,i) = Yind';
% end
% for i = 1:length(Yind)
%     Xind2(i,:) = Xind;
% end
% 
% Xind = Xind2;
% Yind = Yind2;

mu_x = beta(1);
mu_y = beta(2);
sigma_x = beta(3);
sigma_y = beta(4);
height = beta(5);
% baseline = beta(6);
baseline = 0;

% if sigma_x <= 1
%     sigma_x = 1;
% end
% 
% if sigma_y <= 1
%     sigma_y = 1;
% end

Amax_x = (Xind + 0.5 - mu_x) ./ sigma_x;
Amin_x = (Xind - 0.5 - mu_x) ./ sigma_x;

gaussIntegration_x = erf(Amax_x) - erf(Amin_x);

Amax_y = (Yind + 0.5 - mu_y) ./ sigma_y;
Amin_y = (Yind - 0.5 - mu_y) ./ sigma_y;

gaussIntegration_y = erf(Amax_y) - erf(Amin_y);

img = repmat(gaussIntegration_x, [length(Yind), 1]) .* repmat(gaussIntegration_y', [1, length(Xind)]);

% img = gaussIntegration_x .* gaussIntegration_y;

img = img .* height + baseline;

img = img(:);

% function mat_out = h_repmat(mat_in, rep_siz)
% %hopefully a fasterway for doing repmat and make the fittig faster
% %only for 2d matrix
% 
% %tested - slower than repmat.
% 
% siz = size(mat_in);
% mat_siz = siz.*rep_siz;
% mat_out = zeros(mat_siz);
% for i = 1:rep_siz(1)
%     for j = 1:rep_siz(2)
%         mat_out((1:siz(1))*i,(1:siz(2))*j) = mat_in;
%     end
% end





