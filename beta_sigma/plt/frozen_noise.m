% for the plot of the activity

%close all
clear all
%clc

savefig=0;
addpath([cd,'/code/function/'])

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=0.5;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_fe=10;                             % t. const firing rate of E neurons
tau_fi=10;                             % t. constant firing rate of I neurons 
   
b=1.0;                                   % sets the strength of the regularizer     
c=33;                                  % sets the strength of the noise 
beta=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % noise intensity

dt=0.02;                               % time step in ms     
q=4;                                 % ratio number E to I neurons
d=3;                                   % ratio IPSP/EPSP 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_fe, tau_fi);

%% set the input

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);

[w,J] = w_fun(M,N,q,d);

xi_e=randn(N,T);
xi_i=randn(N/q,T);

%% simulate network activity

spikes=cell(2,1);
est=cell(2,1);
for ii=1:2
    [ye,yi,xhat_e,xhat_i,fe,fi] =net_fun_frozen(dt,sigmav,beta,tau_vec,s,w,J,xi_e,xi_i);
    spikes{ii}=ye
    est{ii}=xhat_e;
end

%% plot spikes and signal in E 


type=2;
figname=['frozen_noise_N',sprintf('%1.0i',N)];
savefile=[cd,'/figure/beta_sigma/'];

pos_vec=[0,0,15,12];
%plt_frozen(spikes,dt,figname, savefig,savefile,pos_vec)
plt_2trials(spikes,est,dt,figname, savefig,savefile,pos_vec,type)

