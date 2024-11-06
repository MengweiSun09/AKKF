function [Sys,Tar, h] = Target_generation

Sys.N = 30; % Tracking sequence length

%% Motion model parameters
Sys.T = 1; % Sample time
Sys.F = [1 Sys.T 0 0; 0 1 0 0; 0 0 1 Sys.T;0 0 0 1]; %% Transition matrix

Sys.Phi = [0.5 1 0 0; 0 0 0.5 1].';
Sys.q = 10^(-2)^2; 
Sys.V = Sys.Phi * Sys.q * Sys.Phi.';

Sys.P0  = [0.1 0 0 0; 0 0.005 0 0; 0 0 0.1 0;0 0 0 0.01].^2; % State initilisation covariance matiex


%% Observation model parameters
Tar.h = @(x,y)  atan2(real(y), real(x));   % bearing only function
Sys.mes_noise_b = 0.005^2; % Bearing-only measurement noise variance
Tar.Z_noise = normrnd(0, sqrt(Sys.mes_noise_b), 1, Sys.N); % Measurement noise 

%% The first slot
n = 1;
Tar.X(:,n) = [-0.05 0.001 0.7 -0.055].'; % Hidden state: X_position; X_velocity; Y_position; Y_velocity
Tar.Z(1, n) = Tar.h(Tar.X(1,n), Tar.X(3,n)) + Tar.Z_noise(1,n);

%%
for n = 2 : Sys.N
    Tar.X(:,n) = Sys.F  * Tar.X(:,n-1) + mvnrnd(zeros(4,1), Sys.V).';
    Tar.Z(1,n) = Tar.h(Tar.X(1,n), Tar.X(3,n)) + Tar.Z_noise(1,n);
end

end


