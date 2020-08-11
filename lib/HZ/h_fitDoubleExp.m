function Aout = h_fitDoubleExp(x,y,a,b,c,t1,t2,fig_on)


% function Aout = h_fitDoubleExp(x,y,a,b,c,t1,t2)


%%%%%%%%%%%%%%%  Initialization  %%%%%%%%%%%%%%%%%%
x1 = x(1);
x = x - x1;

x = x(:);
y = y(:);

if ~(exist('a')==1)|isempty(a)
    a = 0.5*(y(1)-y(end));
end

if ~(exist('b')==1)|isempty(b)
    b = 0.5*(y(1)-y(end));
end

if ~(exist('c')==1)|isempty(c)
    c = y(end);
end

if ~(exist('t1')==1)|isempty(t1)
    t1 = 0.5*sum(((y-y(end)).*vertcat(diff(x),x(end)-x(end-1))))/(a+b);
end

if ~(exist('t2')==1)|isempty(t2)
    t2 = 2*sum(((y-y(end)).*vertcat(diff(x),x(end)-x(end-1))))/(a+b);
end

if ~(exist('fig_on')==1)|isempty(fig_on)
    fig_on = 1;
end

beta0 = [a,t1,b,t2,c];

[beta,R,J, converge] = h_nlinfit(x,y,@double_exp,beta0);

Aout.method = 'y = a*exp(-x/t1) + b*exp(-x/t2) + c';
Aout.x = [1:1000] * max(x) / 1000; 
Aout.y = double_exp(beta, Aout.x);
Aout.a = beta(1);
Aout.b = beta(3);
Aout.c = beta(5);
Aout.t1 = beta(2);
Aout.t2 = beta(4);
Aout.x = Aout.x + x1;
Aout.text = ['y = ',num2str(Aout.a),'*exp(-x/',num2str(Aout.t1),') + ',...
    num2str(Aout.b),'*exp(-x/',num2str(Aout.t2),') + ',num2str(Aout.c)];
Aout.converge = converge;

if fig_on
    figure,plot(x+x1,y,'o',Aout.x,Aout.y,'-')
    title(Aout.text);
end