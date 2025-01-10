
% computes measures of performance  and dynamics for the network with
% random jittering ot he connectivity (type=1),
% network with fully removed connectivity structure (type=2) and partially removed
% connectivity structure (type=3)
% OU stimulus

clear
close all
clc

type=3;
namet={'perturbation','perm_full','perm_partial'};
saveres=0;

addpath([cd,'/code/function/'])
disp(['computing measures with ',namet{type}]);

%% parameters

tic
ntr=200;

nsec=1;                                % duration of the trial in seconds 
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons       

tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity 

tau_s=10;                              % time constant of the stimulus features  
sigma_s=2;                             % noise strength for the generation of the OU processes (stimulus features) 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re,tau_ri);
which_permuted={'I to I','E to I','I to E','all'};      % which matrix is shuffled

%% compute performance with noise in the connectivity

if type==1                  % jittering of connectivity
    fvec=0:0.025:0.6;
else
    fvec=[2,3,4,5];
end

n=length(fvec);

frate=zeros(n,2);
CVs=zeros(n,2);

ms=zeros(n,2);
cost=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

for g=1:n
    disp(n-g)
    
    f=fvec(g);
    
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    rmse_tr=zeros(ntr,2);
    kappa_tr=zeros(ntr,2);
    
    for ii=1:ntr
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        [I_E,I_I,r,rmse,CV,fr,kappa] = current_fun_unstructured(dt,sigmav,beta,tau_vec,s,N,q,d,x,f,type);
        
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
toc

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/structure/';
    savename=['measures_',namet{type}];
    save([savefile,savename],'fvec','frate','CVs','ms','cost','r_ei','meanE','meanI','which_permuted','parameters','param_name')
end


