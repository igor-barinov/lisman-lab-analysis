function Aout = h_fitGaussian(x, y)

% mu0 = sum(y(:).*x(:))/sum(y);
[maxY, I] = max(y(:));
mu0 = x(I(1));
% sigma0 = sqrt(sum(((x(:)-mu0).^2).*y(:))./sum(y(:)));
sigma0 = h_findFWHM(y);
height0 = max(y) - min(y);
baseline = min(y);
beta0 = [mu0 sigma0 height0 baseline];

[beta,r,J,converge] = h_nlinfit(x,y,@h_gaussian,beta0);
Aout.mu = beta(1);
Aout.sigma = beta(2);
Aout.height = beta(3);
Aout.baseline = beta(4);
Aout.FWHM = Aout.sigma * 2 * sqrt(2*log(2));
Aout.converge = converge;
Aout.x(1:2:2*length(x)-1) = x;
Aout.x(2:2:end) = x(1:end-1) + diff(x)/2;
Aout.y = h_gaussian(beta, Aout.x);

