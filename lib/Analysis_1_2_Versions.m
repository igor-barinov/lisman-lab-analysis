classdef Analysis_1_2_Versions
    properties (Constant) % Since MATLAB does not support string enums
        v070119 = 'analysis_1_2_070119';
        v071519 = 'analysis_1_2_071510';
        v072219 = 'analysis_1_2_072219';
        v011820 = 'analysis_1_2_011820';
        v012220 = 'analysis_1_2_012220';
        v052520 = 'analysis_1_2_052520';
        v061020 = 'analysis_1_2_061020';
        v061220 = 'analysis_1_2_061220';
        v062320 = 'analysis_1_2_062320';
        v080420 = 'analysis_1_2_080420';
        v081420 = 'analysis_1_2_081420';
    end
    
    methods (Static)
        function [version] = release()
            version = Analysis_1_2_Versions.v081420;
        end
    end
end