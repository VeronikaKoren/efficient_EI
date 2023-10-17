
clear all

addpath([cd,'/code/function/'])
saveres=0;
showfig=0;

type=2;

namet={'local_current_E','local_current_I'};
namevar={'\delta^E','\delta^I'};
display(['computing measures as a function of ',namet{type}]);

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=5;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

if type==1
    tau_ri=10;
else
    tau_re=10;
end
   
b=1;
c=33;
beta=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

q=4;                                   % ratio of E to I neurons      
d=3;                                   % ratio of weight amplitudes I to E 
dt=0.02;                               % time step in ms

[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);

%% compute measures

ntr=100;
%variable=[5,10,20];
variable=[5:0.5:10,11:20,25,30:10:100,200:100:500];
n=length(variable);

frate=zeros(n,2);
CVs=zeros(n,2);

ms=zeros(n,2);
ratios=zeros(n,2);

r_ei=zeros(n,2);
meanE=zeros(n,2);
meanI=zeros(n,2);

delta=zeros(n,1);

for g=1:n
    disp(n-g)
    
    if type==1
        tau_re=variable(g);               
        delta(g)=(1/tau_e) - (1/tau_re);
    elseif type==2
        tau_ri=variable(g);               
        delta(g)=(1/tau_i) - (1/tau_ri);
    end

    tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
    
    r_tr=zeros(ntr,2);
    currE_tr=zeros(ntr,2);
    currI_tr=zeros(ntr,2);

    fr_tr=zeros(ntr,2);
    CV_tr=zeros(ntr,2);
    mse_tr=zeros(ntr,2);
    ratio_tr=zeros(ntr,2);
    
    for ii=1:ntr
        
        [I_E,I_I,r,rmse,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x)
        %[I_E,I_I,r,mse,ratio,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x);
        
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

%%

if showfig==1
    
    figure('units','centimeters','position',[0,0,16,20])
    subplot(4,1,1)
    hold on
    plot(delta,frate(:,1),'r')
    plot(delta,frate(:,2),'b')
    hold off
    ylabel('spikes/sec')

    subplot(4,1,2)
    plot(delta,CVs(:,1),'r')
    hold on
    plot(delta,CVs(:,2),'b')
    line([delta(1) delta(end)],[1 1])
    hold off
    ylabel('CV')
    box off
    
    subplot(4,1,3)
    plot(delta,ms(:,1),'r')
    hold on
    plot(delta,ms(:,2),'b')
    ylabel('MSE')
    box off
    
    subplot(4,1,4)
    plot(delta,ratios(:,1),'r')
    hold on
    plot(delta,ratios(:,2),'b')
    line([delta(1) delta(end)],[1 1])
    hold off
    ylabel('ratio variance')
    box off
    xlabel(namevar{type})
       
    figure()
    subplot(3,1,1)
    hold on
    plot(delta,meanE(:,1),'k')
    plot(delta,meanE(:,2),'b')
    hold off
    grid on
    ylabel('current E')
    
    subplot(3,1,2)
    hold on
    plot(delta,meanI(:,1),'r')
    plot(delta,meanI(:,2),'b')
    hold off
    grid on
    ylabel('current I')
    
    subplot(3,1,3)
    plot(delta,r_ei(:,1),'r')
    plot(delta,r_ei(:,2),'b')
    ylabel('balance E-I currents')
    ylim([-1,1])
    xlabel(namevar{type})
    
end
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{},{q},{dt},{nsec},{ntr}};
    
    savefile='result/adaptation/';
    savename=['measures_',namet{type}];
    save([savefile,savename],'variable','delta','frate','CVs','ms','ratios','r_ei','meanE','meanI','parameters','param_name')
end
