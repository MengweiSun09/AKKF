function [PF] = PF_track(Sys, Tar, PF)

tic
%% 1. n = 1
n = 1;
PF.X_P(:,:,n) = mgd(PF.N_P, 4, Tar.X(:,n), Sys.P0).'; % state particles

for n_p = 1 : PF.N_P
    PF.W_prior(n_p,n) = mvnpdf(PF.X_P(:,n_p,n), Tar.X(:,n), Sys.P0);
end

[PF] = PF_update(Sys, Tar, PF, n);
[PF] = PF_resample(Sys, Tar, PF, n);

%% 2. n = 1:Tar.N
for n = 2 : Sys.N
    PF.X_P(:,:,n) = Sys.F * PF.X_P(:,:,n-1) + mgd(PF.N_P,4,zeros(4,1),Sys.V).'; % hidden states particles
    PF.W_prior(:,n)=  PF.W_pos(:,n-1);

    [PF] = PF_update(Sys, Tar, PF, n);
    [PF] = PF_resample(Sys, Tar, PF, n);
end
PF.Computation_time = toc;
PF.LMSE = log10(sum(sum((Tar.X([1,3],:) - PF.X_est([1,3],:)).^2))/Sys.N);
end


function [PF] = PF_update(Sys, Tar, PF, n)
for n_p = 1 : PF.N_P
    PF.Z_P(n,n_p) = Tar.h(PF.X_P(1,n_p,n), PF.X_P(3,n_p,n));
    W_P_tem(n_p, n) = mvnpdf(Tar.Z(1,n), PF.Z_P(n,n_p), Sys.mes_noise_b) * PF.W_prior(n_p,n); %weight
end

PF.W_pos(:,n) =  W_P_tem(:, n)/sum(W_P_tem(:, n)); % weight normilisation
end

function [PF] = PF_resample(Sys, Tar, PF, n)

%% Estimation
PF.X_est(:,n) = PF.X_P(:,:,n) * PF.W_pos(:,n); %state mean

%% Resample
Neff = 1/(sum(PF.W_pos(:,n).^2)); % Test effective particle size
if Neff < 0.85 * size(PF.W_pos(:,n),1)
   X_P_PF_update(:,:,n) = zeros(4, PF.N_P);
   L = cumsum(PF.W_pos(:,n));
   for i = 1 : PF.N_P
       X_P_PF_update(:,i,n) = PF.X_P(:,find(rand <= L,1),n);
   end
   PF.W_pos(:,n) = ones(PF.N_P, 1) * 1./PF.N_P;
else
   PF.W_pos(:,n) = PF.W_pos(:,n);
   X_P_PF_update(:,:,n)= PF.X_P(:,:,n);
end

PF.X_P(:,:,n) = X_P_PF_update(:,:,n);

end