
clear all
close all

addpath([cd,'/code/function/'])
computing=0;

if computing ==1
    saveres=1;
    showfig=0;
else
    saveres=0;
    showfig=1;
end

disp('computing measures as a function of time constant of the target');

%% parameters

M=3;
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

sigma_s=2;
tau_s=10;


tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   

beta=14;                           % quadratic cost constant
sigmav=5;                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;                                   % ratio of weight amplitudes I to E 
d=3;

%% compute measures

if computing==1
    ntr=100;
    tauxvec=1:50;
else
    ntr=3;
    tauxvec=[1,10,50];
end

n=length(tauxvec);

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

    tau_x=tauxvec(g);    
    tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

    rmse_tr=zeros(ntr,2);
    kappa_tr=zeros(ntr,2);

    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    
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
    savename='measures_taux';
    save([savefile,savename],'tauxvec','rms','cost','frate','CVs','meanE','meanI','r_ei','parameters','param_name')
end

%%

if showfig==1
    
    %%
    figure('units','centimeters','position',[0,0,16,20])
    subplot(4,1,1)
    plot(tauxvec,rms(:,1),'r')
    hold on
    plot(tauxvec,rms(:,2),'b')
    ylabel('RMSE')
    box off

    subplot(4,1,2)
    hold on
    plot(tauxvec,cost(:,1),'r')
    plot(tauxvec,cost(:,2),'b')
    hold off
    ylabel('cost')
    
    subplot(4,1,3)
    plot(tauxvec,CVs(:,1),'r')
    hold on
    plot(tauxvec,CVs(:,2),'b')
    hold off
    ylabel('CV')
    box off
    
    subplot(4,1,4)
    hold on
    plot(tauxvec,r_ei(:,1),'r')
    plot(tauxvec,r_ei(:,2),'b')
    ylabel('corr. coeff. E & I currents')
    ylim([-1,0])
    xlabel('number input variables')
    
    

end
%%

