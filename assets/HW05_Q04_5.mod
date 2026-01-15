% ===============================================================
% Ramsey (Cass–Koopmans) — Two Economies A & B
% Stationary core in efficiency units; compute sI path after solve
% No macro preprocessor, no special syntax.
% ===============================================================

var cA_til kA_til  cB_til kB_til;     // tilde vars: per efficiency unit (stationary)
parameters alphaA deltaA sigmaA thetaA nA A0A gAA;
parameters alphaB deltaB sigmaB thetaB nB A0B gAB;
parameters k0fac c0fac phiA phiB;
parameters kA_ss_til cA_ss_til kB_ss_til cB_ss_til;

% ---------- Parameters (you may edit these) ----------
%alphaA = 0.33;     deltaA = 0.05;   sigmaA = 2.00;  thetaA = 0.04;  nA = 0.00;
%alphaB = 0.33;     deltaB = 0.05;   sigmaB = 2.00;  thetaB = 0.04;  nB = 0.00;

% For level reconstruction only (NOT inside the model)
%A0A = 1;           gAA = 0.00;      % set 0.00 or 0.02
%A0B = 1;           gAB = 0.00;      % set 0.00 or 0.02


% case I: bech mark-SI* = 1/sigma
alphaA = 0.7;     deltaA = 0.06;   sigmaA = 2.00;  thetaA = 0.04;  nA = 0.02;   A0A = 1;  gAA = 0.02;      

% case II: SI* < 1/sigma
% alphaB = 0.6;     deltaB = 0.06;   sigmaB = 2.00;  thetaB = 0.04;  nB = 0.02;   A0B = 1;  gAB = 0.02;      

% case III: bech mark-SI* > 1/sigma
alphaB = 0.8;     deltaB = 0.06;   sigmaB = 2.00;  thetaB = 0.04;  nB = 0.02;   A0B = 1;  gAB = 0.02;      




% Initial deviations from tilde steady state
k0fac = 0.60;      c0fac = 0.80;

% Exponents for level reconstruction: k = k_til * A^phi
phiA = 1/(1 - alphaA);
phiB = 1/(1 - alphaB);

% ---------- Tilde steady states (no gA here) ----------
kA_ss_til = ( alphaA / (deltaA + thetaA) )^( 1/(1 - alphaA) );
cA_ss_til = kA_ss_til^alphaA - (deltaA + nA) * kA_ss_til;

kB_ss_til = ( alphaB / (deltaB + thetaB) )^( 1/(1 - alphaB) );
cB_ss_til = kB_ss_til^alphaB - (deltaB + nB) * kB_ss_til;

% ===============================================================
% MODEL (stationary system only; no A_t here)
% ===============================================================
model;
  % ----- Economy A -----
  (cA_til(+1)/cA_til)^sigmaA = (1/(1 + thetaA)) * ( alphaA * kA_til(+1)^(alphaA - 1) + 1 - deltaA );
  kA_til = ( (1 - deltaA)*kA_til(-1) + kA_til(-1)^alphaA - cA_til(-1) ) / (1 + nA);

  % ----- Economy B -----
  (cB_til(+1)/cB_til)^sigmaB = (1/(1 + thetaB)) * ( alphaB * kB_til(+1)^(alphaB - 1) + 1 - deltaB );
  kB_til = ( (1 - deltaB)*kB_til(-1) + kB_til(-1)^alphaB - cB_til(-1) ) / (1 + nB);
end;

steady;
check;

% ===============================================================
% INITIAL & TERMINAL CONDITIONS (tilde)
% ===============================================================
initval;
  kA_til = k0fac * kA_ss_til;
  cA_til = c0fac * cA_ss_til;
  kB_til = k0fac * kB_ss_til;
  cB_til = c0fac * cB_ss_til;
end;

endval;
  kA_til = kA_ss_til;
  cA_til = cA_ss_til;
  kB_til = kB_ss_til;
  cB_til = cB_ss_til;
end;

options_.dynatol.f  = 1e-7;
options_.dynatol.x  = 1e-7;
options_.maxit_     = 2000;
options_.solve_algo = 0;

perfect_foresight_setup(periods=800);
perfect_foresight_solver;

% ===============================================================
% POST-SOLVE (MATLAB zone): compute sI, optionally reconstruct levels
% ===============================================================
t = (1:columns(oo_.endo_simul))';  t = t(:);

% Safe index retrieval (no anonymous functions)
ix_cA = strmatch('cA_til', M_.endo_names, 'exact');
ix_kA = strmatch('kA_til', M_.endo_names, 'exact');
ix_cB = strmatch('cB_til', M_.endo_names, 'exact');
ix_kB = strmatch('kB_til', M_.endo_names, 'exact');

cAtil = oo_.endo_simul(ix_cA, :)';    kAtil = oo_.endo_simul(ix_kA, :)';
cBtil = oo_.endo_simul(ix_cB, :)';    kBtil = oo_.endo_simul(ix_kB, :)';

% ---- Savings rates in efficiency units (A- and B-independent) ----
% sI_t = 1 - c~/k~^alpha
sA = 1 - cAtil ./ (kAtil.^alphaA);
sB = 1 - cBtil ./ (kBtil.^alphaB);

% Analytic steady-state sI* (Ch.7):  sI* = alpha*(gA + delta + gL)/(theta + delta + sigma*gA)
gL_A = nA;  gL_B = nB;
sA_star = alphaA * (gAA + deltaA + gL_A) / (thetaA + deltaA + sigmaA * gAA);
sB_star = alphaB * (gAB + deltaB + gL_B) / (thetaB + deltaB + sigmaB * gAB);

% ---- Plot savings rate paths ----
figure;
plot(t, sA, 'r-', 'LineWidth', 1.6); hold on;
plot(t, sB, 'b--','LineWidth', 1.6);
yline(1/sigmaA, ':', '1/\sigma_A','LineWidth',1.0);
yline(sA_star,  '--', 's_I^* (A)','LineWidth',1.0);
yline(1/sigmaB, ':', '1/\sigma_B','LineWidth',1.0);
yline(sB_star,  '--', 's_I^* (B)','LineWidth',1.0);
xlabel('Time'); ylabel('s_I(t)'); grid on;
title('Savings rate paths (efficiency units)');
legend('A: s_I(t)','B: s_I(t)','1/\sigma_A','s_I^* (A)','1/\sigma_B','s_I^* (B)','Location','best');

% ---- (Optional) Reconstruct level series if you want to plot them) ----
AA = A0A * (1 + gAA).^(t - 1);
AB = A0B * (1 + gAB).^(t - 1);
cA = cAtil .* (AA.^phiA);   kA = kAtil .* (AA.^phiA);   yA = (AA.^phiA) .* (kAtil.^alphaA);
cB = cBtil .* (AB.^phiB);   kB = kBtil .* (AB.^phiB);   yB = (AB.^phiB) .* (kBtil.^alphaB);

figure;
plot(t, log(cA), 'r-', 'LineWidth', 1.2); hold on;
plot(t, log(cB), 'b--','LineWidth', 1.2);
xlabel('Time'); ylabel('ln C_t'); grid on;
title('Log consumption (levels)'); legend('A','B','Location','best');
