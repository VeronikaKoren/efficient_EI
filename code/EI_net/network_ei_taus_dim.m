% for the plot of the activity

close all
clear all
%clc

savefig=0;
figname='activity_3taus';
addpath([cd,'/code/function/'])

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=1;                                % duration of the trial in seconds 

sigma_s=2;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 
tau_re=10;                             % t. const of E neurons
tau_ri=10;                             % t. constant of I neurons 
                                       
beta=14;                               % quadratic cost constant
sigmav=5;                              % noise intensity

dt=0.02;                               % time step in ms     
q=4;                                   % ratio number E to I neurons
d=3;                                   % ratio IPSP/EPSP 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
taus_vec=[10,50,300]';               % time constant of the stimulus in dimensions 1, 2 and 3

%% set the input

T=(nsec*1000)./dt;
[s,x]=signal_taus_fun(taus_vec,sigma_s,tau_x,M,nsec,dt);

[w,J] = w_fun(M,N,q,d);

%% simulate network activity

[fe,fi,xhat_e,xhat_i,re,ri] =net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J);

%% performance

[rmse,kappa] = performance_fun(x,xhat_e,xhat_i,re,ri);
gL=0.7;
loss=gL*mean(rmse) + (1-gL).*mean(kappa);
display(loss, 'average loss')

%%
sc_E=sum(mean(fe,1))./nsec;              % spikes/sec
sc_I=sum(mean(fi,1))./nsec;
display([sc_E,sc_I],'average spike count per second in E and I')

%% nice plot signal and E estimate, spikes and pop. firing rate

savefile='/Users/vkoren/ei_net/figure/implementation/';

pos_vec=[0,0,20,17];
plt_network_taus(x,xhat_e,xhat_i,fe,fi,re,ri,dt,tau_re,tau_ri,figname, savefig,savefile,pos_vec,taus_vec)


