classdef FLIMageFitting
    methods (Static)        
        function [y] = ExpGauss(beta0, x)
        %% --------------------------------------------------------------------------------------------------------
        % 'ExpGauss' Method
        %
            beta3_sq = beta0(3)^2;
            beta2_sq = beta0(2)^2;
            y1 = beta0(1) * exp(beta3_sq * beta2_sq / 2 - (x - beta0(4)) * beta0(2));
            y2 = erfc((beta3_sq * beta0(2) - (x - beta0(4))) / (sqrt(2) * beta0(3)));
            y = y1 .* y2 /2;
        end
        
        function [y] = Exp2Gauss(beta0, x)
        %% --------------------------------------------------------------------------------------------------------
        % 'Exp2Gauss' Method
        %
            beta1 = [beta0(1), beta0(2), beta0(5), beta0(6)];
            beta2 = [beta0(3), beta0(4), beta0(5), beta0(6)];
            
            y = FLIMageFitting.ExpGauss(beta1, x) + FLIMageFitting.ExpGauss(beta2, x);
        end
        
        function [beta0] = ExpGaussInitialPrms(x, y, psPerUnit)
        %% --------------------------------------------------------------------------------------------------------
        % 'ExpGaussInitialPrms' Method
        %
            [maxY, i] = max(y);
            maxX = x(i);
            sumX = dot(x, y);
            sumY = sum(y);
            
            tau1 = sumY / maxY;
            tauG = 100 / psPerUnit;
            
            beta0 = ones(1, 4);
            beta0(1) = maxY * (1 + tauG / tau1);
            beta0(2) = 1 / tau1;
            beta0(3) = maxX - 2 * tauG;
            beta0(4) = tauG;
        end
        
        function [beta0] = Exp2GaussInitialPrms(x, y, psPerUnit)
        %% --------------------------------------------------------------------------------------------------------
        % 'Exp2GaussInitialPrms' Method
        %
            [maxY, i] = max(y);
            maxX = x(i);
            sumX = dot(x, y);
            sumY = sum(y);
            
            tau1 = sumY / maxY;
            tauG = 100 / psPerUnit;
            
            beta0 = ones(1, 6);
            beta0(1) = maxY / 2;
            beta0(2) = 1 / tau1 / 2;
            beta0(3) = maxY / 2;
            beta0(4) = 1 / tau1 / 0.5;
            beta0(5) = maxX - 1 * tauG;
            beta0(6) = tauG;
        end
        
        function [betahat] = ExpGaussFit(beta0, x, y)
        %% --------------------------------------------------------------------------------------------------------
        % 'ExpGaussFit' Method
        %
            weights = ones(size(y)) ./ sqrt(y);
            weights(isnan(weights) | isinf(weights)) = 1;
            betahat = nlinfit(x, y, @FLIMageFitting.ExpGauss, beta0, 'Weights', weights);
            betahat = [betahat(1), betahat(2), 0, 0, betahat(3), betahat(4)];
        end
        
        function [betahat] = Exp2GaussFit(beta0, x, y)
        %% --------------------------------------------------------------------------------------------------------
        % 'Exp2GaussFit' Method
        %
            weights = ones(size(y)) ./ sqrt(y);
            weights(isnan(weights) | isinf(weights)) = 1;
            betahat = nlinfit(x, y, @FLIMageFitting.Exp2Gauss, beta0, 'Weights', weights);
        end
    end
end
