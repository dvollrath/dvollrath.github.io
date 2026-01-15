%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shooting algorithm (grid search) for the Ramsey model (deterministic)
% Criterion: choose c0 that MAXIMIZES discounted lifetime utility
%            J(c0) = sum_{t=1}^T beta^(t-1) * u(c_t)
%
% u(c) = c^(1-sigma)/(1-sigma)  (log utility if sigma = 1)
% y_t  = A * k_t^alpha
% k_{t+1} = y_t + (1 - delta) k_t - c_t
% Euler: c_{t+1} = c_t * beta * [A*alpha*k_{t+1}^{alpha-1} + 1 - delta]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0. Environment ---------------------------------------------------------
clear; clf; close all;

doplot  = 1;   % 1 = make figures
savefig = 0;   % 1 = save figures to PNG

%% 1. Parameters ----------------------------------------------------------
% Preferences & technology
sigma = 1.0;     % CRRA coefficient (sigma = 1 -> log utility)
beta  = 0.98;    % discount factor
alpha = 0.36;    % capital share
delta = 0.10;    % depreciation
A     = 1.00;    % productivity (constant, deterministic)

% Initial capital and horizon
k0 = 1.00;       % initial capital k_0
T  = 200;        % number of periods to simulate forward

% Grid over c0 (your “split feasible interval into n bins”)
nC = 401;        % number of c0 candidates (larger = finer grid)

% Numerical guards
eps_c  = 1e-12;  % min consumption to avoid log/negative issues
eps_k  = 1e-14;  % min capital
utility_floor = -1e18; % very low utility for infeasible paths

%% 2. Steady state (k*, c*, y*, R*) ---------------------------------------
% 1 = beta*(A*alpha*k*^(alpha-1) + 1 - delta)  ->  A*alpha*k*^(alpha-1) = 1/beta - 1 + delta
k_ss = ((1/beta - 1 + delta) / (A*alpha))^(1/(alpha-1));
y_ss = A * k_ss^alpha;
c_ss = y_ss - delta * k_ss;
R_ss = A*alpha*k_ss^(alpha-1) + 1 - delta;

%% 3. Feasible interval for c0 and grid -----------------------------------
% Period-0 resources: y0 + (1 - delta)*k0
y0   = A * k0^alpha;  
res0 = y0 + (1 - delta)*k0;  % feasible c0

% Safe interior (avoid corners that blow up dynamics)
c0_min = max(eps_c, 0.02 * res0);
c0_max = 0.98 * res0;
c0_grid = linspace(c0_min, c0_max, nC)';

%% 4. Containers for paths & objective ------------------------------------
% Each c0 produces a path: k (length T+1), c/y/R (length T)
K_paths = NaN(nC, T+1);
C_paths = NaN(nC, T);
Y_paths = NaN(nC, T);
R_paths = NaN(nC, T);

% Discounted utility for each candidate c0
J_vals = -inf(nC,1);

% Also store final-period values for quick inspection
kT_store = NaN(nC,1);
cT_store = NaN(nC,1);

%% 5. Main loop: simulate each c0 forward ---------------------------------
for j = 1:nC
    % Initialize arrays for this candidate
    k = zeros(T+1,1);
    c = zeros(T,1);
    y = zeros(T,1);
    R = zeros(T,1);

    k(1) = max(k0, eps_k);
    c(1) = max(c0_grid(j), eps_c);

    feasible = true;
    disc_util = 0.0;

    for t = 1:T
        % Output at t
        y(t) = A * k(t)^alpha;

        % Capital law of motion
        k(t+1) = y(t) + (1 - delta)*k(t) - c(t);

        % Basic feasibility checks:
        % Ensure that next-period capital, output, and consumption remain valid.
        % - k(t+1) must be finite and above a small threshold (eps_k).
        % - y(t) must be finite.
        % - c(t) must be finite and above a small threshold (eps_c).
        % If any condition fails, mark the path as infeasible and stop the loop.
        if ~isfinite(k(t+1)) || k(t+1) <= eps_k || ~isfinite(y(t)) || c(t) <= eps_c
            feasible = false; break;
        end

        % Gross return (based on k_{t+1})
        R(t) = A*alpha*k(t+1)^(alpha-1) + 1 - delta;

        % Accumulate discounted utility for period t consumption
        if sigma == 1
            u_t = log(c(t));
        else
            u_t = (c(t)^(1 - sigma)) / (1 - sigma);
        end
        disc_util = disc_util + (beta^(t-1)) * u_t;

        % Next consumption via Euler (except at T)
        if t < T
            c(t+1) = c(t) * beta * R(t);

            % Guard against non-sense values
            if ~isfinite(c(t+1)) || c(t+1) <= eps_c || c(t+1) > 1e12
                feasible = false; break;
            end
        end
    end

    % Record results for this candidate
    if feasible
        J_vals(j)   = disc_util;    % using accumulated utility as selection criterion
        K_paths(j,:)= k.';
        C_paths(j,:)= c.';
        Y_paths(j,:)= y.';
        R_paths(j,:)= R.';
        kT_store(j) = k(end);
        cT_store(j) = c(end);
    else
        % Keep -inf and leave paths as NaN (helps us see infeasible shots)
        J_vals(j) = utility_floor;
    end
