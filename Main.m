%% Author: Mengwei Sun Edinburgh University UDRC Project
%% Related Paper: Adaptive Kernel Kalman Filter
%% Time: 08/03/2023
%% Object: AKKF for single target tracking --- Adaptive Kernel Kalman Filter
%% Motion model: Nearly constant velocity (NCV) model
%% Measurement model: Bearing-only tracking (BOT) model 


warning('off','all');
warning;
clear;
clc;close all
dbstop if error

%% Customer input
msg = "Choose the kernel type";
opts = ["Quadratic" "Quartic" "Gaussian"];
AKKF.kernel = menu(msg,opts);

msg = "Choose the number of particles for the AKKF";
opts = ["20" "50" "100" "200"];
choice = menu(msg,opts);
N_P_AKKF_set = [20,50,100,200];
AKKF.N_P = N_P_AKKF_set(choice);

msg = "Choose the number of particles for the PF";
opts = ["Same as the AKKF" "Benchmark (2000)"];
choice = menu(msg,opts);
N_P_PF_set = [AKKF.N_P,2000];
PF.N_P = N_P_PF_set(choice);

%% 1. System parameter setting & Target trajecroty generation  
[Sys, Tar] = Target_generation;

%% 2. AKKF filter (Quadratic Kernel)
[AKKF] = AKKF_track(Sys, Tar, AKKF);

%% 3.PF filter 
[PF] = PF_track(Sys, Tar, PF);

%% 3. Tracking performance
Tracking_performance(Sys, Tar, AKKF, PF);

tdata =[AKKF.LMSE; PF.LMSE; AKKF.Computation_time; PF.Computation_time];
h = {'AKKF LMSE', 'PF LMSE', 'AKKF computation time (s)', 'PF computation time (s)'};
fig = uifigure('Position',[500 500 570 360]);
uit = uitable(fig);
uit.Data = tdata;
uit.RowName = h;
uit.ColumnName = {'Value'};
