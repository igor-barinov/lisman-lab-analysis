function [pop1, tau1, pop2, tau2, tau_d, tau_g, bg] = spc_unpackParams(beta)
    if nargin < 1
        error('Could not unpack parameters: no input was given');
    end

    if ~isnumeric(beta)
        error('Could not unpack parameters: ''beta'' is not numeric');
    end

    if numel(beta) < 6
        error('Could not unpack parameters: ''beta'' had %d values, expected 6.', numel(beta));
    elseif numel(beta) > 7
        warning('Unpacking only 7 parameters, but ''beta'' has %d values', numel(beta));
    end


    pop1 = beta(1);
    tau1 = beta(2);
    pop2 = beta(3);
    tau2 = beta(4);
    tau_d = beta(5);
    tau_g = beta(6);
    
    if numel(beta) > 6
        bg = beta(7);
    end
end