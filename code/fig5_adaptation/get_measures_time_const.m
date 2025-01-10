
% computes measures of performance  and dynamics as a
% function of a time constant of single neuron readout of E and I neurons (tau_re OR tau_ri)

close all
clear
clc

type=1;   % 1 or 2 for selecting the variable tau_re or tau_ri
computing=1; % 0 for testing, 1 for computing

ntype={'tau_re','tau_ri'};

if computing==1
    saveres=1;
    showfig=0;
else
    saveres=0;
    showfig=1;
end


disp(['computing measures as a function of ',ntype{type}])

addpath('code/function/')
%% parameters

nsec=1;                                % duration of the trial in seconds   
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables (stimulus features) 
N=400;                                 % number of E neurons                                  

sigma_s=2;                             % strength of the noise for defining the stimulus features (OU processes)
tau_s=10;                              % time constant of the stimuls (OU process)
tau_x=10;                              % time constant of the target signal  

tau_e=10;                              % time constant of the excitatory estimate
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons
    
sigmav=5;
beta=14;

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity   

%% simulate network activity

tic
if computing==1
    variable=[10:20,25,30:10:100,200:100:500]; 
    ntr=100;
else
    variable=[10,50,100];
    ntr=2;
end
n=length(variable);

rms=zeros(n,2);
cost=zeros(n,2);

frate=zeros(n,2);
CVs=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

for g=1:n
    disp(n-g+1)
    
    if type==1
        tau_re=variable(g);            % vary strength of adaptation in E   
        
    elseif type==2                     % vary strength of adaptation in I 
        tau_ri=variable(g);               
        
    end

    tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
   
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

param_name={{'N'},{'M'},{'beta'},{'tau_vec:X,E,I,rE,rI'},{'sigmav'},{'dt'},{'nsec'},{'q'},{'tau_s'},{'d'}};
parameters={{N},{M},{beta},{tau_vec},{sigmav},{dt},{nsec},{q},{tau_s},{d}};

if saveres==1
    
    savename=['measures_adaptation_',ntype{type}];
    savefile='result/adaptation/';
    save([savefile,savename],'rms','cost','frate','CVs','r_ei','meanE','meanI','variable','parameters','param_name')

end

%%

if showfig==1
    
    figure()
    subplot(2,1,1)
    plot(variable, rms(:,1),'r')
    hold on
    plot(variable, rms(:,2),'b')
    
    subplot(2,1,2)
    plot(variable, cost(:,1),'r')
    hold on
    plot(variable, cost(:,2),'b')

end
%}

