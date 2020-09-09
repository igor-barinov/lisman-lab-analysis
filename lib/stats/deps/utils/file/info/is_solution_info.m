function [tf] = is_solution_info(input)
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    if ~iscell(input) || isempty(input) || size(input, 2) ~= 2
        tf = false;
        return;
    end
    
    for r = 1:size(input, 1)
        if ~ischar(input{r, 1}) || ~isnumeric(input{r, 2}) || numel(input{r, 2}) ~= 1
            tf = false;
            return;
        end
    end
    
    tf = true;
end