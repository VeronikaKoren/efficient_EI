clear all
%clc

addpath([cd,'/code/function/'])
saveres=1;
showfig=0;

disp('computing performance measures as a function of mu_s');

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=7; %7                                % duration of the trial in seconds 

tau_s=10;
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
q=4;
d=3;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

[w,C] = w_fun(M,N,q,d);

%% compute performance 

T=nsec*1000/dt;
ntr=100;
mus_vec=0:5:50;
n=length(mus_vec);

bias=zeros(n,2);
varest=zeros(n,2);
mse=zeros(n,2);
R2=zeros(n,2);
ratio=zeros(n,2);
kappa=zeros(n,2);

for g=1:n
    disp(n-g)
    
    mu_abs=mus_vec(g);
    mu_s=[mu_abs,mu_abs,mu_abs]';
   
    [s,x]=signal_sepdim_fun(tau_s,tau_x,M,nsec,dt,mu_s);
    varx=var(x,0,2);

    estE=zeros(ntr,M,T);
    estI=zeros(ntr,M,T);
    
    vars=zeros(ntr,M,2);
    ratio_tr=zeros(ntr,2);
    kappa_tr=zeros(ntr,2);

    for ii=1:ntr
        
        [~,~,xhat_e,xhat_i,re,ri] = net_fun_complete(dt,sigmav,mu,tau_vec,s,w,C);
        %[r,mean_eiff,CV,fr,xhat_e,xhat_i,ms,ratio] = current_fun2(dt,sigmav,mu,tau_vec,s,N,q,d,x);
        
        kappa_tr(ii,1)=sqrt(mean(sum(re.^2,1)));
        kappa_tr(ii,2)=sqrt(mean(sum(ri.^2,1)));
       
        estE(ii,:,:)=xhat_e;
        estI(ii,:,:)=xhat_i;
        
        vars(ii,:,1)=var(xhat_e,0,2);
        vars(ii,:,2)=var(xhat_i,0,2);

        vare=var(xhat_e,0,2);
        vari=var(xhat_i,0,2);

        ratio_e=mean(vare./varx);
        ratio_i=mean(vari./varx);

        ratio_tr(ii,:)=cat(1,ratio_e,ratio_i);
        
    end
    
    BE=mean(squeeze(mean(estE)) - x);        % time-dependent bias of the estimate
    BI=mean(squeeze(mean(estI)) - squeeze(mean(estE)));
    
    VE=squeeze(mean(var(estE)))';            % time-dependent variance of the estimate
    VI=squeeze(mean(var(estI)))';
    
    bias(g,:)=cat(2,mean(BE),mean(BI));           % average bias
    varest(g,:)=cat(2,mean(VE),mean(VI));           % average variance of the estimate
    
    %%%%%%%%%%%%%%%%%%%%%%%%%

    xtr=permute(repmat(x,1,1,ntr),[3,1,2]);
    mse_e=mean(mean((xtr-estE).^2,3));
    mse_i=mean(mean(estE-estI).^2,3);
    
    mse(g,:)=cat(2,mean(mse_e),mean(mse_i));   % mean squared error
    kappa(g,:)=mean(kappa_tr);
    %%
    
    sigma=squeeze(mean(vars))';            % variance of estimates, averaged across trials
    R2e=1-mean(mse_e./varx');
    R2i=1-mean(mse_i./sigma(1,:));
    R2(g,:)=cat(2,R2e,R2i);                % R2
    
    ratio(g,:)=mean(ratio_tr);             % ratio variance 
    %ratio(g,:)=mean(sigma./varx,2);        
    
end

%%
if showfig==1
    
    tindex=(1:T)*dt;
    
    figure
    subplot(2,2,1)
    hold on
    for c=1:2
        plot(mus_vec,bias(:,1),'r')
        plot(mus_vec,bias(:,2),'b')
    end
    hold off
    ylabel('bias')
    legend('E','I','Location','best')
    
    subplot(2,2,2)
    hold on
    for c=1:2
        plot(mus_vec,varest(:,1),'r')
        plot(mus_vec,varest(:,2),'b')
    end
    hold off
    
    subplot(2,3,4)
    hold on
    for c=1:2
        plot(mus_vec,kappa(:,1),'r')
        plot(mus_vec,kappa(:,2),'b')
    end
    hold off
    ylabel('kappa')
    
    subplot(2,3,5)
    hold on
    for c=1:2
        plot(mus_vec,R2(:,1),'r')
        plot(mus_vec,R2(:,2),'b')
    end
    hold off
    ylabel('R squared')
    
    subplot(2,3,6)
    hold on
    for c=1:2
        plot(mus_vec,ratio(:,1),'r')
        plot(mus_vec,ratio(:,2),'b')
    end
    hold off
    ylabel('ratio variance')
   
end
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{d},{dt},{nsec}};
    
    savefile='result/stimulus/';
    savename='performance_mus';
    save([savefile,savename],'mus_vec','bias','varest','mse','kappa','R2','ratio','parameters','param_name')
    
end

