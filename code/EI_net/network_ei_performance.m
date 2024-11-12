% to measure the metabolic cost and the firing rate in the E-I network

close all
clear all
clc

saveres=0;
addpath([cd,'/code/function/'])

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
   
%b=2.18;
%c=30;

beta=14;                             % quadratic cost constant
sigmav=5;                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=3.75;
d=3;

sigma_s=2;
tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%T=(nsec*1000)./dt;
%% simulate network activity in trials (with different realization of random variables)

ntr=100;

tic

rmse=zeros(2,ntr);
cost=zeros(2,ntr);
sc=zeros(2,ntr);
for tr=1:ntr
    
    disp(ntr-tr)
    [w,J] = w_fun(M,N,q,d);             % selectivity weights and synaptic weights
    [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    [fe,fi,xhat_e,xhat_i,re,ri] = net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J);

    sc_E=sum(mean(fe,1))./nsec;              % spike count in 1 sec
    sc_I=sum(mean(fi,1))./nsec;
    sc(:,tr)=cat(1,sc_E,sc_I);

    [rms,kappa] = performance_fun(x,xhat_e,xhat_i,re,ri);
    rmse(:,tr)=rms;
    cost(:,tr)=kappa;


end
toc

%% save result?

if saveres==1
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{d},{dt},{nsec},{ntr}};

    savefile='result/implementation/';
    savename='loss_measures_optimal_ei';
    save([savefile,savename],'rmse','cost','sc','param_name','parameters','ntr');
end


