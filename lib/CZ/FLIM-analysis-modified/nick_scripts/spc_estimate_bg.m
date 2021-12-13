function spc_estimate_bg
global gui spc
% spc_redrawSetting(1);

range = spc.fit(gui.spc.proChannel).range;
x = range(1):1:range(2);
lifetime = spc.lifetime(x);

       if ~str2double(get(gui.spc.spc_main.beta7, 'String'))==0
                 k=1;
       else
           k=0;
       end
   spc.fit(gui.spc.proChannel).background = (mean(lifetime(1:3))*k);%nicko
   set(gui.spc.spc_main.beta7, 'string', num2str(spc.fit(gui.spc.proChannel).background ));
  % bg_residual_max=[1,2,3];%nicko
% bg_residual_min=[1,2,3];
%   if ~isempty(bg_residual_max)==1
%    k=2;
%     if bg_residual_max (2)<bg_residual_max(1)
%         bg_residual_max (1)=bg_residual_max (2);
         
%         spc.fit(gui.spc.proChannel).background = sqrt(max(lifetime)*k);%nicko
%           spc.fit(gui.spc.proChannel).background = sqrt(sum(lifetime)*k);%nicko
% bgr=[];
%      bgr = str2num(get(gui.spc.spc_main.beta7, 'String'));


% spc_redrawSetting(1)