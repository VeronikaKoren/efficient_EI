
clear all

saveres=1;
showfig=0;

addpath([cd,'/code/function/'])
disp('computing measures as a function of number of E neurons (with fixed numbr of I neurons) - q ratio');

%% parameters

M=3;                                   % number of input variables    
%N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

sigma_s=2;
tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1;
c=33;
N=400;
beta=b*log(N);                         % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
%d=3.00;                                % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
Ni=100;
dI=3;
dE=1;

%% compute measures

ntr=100;
Nvec=50:25:1000;

%Nvec=[50,100,200,400,800] %for testing
n=length(Nvec);

frate=zeros(n,2);
CVs=zeros(n,2);

ms=zeros(n,2);
cost=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

for g=1:n
    disp(n-g)

    N=Nvec(g);

    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    
    rmse_tr=zeros(ntr,2);
    kappa_tr=zeros(ntr,2);
    
    for ii=1:ntr
        
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        %[I_E,I_I,r,rmse,kappa,CV,fr] = current_fun_Ne(dt,sigmav,beta,tau_vec,s,N,Ni,d,x);
        [I_E,I_I,r,rmse,ka,CV,fr] = current_fun_ratios(dt,sigmav,beta,tau_vec,s,N,Ni,dI,dE,x);
        rmse_tr(ii,:)=rmse;
        kappa_tr(ii,:)=ka;
        
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
%{
g_l=0.7;
g_e = 0.7;
g_k = 0.7;

eps=ms))./max(ms-min(ms));
ka= (cost-min(cost))./max(cost - min(cost));
error=(g_e*eps(:,1)) + ((1-g_e)*eps(:,2));
costmix=(g_k*ka(:,1)) + ((1-g_k)*ka(:,2));
loss=(g_l*error) + ((1-g_l) * costmix);

[~,idx]=min(loss);
optimal_param=Nvec(idx);
display(optimal_param,'best param');
%}
%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'Ni'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{Ni},{dt},{nsec},{ntr}};
    
    savefile='result/ratios/';
    savename='measures_N2';
    save([savefile,savename],'Nvec','frate','CVs','ms','cost','r_ei','meanE','meanI','parameters','param_name')
    disp('saved bye')
end

%%

if showfig==1

   
    qvec=Nvec/Ni;
    figure('units','centimeters','position',[0,0,16,20])
    subplot(4,1,1)
    hold on
    plot(qvec,frate(:,1),'r')
    plot(qvec,frate(:,2),'b')
    hold off
    ylabel('spikes/sec')

    subplot(4,1,2)
    plot(qvec,CVs(:,1),'r')
    hold on
    plot(qvec,CVs(:,2),'b')
    line([qvec(1) qvec(end)],[1 1])
    hold off
    ylabel('CV')
    box off
    
    subplot(4,1,3)
    plot(qvec,ms(:,1),'r')
    hold on
    plot(qvec,ms(:,2),'b')
    ylabel('MSE')
    box off

    subplot(4,2,7)
    plot(qvec,cost(:,1),'r')
    hold on
    plot(qvec,cost(:,2),'b')
    hold off
    ylabel('metabolic cost')
    box off
    
    subplot(4,2,8)
    hold on
    plot(qvec,error(:,1),'r')
    plot(qvec,costmix(:,1),'g')
    plot(qvec,loss,'k')

    
end
%%

