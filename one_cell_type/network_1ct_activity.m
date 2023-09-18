% simple net with function

clear all
close all

savefig=0;
savefile=[cd,'/figure/'];
figname='activity_1ct';

disp('computing MSE for the network with 1 cell type')
%% parameters

nsec=1;                     % simulation length in seconds

M=10;                        % number of inputs
N=400;
tau=10;                     % time constant of the membrane potential

b=1.5;
c=33;

nu=0;                       % linear cost
beta=b*log(N);                % quadratic cost
sigmav=c/log(N);            % standard deviation of the noise


dt=0.02;                    % time step  

%% signal

sigma_s=2;
tau_s=10;
tau_x=10;
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% simulate network activity
  
T=nsec*1000/dt;
[xhat,f,r] =network_1pop_fun(N,s,dt,tau,beta,sigmav);

frate=sum(sum(f))/(N*nsec);           % average nb.spikes/sec
rmse=sqrt(mean(sum((x-xhat).^2,2)./T));        % mean squared error

display(rmse,'mean squared error');
display(frate,'mean firing rate');

%% plot signal, estimate and spikes

pos_vec=[0,0,20,15];
plt_1pop_network(x,xhat,f,r,dt,tau,pos_vec,savefig,savefile,figname)
%}

