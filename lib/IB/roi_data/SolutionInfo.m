classdef (Abstract) SolutionInfo
    methods (Abstract)
        [tf] = has_number_of_baseline_pts(obj);
        [count] = number_of_baseline_pts(obj);
        [newObj] = set_baseline_solution(obj);
        [newObj] = add_solution(obj);
        [newObj] = remove_solution(obj, solutionIndex);
        [newObj] = append_solution_info(obj);
        [objs] = split_solution_info(obj);
        
        [newObj] = horzcat(varargin);
        [newObj] = vertcat(varargin);
    end
end