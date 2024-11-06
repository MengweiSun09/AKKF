function [AKKF] = AKKF_predict(Sys, Tar, AKKF, n)

%% Data space
AKKF.X_P(:,:,n) = Sys.F * AKKF.X_P_proposal(:,:,n-1)...
    + mgd(AKKF.N_P,4,zeros(4,1),Sys.V).';  % hidden states particles

%% Kernel Space

if AKKF.kernel == 1 %Quadratic
    K_tilde_tilde = (AKKF.X_P_proposal(:,:,n-1).' * AKKF.X_P_proposal(:,:,n-1)/AKKF.poly_para_b...
        + AKKF.c * ones(AKKF.N_P, AKKF.N_P)).^2;
    K_tilde_nontilde = (AKKF.X_P_proposal(:,:,n-1).' * AKKF.X_P(:,:,n-1)/AKKF.poly_para_b...
        + AKKF.c * ones(AKKF.N_P, AKKF.N_P)).^2;
elseif  AKKF.kernel == 2  %Quartic
    K_tilde_tilde = (AKKF.X_P_proposal(:,:,n-1).' * AKKF.X_P_proposal(:,:,n-1)/AKKF.poly_para_b...
        + AKKF.c * ones(AKKF.N_P, AKKF.N_P)).^4;
    K_tilde_nontilde = (AKKF.X_P_proposal(:,:,n-1).' * AKKF.X_P(:,:,n-1)/AKKF.poly_para_b...
        + AKKF.c * ones(AKKF.N_P, AKKF.N_P)).^4;
else %Gaussian
    for nn = 1:4
        diff_tilde_tilde(:,:,nn) = (AKKF.X_P_proposal(nn,:,n-1).' - AKKF.X_P_proposal(nn,:,n-1)).^2;
        diff_tilde_nontilde(:,:,nn) = (AKKF.X_P_proposal(nn,:,n-1).' - AKKF.X_P(nn,:,n-1)).^2;
    end

    diff_tilde_tilde_sum = sum(diff_tilde_tilde, 3);
    diff_tilde_nontilde_sum = sum(diff_tilde_nontilde, 3);

    K_tilde_tilde = exp(-diff_tilde_tilde_sum/(2 * AKKF.Var_Gaussian))/(sqrt(2 * pi * AKKF.Var_Gaussian));
    K_tilde_nontilde  = exp(-diff_tilde_nontilde_sum/(2 * AKKF.Var_Gaussian))/(sqrt(2 * pi * AKKF.Var_Gaussian));
end

% K_tilde_tilde = AKKF.X_P_proposal(:,:,n-1).' * AKKF.X_P_proposal(:,:,n-1);
% K_tilde_nontilde = AKKF.X_P_proposal(:,:,n-1).' * AKKF.X_P(:,:,n-1);


T =  inv( K_tilde_tilde + AKKF.lambda * eye(AKKF.N_P) ) * K_tilde_nontilde; %Transition matrix

AKKF.W_minus(:,n) = T * AKKF.W_plus(:,n-1); % Predictive kernel weight mean

V = (inv(K_tilde_tilde + AKKF.lambda * eye(AKKF.N_P)) * K_tilde_tilde - eye(AKKF.N_P)) ...
    *(inv(K_tilde_tilde + AKKF.lambda * eye(AKKF.N_P)) * K_tilde_tilde - eye(AKKF.N_P)).' /AKKF.N_P;

AKKF.S_minus(:,:,n) = T * AKKF.S_plus(:,:,n-1) * T.' + V; % Predictive kernel weight covariance


end