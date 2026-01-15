% Setup block with table of parameters and initial conditiosn
% Function to solve a given Table entry for the policy function, without
% initial K0 conditions? Use k = (0,10) as a wide range of options
% There are several functions here:
% - ODE method
% - Value function iteration
% - Linearization

% Function to take a given policy function and calculate the time paths
% given some initial K0 conditions? Need to know how to match actual
% changes to policy functions
% Function to take a given policy function/Table entry and calculate the
% BGP for a time path?

%% Setup block

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare Ramsey economies with shocks and diff parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

t = 50; % time periods to simulate for all economies
N = 3; % how many economies to plot (may not always want all three)

% Parameters and starting values for economies
T = table;
T.label = ['A'; 'B'; 'C'];
T.sigma = [1.1; 2;   8];
T.theta = [.08; .08; .08]; % placeholder - see below
T.noise = [  0;  0;   0]; % kludge for uncertainty
T.epK   = [ .4;  .4;  .4];
T.delta = [.05; .05; .05];
T.gL    = [.01; 0.01; 0.01];
T.gA    = [.01; 0.01; .01];
T.A0    = [  1;   1;  1];
T.L0    = [  1;   1;  1];
T.period= [  t;   t;   t];

% Calculate ss values to help set initial conditions
T.kyss  = T.epK./(T.theta + T.delta + T.sigma.*T.gA - T.noise); % ss K/Y ratio
T.power = ones(3,1)./(ones(3,1)-T.epK); % for calculation
T.khatss= T.kyss.^T.power; % ss K/AL ratio
T.rss   = T.epK.*T.kyss.^(-1) - T.delta; % ss return

% Set/replace initial conditions to hit certain marks
T.K0    = [T.khatss(1)*.8;   T.khatss(1)*.8;   T.khatss(1)*.8]; % start at same K value on BGP
T.theta = [T.theta(1);    T.rss(1) - T.sigma(2)*T.gA(2); T.rss(1) - T.sigma(3)*T.gA(3)]; % hit same rss

%% Processing block

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate everything about a Ramsey path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R,BGP] = Ramsey(T) % declaration of function
    ky_ss = T.epK/(T.theta + T.delta + T.sigma*T.gA - T.noise); % capital/output ss
        % Can add in gL to kySS if you want
    yk_ss = 1/ky_ss; % just for ease later
    sI_ss = ky_ss*(T.delta + T.gA + T.gL); % savings rate ss
    r_ss = T.epK*yk_ss - T.delta; % rate of return steady state
    t = 0:T.period; % list of time periods
    lnA = log(T.A0) + T.gA*t; % log A for all periods
    lnyBGP = (T.epK/(1-T.epK))*log(ky_ss) + lnA; % BGP of GDP per capita
    lncBGP = log(1-sI_ss) + lnyBGP; % BGP of consumption
    sIBGP = ones(1,length(t))*sI_ss; % BGP of savings rate
    rBGP = ones(1,length(t))*r_ss; % BGP of rate of return

    % Set up transition matrix Z and get eigenvalues/vectors
    Z = [(T.epK-sI_ss)*yk_ss, -1; ((T.epK*(T.epK-1)/T.sigma)*(1-sI_ss))*yk_ss^2, 0];
    [V,D] = eig(Z); % eigenvalues/vectors of the transition matrix
    lambda = D(2,2); % convergence speed - the negative eigenvalue
    cweight = V(2,2)/V(1,2); % consumption weight
    
    % Solve for K/AL and C/AL terms used in linearization
    khat_0 = T.K0/(T.A0*T.L0);
    khat_ss = ky_ss.^(1/(1-T.epK));
    chat_ss = (1 - sI_ss)*khat_ss^T.epK; % chat = C/AL
    khat_t = khat_ss + (khat_0 - khat_ss)*exp(lambda*t);
    chat_t = chat_ss + cweight*(khat_0 - khat_ss)*exp(lambda*t);
    ky_initial = linspace(.75*ky_ss,1.25*ky_ss,length(t));
    gkyinit = lambda*(log(ky_initial) - log(ky_ss));
    cy_init = 1 - ((gkyinit./(1-T.epK)) + (T.gL + T.gA + T.delta)).*ky_initial;

    % Convert back to normal per capita terms
    lny = T.epK*log(khat_t) + lnA;
    lnc = log(chat_t) + lnA;
    sI = 1 - exp(lnc - lny);
    cy = 1 - sI;
    r = T.epK*khat_t.^(T.epK - 1) - T.delta;
    ky = khat_t.^(1-T.epK);
    gky = lambda*(log(ky) - log(ky_ss));
    
    % Stack everything into single matrix to return
    R = [lny; lnc; sI; r; khat_t; gky; ky; cy];
    BGP = [lnyBGP; lncBGP; sIBGP; rBGP; khat_ss*ones(1,length(t)); gkyinit; ky_initial; cy_init];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up and solve for individual scenarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index = 1; % for building panels in matrix

