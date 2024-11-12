% to measure the metabolic cost and the firing rate in the E-I network

close all
clear all
clc

saveres=1;
addpath([cd,'/code/function/'])

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
beta=14;                             % quadratic cost constant
sigmav=5;                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

as=1.6; % strength of the constant sitmulus

%% define constant stimulus and compute the target signal

T=(nsec*1000)./dt;

s=ones(M,T).*as;
lambda=1/tau_x;
x=zeros(M,T);
for t=1:T-1
    x(:,t+1)=(1-lambda*dt)*x(:,t)+s(:,t)*dt;  
end
%% simulate network activity in trials (with different realization of random variables)

ntr=200;

tic

r_tr=zeros(ntr,2);
currE_tr=zeros(ntr,2);
currI_tr=zeros(ntr,2);

fr_tr=zeros(ntr,2);
CV_tr=zeros(ntr,2);
for tr=1:ntr
    
    disp(ntr-tr)
    [w,J] = w_fun(M,N,q,d);             % selectivity weights and synaptic weights
    %[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    [I_E,I_I,r,~,~,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x);

    currE_tr(tr,:)=I_E;
    currI_tr(tr,:)=I_I;
    r_tr(tr,:)=r;

    CV_tr(tr,:)=CV;
    fr_tr(tr,:)=fr;
    
end
toc

%% save result?

if saveres==1
    param_name={{'N'},{'M'},{'as'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{as},{beta},{sigmav},{tau_vec},{q},{d},{dt},{nsec},{ntr}};

    savefile='result/implementation/';
    savename='activity_measures_const_stim';
    save([savefile,savename],'fr_tr','CV_tr','r_tr','currE_tr','currI_tr','param_name','parameters','ntr');
end


