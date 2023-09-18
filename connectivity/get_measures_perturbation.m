
clear all

addpath([cd,'/code/function/'])
saveres=0;
showfig=0;
type=2;

namet={'noiseC','perm_full','perm_partial','non_rectified','disorder','perm_full2','perm_partial2'};
disp(['computing dynamical and performance measures with ',namet{type}]);

%% parameters
tic
ntr=1;

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

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
[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);

Ct={'I to I','E to I','I to E','all'}; % those that are permuted
C2={'I to I','E to I','I to E'};       % those that are NOT permuted     
%% compute performance with noise in the connectivity

if type==1                  % noise proportional to the average C matrix
    fvec=0:.1:2.5;
elseif or(type==2,type==3)  % full and partial permutation of the C matrix
    fvec=[2,3,4,5]; 
elseif type==5              % noise proportional to synaptic weight
    fvec=0:0.025:0.6;
else
    fvec=[2,3,4];
end

n=length(fvec);

frate=zeros(n,2);
CVs=zeros(n,2);

ms=zeros(n,2);
ratios=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

for g=1:n
    disp(n-g)
    
    f=fvec(g);
    
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    mse_tr=zeros(ntr,2);
    ratio_tr=zeros(ntr,2);
    
    for ii=1:ntr
        
        [I_E,I_I,r,mse,ratio,CV,fr] = current_fun_1g_noise(dt,sigmav,mu,tau_vec,s,N,q,d,x,f,type);
        
        mse_tr(ii,:)=mse;
        ratio_tr(ii,:)=ratio;
        
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

    ms(g,:)=mean(mse_tr);
    ratios(g,:)=mean(ratio_tr);
   
end
toc
%%

if showfig==1
    
    figure('units','centimeters','position',[0,0,16,20])
    subplot(4,1,1)
    hold on
    plot(fvec,frate(:,1),'r')
    plot(fvec,frate(:,2),'b')
    hold off
    ylabel('spikes/sec')
    set(gca,'XTick',fvec)

    subplot(4,1,2)
    plot(fvec,CVs(:,1),'r')
    hold on
    plot(fvec,CVs(:,2),'b')
    line([fvec(1) fvec(end)],[1 1])
    hold off
    ylabel('CV')
    box off
    set(gca,'XTick',fvec)

    subplot(4,1,3)
    plot(fvec,sqrt(ms(:,1)),'r')
    hold on
    plot(fvec,sqrt(ms(:,2)),'b')
    ylabel('MSE')
    box off
    set(gca,'XTick',fvec)
    
    subplot(4,1,4)
    plot(fvec,ratios(:,1),'r')
    hold on
    plot(fvec,ratios(:,2),'b')
    line([fvec(1) fvec(end)],[1 1])
    hold off
    ylabel('ratio variance')
    box off
    if type==1
        xlabel('noise intensity')
    else
        set(gca,'XTick',fvec)
        set(gca,'XTickLabel',Ct)
    end
    
    figure()
    subplot(3,1,1)
    hold on
    plot(fvec,meanE(:,1),'k')
    plot(fvec,meanE(:,2),'b')
    hold off
    grid on
    ylabel('mean E current')
    set(gca,'XTick',fvec)

    subplot(3,1,2)
    hold on
    plot(fvec,meanI(:,1),'r')
    plot(fvec,meanI(:,2),'b')
    hold off
    grid on
    ylabel('mean I current')
    set(gca,'XTick',fvec)

    subplot(3,1,3)
    plot(fvec,r_ei(:,1),'r')
    plot(fvec,r_ei(:,2),'b')
    ylabel('balance E-I currents')
    ylim([-1,1])
    if type==1
        xlabel('noise intensity')
    else
        set(gca,'XTick',fvec)
        set(gca,'XTickLabel',Ct)
    end
    set(gca,'XTick',fvec)
end
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename=['measures_',namet{type}];
    save([savefile,savename],'fvec','frate','CVs','ms','ratios','r_ei','meanE','meanI','Ct','C2','parameters','param_name')
end


