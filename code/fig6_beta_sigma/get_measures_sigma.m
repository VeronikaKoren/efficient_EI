
% computes measures of performance  and dynamics as a
% function of the noise strength sigma

clear
close all
clc

saveres=0;

disp('computing measures as a function of sigma');
addpath([cd,'/code/function/'])

%% parameters

nsec=1;                                % duration of the trial in seconds 
dt=0.02;                               % time step in ms   

M=3;                                   % number of encoded variables             
N=400;                                 % number of E neurons   

sigma_s=2;                             % strength of the noise for generating the stimulus features (OU processs)
tau_s=10;                              % time constant of the stimuls (OU process)
tau_x=10;                              % time constant of the target signal

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                              % time const single neuron readout in E neurons
tau_ri=10;                              % time const single neuron readout in E neurons
   
beta=14;                               % metabolic constant

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% compute measures

ntr=100;
sigma_vec=0:1:25;                      

n=length(sigma_vec);

rms=zeros(n,2);
cost=zeros(n,2);

frate=zeros(n,2);
CVs=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

tic
for g=1:n
    disp(n-g)
    
    sigmav=sigma_vec(g);
   
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
    
    rms(g,:)=mean(rmse_tr);
    cost(g,:)=mean(kappa_tr);
    
    frate(g,:)=mean(fr_tr);
    CVs(g,:)=mean(CV_tr);

    r_ei(g,:)=mean(r_tr);
    meanE(g,:)=mean(currE_tr);
    meanI(g,:)=mean(currI_tr);

end
toc
%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/beta_sigma/';
    savename='measures_sigma';
    save([savefile,savename],'sigma_vec','rms','cost','frate','CVs','meanE','meanI','r_ei','parameters','param_name')
end

