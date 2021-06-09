classdef ROIFileType < uint8
%% ----------------------------------------------------------------------------------------------------------------
% 'ROIFileType' enumeration
%
% Enum describing different ROI file formats
%
    enumeration
        Raw         (1)
        FLImage     (2)
        Prepared    (3)
        Averaged    (4)
        None        (0)
    end
    
    methods (Static)
        %% --------------------------------------------------------------------------------------------------------
        % 'as_string' Method
        %
        % Converts a ROIFileType value to a string
        %
        % (IN) "type": ROIFileType to be converted
        %
        % (OUT) "str": string describing the current enumeration
        %
        function [str] = as_string(type)
            switch type
                case ROIFileType.Raw
                    str = 'Raw';
                case ROIFileType.FLImage
                    str = 'FLImage';
                case ROIFileType.Prepared
                    str = 'Prepared';
                case ROIFileType.Averaged
                    str = 'Averaged';
                case ROIFileType.None
                    str = 'None';
            end
        end
    end
end