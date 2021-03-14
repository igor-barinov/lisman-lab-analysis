classdef Stats_IB_Versions
    properties (Constant)
        v031920 = 'stats_IB_031920';
        v052220 = 'stats_IB_052220';
        v061020 = 'stats_IB_061020';
        v080420 = 'stats_IB_080420';
    end
    
    methods (Static)
        function [version] = release()
            version = Stats_IB_Versions.v080420;
        end
    end
end
