
clear all
close all

addpath([cd,'/code/function/'])

computing=1;

if computing==1
    saveres=1;
    showfig=0;
else                % testing
    saveres=0;
    showfig=1;
end

vari='tau_s_dim';
disp(['computing measures as a function of ',vari]);

%% parameters

M=3; 
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

sigma_s=2;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
%b=1;
%c=33;
beta=14;                           % quadratic cost constant
sigmav=5;                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;                                   % ratio of weight amplitudes I to E 
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% compute measures

taus1=10;
if computing==0

    taus2=1:20:101;                      % time constant of input features
    ntr=5;
else

    taus2=3:3:202;
    ntr=200;
end

taus3=taus2.*2;
n=length(taus2);

taus_dim=cat(1,repmat(taus1,1,n),taus2,taus3);
%%
%ntr=2;
%taus_vec=[1,10]

mse_dim=zeros(n,M,2);
cost=zeros(n,2);

frate=zeros(n,2);
CVs=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

tic
for g=1:n
    disp(n-g)
    
    tau_s=taus_dim(:,g);
    
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);

    mse_tr=zeros(ntr,M,2);
    kappa_tr=zeros(ntr,2);
    
    for ii=1:ntr
        [s,x]=signal_taus_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        [I_E,I_I,r,mse,kappa,CV,fr] = current_fun_taus(dt,sigmav,beta,tau_vec,s,N,q,d,x);
        
        mse_tr(ii,:,:)=mse;
        kappa_tr(ii,:)=kappa;

        currE_tr(ii,:)=I_E;
        currI_tr(ii,:)=I_I;
        r_tr(ii,:)=r;
        
        CV_tr(ii,:)=CV;
        fr_tr(ii,:)=fr;
        
    end
    
    mse_dim(g,:,:)=mean(mse_tr);
    cost(g,:)=mean(kappa_tr);
    
    frate(g,:)=mean(fr_tr);
    CVs(g,:)=mean(CV_tr);

    r_ei(g,:)=mean(r_tr);
    meanE(g,:)=mean(currE_tr);
    meanI(g,:)=mean(currI_tr);

end
toc

rmse_e=sqrt(mean(mse_dim(:,:,1),2)); % root mean squared error as evaluated for other measures 
rmse_i=sqrt(mean(mse_dim(:,:,2),2));

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/stimulus/';
    savename='measures_taus_dim2';
    save([savefile,savename],'taus_dim','mse_dim','cost','frate','CVs','meanE','meanI','r_ei','parameters','param_name')
end

%%

if showfig==1
   
    figure('units','centimeters','position',[0,0,16,20])
    subplot(4,1,1)
    plot(taus2,squeeze(mse_dim(:,1,1)),'k')
    hold on
    plot(taus2,squeeze(mse_dim(:,2,1)),'g')
    plot(taus2,squeeze(mse_dim(:,3,1)),'m')
    ylabel('MSE')
    box off

    subplot(4,1,2)
    plot(taus2,rmse_e,'r')
    hold on
    plot(taus2,rmse_i,'b')
    hold off

    subplot(4,1,3)
    hold on
    plot(taus2,cost(:,1),'r')
    plot(taus2,cost(:,2),'b')
    hold off
    ylabel('cost')
    
    subplot(4,1,4)
    hold on
    plot(taus2,r_ei(:,1),'r')
    plot(taus2,r_ei(:,2),'b')
    ylabel('\rho E & I currents')
    ylim([-1,0])
    xlabel(vari)
    
end
%%
