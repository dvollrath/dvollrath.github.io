%% ===============================================================
%  Solow model simulation (manual shocks at specific periods)
%  - One-loop version: when t hits shock_start/end, manually adjust
%    parameters or states (K, L) right inside the loop.
% ===============================================================

clear; close all; clc;

%% 1) Parameters and switches
T_max  = 500;         % maximum simulation periods
alpha  = 0.30;        % capital share
delta  = 0.05;        % depreciation
sI     = 0.25;        % investment share of GDP
gA     = 0.02;        % TFP growth (gross: 1+gA)
gL     = 0.01;        % population growth (gross: 1+gL)

A0 = 1.0;             % initial TFP level
L0 = 1.0;             % initial population level
K0 = 1.0;             % initial capital level (can also set to BGP later)

% --- shock timing (manual editing here) ---
shock_start = 80;     % when the shock begins (apply at start of this period)
shock_end   = Inf;    % if finite number => temporary; Inf => permanent

% --- what to change at shock_start (examples; edit as you wish) ---
chg_param = true;     % change parameters? (sI, gA, gL, delta, alpha)
sI_new    = sI;     % example: raise investment share permanently
gA_new    = gA;     % keep same if you don't want to change
gL_new    = gL;     % keep same if you don't want to change
delta_new = delta;
alpha_new = alpha;

chg_stateK = false;    % shock to capital stock K at shock_start?
K_scale    = 0.8;    % e.g., disaster: K := 0.85*K  (set =1.0 to disable)
K_add      = 0.0;     % or level shift: K := K + K_add

chg_stateL = false;   % shock to population L at shock_start?
L_scale    = 0.8;    % e.g., sudden drop or jump in L
L_add      = 0.0;

chg_stateA = false;   % shock to productivity at shock_start?
A_scale    = 0.8;    % e.g., sudden drop or jump in A
A_add      = 0.0;


% --- if temporary shock, how to revert at shock_end+1 (examples) ---
revert_param = false;
sI_back    = sI;    % restore original values (or any values you want)
gA_back    = gA;
gL_back    = gL;
delta_back = delta;
alpha_back = alpha;

revert_stateK = false;  % usually we do NOT revert K/L (state shocks are one-off)
K_scale_back  = 1.0; K_add_back = 0.0;
revert_stateL = false;  % set true only if you really want to jump L back
L_scale_back  = 1.0; L_add_back = 0.0;

% --- convergence option ---
stop_on_convergence = false;   % true => stop early when |K_{t+1}-K_t| < tol
tol = 1e-8;


%% 2) Helpers
prodY = @(A,L,K,alpha) K.^alpha .* (A.*L).^(1-alpha);      % Y = K^α (AL)^(1-α)
KY_bgp_fun = @(sI,gA,gL,delta) sI ./ (gA + gL + delta);     % (K/Y)_BGP
% BGP log y path given piecewise gA and KY (used below after sim)

%% 3) Containers
K  = nan(T_max+1,1);
A  = nan(T_max+1,1);
L  = nan(T_max+1,1);
Y  = nan(T_max+1,1);
y_pc = nan(T_max+1,1);    % GDP per capita
lny  = nan(T_max+1,1);
g_y_pc = nan(T_max+1,1);  % Δlog y_pc
KY = nan(T_max+1,1);

% parameter histories (for plotting BGP reference)
sI_t = nan(T_max,1); gA_t = nan(T_max,1); gL_t = nan(T_max,1);
delta_t = nan(T_max,1); alpha_t = nan(T_max,1);

%% 4) Initial conditions (you may also put K0 on initial BGP if desired)
A(1)=A0; L(1)=L0; K(1)=K0;
Y(1)=prodY(A(1),L(1),K(1),alpha);
y_pc(1)=Y(1)/L(1); lny(1)=log(y_pc(1)); KY(1)=K(1)/Y(1);

%% 5) Simulation (single loop; manual edits at specific t)
t_stop = T_max;

