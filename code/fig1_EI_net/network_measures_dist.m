
% gets measures of dynamics of the optimal E-I network across trials 

close all
clear
clc

saveres=0;
addpath([cd,'/code/function/'])

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=20;                               % duration of the trial in seconds 

tau_s=10;                              % time constant of the stimulus features 
tau_x=10;                              % time constant of the targets  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons
   
beta=14;                               % quadratic cost constant
sigmav=5;                              % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;                                   % E-I ratio 
d=3;                                   % ratio of mean I-I to E-I connectivity 

sigma_s=2;                             % strength of the noise for the OU process (to define stimulus feature)
tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

Ni=N/q;                                 % number of I neurons
%% simulate network activity in trials (with different realization of random variables)

ntr=10;

tic

re_tr=zeros(ntr,N);
ri_tr=zeros(ntr,Ni);

Ie_tr=zeros(ntr,N,2);
Ii_tr=zeros(ntr,Ni,2);

fre_tr=zeros(ntr,N);
fri_tr=zeros(ntr,Ni);

CVe_tr=zeros(ntr,N);
CVi_tr=zeros(ntr,Ni);

for tr=1:ntr
    
    disp(ntr-tr)
    
    [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    [Ie,Ii,re,ri,CVe,CVi,fre,fri] = current_fun_distributions(dt,sigmav,beta,tau_vec,s,N,q,d);

    
    Ie_tr(tr,:,:)=Ie;
    Ii_tr(tr,:,:)=Ii;

    re_tr(tr,:)=re;
    ri_tr(tr,:)=ri;

    CVe_tr(tr,:)=CVe;
    CVi_tr(tr,:)=CVi;

    fre_tr(tr,:)=fre;
    fri_tr(tr,:)=fri;
    
end
toc

%% save result?

if saveres==1
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{d},{dt},{nsec},{ntr}};

    savefile='result/EI_net/';
    savename='activity_measures_distribution';
    save([savefile,savename],'fre_tr','CVe_tr','re_tr','Ie_tr','fri_tr','CVi_tr','ri_tr','Ii_tr','param_name','parameters','ntr');
    disp('saved')
end

%%




