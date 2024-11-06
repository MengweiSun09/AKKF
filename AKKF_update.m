function [AKKF] = AKKF_update(Sys, Tar, AKKF, n)

%% Data space
for n_p = 1 : AKKF.N_P    
    Z_P_tem(n,n_p) = Tar.h(AKKF.X_P(1,n_p,n), AKKF.X_P(3,n_p,n));  %bearing
end

AKKF.Z_P(n,:) = Z_P_tem(n,:) + normrnd(0, sqrt(Sys.mes_noise_b), 1, AKKF.N_P);

%% Kernel Space
if AKKF.kernel == 1 %Quadratic
    G_yy = (AKKF.Z_P(n,:).' * AKKF.Z_P(n,:)/AKKF.poly_para_b + AKKF.c * ones(AKKF.N_P, AKKF.N_P)).^2;
    g_y(:,n) = (AKKF.Z_P(n,:).' * Tar.Z(1,n)/AKKF.poly_para_b + AKKF.c * ones(AKKF.N_P, 1)).^2;
elseif  AKKF.kernel == 2  %Quartic
    G_yy = (AKKF.Z_P(n,:).' * AKKF.Z_P(n,:)/AKKF.poly_para_b + AKKF.c * ones(AKKF.N_P, AKKF.N_P)).^4;
    g_y(:,n) = (AKKF.Z_P(n,:).' * Tar.Z(1,n)/AKKF.poly_para_b + AKKF.c * ones(AKKF.N_P, 1)).^4;
else %Gaussian
    G_yy = exp(-(AKKF.Z_P(n,:).' - AKKF.Z_P(n,:)).^2/(2 * AKKF.Var_Gaussian))/(sqrt(2 * pi * AKKF.Var_Gaussian));
    g_y(:,n)  = exp(-(AKKF.Z_P(n,:).' - Tar.Z(1,n)).^2/(2 * AKKF.Var_Gaussian))/(sqrt(2 * pi * AKKF.Var_Gaussian));
end

Q_KKF = AKKF.S_minus(:,:,n) * inv(G_yy * AKKF.S_minus(:,:,n) + AKKF.lambda_KKF * eye(AKKF.N_P));
AKKF.W_plus(:,n) = AKKF.W_minus(:,n) + Q_KKF * (g_y(:, n) - G_yy *  AKKF.W_minus(:,n));
AKKF.S_plus(:,:,n) = AKKF.S_minus(:,:,n) - Q_KKF * G_yy * AKKF.S_minus(:,:,n);

end