% --- Ramsey Model Simulation with Multiple Initial Consumption Paths ---
clear all;
clc;
close all;

% --- 1. Set Parameters ---
alpha = 0.3;     % Capital share in production (epsilon_k)
beta  = 0.96;    % Discount factor
delta = 0.08;    % Depreciation rate
sigma = 2.0;     % Coefficient of relative risk aversion (inverse of IES)
g_L   = 0;       % Population growth rate (set to zero as suggested)
k0    = 1.0;     % Initial capital per capita

% --- Simulation Settings ---
T = 100;         % Number of periods to simulate

% --- Derived Parameters ---
theta = 1/beta - 1; % Discount rate (approximately)

% --- Production Function and its Derivative ---
f = @(k) k.^alpha;         % Per-capita production function y = k^alpha
f_prime = @(k) alpha * k.^(alpha-1); % Marginal product of capital (MPK)

% --- Calculate Steady State ---
% From f'(k*) - delta = theta (since gc=0 in steady state and ga=0)
k_steady = (alpha / (theta + delta))^(1/(1-alpha));
y_steady = f(k_steady);
c_steady = y_steady - (delta + g_L) * k_steady;
fprintf('Steady State Values (for reference):\n');
fprintf('  k* = %.4f\n', k_steady);
fprintf('  y* = %.4f\n', y_steady);
fprintf('  c* = %.4f\n', c_steady);
fprintf('Initial k0 = %.4f\n\n', k0);

% --- 2. Choose Initial Consumption Values ---
% NOTE: Finding the exact c0 for the stable path numerically (the "theoretical" c0)
% typically requires a shooting algorithm or more advanced techniques.
% Here, we manually select a value that appears close to the stable path
% based on the steady state and k0, and choose others relative to it.
% Since k0 < k_steady, the optimal c0 is usually less than c_steady.
c0_optimal_approx = 0.69875568; % Manually chosen value close to stable path for these parameters
c0_low = c0_optimal_approx * 0.7;    % Lower initial consumption (over-saving case)
c0_high = c0_optimal_approx * 1.3;   % Higher initial consumption (over-consumption case)

c0_values = [c0_low, c0_optimal_approx, c0_high];
path_labels = {'Low c0 (Over-saving)', 'Approx Optimal c0', 'High c0 (Over-consumption)'};
line_styles = {'--b', '-k', ':r'}; % Different line styles for plotting

% --- Initialize Cell Arrays to Store Results for Each Path ---
k_paths = cell(1, 3);
c_paths = cell(1, 3);

% --- 3. Simulation Loop for Each c0 ---
for i = 1:length(c0_values)
    current_c0 = c0_values(i);
    fprintf('Simulating path for c0 = %.4f...\n', current_c0);

    % Initialize vectors for this path
    k_path_temp = zeros(T+1, 1);
    c_path_temp = zeros(T+1, 1);
    k_path_temp(1) = k0;
    c_path_temp(1) = current_c0;
    
    simulation_complete = true; % Flag to track if simulation ran fully

    for t = 1:T
        % Current state
        kt = k_path_temp(t);
        ct = c_path_temp(t);

        % Check if capital or consumption is non-positive
        if kt <= 0 || ct <= 0
            fprintf('  Simulation stopped at t=%d due to non-positive k or c.\n', t);
            % Trim arrays to the valid length
            k_path_temp = k_path_temp(1:t);
            c_path_temp = c_path_temp(1:t);
            simulation_complete = false; 
            break; % Exit inner loop for this c0
        end

        % Calculate output and rate of return for the *current* period
        yt = f(kt);
        rt = f_prime(kt) - delta; % Net rate of return in period t

        % a) Calculate capital for the *next* period (k_{t+1})
        % From discrete version of dk = y - c - (delta + g_L)k
        % k_{t+1} - k_t = y_t - c_t - (delta + g_L)k_t
        k_next = yt - ct + (1 - delta - g_L) * kt;
        k_path_temp(t+1) = k_next;

        % b) Calculate consumption for the *next* period (c_{t+1})
        % From discrete Euler: c_{t+1} = c_t * [beta * (1 + r_{t+1}) ]^(1/sigma)
        % We approximate using r_t for simplicity in forward simulation:
        % Note: A more precise simulation might use r_{t+1} which depends on k_{t+1}
        c_next = ct * (beta * (1 + rt))^(1/sigma);
        c_path_temp(t+1) = c_next;
        
        % Optional: Check for explosive behavior early
        if (k_next > k_steady*10 || c_next > c_steady*10) && k_next > k0*10 % Heuristic check
             fprintf('  Warning: Possible explosive behavior detected at t=%d.\n', t);
        end        
    end
    
    if simulation_complete
       fprintf('  Simulation completed for %d periods.\n', T);
    end

    % Store results for this c0
    k_paths{i} = k_path_temp;
    c_paths{i} = c_path_temp;
    fprintf('\n');
end

% --- 4. Plot Results ---
figure('Name', 'Ramsey Model Simulation Paths'); % Create figure window

% Subplot for Capital Paths
subplot(2,1,1);
hold on; % Hold on to plot multiple lines
for i = 1:length(c0_values)
    time_vector = 0:(length(k_paths{i})-1); % Adjust time vector if simulation stopped early
    plot(time_vector, k_paths{i}, line_styles{i}, 'LineWidth', 1.5, 'DisplayName', path_labels{i});
end
plot(0:T, ones(T+1, 1)*k_steady, '--m', 'LineWidth', 1, 'DisplayName', 'k* Steady State');
hold off;
title('Path of Capital per Capita (k_t)');
xlabel('Time (t)');
ylabel('k_t');
grid on;
legend('Location', 'best');
ylim([0, max(k_steady*1.5, k0*1.5)]); % Adjust y-axis limit for better visibility

% Subplot for Consumption Paths
subplot(2,1,2);
hold on; % Hold on to plot multiple lines
for i = 1:length(c0_values)
    time_vector = 0:(length(c_paths{i})-1); % Adjust time vector if simulation stopped early
    plot(time_vector, c_paths{i}, line_styles{i}, 'LineWidth', 1.5, 'DisplayName', path_labels{i});
end
plot(0:T, ones(T+1, 1)*c_steady, '--m', 'LineWidth', 1, 'DisplayName', 'c* Steady State');
hold off;
title('Path of Consumption per Capita (c_t)');
xlabel('Time (t)');
ylabel('c_t');
grid on;
legend('Location', 'best');
ylim([0, max(c_steady*1.5, c0_high*1.1)]); % Adjust y-axis limit

