
% computes measures of performance and dynamics as a
% function of the ratio of mean I-I to E-I connectivity called (dE)
% by changing the parameter sigma_w^E (sigma_w^I stays fixed)

close all
clear
clc

saveres=0;
showfig=0;

addpath([cd,'/code/function/'])
disp('computing measures as a function of ratio of sigma of decoding weights changing the spread of distribution of decoding weights for E neurons');

%% parameters

nsec=1;                                % duration of the trial in seconds 
dt=0.02;                               % time step in ms     

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio 
dI=3;                                  % spread of the distribution of decoding weights in I neurons     

sigma_s=2;                             % noise strength for the generation of the OU processes (stimulus features) 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
Ni=N/q;

%% compute measures

ntr=100;
devec=0.3:0.1:3;
n=length(devec);

frate=zeros(n,2);
CVs=zeros(n,2);

ms=zeros(n,2);
cost=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

for g=1:n
    disp(n-g)
    
    dE=devec(g);
    
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    rmse_tr=zeros(ntr,2);
    kappa_tr=zeros(ntr,2);
    
    for ii=1:ntr
        
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        [I_E,I_I,r,rmse,kappa,CV,fr] = current_fun_ratios(dt,sigmav,beta,tau_vec,s,N,Ni,dI,dE,x);
        
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
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dI'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dI},{dt},{nsec},{ntr}};
    
    savefile='result/ratios/';
    savename='measures_dE';
    save([savefile,savename],'devec','frate','CVs','ms','cost','r_ei','meanE','meanI','parameters','param_name')
end

%%
if showfig==1
    
    figure('units','centimeters','position',[0,0,16,20])
    subplot(4,1,1)
    hold on
    plot(devec,frate(:,1),'r')
    plot(devec,frate(:,2),'b')
    hold off
    ylabel('spikes/sec')

    subplot(4,1,2)
    plot(devec,CVs(:,1),'r')
    hold on
    plot(devec,CVs(:,2),'b')
    line([devec(1) devec(end)],[1 1])
    hold off
    ylabel('CV')
    box off
    
    subplot(4,1,3)
    plot(devec,ms(:,1),'r')
    hold on
    plot(devec,ms(:,2),'b')
    ylabel('MSE')
    box off
    
    subplot(4,1,4)
    plot(devec,cost(:,1),'r')
    hold on
    plot(devec,cost(:,2),'b')
    line([devec(1) devec(end)],[1 1])
    hold off
    ylabel('met. cost')
    xlabel('length selectivity vector in E (d^E)')
    box off
    
    
end
%%

