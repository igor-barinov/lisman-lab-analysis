classdef Analysis_1_2_Versions
    properties (Constant) % Since MATLAB does not support string enums
        v070119 = 'analysis_1_2_IB_070119';
        v071519 = 'analysis_1_2_IB_071510';
        v072219 = 'analysis_1_2_IB_072219';
        v011820 = 'analysis_1_2_IB_011820';
        v012220 = 'analysis_1_2_IB_012220';
        v052520 = 'analysis_1_2_IB_052520';
        v061020 = 'analysis_1_2_IB_061020';
        v061220 = 'analysis_1_2_IB_061220';
        v062320 = 'analysis_1_2_IB_062320';
        v080420 = 'analysis_1_2_IB_080420';
        v081420 = 'analysis_1_2_IB_081420';
        v090920 = 'analysis_1_2_IB_090920';
        v031221 = 'analysis_1_2_IB_031221';
        v061521 = 'analysis_1_2_IB_061521';
        v070721 = 'analysis_1_2_IB_070721';
        v100921 = 'analysis_1_2_IB_100921';
    end
    
    methods (Static)
        function [version] = release()
            version = Analysis_1_2_Versions.v100921;
        end
    end
end