end

%% 6. Pick the best c0 by MAX discounted utility --------------------------
[best_J, best_idx] = max(J_vals);
best_c0 = c0_grid(best_idx);

fprintf('Best c0 by discounted utility: %.8f   J = %.6f\n', best_c0, best_J);

%% 7. Choose representative paths to plot ---------------------------------
% We’ll show: best, min c0, 25th, 50th, 75th percentiles, and max c0.
[~, sort_idx] = sort(c0_grid);
p_idx = @(p) sort_idx(max(1, min(nC, round(p*(nC-1)+1))));

idx_min = sort_idx(1);
idx_p25 = p_idx(0.25);
idx_p50 = p_idx(0.50);
idx_p75 = p_idx(0.75);
idx_max = sort_idx(end);

sel_idx = unique([best_idx, idx_min, idx_p25, idx_p50, idx_p75, idx_max], 'stable');

labels = cell(numel(sel_idx),1);
for ii = 1:numel(sel_idx)
    tag = sprintf('c0=%.3f', c0_grid(sel_idx(ii)));
    if sel_idx(ii) == best_idx
        labels{ii} = ['best ', tag];
    else
        labels{ii} = tag;
    end
end

%% 8. Plotting -------------------------------------------------------------
if doplot == 1
    ttK = 0:T;   % k path indices
    tt  = 1:T;   % c, y, R indices

    % (a) Capital paths
    figure(1); clf; hold on; box on;
    for ii = 1:numel(sel_idx)
        plot(ttK, K_paths(sel_idx(ii),:), 'LineWidth', 1.6);
    end
    yline(k_ss, '--', 'k*', 'LineWidth', 1.0);
    xlabel('t'); ylabel('Capital k_t');
    title('Capital paths for selected c_0 (utility-max criterion)');
    legend(labels, 'Location','best'); grid on;

    % (b) Consumption paths
    figure(2); clf; hold on; box on;
    for ii = 1:numel(sel_idx)
        plot(tt, C_paths(sel_idx(ii),:), 'LineWidth', 1.6);
    end
    yline(c_ss, '--', 'c*', 'LineWidth', 1.0);
    xlabel('t'); ylabel('Consumption c_t');
    title('Consumption paths for selected c_0 (utility-max criterion)');
    legend(labels, 'Location','best'); grid on;

    % (c) Output paths
    figure(3); clf; hold on; box on;
    for ii = 1:numel(sel_idx)
        plot(tt, Y_paths(sel_idx(ii),:), 'LineWidth', 1.6);
    end
    yline(y_ss, '--', 'y*', 'LineWidth', 1.0);
    xlabel('t'); ylabel('Output y_t');
    title('Output paths for selected c_0');
    legend(labels, 'Location','best'); grid on;

    % (d) Gross return paths
    figure(4); clf; hold on; box on;
    for ii = 1:numel(sel_idx)
        plot(tt, R_paths(sel_idx(ii),:), 'LineWidth', 1.6);
    end
    yline(R_ss, '--', 'R*', 'LineWidth', 1.0);
    xlabel('t'); ylabel('R_{t+1} = \alpha A k_{t+1}^{\alpha-1} + 1-\delta');
    title('Gross return paths for selected c_0');
    legend(labels, 'Location','best'); grid on;

    if savefig
        saveas(1, 'shoot_k_paths.png');
        saveas(2, 'shoot_c_paths.png');
        saveas(3, 'shoot_y_paths.png');
        saveas(4, 'shoot_R_paths.png');
    end
end

%% 9. Quick table printout -------------------------------------------------
disp('--- Summary (first 10 candidates) ---');
Nshow = min(10, nC);
tbl = table(c0_grid(1:Nshow), J_vals(1:Nshow), kT_store(1:Nshow), cT_store(1:Nshow), ...
    'VariableNames', {'c0','J_discounted','k_T','c_T'});
disp(tbl);

fprintf('\nSteady state: k*=%.6f, c*=%.6f, y*=%.6f, R*=%.6f\n', k_ss, c_ss, y_ss, R_ss);
fprintf('Best c0 (utility-max): %.6f\n', best_c0);