for t = 1:T_max
    % record current parameters used in (t -> t+1) transition
    sI_t(t)   = sI;   gA_t(t) = gA;   gL_t(t) = gL;
    delta_t(t)= delta; alpha_t(t) = alpha;

    % ---- APPLY SHOCKS AT START OF PERIOD t (before producing t-output) ----
    if t == shock_start
        % (i) parameter changes
        if chg_param
            sI = sI_new; gA = gA_new; gL = gL_new; delta = delta_new; alpha = alpha_new;
        end
        % (ii) state shocks to K, L
        if chg_stateK
            K(t) = K_scale * K(t) + K_add;
        end
        if chg_stateL
            L(t) = L_scale * L(t) + L_add;
        end
        if chg_stateA
            A(t) = A_scale * A(t) + A_add;
        end
        % recompute output at t if K/L changed
        Y(t)=prodY(A(t),L(t),K(t),alpha);
        y_pc(t)=Y(t)/L(t); lny(t)=log(y_pc(t)); KY(t)=K(t)/Y(t);
    end

    % ---- OPTIONAL: revert parameters at shock_end+1 for temporary shocks ----
    if ~isinf(shock_end) && t == (shock_end + 1)
        if revert_param
            sI = sI_back; gA = gA_back; gL = gL_back; delta = delta_back; alpha = alpha_back;
        end
        if revert_stateK
            K(t) = K_scale_back * K(t) + K_add_back;
        end
        if revert_stateL
            L(t) = L_scale_back * L(t) + L_add_back;
        end
        % recompute with reverted states (rare)
        Y(t)=prodY(A(t),L(t),K(t),alpha);
        y_pc(t)=Y(t)/L(t); lny(t)=log(y_pc(t)); KY(t)=K(t)/Y(t);
    end

    % ---- Dynamics: build (t+1) ----
    % K_{t+1} = (1-δ)K_t + sI * Y_t
    if t < T_max
        K(t+1) = (1 - delta)*K(t) + sI * Y(t);
        A(t+1) = A(t) * (1 + gA);
        L(t+1) = L(t) * (1 + gL);

        Y(t+1)   = prodY(A(t+1),L(t+1),K(t+1),alpha);
        y_pc(t+1)= Y(t+1)/L(t+1);
        lny(t+1) = log(y_pc(t+1));
        KY(t+1)  = K(t+1)/Y(t+1);
        g_y_pc(t+1) = lny(t+1) - lny(t);

        % convergence check (optional)
        if stop_on_convergence && t > 1
            if abs(K(t+1) - K(t)) < tol
                t_stop = t+1;
                break;
            end
        end
    end
end

% truncate to actual length simulated
K  = K(1:t_stop); A=A(1:t_stop); L=L(1:t_stop); Y=Y(1:t_stop);
y_pc=y_pc(1:t_stop); lny=lny(1:t_stop); KY=KY(1:t_stop);
g_y_pc=g_y_pc(1:t_stop);
sI_t=sI_t(1:min(t_stop,T_max)); gA_t=gA_t(1:min(t_stop,T_max));
gL_t=gL_t(1:min(t_stop,T_max)); delta_t=delta_t(1:min(t_stop,T_max));
alpha_t=alpha_t(1:min(t_stop,T_max));

%% 6) BGP references (piecewise, using time-varying parameters actually used)
Tref = numel(sI_t);
KY_bgp = KY_bgp_fun(sI_t, gA_t, gL_t, delta_t);      % (K/Y)_BGP(t)

% ln y_BGP(t) = (α/(1-α)) ln(K/Y)_BGP(t) + ln A(1) + cumulative gA
% (strictly α may change; we use alpha_t for piecewise α)
cum_gA = [0; cumsum(gA_t(1:end-1))];                 % align with 1..Tref
lny_bgp = (alpha_t./(1 - alpha_t)).*log(KY_bgp) + log(A0) + cum_gA;

%% 7) Console summary
fprintf('--- Simulation summary ---\n');
fprintf('Horizon simulated: t = 1..%d\n', t_stop);
fprintf('Final K: %.6f | Final y_pc: %.6f | Final K/Y: %.6f\n', K(end), y_pc(end), KY(end));

%% 8) Plots
tt = (1:t_stop)';

figure('Name','Solow: manual shocks','Position',[120 120 920 760]);

subplot(3,1,1);
plot(tt, lny, 'LineWidth', 1.8); hold on;
plot(1:Tref, lny_bgp(1:Tref), '--', 'LineWidth', 1.2);
ylabel('log y_t (per capita)'); title('Log GDP per capita');
legend('Actual','BGP (piecewise)','Location','northwest'); grid on;

subplot(3,1,2);
plot(tt, g_y_pc, 'LineWidth', 1.8); hold on;
plot(1:Tref, gA_t(1:Tref), '--', 'LineWidth', 1.2); % BGP growth = gA
ylabel('\Delta log y_t'); title('Growth rate of GDP per capita');
legend('Actual','g_A(t) (BGP growth)','Location','northwest'); grid on;

subplot(3,1,3);
plot(tt, KY, 'LineWidth', 1.8); hold on;
plot(1:Tref, KY_bgp(1:Tref), '--', 'LineWidth', 1.2);
xlabel('time'); ylabel('K/Y'); title('Capital-Output ratio');
legend('Actual','(K/Y)_{BGP}(t)','Location','best'); grid on;
