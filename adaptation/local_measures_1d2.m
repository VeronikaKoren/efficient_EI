
%close all
clear all
clc

addpath('code/function/')
saveres=1;
showfig=0;

cases=2;

namec={'localE','localI'};
namevar={'\beta^E','\beta^I'};
disp(['computing measures as a function of the ',namec{cases},' current'])

%% parameters

M=3;                                   
N=400;                               
nsec=1;                               

tau_s=10;
tau_x=10;
tau_e=10;                             
tau_i=10;   

if cases==1
    tau_ri=10;
else
    tau_re=10;
end

b=1;
c=33;
mu=b*log(N);                           % quadratic cost
sigmav=c/log(N);                       % standard deviation of the noise

q=4;                                   % ratio E to I 
d=3;
dt=0.02;                               % time step in ms  

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);

%% simulate network activity

tic
ntr=100;
variable=[5:0.5:10,11:20,25,30:10:100,200:100:500]; 
%variable=[5,10,50,100];
n=length(variable);

rms=zeros(n,2);
bias_ei=zeros(n,2);
ratios=zeros(n,2);
cost=zeros(n,2);

frate=zeros(n,2);
CVs=zeros(n,2);

r_ei=zeros(n,1);
mean_curr=zeros(n,3);

beta=zeros(n,1);     % difference of time constants

for g=1:n
    
    disp(n-g)
    if cases==1
        
        tau_re=variable(g);               
        beta(g)=(1/tau_e) - (1/tau_re);
        
    elseif cases==2
        
        tau_ri=variable(g);               
        beta(g)=(1/tau_i) - (1/tau_ri);
        
    end
    
    tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
    
    fratet=zeros(ntr,2);
    rmst=zeros(ntr,2);
    bias_eit=zeros(ntr,2);
    ratiost=zeros(ntr,2);
    kapatr=zeros(ntr,2);
    
    CVst=zeros(ntr,2);
    r_eit=zeros(ntr,1);
    mean_currt=zeros(ntr,3);
    
    for ii=1:ntr
        [r,mean_eiff,kappa,ms,ratio,bias,CV,fr] = current_fun2(dt,sigmav,mu,tau_vec,s,N,q,d,x);
        
        rmst(ii,:)=ms;
        bias_eit(ii,:)=bias;
        ratiost(ii,:)=ratio;
        kapatr(ii,:)=kappa;
        
        CVst(ii,:)=CV;
        fratet(ii,:)=fr;
        
        r_eit(ii)=r;
        mean_currt(ii,:)=mean_eiff;
    end
    
    bias_ei(g,:)=mean(bias_eit);
    rms(g,:)=mean(rmst);
    ratios(g,:)=mean(ratiost);
    cost(g,:)=mean(kapatr);
    
    frate(g,:)=mean(fratet);
    CVs(g,:)=mean(CVst);
    r_ei(g)=mean(r_eit);
    mean_curr(g,:)=mean(mean_currt);
    
    
end
toc
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{d},{dt},{nsec},{ntr}};
    
    savename=['measures_1d_',namec{cases}];
    savefile='result/adaptation/';
    save([savefile,savename],'beta','variable','frate','CVs','rms','ratios','bias_ei','cost','r_ei','mean_curr','parameters','param_name')
    
end

%%

if showfig==1
     
    H=figure('units','centimeters','Position',[0,0,28,20]);
    subplot(2,3,1)
    hold on
    plot(beta,rms(:,1),'r')
    plot(beta,rms(:,2),'b')
    hold off
    set(gca,'YScale','log') 
    ylabel('root MSE')
    
    subplot(2,3,2)
    plot(beta,cost(:,1),'r')
    hold on
    plot(beta,cost(:,2),'b')
    hold off
    set(gca,'YScale','log')
    ylabel('cost')
    
    subplot(2,3,3)
    plot(beta,r_ei,'k')
    ylabel('corr. E-I currents')
    
    subplot(2,3,4)
    plot(beta,mean_curr(:,1),'r')
    hold on
    plot(beta,mean_curr(:,2),'b')
    plot(beta,mean_curr(:,3),'m')
    hold off
    xlabel(namevar{cases})
    
    subplot(2,3,5)
    %plot(beta,bias_ei(:,1),'r')
    hold on
    plot(beta,bias_ei(:,2),'b')
    hold off
    xlabel(namevar{cases})
    ylabel('bias')
   
    subplot(2,3,6)
    plot(beta,ratios(:,1),'r')
    hold on
    plot(beta,ratios(:,2),'b')
    hold off
    ylabel('ratio variance')
    xlabel(namevar{cases})
    
end
%}

