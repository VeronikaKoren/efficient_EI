% to measure the metabolic cost and the firing rate in the E-I network

close all
clear all
clc

saveres=0;
addpath([cd,'/function/'])

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=3;
c=33;
mu=b*log(N);                             % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;

sigma_s=2;
tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% set the input

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% simulate network activity in trials (with different realization of random variables)

ntr=100;

tic

Rmse=zeros(2,ntr);
cost=zeros(2,ntr);
sc=zeros(2,ntr);
for tr=1:ntr
    
    [w,C] = w_fun(M,N,q,d);             % selectivity weights and synaptic weights
    [fe,fi,xhat_e,xhat_i,re,ri] = net_fun_complete(dt,sigmav,mu,tau_vec,s,w,C);

    sc_E=sum(mean(fe,1))./nsec;              % spike count in 1 sec
    sc_I=sum(mean(fi,1))./nsec;
    sc(:,tr)=cat(1,sc_E,sc_I);

    [rmse,kappa] = performance_fun(x,xhat_e,xhat_i,re,ri);
    Rmse(:,tr)=rmse;
    cost(:,tr)=kappa;

end
toc

%% save result?

if saveres==1
    savefile='result/connectivity/';
    savename='cost_sc_ei';
    save([savefile,savename],'Rmse','cost','sc');
end