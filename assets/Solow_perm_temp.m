%% ===============================================================
%  Solow model simulation in MATLAB
%  - Two TFP scenarios: 'perm' or 'temp'
% ===============================================================

clear; close all; clc;

%% 1) Parameters and convergence settings
alpha = 0.30;      % capital share
delta = 0.05;      % depreciation rate
s     = 0.25;      % saving rate (0<s<1)

T_max = 200;       % maximum simulation periods
tol   = 1e-8;      % convergence tolerance on |k_{t+1}-k_t|
k0    = 1.00;      % initial capital (level)

scenario = 'perm'; % 'perm' (permanent jump), 'temp' (temporary 5..15)
shock_start = 5;   % when the shock hit in, applied to perm and temp
shock_end = 15;    % when the shock end, applied to temp only

A_low  = 0.10;     % baseline TFP level
A_high = 1.00;     % high TFP level

%% 2) Production function and law of motion (function handles)
% y = A * k^alpha
prod = @(A,k) A .* (k.^alpha);

% k_{t+1} = s*y + (1-delta)*k = s*A*k^alpha + (1-delta)*k
k_next = @(A,k) s .* prod(A,k) + (1 - delta).*k;

% The symbol @ is used to create an "anonymous function".
% An anonymous function is a function defined in a single line, without 
% needing to create a separate function file. 
%
% For example:
%   f = @(x) x^2 + 1;
% defines a function f(x) = x^2 + 1.
% After this, typing f(2) will return 5.

%% 3) Build TFP path A_t
A_path = A_low * ones(T_max,1);
switch scenario
    case 'perm'
        A_path(shock_start:end) = A_high;     % permanent high after the assigned periods
    case 'temp'
        A_path(shock_start:shock_end)  = A_high;     % temporary high in assigned periods
    otherwise
        % keep default A_low; or customize A_path here
end

%% 4) Closed-form steady states for reference (given constant A)
% steady-state values for original TFP
k_ss_low  = (s*A_low / delta)^(1/(1-alpha));
y_ss_low  = A_low * k_ss_low^alpha;
c_ss_low  = (1 - s) * y_ss_low;

% steady-state values for new TFP
k_ss_high = (s*A_high / delta)^(1/(1-alpha));
y_ss_high = A_high * k_ss_high^alpha;
c_ss_high = (1 - s) * y_ss_high;

%% 5) Containers
% set up containers for variables in simulation loop
k = nan(T_max+1,1);   % capital path (store k_0..k_T)
y = nan(T_max,1);     % output
c = nan(T_max,1);     % consumption

k(1) = k0;            % the first value in the capital path is the given initial capital k0

%% 6) Simulation loop (stop early if converged)
t_stop = T_max;  % actual last period simulated
for t = 1:T_max
    A = A_path(t);
    y(t) = prod(A, k(t));
    c(t) = (1 - s) * y(t);
    k(t+1) = k_next(A, k(t));

    % Convergence check (skip t=1 for safety)
    if t > 1
        if abs(k(t+1) - k(t)) < tol
            t_stop = t;      % record the last meaningful period
            k = k(1:t+1);
            y = y(1:t);
            c = c(1:t);
            A_path = A_path(1:t);
            break
        end
    end
end

%% 7) Console summary
fprintf('--- Simulation summary ---\n');
fprintf('Scenario: %s\n', scenario);
fprintf('Horizon simulated (t=0..%d)\n', t_stop);
fprintf('Final k_t: %.6f\n', k(end));
fprintf('Low-SS k*: %.6f, High-SS k*: %.6f\n', k_ss_low, k_ss_high);

%% 8) Plots (capital accumulation emphasized, plus output and phase diagram)
ttK = 0:(numel(k)-1);   % 0..t_stop for capital
tt  = 1:(numel(k)-1);   % 1..t_stop for output, consumption, TFP

figure('Position',[200 200 1600 420]);

% (a) Capital accumulation path
subplot(1,3,1); hold on; box on;
plot(ttK, k, 'LineWidth', 1.8);
yline(k_ss_low,  '--', 'k* (A=low)','LineWidth',1.0);
yline(k_ss_high, '--', 'k* (A=high)','LineWidth',1.0);
xlabel('t'); ylabel('Capital k_t');
title('Capital accumulation');
legend('k_t','k* low','k* high','Location','best'); grid on;

% (b) Output path
subplot(1,3,2); hold on; box on;
plot(tt, y, 'LineWidth', 1.8);
yline(y_ss_low,  '--', 'y* (A=low)','LineWidth',1.0);
yline(y_ss_high, '--', 'y* (A=high)','LineWidth',1.0);
xlabel('t'); ylabel('Output y_t');
title('Output');
legend('y_t','y* low','y* high','Location','best'); grid on;

% (c) TFP path
subplot(1,3,3); hold on; box on;
plot(tt, A_path(1:numel(tt)), 'LineWidth', 1.8);
xlabel('t'); ylabel('A_t');
title('TFP path');
grid on;

