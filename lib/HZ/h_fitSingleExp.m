function Aout = h_fitSingleExp(x,y,a,b,t, fig_on)


% Aout = h_fitSingleExp(x,y,a,b,t)
% Default initial value: a = 1, b = 0, t = 2


%%%%%%%%%%%%%%%  Initialization  %%%%%%%%%%%%%%%%%%
x1 = x(1);
x = x - x1;

x = x(:);
y = y(:);

if ~(exist('a')==1)|isempty(a)
    a = y(1)-y(end);
end

if ~(exist('b')==1)|isempty(b)
    b = y(end);
end

if ~(exist('t')==1)|isempty(t)
    t = abs(sum(((y-y(end)).*vertcat(diff(x),x(end)-x(end-1))))/a);
end

if ~(exist('fig_on')==1)|isempty(fig_on)
    fig_on = 1;
end

beta0 = [a,t,b];

[beta,R,J,converge] = h_nlinfit(x,y,@single_exp,beta0);

Aout.method = 'y = a*exp(-(x-x1)/t) + b';
Aout.x = [0:1000] * max(x) / 1000; 
Aout.y = single_exp(beta, Aout.x);
Aout.a = beta(1);
Aout.b = beta(3);
Aout.t = beta(2);
Aout.x = Aout.x + x1;
Aout.text = ['y = ',num2str(Aout.a),'*exp(-(x-',num2str(x1),')/',num2str(Aout.t),') + ',num2str(Aout.b)];
Aout.converge = converge;

if fig_on
    figure,plot(x+x1,y,'o',Aout.x,Aout.y,'-')
    title(Aout.text);
end
