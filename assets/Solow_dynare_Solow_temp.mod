
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Solow Model                     %
%           Temporary Productivity (TFP) Change         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------ Declare Variables and Parameters --------------------------------

% Endogenous Variables (stored in logs inside the model via exp(.))
var y c k;

% Exogenous Variable (log TFP)
varexo a;

% Parameters
parameters alpha delta s;

% Set Parameter Values
alpha = 0.3;    % Capital share
delta = 0.05;   % Depreciation rate
s     = 0.25;   % Exogenous saving rate (0 < s < 1)

% ------------------------------------------------------------------------
%                 Solow Model (in levels via exp(.))
%   Timing: y_t = A_t * k_{t-1}^alpha  (predetermined capital)
%           c_t = (1 - s) * y_t
%           k_t = s * y_t + (1 - delta) * k_{t-1}
%   Note: we keep log variables inside Dynare and use exp(·) in equations.
% ------------------------------------------------------------------------

model;
    % Production with predetermined capital
    exp(y) = exp(a) * (exp(k(-1))^alpha);

    % Consumption (exogenous saving rate)
    exp(c) = (1 - s) * exp(y);

    % Capital accumulation
    exp(k) = s * exp(y) + (1 - delta) * exp(k(-1));
end;

% ------------------------------------------------------------------------
%               Closed-form Steady States for given TFP A
%   In levels:
%       k_ss = (s*A/delta)^(1/(1 - alpha))
%       y_ss = A * k_ss^alpha = A * (s*A/delta)^(alpha/(1 - alpha))
%       c_ss = (1 - s) * y_ss
%   We store logs for Dynare's initval/endval.
% ------------------------------------------------------------------------

% ------ Initial Steady State (A = 0.1) ----------------------------------
initval;
    a = log(0.1);

    k = log( (s*0.1/delta)^( 1/(1 - alpha) ) );
    y = log( 0.1 * ( (s*0.1/delta)^( alpha/(1 - alpha) ) ) );
    c = log( (1 - s) * exp(y) );
end;
steady;

%% ------ Final Steady State (A = 1) --------------------------------------
%endval;
%    a = log(1.0);
%
 %   k = log( (s*1.0/delta)^( 1/(1 - alpha) ) );
  %  y = log( 1.0 * ( (s*1.0/delta)^( alpha/(1 - alpha) ) ) );
   % c = log( (1 - s) * exp(y) );
%end;
% steady;


% ------------------------------------------------------------------------
%         Temporary TFP change: A jumps from 0.1 to 1 from t = 5 to t = 15
%   (Under perfect foresight, initval is t=0; shocks assigns path from t>=1)
% ------------------------------------------------------------------------
shocks;
    var a;
    periods 5:15;
    values (log(1.0));
end;

% ------ Simulation -------------------------------------------------------
% Keep periods consistent with plotting horizon
perfect_foresight_setup(periods = 100);
perfect_foresight_solver;

% ------ Plotting Results (robust to exo storage) ------------------------
matlab;
    % Timeline length
    T = size(oo_.endo_simul, 2);

    % Endogenous indices
    idx_y = strmatch('y', M_.endo_names, 'exact');
    idx_k = strmatch('k', M_.endo_names, 'exact');
    idx_c = strmatch('c', M_.endo_names, 'exact');

    % ---- Build log(a) series robustly ----
    a_log = nan(1, T);

    % Try to use oo_.exo_simul if it has enough columns
    has_exo = isfield(oo_, 'exo_simul') && ~isempty(oo_.exo_simul) ...
              && size(oo_.exo_simul, 2) >= T;

    if has_exo
        a_log = oo_.exo_simul(1, 1:T);     % log(a)
    else
        % Fallback: reconstruct from identity exp(y) = exp(a)*exp(k(-1))^alpha
        % => in logs: a_t = y_t - alpha * k_{t-1}
        % First period use init a (initval)
        if exist('a', 'var')
            a_log(1) = a;                  % initval a = log(0.1)
        else
            a_log(1) = log(0.1);           % safety fallback
        end
        % t = 2..T : use measured y_t and k_{t-1}
        a_log(2:T) = oo_.endo_simul(idx_y, 2:T) - alpha * oo_.endo_simul(idx_k, 1:T-1);
    end

    % ---- Plot logs ------------------------------------------------------
    close all; figure;

    subplot(1,4,1);
    plot(1:T, a_log, 'LineWidth', 2);
    xlabel('t'); ylabel('log a'); title('Productivity (a)', 'FontSize', 16);

    subplot(1,4,2);
    plot(1:T, oo_.endo_simul(idx_y, 1:T)', 'LineWidth', 2);
    xlabel('t'); ylabel('log y'); title('Output (y)', 'FontSize', 16);

    subplot(1,4,3);
    plot(1:T, oo_.endo_simul(idx_k, 1:T)', 'LineWidth', 2);
    xlabel('t'); ylabel('log k'); title('Capital (k)', 'FontSize', 16);

    subplot(1,4,4);
    plot(1:T, oo_.endo_simul(idx_c, 1:T)', 'LineWidth', 2);
    xlabel('t'); ylabel('log c'); title('Consumption (c)', 'FontSize', 16);

    set(gcf, 'position', [200, 200, 1200, 400]);
    saveas(gcf, 'solow_perm_tfp_logs.png');


