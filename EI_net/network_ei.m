% plot of the activity in one trial

%close all
clear all
%clc

savefig=0;
addpath([cd,'/function/'])
%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=1;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_fe=10;                             % t. const firing rate of E neurons
tau_fi=10;                             % t. constant firing rate of I neurons 
   
b=1.0;                                   % sets the strength of the regularizer     
c=33;                                  % sets the strength of the noise 
mu=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % noise intensity

dt=0.02;                               % time step in ms     
q=4;                                   % ratio number E to I neurons
d=3;                                   % ratio spread of weights I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_fe, tau_fi);

sigma_s=2;                              % STD of input features
%% set the input, selectivity weigths and connectivity

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

[w,J] = w_fun(M,N,q,d);

%% simulate network activity

[fe,fi,xhat_e,xhat_i,re,ri] =net_fun_complete(dt,sigmav,mu,tau_vec,s,w,J);

%%
sc_E=sum(mean(fe,1))./nsec;              % spikes/sec
sc_I=sum(mean(fi,1))./nsec;
display([sc_E,sc_I],'average spike count per second in E and I')

%% nice plot signal and E estimate, spikes and pop. firing rate

figname='activity22';
savefile='/Users/vkoren/ei_net/figure/implementation/';

pos_vec=[0,0,20,17];
plt_network(x,xhat_e,xhat_i,fe,fi,re,ri,dt,tau_fe,tau_fi,figname, savefig,savefile,pos_vec)