for row = 1:N % for each economy
    [Econ(:,:,index),Econ(:,:,index+1)] = Ramsey(T(row,:)); % call the Ramsey function
    index = index + 2; % indexing for results table
end

%% Plotting block

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot figures for all three
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Econ = permute(Econ,[3,2,1]); % transpose stack to extract data
gy = [diff(Econ(:,:,1),1,2)]; % calculate growth rate of GDP per capita
gc = [diff(Econ(:,:,2),1,2)]; % calculate growth rate of GDP per capita
t = 1:length(Econ(1,:,1)); % build time periods to match

clf; % clear figures
linestyles = ["-o","--","-o","--","-o","--","-o","--"]; % set pattern for lines
colors = ["#003f5c","#003f5c","#bc5090","#bc5090","#ffa600","#ffa600"]; % set colors

figure(1)
colororder(colors);
linestyleorder(linestyles);
plot(t,Econ(:,:,1),'LineWidth', 2);
axis padded;
legend({'A','BGP A ','B','BGP B','C','C BGP'},'Location','northeast','Orientation','horizontal')
xlabel('Time period')
ylabel('Log output per capita')
 
figure(2)
colororder(colors);
linestyleorder(linestyles);
plot(t(1:length(t)-1),gy,'LineWidth', 2); % growth rate has t-1 dimensions
axis padded;
xlabel('Time period')
ylabel('Growth rate of output per capita')
legend({'A','BGP A ','B','BGP B','C','C BGP'},'Location','northeast','Orientation','horizontal')

figure(3)
colororder(colors);
linestyleorder(linestyles);
plot(t,Econ(:,:,2),'LineWidth', 2);
xlabel('Time period')
ylabel('Log consumption per capita')
legend({'A','BGP A ','B','BGP B','C','C BGP'},'Location','northeast','Orientation','horizontal')

figure(4)
colororder(colors);
linestyleorder(linestyles);
plot(t(1:length(t)-1),gc,'LineWidth', 2); % growth rate has t-1 dimensions
axis padded;
xlabel('Time period')
ylabel('Growth rate of consumption per capita')
legend({'A','BGP A ','B','BGP B','C','C BGP'},'Location','northeast','Orientation','horizontal')
 

figure(5)
colororder(colors);
linestyleorder(linestyles);
plot(t,Econ(:,:,3),'LineWidth', 2);
axis padded;
xlabel('Time period')
ylabel('Savings rate')
legend({'A','BGP A ','B','BGP B','C','C BGP'},'Location','northeast','Orientation','horizontal')

figure(6)
colororder(colors);
linestyleorder(linestyles);
plot(t,Econ(:,:,4),'LineWidth', 2);
axis padded;
xlabel('Time period')
ylabel('Rate of return')
legend({'A','BGP A ','B','BGP B','C','C BGP'},'Location','northeast','Orientation','horizontal')

figure(7)
colororder(colors);
linestyleorder(linestyles);
hold on;
for i = 1:height(Econ)
    plot(Econ(i,:,7),Econ(i,:,6),'LineWidth', 2);
end
yline(0,'--','Color','black');
axis padded;
xlabel('K/Y ratio')
ylabel('gKY')
legend({'Actual A','Path A ','Actual B','Path B','Actual C','Path C'},'Location','northeast','Orientation','horizontal')
hold off;

