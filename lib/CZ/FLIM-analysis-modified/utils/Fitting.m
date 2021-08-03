classdef Fitting
    methods (Static)
        function [beta] = convert_params(beta0, mode)
        %% --------------------------------------------------------------------------------------------------------
        % 'convert_params' Method
        %
        % Converts function parameters into correct units
        %
        % (IN) "beta0": Vector containing the 6 parameters. Must work with 'spc_unpackParams'.
        %
        % (IN) "mode": String describing what type of conversion to perform. Possible conversions are 'spc2flimage' or 'flimage2spc'.
        %
        % (OUT) "beta": Vector containing the 6 converted parameters
        %
            [pop1, tau1, pop2, tau2, tau_d, tau_g] = spc_unpackParams(beta0);
            
            if strcmp(mode, 'spc2flimage')
                tau1 = spc_picoseconds(1 / tau1);
                tau2 = spc_picoseconds(1 / tau2);
                tau_d = spc_nanoseconds(tau_d);
                tau_g = spc_nanoseconds(tau_g);
            elseif strcmp(mode, 'flimage2spc')
                tau1 = spc_picoseconds(1 / tau1);
                tau2 = spc_picoseconds(1 / tau2);
                tau_d = spc_picoseconds(tau_d);
                tau_g = spc_picoseconds(tau_g);
            end
            
            beta = spc_packParams(pop1, tau1, pop2, tau2, tau_d, tau_g);
        end
        
        function [beta] = fix_params(beta0, betaFixed, isFixed)
        %% --------------------------------------------------------------------------------------------------------
        % 'fix_params' Method
        %
        % Replaces a subset of input parameters with a set of fixed parameters
        %
        % (IN) "beta0": Vector containing the parameters to be replaced
        %
        % (IN) "betaFixed": Vector containing the fixed parameters that will act as replacements
        %
        % (IN) "isFixed": Logical array indicating which parameters should be replaced. 
        %                 At a given index, 'true' indicates the parameter at that index will be replaced,
        %                 and 'false' indicates otherwise.
        %
        % (OUT) "beta": Vector containing the newly replaced parameters
        %
            beta = beta0;
            for i = 1:numel(beta)
                if isFixed(i)
                    beta(i) = betaFixed(i);
                end
            end
        end
        
        function [beta0] = spc_single_exp_initial_params(beta_in, y)
        %% --------------------------------------------------------------------------------------------------------
        % 'spc_single_exp_initial_params' Method
        %
        % Generates the initial parameters for a single exponential fit under 'spc' rules
        %
        % (IN) "beta_in": Vector containing the 6 parameters (pop1, tau1, pop2, tau2, tau_d, tau_g) that are the basis for the generated parameters
        %
        % (IN) "y": Vector representing the dependent variable that will be fit to
        %
        % (OUT) "beta0": Vector containing the generated initial parameters
        %
            [pop1, tau1, pop2, tau2, tau_d, tau_g] = spc_unpackParams(beta_in);
            
            tau1 = spc_nanoseconds(tau1);
            tau_d = spc_nanoseconds(tau_d);
            tau_g = spc_nanoseconds(tau_g);
            
            if pop1 <= 100 || tau1 <= spc_nanoseconds(0.5) || tau1 >= spc_nanoseconds(5)
                pop1 = max(y);
                tau1 = sum(y) / pop1;
            end
            
            if tau_d <= spc_nanoseconds(0) || tau_d >= spc_nanoseconds(6)
                tau_d = spc_nanoseconds(2);
            end
            
            if tau_g <= spc_nanoseconds(0.05) || tau_g >= spc_nanoseconds(1)
                tau_g = spc_nanoseconds(0.15);
            end
            
            beta0 = spc_packParams(pop1, tau1, pop2, tau2, tau_d, tau_g);
        end
        
        function [beta0] = spc_double_exp_initial_params(beta_in, y)
            [pop1, tau1, pop2, tau2, tau_d, tau_g] = spc_unpackParams(beta_in);
            
            tau1 = spc_nanoseconds(tau1);
            tau2 = spc_nanoseconds(tau2);
            tau_d = spc_nanoseconds(tau_d);
            tau_g = spc_nanoseconds(tau_g);
            
            if pop1 <= 10 || tau1 <= spc_nanoseconds(0.1) || tau1 >= spc_nanoseconds(10)
                yMax = max(y);
                ySum = sum(y) / yMax;
                
                pop1 = yMax / 2;
                pop2 = yMax / 2;
                tau1 = ySum * 1.2;
                tau2 = ySum * 0.3;
            end
            
            if pop2 <= 10 || tau2 <= spc_nanoseconds(0.1) || tau2 >= spc_nanoseconds(10)
                pop1 = pop1 * 0.4;
                pop2 = pop1 * 0.4;
                tau1 = tau1 * 1.2;
                tau2 = tau1 * 0.4; 
            end
            
            if tau_d <= spc_nanoseconds(0) || tau_d >= spc_nanoseconds(6)
                tau_d = spc_nanoseconds(1);
            end
            
            if tau_g <= spc_nanoseconds(0.02) || tau_g > spc_nanoseconds(0.5)
                tau_g = spc_nanoseconds(0.11);
            end
            
            beta0 = spc_packParams(pop1, tau1, pop2, tau2, tau_d, tau_g);
        end
        
        function [beta0] = flimage_single_exp_initial_params(x, y)            
            [maxY, i] = max(y);
            maxX = x(i);
            sumY = sum(y);
            
            tau0 = sumY / maxY;
            tauG = spc_nanoseconds(0.1);
            
            pop1 = maxY * (1 + tauG / tau0);
            tau1 = 1 / tau0;
            tau_d = maxX - 2 * tauG;
            tau_g = tauG;
            
            beta0 = spc_packParams(pop1, tau1, 0, 0, tau_d, tau_g);
        end
        
        function [beta0] = flimage_double_exp_initial_params(x, y)
            [maxY, i] = max(y);
            maxX = x(i);
            sumY = sum(y);
            
            tau0 = sumY / maxY;
            tauG = spc_nanoseconds(0.1);
            
            pop1 = maxY / 2;
            tau1 = 1 / tau0 / 2;
            pop2 = maxY / 2;
            tau2 = 1 / tau0 / 0.5;
            tau_d = maxX - 1 * tauG;
            tau_g = tauG;
            
            beta0 = spc_packParams(pop1, tau1, pop2, tau2, tau_d, tau_g);
        end
                
        function [y] = spc_single_exp(beta, x)
            global spc gui;
            bg = str2double(get(gui.spc.spc_main.beta7, 'string'));
            
            
            [pop, tau, ~, ~, tau_d, tau_g] = spc_unpackParams(beta);
            
            y1 = pop*exp(tau_g^2/2/tau^2 - (x-tau_d)/tau);
            y2 = erfc((tau_g^2-tau*(x-tau_d))/(sqrt(2)*tau*tau_g));
            y=y1.*y2 / 2;
            
            
            pulseI =spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;
            pre_y1 = pop*exp(tau_g^2/2/tau^2 - (x-tau_d+pulseI)/tau);
            pre_y2 = erfc((tau_g^2-tau*(x-tau_d+pulseI))/(sqrt(2)*tau*tau_g));
            pre_y = pre_y1.*pre_y2;
            
            y = (y + pre_y)/2 + bg;
        end
        
        function [y] = spc_double_exp(beta, x)
            global spc;
            
            [pop1, tau1, pop2, tau2, tau_d, tau_g] = spc_unpackParams(beta);
            
            y1 = pop1 * exp(tau_g^2/2/tau1^2 - (x-tau_d)/tau1);
            y2 = erfc((tau_g^2-tau1*(x-tau_d))/(sqrt(2)*tau1*tau_g));
            ya = y1.*y2 / 2;

            y1 = pop2*exp(tau_g^2/2/tau2^2 - (x-tau_d)/tau2);
            y2 = erfc((tau_g^2-tau2*(x-tau_d))/(sqrt(2)*tau2*tau_g));
            yb = y1.*y2 / 2;
            
            pulseI = spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;
            pre_y1 = pop1*exp(tau_g^2/2/tau1^2 - (x-tau_d+pulseI)/tau1);
            pre_y2 = erfc((tau_g^2-tau1*(x-tau_d+pulseI))/(sqrt(2)*tau1*tau_g));
            pre_y = pre_y1.*pre_y2;
            
            y=(ya + yb + pre_y)/2;
        end
                
        function [y] = flimage_single_exp(beta, x)
            global spc;
            
            [pop, tau, ~, ~, tau_d, tau_g] = spc_unpackParams(beta);
            
            y1 = pop * exp(tau_g^2 * tau^2 / 2 - (x - tau_d) * tau);
            y2 = erfc((tau_g^2 * tau - (x - tau_d)) / (sqrt(2) * tau_g));
            y = y1.*y2 / 2;
            
            pulseI = spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;
            pre_y1 = pop*exp(tau_g^2 * tau^2 / 2- (x-tau_d+pulseI)*tau);
            pre_y2 = erfc((tau_g^2* tau - (x-tau_d+pulseI))/(sqrt(2) * tau_g));
            pre_y = pre_y1.*pre_y2;
           
            y = (y + pre_y)/2;
        end
        
        function [y] = flimage_double_exp(beta, x)
            global spc;
            
            [pop1, tau1, pop2, tau2, tau_d, tau_g] = spc_unpackParams(beta);
            
            y1 = pop1 * exp(tau_g^2 * tau1^2 / 2 - (x - tau_d) * tau1);
            y2 = erfc((tau_g^2 * tau1 - (x - tau_d)) / (sqrt(2) * tau_g));
            ya = y1.*y2 / 2;
            
            y1 = pop2 * exp(tau_g^2 * tau2^2 / 2 - (x - tau_d) * tau2);
            y2 = erfc((tau_g^2 * tau2 - (x - tau_d)) / (sqrt(2) * tau_g));
            yb = y1.*y2 / 2;
            
            pulseI = spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;
            pre_y1 = pop1*exp(tau_g^2 * tau1^2 / 2 - (x-tau_d+pulseI)*tau1);
            pre_y2 = erfc((tau_g^2*tau1 - (x-tau_d+pulseI))/(sqrt(2) * tau_g));
            pre_y = pre_y1.*pre_y2;
            
            y = (ya + yb + pre_y);
        end
        
        function [betahat] = spc_fit_single_exp(beta0, x, y)
            % Old SPC Single Exponential
            weight = sqrt(y)/sqrt(max(y));
            weight(y < 1)= 1/sqrt(max(y));
            opts = statset('Display', 'iter');
            betahat = nlinfit(x, y, @Fitting.spc_single_exp, beta0, opts, 'Weights', weight);
        end
        
        function [betahat] = spc_fit_double_exp(beta0, x, y)
            % Old SPC Double Exponential
            weight = sqrt(y)/sqrt(max(y));
            weight(y < 1)= 1/sqrt(max(y));
            opts = statset('Display', 'iter');
            betahat = nlinfit(x, y, @Fitting.spc_double_exp, beta0, opts, 'Weights', weight);
        end
        
        function [betahat] = flimage_fit_single_exp(beta0, x, y)
            % New FLIMage Single Exponential
            weights = ones(size(y)) ./ sqrt(y);
            weights(isnan(weights) | isinf(weights)) = 1;
            opts = statset('Display', 'iter');
            betahat = nlinfit(x, y, @Fitting.flimage_single_exp, beta0, opts, 'Weights', weights);
        end
        
        function [betahat] = flimage_fit_double_exp(beta0, x, y)
            % New FLIMage Double Exponential
            weights = ones(size(y)) ./ sqrt(y);
            weights(isnan(weights) | isinf(weights)) = 1;
            opts = statset('Display', 'iter');
            betahat = nlinfit(x, y, @Fitting.flimage_double_exp, beta0, opts, 'Weights', weights);
        end
        
        function set_fit_warnings(mode)
            warning(mode, 'MATLAB:rankDeficientMatrix');
            warning(mode, 'stats:nlinfit:ModelConstantWRTParam');
            warning(mode, 'stats:nlinfit:IterationLimitExceeded');
        end
        
        function [betahat, curve] = fit(beta_in, isFixed, x, y, mode)
            if strcmp(mode, 'spc_single')
                beta0 = Fitting.spc_single_exp_initial_params(beta_in, y);
                beta0 = Fitting.fix_params(beta0, beta_in, isFixed);
                fittingMethod = @Fitting.spc_fit_single_exp;
                fittingModel = @Fitting.spc_single_exp;
            elseif strcmp(mode, 'spc_double')
                beta0 = Fitting.spc_double_exp_initial_params(beta_in, y);
                beta0 = Fitting.fix_params(beta0, beta_in, isFixed);
                fittingMethod = @Fitting.spc_fit_double_exp;
                fittingModel = @Fitting.spc_double_exp;
            elseif strcmp(mode, 'flimage_single')
                beta_in = Fitting.convert_params(beta_in, 'spc2flimage');
                beta0 = Fitting.flimage_single_exp_initial_params(x, y);
                beta0 = Fitting.fix_params(beta0, beta_in, isFixed);
                fittingMethod = @Fitting.flimage_fit_single_exp;
                fittingModel = @Fitting.flimage_single_exp;
            elseif strcmp(mode, 'flimage_double')
                beta_in = Fitting.convert_params(beta_in, 'spc2flimage');
                beta0 = Fitting.flimage_double_exp_initial_params(x, y);
                beta0 = Fitting.fix_params(beta0, beta_in, isFixed);
                fittingMethod = @Fitting.flimage_fit_double_exp;
                fittingModel = @Fitting.flimage_double_exp;
            end
            
            Fitting.set_fit_warnings('off');            
            betahat = fittingMethod(beta0, x, y);
            Fitting.set_fit_warnings('on');
            
            betahat = Fitting.fix_params(betahat, beta_in, isFixed);
            curve = fittingModel(betahat, x);
            
            if strcmp(mode, 'flimage_single') || strcmp(mode, 'flimage_double')
                betahat = Fitting.convert_params(betahat, 'flimage2spc');
            else
                betahat = spc_picoseconds(betahat);
                betahat = Fitting.fix_params(betahat, beta_in, isFixed);
            end
        end
        
        
    end
end