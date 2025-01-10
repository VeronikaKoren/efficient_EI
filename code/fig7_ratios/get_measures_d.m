% computes measures of performance and dynamics as a
% function of the ratio of mean I-I to E-I connectivity (called d)
% by changing the parameter sigma_w^I (sigma_w^E stays fixed)

clear
close all
clc

addpath([cd,'/code/function/'])
saveres=0;

disp('computing measures as a function of d=ratio of sigmas of decoding weights');

%% parameters

nsec=10;                                % duration of the trial in seconds
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
 

tau_s=10;
tau_x=10;                              % time constant of the targets   

tau_e=10;                              % time constant of the excitatory estimates  
tau_i=10;                              % time const I estimates 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength
    
q=4;                                   % E-I ratio

sigma_s=2;                             % noise strength for the generation of the OU processes (stimulus features)

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% compute measures

ntr=100;
dvec=1:0.25:8;
n=length(dvec);

frate=zeros(n,2);
CVs=zeros(n,2);

ms=zeros(n,2);
cost=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

for g=1:n
    disp(n-g)
    
    d=dvec(g);
    
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    rmse_tr=zeros(ntr,2);
    kappa_tr=zeros(ntr,2);
    
    for ii=1:ntr
        
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        [I_E,I_I,r,rmse,kappa,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x);
        
        rmse_tr(ii,:)=rmse;
        kappa_tr(ii,:)=kappa;
       
        currE_tr(ii,:)=I_E;
        currI_tr(ii,:)=I_I;

        r_tr(ii,:)=r;
        CV_tr(ii,:)=CV;
        fr_tr(ii,:)=fr;
        
    end
    
    r_ei(g,:)=mean(r_tr);
    meanE(g,:)=mean(currE_tr);
    meanI(g,:)=mean(currI_tr);

    frate(g,:)=mean(fr_tr);
    CVs(g,:)=mean(CV_tr);

    ms(g,:)=mean(rmse_tr);
    cost(g,:)=mean(kappa_tr);
    
end

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/ratios/';
    savename='measures_d';
    save([savefile,savename],'dvec','frate','CVs','ms','cost','r_ei','meanE','meanI','parameters','param_name')
end
