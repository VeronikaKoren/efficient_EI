
%close all
clear all
clc

addpath('code/function/')
saveres=1;
showfig=0;

disp('computing balance measures as a function of the local current in E and I neurons')

%% parameters

M=3;                                   
N=400;                               
nsec=1;                               

tau_s=10;
tau_x=10;
tau_e=10;                             
tau_i=10;                          

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
%variable=[5,10,50];
n=length(variable);

rms=zeros(n,n,2);
bias_ei=zeros(n,n,2);
ratios=zeros(n,n,2);
cost=zeros(n,n,2);

frate=zeros(n,n,2);
CVs=zeros(n,n,2);

r_ei=zeros(n,n,1);
mean_curr=zeros(n,n,3);

beta=zeros(n,2);     % difference of time constants

for g=1:n
    
    disp(n-g)
    tau_re=variable(g);               
    beta(g,1)=(1/tau_e) - (1/tau_re);
    
    for h=1:n
        
        tau_ri=variable(h);
        if g==1
            beta(h,2)=(1/tau_i) - (1/tau_ri);
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
        
        bias_ei(g,h,:)=mean(bias_eit);
        rms(g,h,:)=mean(rmst);
        ratios(g,h,:)=mean(ratiost);
        cost(g,h,:)=mean(kapatr);
        
        frate(g,h,:)=mean(fratet);
        CVs(g,h,:)=mean(CVst);
        r_ei(g,h)=mean(r_eit);
        mean_curr(g,h,:)=mean(mean_currt);
        
    end
    
end
toc
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{d},{dt},{nsec},{ntr}};
    
    savename='local_2d_measures';
    savefile='result/adaptation/';
    save([savefile,savename],'beta','variable','frate','CVs','rms','ratios','bias_ei','cost','r_ei','mean_curr','parameters','param_name')
    
end

%%

if showfig==1
    
    rmse_tot= (rms(:,:,1) + rms(:,:,2))./2;
    cost_tot=(cost(:,:,1)+cost(:,:,2))./2;
     
    H=figure('units','centimeters','Position',[0,0,28,20]);
    subplot(2,2,1)
    imagesc(beta(:,1),beta(:,2),log(rms(:,:,1)))
    %set(gca,'YScale','log')
    %set(gca,'XScale','log')
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    
    title('coding error')
    
    subplot(2,2,2)
    imagesc(beta(:,1),beta(:,2),cost_tot)
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    title('cost')
    
    
    subplot(2,2,3)
    imagesc(beta(:,1),beta(:,2),r_ei)
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    title('correlation of E-I currents')
    
    subplot(2,2,4)
    imagesc(beta(:,1),beta(:,2),CV)
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    title('CV')
    
end
%}

