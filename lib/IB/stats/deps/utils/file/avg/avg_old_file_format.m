% 'avg_old_file_format' Function
%   Returns the names of fields in an 'avg_old_file' struct
%
% NO INPUTS
%
% OUTPUTS
% -------
% <fields>, cell: Will contain the names of each field. 
%                 Sub fields are displayed in the same string
%                 as the parent field: 'parent- > {sub1, ...}'
%
function [fields] = avg_old_file_format()
    fields = {'time', 'dnaType', 'fileName', 'filePath', 'numBase', 'numROI', 'solBase', 'solutions', ...
        'averages -> {tauAvg, tauSte, tauNormAvg, tauNormSte, intAvg, intSte, intNormAvg, intNormSte, redAvg, redSte, redNormAvg, redNormSte}'};
end