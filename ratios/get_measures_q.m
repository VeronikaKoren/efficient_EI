
clear all

addpath([cd,'/function/'])
saveres=0;

disp('computing measures as a function of q=ratio of E to I neurons');
%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=5;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1;
c=33;
beta=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
d=3.00;                                   % ratio of weight amplitudes I to E 

sigma_s=2;
tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);


%% compute measures

ntr=100;
qvec=1:0.25:8;
%ntr=3 % for testing
%qvec=1:2:5
n=length(qvec);

frate=zeros(n,2);
CVs=zeros(n,2);

ms=zeros(n,2);
ratios=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

for g=1:n
    %disp(n-g)
    
    q=qvec(g);
    
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    rmse_tr=zeros(ntr,2);
    ratio_tr=zeros(ntr,2);
    
    for ii=1:ntr
        
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        [I_E,I_I,r,rmse,CV,fr] = current_fun_1g(dt,sigmav,beta,tau_vec,s,N,q,d,x);
        
        rmse_tr(ii,:)=rmse;
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

    ms(g,:)=mean(rmse_tr);
    ratios(g,:)=mean(ratio_tr);
   
end

%%

if showfig==1
    
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
    
    subplot(4,1,4)
    plot(qvec,ratios(:,1),'r')
    hold on
    plot(qvec,ratios(:,2),'b')
    line([qvec(1) qvec(end)],[1 1])
    hold off
    ylabel('ratio variance')
    box off
    
        
    figure()
    subplot(3,1,1)
    hold on
    plot(qvec,meanE(:,1),'k')
    plot(qvec,meanE(:,2),'b')
    hold off
    grid on
    ylabel('mean E current')
    
    subplot(3,1,2)
    hold on
    plot(qvec,meanI(:,1),'r')
    plot(qvec,meanI(:,2),'b')
    hold off
    grid on
    ylabel('mean I current')
    
    subplot(3,1,3)
    plot(qvec,r_ei(:,1),'r')
    plot(qvec,r_ei(:,2),'b')
    ylabel('balance E-I currents')
    ylim([-1,1])
    xlabel('noise intensity')
    
end
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename='measures_all_q';
    save([savefile,savename],'qvec','frate','CVs','ms','ratios','r_ei','meanE','meanI','parameters','param_name')
end
