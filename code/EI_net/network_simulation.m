% simulates and plots the optimal E-I network in one trial

close all
clear all
clc

savefig=0; % save figure?
addpath([cd,'/code/function/'])

%% parameters

nsec=1;                                % duration of the trial in seconds 
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons       

sigma_s=2;
tau_s=10;                              % time constant of the stimulus features  
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% get decoding weights and connectivity weights

[w,J] = w_fun(M,N,q,d);

%% set the stimulus features and the target signal

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

% constant stimulus
%{
s=ones(M,T).*1.6;
lambda=1/tau_x;
x=zeros(M,T);
for t=1:T-1
    x(:,t+1)=(1-lambda*dt)*x(:,t)+s(:,t)*dt;  
end
%}

%% simulate network

[fe,fi,xhat_e,xhat_i,re,ri] =net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J);

%% get performance

[rmse,kappa] = performance_fun(x,xhat_e,xhat_i,re,ri);
gL=0.7;
loss=gL*mean(rmse) + (1-gL).*mean(kappa);
display(loss, 'average loss')

%% spike count

sc_E=sum(mean(fe,1))./nsec;              % spikes/sec
sc_I=sum(mean(fi,1))./nsec;
display([sc_E,sc_I],'average spike count per second in E and I')

%% plot signal, estimates, spikes and pop. firing rate

figname='activity_optimal';
savefile='/Users/vkoren/ei_net/figure/implementation/';

pos_vec=[0,0,20,17];  % figure size
plt_network(x,xhat_e,xhat_i,fe,fi,re,ri,dt,tau_re,tau_ri,figname, savefig,savefile,pos_vec)


