function [newExpInfo] = update_exp_info_struct(expInfoStruct, varargin)
    if nargin < 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    if ~is_exp_info_struct(expInfoStruct)
        throw(invalid_struct_error(expInfoStruct, exp_info_struct_format()));
    end
    
    try
        newExpInfo = expInfoStruct;
        dataCount = min([nargin - 1, 3]);

        changedNumROI = false;
        changedDNAType = false;
        changedSolutions = false;
        for i = 1:dataCount
            inputVal = varargin{i};
            if isnumeric(inputVal) && numel(inputVal) == 1 && ~changedNumROI            
                newExpInfo.numROI = inputVal;
                changedNumROI = true;
            elseif ischar(inputVal) && ~isempty(inputVal) && ~changedDNAType            
                newExpInfo.dnaType = inputVal;
                changedDNAType = true;
            elseif is_solution_info(inputVal) && ~changedSolutions
                newExpInfo.solutions = sort_solution_info(inputVal);
                changedSolutions = true;
            else
                throw(invalid_type_error({['arg ', num2str(i)]}, {'number, char, or n x 2 cell ([char, number])'}));
            end
        end
    catch err
        rethrow(err);
    end
end