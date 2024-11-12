 
clear all
close all

computing=1;   % testing or computing?

if computing==1
    saveres=1;
    showfig=0;
    disp('computing random parameter search for all relevant parameters; continuous');
else
    saveres=0;
    showfig=1;
    disp('testing random parameter search for all relevant parameters; continuous');
end

%% parameters

nsec=1;                               % duration of the trial in seconds   
dt=0.02;                               % time step in ms 

M=3; 
N=400;                                 % number of E neurons                                  

sigma_s=2;                             % sigma of the stimulus (OU process)
tau_s=10;                              % time constant of the stimuls (OU process)
tau_x=10;                              % time constant of the target signal  

tau_e=10;                              % time constant of the excitatory estimate
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
 
beta=14;                               % quadratic cost constant
sigmav=5; 

q=4;                                   % ratio of weight amplitudes I to E 
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
addpath([cd,'/code/function/'])

%% parameter ranges

param0=[sigmav, beta, tau_re, tau_ri,q,d]';  % parameter values to initialize
np=length(param0);                                  % number of parameters 
list_tested={'sigmav','beta','tau_re','tau_ri','q','d'};
range={[1,10];[2,29];[5,50];[5,50];[1,8];[1,8]}; % all parameter ranges

%% 

if computing==0
    ntr=5;
    nmc=20;
else
    ntr=20;    % number of trials
    nmc=10000; % number of random searches
end


%% get parameter configurations

theta_all=zeros(np,nmc+1);
theta_all(:,1)=param0;

for p=[1:4,6]
    for g=1:nmc
        theta_all(p,g+1)= unifrnd(range{p}(1),range{p}(2));
    end
    
end

%% ratio of neurons cannot take all numbers

 deltaq=N/(N-1) - 1;
 qrange=range{5}(1):deltaq:range{5}(2);
 nq=length(qrange);

 for g=1:nmc
     [~,idxq]=sort(randn(1,nq));
     theta_all(5,g+1)=qrange(idxq(1));
 end
 
%%

rmse_tr=zeros(nmc+1,ntr,2);
cost_tr=zeros(nmc+1,ntr,2);

tic
for g=1:nmc+1
    
    disp(nmc+1 - g)
    theta=theta_all(:,g);
    tau_vec=cat(1,tau_x,tau_e,tau_i,theta(3), theta(4));

    %rmse_tr=zeros(ntr,2);
    %kappa_tr=zeros(ntr,2);

    for ii=1:ntr

        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);      
        [rmse,kappa] = net_mc_fun(dt,theta(1),theta(2),tau_vec,s,N,theta(5),theta(6),x);

        rmse_tr(g,ii,:)=rmse;
        cost_tr(g,ii,:)=kappa;

    end

    %rms(g,:)=mean(rmse_tr);
    %cost(g,:)=mean(kappa_tr);
    
end
toc

gL=0.7;
rms=squeeze(mean(rmse_tr,2));
cost=squeeze(mean(cost_tr,2));
loss=mean(gL.*rms + ((1-gL).*cost),2);
[~,idx_min_loss]=min(loss);
display(idx_min_loss,'index with minimal loss')

%%

if saveres==1
    %%

    param_name={{'N'},{'M'},{'tau_s'},{'tau_x'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{tau_x},{dt},{nsec},{ntr}};
    
    savefile=[cd,'/result/global/'];
    savename='performance_mc_cont';
    save([savefile,savename],'theta_all','rmse_tr','cost_tr','loss','parameters','param_name','range','list_tested')
    disp('saved result')
end

%%

if showfig==1
%%
    figure('units','centimeters','position',[0,0,16,16])
    
    plot(1:nmc+1,log(loss))
    ylabel('log(loss)')
    xlabel('iteration index')

    cit1=5
    loss1=mean(squeeze((gL.*rmse_tr(cit1,:,:)) + ((1-gL).*cost_tr(cit1,:,:))),2);
    cit2=10;
    loss2=mean(squeeze((gL.*rmse_tr(cit2,:,:)) + ((1-gL).*cost_tr(cit2,:,:))),2);

    hold on
    boxplot(log([loss1,loss2]),'Positions',[cit1,cit2])
    %boxplot(log(squeeze(rmse_tr(5,:,:))),{'E','I'},'Positions',[5,6])
    %boxplot(log(squeeze(rmse_tr(10,:,:))),{'E','I'},'Positions',[10,11])
    %hold on
    hold off
    xlim([0,nmc+1])
    title('loss in randomly sampled parameter configurations')
    ylabel('log(error)')
    xlabel('iteration index')
end
%%

