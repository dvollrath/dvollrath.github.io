%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Value function iteration for basic Ramsey model with non-stochastic
% productivity growth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ;% this clears variables from the workspace
clf; % this clears the figures

doplot=1; % just allows us to turn on/off plotting
Max = 750; % maximum number of iterations to run, if we haven't converged by this point, stop processing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functional forms and parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the model is the simple growth model  
% preferences: u(c)=c to the power of (1-sigma) over (1-sigma)
% beta is the discount factor
% delta is the rate of capital depreciation
% the production function is: k to the power of alpha

sigma=1; % CRRA coefficient
beta=.98; % patience parameter
alpha=.36; % elasticity of output wrt capital
delta=0.1; % depreciation

% We can immediately solve for the steady state capital stock
Kstar=(((1/(alpha*beta))-((1-delta)/alpha)))^(1/(alpha-1));

% Productivity process parameters lnAt = rho*lnAt-1 + epsilon
rho = .7; % AR(1) persistence parameter
sigmae = .1; % SD of shock to productivity
p = (1+rho)/2; % Markov transition probability
Q = [p 1-p ; 1-p p]; % Markov transition matrix
shock = sqrt(sigmae^2/(1-rho^2)); % productivity shock size
lnA = [-shock shock]; % vector of log productivity draws possible
A = exp(lnA); % vector of level productivity draws possible

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computational parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=1000; % number of points of the discretized values of capital

% We will be calculating the value function over a given range of capital
% values that bound Kstar
Klo = 0.01*Kstar; % set the minimum value of the discretized values of capital
Khi = 1.5*Kstar; % set the maximum value of the discretized values of capital
step = (Khi - Klo)/N; % set the step size of capital between discrete values

K = Klo:step:Khi; % this builds K, the set of possible values that capital can take
K1=K; % copy of the set of values 
n=length(K); % number of possible values of K (will be N+1)

toler=.0001; % tolerance for convergence - if successive value functions differ by less than this, we're done

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Value functions and value function iteration
% This does the actual work
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=zeros(2,n); % We set the initial value function to 0 for all values of K and productivity,
    % note how this is two rows, one for each possible value of A
    % V here doesn't tell us what to do, it tells us the value of having
    % capital equal to any given amount, given the value of productivity
NewV=zeros(2,n); % Set up NewV, the updated value function, with starting values to initialize
Policy=zeros(2,n); % The policy function is what to DO given the amount of capital, initialize to zero as well

tic % this keeps track of time elapsed
for j=1:Max % for up to the max number of iterations
    for i=1:n % for each possible value of K you could *start* with
        for s=1:2 % for the two possible values of productivity you could *start* with
            C=ones(n,1).*(A(s)*K(i)^alpha+(1-delta)*K(i))-K1'; % consumption given the same starting K(i) and A(s)
                %, choosing different values of K for the future (K1). This calculates C for all possible choices of K1 
            % Compute utility of C for all possible choices of K1
            if sigma == 1 % if log utility
                U = log(C); % element-wise log
            else % else find the element wise utility of each consumption outcome
                U = C.^(1-sigma)./(1-sigma); 
            end
            negc=find(C<0); % find location of choices of K1 which make C negative
            U(negc)=-1e50; % set utility for negative C to really low number (replaces missing from log)
            r=U+beta*V'*Q(s,:)'; % 'value of all possible choices of K1, given the Expected V in the future
                % expected V in future is weighted by Q probabilities of being in diff productivity states 
            [value,index]=max(r); % of all possible values from above, find the one yielding the highest value
            NewV(s,i)=value; % the value of the the best possible choice becomes the value for the starting K(iter)
            Policy(s,i)=K1(index); % the choice of K1 the corresponds to the best possible choice is the policy for K(iter)
        end;
    end;
    
    diff=(V-NewV)./V; % get difference of value functions
    if abs(diff) <= toler % if ALL elements of diff are below the tolerance
        break % drop out, you're done, the NewV and old V are so close
    else
        V=NewV; % if not, then make V equal to the NewV and go back and try again
    end;
end; % end the for loop over total iterations

j % list the number of iterations
toc; % list the total time taken

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots of value function and policy function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if doplot==1
    % This plots the value function itself. This is the value from having a
    % given amount of K. 
    figure(1)
    plot(K,V)
    xlabel('Amount of capital at t')
    ylabel('Value v(kt)')
    legend('Value function')

    % This plots the policy function as well as 45 degree line
    figure(2)
    plot(K,Policy,K,K,'r:'); % plot Policy against K in black, plot K against K (45 deg) in red
    xlabel('Amount of capital in t')
    ylabel('Amount of capital in t+1')
    legend('Policy function with Alow','Policy function with Ahigh')

    % This plot shows net investment steady state
    figure(3)
    plot(K,Policy(1,:)-K,K,Policy(2,:)-K)
    xlabel('Amount of capital at t')
    ylabel('Net investment at t')
    legend('New investment with Alow', 'Net investment with Ahigh')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the policy function to plot path of consumption/capital
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = 100; % Time periods to plot over
Kactual = zeros(T,1); % vector holding capital values at each time period
Kactual(1,1) = 1; % set initial value of capital in time period 1
Cactual = zeros(T,1); % vector holding consumption values at each time period
Ractual = zeros(T,1); % vector holding marginal product of capital at each time period
Yactual = zeros(T,1); % vector holding output at each time period
Aactual = zeros(T,1); % vector holding productivity at each time period
time = 1:1:T+1; % vector holding time periods
s = 1; % start with low productivity

for t=1:T
    Kdiff = abs(K - Kactual(t,1)); % find abs value of differences of Kactual value from possible K values
    [Kclose,index]=min(Kdiff); % find location of minimum difference
    Kactual(t+1,1) = Policy(s,index); % Look up that location in policy function, which tells us next value of K to choose
    Cactual(t,1) = A(s)*Kactual(t,1)^alpha + (1-delta)*Kactual(t,1) - Kactual(t+1,1); % consumption 
    Ractual(t,1) = alpha*A(s)*Kactual(t,1)^(alpha-1); % marginal product of capital
    Yactual(t,1) = A(s)*Kactual(t,1)^alpha; % output
    Aactual(t,1) = A(s); % productivity
    draw = rand; % draw a random number from (0,1)
    if draw < Q(s,1) % if draw is less than prob of being in the low state, given s, then be in low state
        s=1; % set s=1, low state
    else % if draw is higher than prob of being in low state, given s, then be in high state
        s=2; % set s=2, high state
    end
end

if doplot==1
    % This plot capital stock over time
    figure(5)
    plot(time,log(Kactual))
    xlabel('Time period')
    ylabel('Capital stock')

    % This plots consumption over time
    figure(6)
    plot(time(1,1:T),log(Cactual))
    xlabel('Time period')
    ylabel('Consumption')    

    % This plots consumption over time
    figure(7)
    plot(time(1,1:T),Ractual)
    xlabel('Time period')
    ylabel('MPK')    
    
    % This plots log output over time
    figure(8)
    plot(time(1,1:T),log(Yactual))
    xlabel('Time period')
    ylabel('Log output') 
    
    % This plots log productivity over time
    figure(9)
    plot(time(1,1:T),log(Aactual))
    xlabel('Time period')
    ylabel('Log productivity')    

    % This plots log productivity over time
    figure(10)
    plot(time(1,1:T),Kactual(1:T,1)./Yactual)
    xlabel('Time period')
    ylabel('Capital/output ratio')    

end

