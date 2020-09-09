function [tf] = file_type_is(input, varargin)
    %% Check if at least 2 inputs were given
    if nargin < 2
        throw(missing_inputs_error(nargin, 2));
    end

    typeCount = length(varargin);
    for i = 1:typeCount
        if strcmp(input, varargin{i})
            tf = true;
            return;
        end
    end
    
    tf = false;
end