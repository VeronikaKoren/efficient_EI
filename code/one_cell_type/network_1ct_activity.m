% simple net with function

clear all
close all

savefig=1;
savefile='/Users/vkoren/ei_net/figure/implementation/';
figname='activity_1ct';

display('computing spiking activity of the 1CT network ')

addpath([cd,'/function/'])
%% parameters

nsec=1;                     % simulation length in seconds

M=10;                        % number of inputs
N=400;
tau=10;                     % time constant of the membrane potential


nu=0;                       % linear cost
beta=11.4                % quadratic cost
sigmav=1.84            % standard deviation of the noise

sigma_s=2;
dt=0.02;                    % time step  

%% external input and signal

%loadname='estimate_non_rectified'; 
%load(loadname,'s','x')
tau_s=10;
tau_x=10;
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% simulate network activity
  
T=nsec*1000/dt;
[xhat,f,r] =network_1pop_fun(N,s,dt,tau,beta,nu,sigmav);

frate=sum(sum(f))/(N*nsec);           % average nb.spikes/sec
rmse=sqrt(mean(sum((x-xhat).^2,2)./T));        % mean squared error
%time_upstate=sum(sum(y)>(N/10));      % time in upstate

display(rmse,'mean squared error');
display(frate,'firing rate');

%% plot signal, estimate and spikes

pos_vec=[0,0,20,15];
plt_1ct_activity(x,xhat,f,r,dt,tau,pos_vec,savefig,savefile,figname)
%}

