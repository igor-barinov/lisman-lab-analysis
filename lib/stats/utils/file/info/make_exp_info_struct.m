function [expInfo] = make_exp_info_struct(numROI, dnaType, solutions)
    expInfo = struct;
    expInfo.numROI = 0;
    expInfo.dnaType = '';
    expInfo.solutions = {};
        
    if nargin > 0
        if ~isnumeric(numROI) || isnan(numROI)
            throw(invalid_type_error({'numROI'}, {'number'}));
        end
        expInfo.numROI = numROI;
    end
    if nargin > 1
        if ~ischar(dnaType)
            throw(invalid_type_error({'dnaType'}, {'char'}));
        end
        expInfo.dnaType = dnaType;
    end
    if nargin > 2
        if ~is_solution_info(solutions)
            throw(invalid_type_error({'solutions'}, {'n x 2 cell: [char, number]'}));
        end
        expInfo.solutions = solutions;
    end
end