% simulation of camkii states and emission lifetime
% Honi Sanders 8/2014

% initial values of fraction of camkii in each state
noCnoP = 0.9;
yesCnoP = 0;
noCyesP = 0;
yesCyesP = 0;
P305 = 0;

% parameters
tau1 = 8;   % time constant of calcium unbinding from unphosphorylated (sec)
tau2 = 20;  % time constant of calcium unbinding from phosphorylated (sec)
k = 0.3;    % fraction of calcium bound camkii that autophosphorylates
beta = 0.25; % fraction of unbound camkii that binds calcium on stim


%%

dt = 0.1;     % time step in seconds
tmax = 170; % end of experiment in seconds
ts = dt:dt:tmax;
t_stim = 20;

F = nan(length(ts),5);  % fraction in each state (columns) at each time step (rows)
F_initial = [noCnoP, yesCnoP, noCyesP, yesCyesP, P305];  % fraction in each state at beginning
F(1,:) = F_initial;
F(1,:) = F(1,:)/sum(F(1,:)); %normalize

  
L = [1.7; 2.1; 1.9; 2.1; 1.7];   % Lifetime of u, c1, 2, c2, 3



stim_mat = [1-beta,     0, 0,      0, 0;
            (1-k)*beta, 0, 0,      0, 0;
            0,          0, 1-beta, 0, 0;
            k*beta,     0, beta,   0, 0;
            0,          0, 0,      0, 1]';  % how state occupancy changes upon stim


for i = 2:length(ts)
    if i == floor(t_stim/dt) % time for stim
        F(i,:) = F(i-1,:)*stim_mat;
    else
        dF = [F(i-1,2)/tau1, -F(i-1,2)/tau1, F(i-1,4)/tau2, -F(i-1,4)/tau2, 0];
        F(i,:) = F(i-1,:) + dF*dt;
    end
end

lifetime = F*L;
lifetime = lifetime - min(lifetime);


figure(2)
subplot(2,1,1)  % top plot
plot(ts, lifetime)
hold on    % uncomment to keep graphs
%ylim([0 0.4])   % limits of y axis on top graph
ylabel('Change in Lifetime')


subplot(2,1,2)  % bottom plot
plot(ts,F)
%hold on    % uncomment to keep graphs
xlabel('Time (s)')
ylabel('Fraction in each state')
legend('noCnoP', 'yesCnoP', 'noCyesP', 'yesCyesP','P305')

% type "clf" into main matlab window to clear the graph
