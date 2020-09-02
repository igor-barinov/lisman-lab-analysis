% 'is_avg_old_file' Function
%   Checks if an input struct follows the 'avg_old_file' struct format
%
% INPUTS
% ------
% <fileStruct>, struct: Struct to be checked
%
% OUTPUTS
% -------
% <tf>, logical: True if <fileStruct> has the following format: (False otherwise)
%                <fileStruct>
%                   -> <averages>
%                       -> <tauAvg>
%                       -> <tauSte>
%                       -> <tauNormAvg>
%                       -> <tauNormSte>
%                       -> <intAvg>
%                       -> <intSte>
%                       -> <intNormAvg>
%                       -> <intNormSte>
%                       -> <redAvg>
%                       -> <redSte>
%                       -> <redNormAvg>
%                       -> <redNormSte>
%                   -> <time>
%                   -> <dnaType>
%                   -> <fileName>
%                   -> <filePath>
%                   -> <numBase>
%                   -> <numROI>
%                   -> <solBase>
%                   -> <solutions>
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <fileStruct> was not given
%
function [tf] = is_avg_old_file(fileStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input struct has averages
    if ~isfield(fileStruct, 'averages')
        tf = false;
        return;
    end
    avgStruct = fileStruct.averages;
    
    %% Check if input struct has 'lifetime' averages
    if ~isfield(avgStruct, 'tauAvg') || ~isfield(avgStruct, 'tauSte') || ...
        ~isfield(avgStruct, 'tauNormAvg') || ~isfield(avgStruct, 'tauNormSte')
        tf = false;
        return;
    end
    %% Check if input struct has 'int' averages
    if ~isfield(avgStruct, 'intAvg') || ~isfield(avgStruct, 'intSte') || ...
        ~isfield(avgStruct, 'intNormAvg') || ~isfield(avgStruct, 'intNormSte')
        tf = false;
        return;
    end
    
    %% Check if input struct has 'red' averages
    if ~isfield(avgStruct, 'redAvg') || ~isfield(avgStruct, 'redSte') || ...
        ~isfield(avgStruct, 'redNormAvg') || ~isfield(avgStruct, 'redNormSte')
        tf = false;
        return;
    end
    
    
    %% Check if input struct has 'time' data
    if ~isfield(fileStruct, 'time')
        tf = false;
        return;
    end
    
    %% Check if input struct has info fields
    if  ~isfield(fileStruct, 'dnaType') || ...
        ~isfield(fileStruct, 'fileName') || ...
        ~isfield(fileStruct, 'filePath') || ...
        ~isfield(fileStruct, 'numBase') || ...
        ~isfield(fileStruct, 'numROI') || ...
        ~isfield(fileStruct, 'solBase') || ...
        ~isfield(fileStruct, 'solutions')
        tf = false;
        return;
    end
    
    tf = true;
end