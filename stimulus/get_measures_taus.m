
clear all
close all

addpath([cd,'/code/function/'])
saveres=1;
showfig=0;

vari='tau_s';
disp(['computing measures as a function of ',vari]);

%% parameters

M=3; 
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1;
c=33;
mu=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;                                   % ratio of weight amplitudes I to E 
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% compute measures

ntr=100;
taus_vec=1:10:201;                      % time constant of input features    
n=length(taus_vec);

rms=zeros(n,2);
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
    
    for ii=1:ntr
        [s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);
        [I_E,I_I,r,rmse,CV,fr] = current_fun_1g(dt,sigmav,mu,tau_vec,s,N,q,d,x);
        
        currE_tr(ii,:)=I_E;
        currI_tr(ii,:)=I_I;
        r_tr(ii,:)=r;
        rmse_tr(ii,:)=rmse;
        CV_tr(ii,:)=CV;
        fr_tr(ii,:)=fr;
        
    end
    
    rms(g,:)=mean(rmse_tr);
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
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/stimulus/';
    savename='measures_all_taus';
    save([savefile,savename],'taus_vec','rms','frate','CVs','meanE','meanI','r_ei','parameters','param_name')
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
    plot(taus_vec,frate(:,1),'r')
    plot(taus_vec,frate(:,2),'b')
    hold off
    ylabel('firing rate')
    
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

