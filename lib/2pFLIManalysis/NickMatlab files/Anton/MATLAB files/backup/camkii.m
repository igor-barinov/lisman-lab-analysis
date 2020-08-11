% simulation of camkii states and emission lifetime
% Honi Sanders 8/2014
% modified by Honi and Nick on 12.12.2004

%   these input values are linked to global input_list from
%   camkii_input.m, which are updated from gui - AZ
global input_list;
camkii_input; % run the gui and return preset or altered values

% initial values of fraction of camkii in each state
noCnoP = input_list(1);
yesCnoP = input_list(2);
noCyesP = input_list(3);
yesCyesP = input_list(4);
P305 = input_list(5);

% parameters
tau1 = input_list(6);   % time constant of calcium unbinding from unphosphorylated (sec)
tau2 = input_list(7);  % time constant of calcium unbinding from phosphorylated (sec)
% tau3 = 30 %input_list(8);  % time constant of unbound CaMKII dephosphorylation (sec)
% tau4 = 30 %input_list(9);  % time constant of bound CaMKII dephosphorylation (sec)
k = input_list(8);    % fraction of calcium bound camkii that autophosphorylates
beta = input_list(9); % fraction of unbound camkii that binds calcium on stim


%%

dt = 0.1;     % time step in seconds
tmax = 200; % end of experiment in seconds
ts = dt:dt:tmax;
t_stim = 60;
tau3 =100; % time constant of unbound CaMKII dephosphorylation (sec)
tau4 =100; % time constant of bound CaMKII dephosphorylation (sec)

F = nan(length(ts),5);  % fraction in each state (columns) at each time step (rows)
F_initial = [noCnoP, yesCnoP, yesCnoP, yesCyesP, P305];  % fraction in each state at beginning
F(1,:) = F_initial;
% F(1,:) = F(1,:)/sum(F(1,:)); %normalize

  
L = [1.7; 2.1; 1.9; 2.1; 1.7];   % Lifetime of: noCnoP(1), yesCnoP(2), yesCnoP(3), yesCyesP(4), P305(5)



stim_mat = [1-beta,     0, 0,      0, 0;
            (1-k)*beta, 0, 0,      0, 0;
            0,          0, 1-beta, 0, 0;
            k*beta,     0, beta,   0, 0;
            0,          0, 0,      0, 1]';  % how state occupancy changes upon stim


for i = 2:length(ts)
    
    if i == floor(t_stim/dt); % time for stim
        F(i,:) = F(i-1,:)*stim_mat;
    else
     F(i,:) = F(i-1,:);
    end
    if i > floor(t_stim/dt);
%          dF = [F(i-1,2)/tau1, -F(i-1,2)/tau1, F(i-1,4)/tau2, -F(i-1,4)/tau2, 0];
        dF = [F(i-1,2)/tau1 + F(i-1,3)/tau3, -F(i-1,2)/tau1+F(i-1,4)/tau4, ...
        F(i-1,4)/tau2-F(i-1,3)/tau3, -F(i-1,4)/tau2-F(i-1,4)/tau4, 0];  % change in each state at this time step
        F(i,:) = F(i-1,:) + dF*dt;
    end
end
% 

lifetime = F*L;
lifetimeNorm = lifetime - min(lifetime);
maxLT=max(lifetimeNorm);
lifetimeNorm = lifetimeNorm/maxLT;

figure(2)
subplot(3,1,1)  % top plot
plot(ts, lifetime)
hold on    % uncomment to keep graphs
% ylim([0, 1])   % limits of y axis on top graph
ylabel('Change in Lifetime')


subplot(3,1,2)  % middle plot
plot(ts, lifetimeNorm)
hold on    % uncomment to keep graphs
ylim([0, 1])   % limits of y axis on top graph
ylabel('Change in LifetimeNorm')

subplot(3,1,3)  % bottom plot
plot(ts,F)
%hold on    % uncomment to keep graphs
xlabel('Time (s)')
ylabel('Fraction in each state')
legend('noCnoP', 'yesCnoP', 'noCyesP', 'yesCyesP','P305')
% type "clf" into main matlab window to clear the graph
