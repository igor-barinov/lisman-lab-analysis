classdef MLE
    methods (Static)
        function [p] = poisson(x, y, modelfunc)
            lambda = modelfunc(x);
            p = poisspdf(y, lambda);
        end
        
        function mle(
    end
end