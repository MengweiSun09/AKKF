function [AKKF] = AKKF_track(Sys, Tar, AKKF)

%% 0. AKKF parameters setting
AKKF.c = 1; %
AKKF.lambda = 10^(-3);  % kernel normisation parameter
AKKF.lambda_KKF = 10^(-3);  % kernel normisation parameter for Kernel Kalman filter gain calculation
AKKF.poly_para_b = 10^(0); % polynomial triack scale for the bearing tracking
AKKF.Var_Gaussian = 0.1;

tic
%% 1. n = 1

%% 1.1 Prediction

% Data space
n = 1;
AKKF.X_P(:,:,n) = mgd(AKKF.N_P, 4, Tar.X(:,n), Sys.P0).'; % state particles

% Kernel space
AKKF.W_minus(:,n) = ones(AKKF.N_P, 1)/AKKF.N_P;
AKKF.S_minus(:,:,n) = eye(AKKF.N_P)/AKKF.N_P;

AKKF.W_plus(:,n) = ones(AKKF.N_P, 1)/AKKF.N_P;
AKKF.S_plus(:,:,n) = eye(AKKF.N_P)/AKKF.N_P;

AKKF.X_P_proposal(:,:,n) =  AKKF.X_P(:,:,n);

AKKF.X_est(:,n) = AKKF.X_P(:,:,n) * AKKF.W_plus(:,n); %state mean
AKKF.X_C(:,:,n) =   AKKF.X_P(:,:,n) * AKKF.S_plus(:,:,n) * AKKF.X_P(:,:,n).'; %state covariance



%% 1.2 Update
[AKKF] = AKKF_update(Sys, Tar, AKKF, n);

%% 1.3 Proposal
[AKKF] = AKKF_proposal(Sys, Tar, AKKF, n);


%% 2. n = 1:Tar.N
for n = 2 : Sys.N
    [AKKF] = AKKF_predict(Sys, Tar, AKKF, n);
    [AKKF] = AKKF_update(Sys, Tar, AKKF, n);
    [AKKF] = AKKF_proposal(Sys, Tar, AKKF, n);
end

AKKF.Computation_time = toc;
AKKF.LMSE = log10(sum(sum((Tar.X([1,3],:) - AKKF.X_est([1,3],:)).^2))/Sys.N);


end




