%% main_consumption_paths.m
% Discrete-time consumption-savings with CRRA preferences
% c_{t+1}/c_t = gamma = [beta*(1+r)]^(1/sigma)
% c0 = (1 - gamma/(1+r)) * ( a0 + W0 ),  W0 = ((1+r)/(r-g)) * w0  (requires r>g)

clear all; clc; close all;

%% ---------------------- Global simulation settings ----------------------
T = 200;                 % number of periods to simulate
printf_lite = true;       % if true, prints concise line-by-line summary

% Which lines to draw? (set true/false)
line_1_draw = true;
line_2_draw = true;
line_3_draw = false;

%% ---------------------- Parameter lines (edit freely) -------------------
% line 1
r_1 = 0.08; g_1 = 0.05; w0_1 = 1.0;     a0_1 = 0.0;  sigma_1 = 2.0; beta_1  = 0.9;
% line 2
r_2 = 0.08; g_2 = 0.05; w0_2 = 1.0;     a0_2 = 0.0;  sigma_2 = 2.0; beta_2  = 0.5;
% line 3
r_3 = 0.04; g_3 = 0.02; w0_3 = 1.0;     a0_3 = 0.0;  sigma_3 = 2.0; beta_3  = 0.96;

%% ---------------------- Pack scenarios into structs ---------------------
lines = {};
if line_1_draw
    lines{end+1} = struct('name','Line 1','r',r_1,'g',g_1,'w0',w0_1,'a0',a0_1,...
                          'sigma',sigma_1,'beta',beta_1,'color',[0 0.447 0.741]);
end
if line_2_draw
    lines{end+1} = struct('name','Line 2','r',r_2,'g',g_2,'w0',w0_2,'a0',a0_2,...
                          'sigma',sigma_2,'beta',beta_2,'color',[0.85 0.325 0.098]);
end
if line_3_draw
    lines{end+1} = struct('name','Line 3','r',r_3,'g',g_3,'w0',w0_3,'a0',a0_3,...
                          'sigma',sigma_3,'beta',beta_3,'color',[0.466 0.674 0.188]);
end
if isempty(lines), error('No lines selected.'); end

%% ---------------------- Compute paths for each scenario ------------------
for i = 1:numel(lines)
    [c, w, s, sr, a, anext, gamma, gc] = solve_consumer(lines{i}, T);

    lines{i}.c  = c;      % c_t,   length T+1
    lines{i}.w  = w;      % w_t,   length T+1
    lines{i}.s  = s;      % s_t=w_t-c_t, length T+1
    lines{i}.sr = sr;     % s_t/w_t, length T+1
    lines{i}.a  = a;      % a_t,   length T+1 (a_0 ... a_T)
    lines{i}.an = anext;  % a_{t+1}, length T+1 (aligned with t=0...T)
    lines{i}.gamma = gamma;    % = 1 + g_c
    lines{i}.gc    = gc;

    if printf_lite
        fprintf('%s: r=%.4f, g=%.4f, sigma=%.2f, beta=%.3f | gamma=%.5f, g_c=%.5f\n', ...
            lines{i}.name, lines{i}.r, lines{i}.g, lines{i}.sigma, lines{i}.beta, ...
            lines{i}.gamma, lines{i}.gc);
        fprintf('   c0=%.6f, w0=%.6f, s0=w0-c0=%.6f,  W0=%.6f\n\n', ...
            lines{i}.c(1), lines{i}.w(1), lines{i}.s(1), ((1+lines{i}.r)/(lines{i}.r-lines{i}.g))*lines{i}.w(1));
    end
end

%% ---------------------- Figure group (tiledlayout) ----------------------
tgrid = (0:T)';

fig = figure('Name','Consumption-Savings (grouped)','Color','w');
tl  = tiledlayout(fig,2,3,'TileSpacing','compact','Padding','compact');

% (1) c_t
nexttile; hold on; grid on;
for i=1:numel(lines), plot(tgrid, lines{i}.c, 'LineWidth',1.6, 'Color', lines{i}.color); end
title('Optimal consumption c_t'); xlabel('t'); ylabel('c_t');
legend(string(cellfun(@(x) x.name, lines, 'UniformOutput', false)),'Location','northwest');

% (2) s_t
nexttile; hold on; grid on;
for i=1:numel(lines), plot(tgrid, lines{i}.s, 'LineWidth',1.6, 'Color', lines{i}.color); end
title('Savings s_t = w_t - c_t'); xlabel('t'); ylabel('s_t');

% (3) savings rate
nexttile; hold on; grid on;
for i=1:numel(lines), plot(tgrid, lines{i}.sr, 'LineWidth',1.6, 'Color', lines{i}.color); end
title('Savings rate s_t/w_t'); xlabel('t'); ylabel('s_t / w_t');

% (4) wages w_t  
nexttile; hold on; grid on;
for i=1:numel(lines), plot(tgrid, lines{i}.w, 'LineWidth',1.6, 'Color', lines{i}.color); end
title('Wage path w_t'); xlabel('t'); ylabel('w_t');

% (5) assets a_{t+1}  
nexttile; hold on; grid on;
for i=1:numel(lines), plot(tgrid, lines{i}.an, 'LineWidth',1.6, 'Color', lines{i}.color); end
title('Asset next-period a_{t+1}'); xlabel('t'); ylabel('a_{t+1}');

% (6) signed log 的 s_t（optional）
% nexttile; hold on; grid on;
% for i=1:numel(lines)
%     y = sign(lines{i}.s).*log(1+abs(lines{i}.s));
%     plot(tgrid, y, 'LineWidth',1.6, 'Color', lines{i}.color);
% end
% title('sign(s_t)·log(1+|s_t|)'); xlabel('t'); ylabel('signed log s_t');

%% ---------------------- Local function ----------------------
function [c, w, s, sr, a, anext, gamma, gc] = solve_consumer(p, T)
    % Unpack
    r = p.r; g = p.g; w0 = p.w0; a0 = p.a0; sigma = p.sigma; beta = p.beta;

    % Feasibility
    if r <= g
        error('%s: requires r > g for PDV of wages to be finite. Got r=%.5f, g=%.5f.', ...
              p.name, r, g);
    end

    % gamma = 1 + g_c (constant)
    gamma = (beta*(1+r))^(1/sigma);
    gc    = gamma - 1;
    if gamma >= (1+r)
        warning('%s: gamma >= 1+r => g_c >= r (check parameters).', p.name);
    end

    % PDV of wages and initial c0
    W0 = ((1+r)/(r - g))*w0;
    c0 = (1 - gamma/(1+r))*(a0 + W0);

    % Grids
    tgrid = (0:T)';
    w = w0 * (1+g).^tgrid;      % wages path
    c = c0 * gamma.^tgrid;      % consumption path
    s = w - c;                  % savings (w_t - c_t), as defined in problem
    sr = s ./ w;                % savings rate
    sr(w==0) = NaN;

    % Assets path: a_{t+1} = w_t + (1+r)a_t - c_t
    a = zeros(T+1,1);
    a(1) = a0;                  % this is a_0
    for t = 1:T
        a(t+1) = w(t) + (1+r)*a(t) - c(t);   % gives a_t for all t
    end
    anext = w + (1+r)*a - c;    % aligned vector for a_{t+1}, length T+1
end
