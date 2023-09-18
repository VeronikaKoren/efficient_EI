
clear all
close all

saveres=0;

disp('computing measures as a function of metabolic constant beta');

addpath([cd,'/function/'])
%% parameters

M=3; 
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

tau_s=10;                              % time constant of the stimuls (OU process)
tau_x=10;                              % time constant of the target signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1;
c=33;
%beta=b*log(N);                        % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;                                   % ratio of weight amplitudes I to E 
d=3;

sigma_s=2;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% compute measures

ntr=100;
beta_vec=0:1:36;                       
n=length(beta_vec);

rms=zeros(n,2);
frate=zeros(n,2);
CVs=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

tic
for g=1:n
    disp(n-g+1)
    
    beta=beta_vec(g);
   
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);
    
    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    rmse_tr=zeros(ntr,2);
    
    for ii=1:ntr
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        [I_E,I_I,r,rmse,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x);
        
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
    
    savefile=[cd,'/result/beta_sigma/'];
    savename='measures_all_beta';
    save([savefile,savename],'beta_vec','rms','frate','CVs','meanE','meanI','r_ei','parameters','param_name')
end

%%

