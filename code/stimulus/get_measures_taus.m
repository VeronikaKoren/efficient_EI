% computes measures of performance  and dynamics as a
% function of the time constant of the stimuli (OU processes)
% with the same time constant across M=3 features

clear
close all
clc

addpath([cd,'/code/function/'])
saveres=0;
showfig=0;

vari='tau_s';
disp(['computing measures as a function of ',vari]);

%% parameters

nsec=1;                                % duration of the trial in seconds 
dt=0.02;                               % time step in ms     

M=3;                                   % number of input features  
N=400;                                 % number of E neurons   

tau_x=10;                              % time constant of the target signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity 

sigma_s=2;                             % noise strength for the generation of the OU processes (stimulus features)

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% compute measures

ntr=100;
taus_vec=1:10:201;                      % time constant of stimulus features    

n=length(taus_vec);

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
    
    tau_s=taus_vec(g);
    
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
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/stimulus/';
    savename='measures_taus';
    save([savefile,savename],'taus_vec','rms','cost','frate','CVs','meanE','meanI','r_ei','parameters','param_name')
end

%%

if showfig==1
    
    figure('units','centimeters','position',[0,0,16,20])
    subplot(4,1,1)
    plot(taus_vec,rms(:,1),'r')
    hold on
    plot(taus_vec,rms(:,2),'b')
    ylabel('RMSE')
    box off

    subplot(4,1,2)
    hold on
    plot(taus_vec,cost(:,1),'r')
    plot(taus_vec,cost(:,2),'b')
    hold off
    ylabel('cost')
    
    subplot(4,1,3)
    plot(taus_vec,CVs(:,1),'r')
    hold on
    plot(taus_vec,CVs(:,2),'b')
    hold off
    ylabel('CV')
    box off
    
    
    subplot(4,1,4)
    hold on
    plot(taus_vec,r_ei(:,1),'r')
    plot(taus_vec,r_ei(:,2),'b')
    ylabel('\rho E & I currents')
    ylim([-1,0])
    xlabel(vari)
    
    %%
    figure()
    subplot(2,1,1)
    hold on
    plot(taus_vec,meanE(:,1),'k')
    plot(taus_vec,meanE(:,2),'b')
    plot(taus_vec,mean(meanE,2),'g')
    hold off
    ylabel('mean currents E')
    
    subplot(2,1,2)
    hold on
    plot(taus_vec,meanI(:,1),'r')
    plot(taus_vec,meanI(:,2),'b')
    plot(taus_vec,mean(meanI,2),'g')
    hold off
    ylabel('mean currents I')
    xlabel(vari)

end
%%

