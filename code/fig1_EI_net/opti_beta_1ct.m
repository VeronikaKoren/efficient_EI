% simulates the network with one cell type net and measures performance as
% a function of the (quadratic) metabolic constant beta to find the optimal
% beta

clear all
close all

addpath([cd,'/code/function/'])
saveres=0;
showfig=0;

disp('computing optimal metabolic constant for the network with 1 cell type')

%% parameters

nsec=1;                     % simulation length in seconds

M=3;                        % number of inputs
N=400;                      % number of neurons 
tau=10;                     % time constant of the membrane potential

nu=0;                       % linear cost
sigmav=1.8;                 % noise strength

dt=0.02;                    % time step  

%% external input and signal

sigma_s=2;
tau_s=10;
tau_x=10;

%% simulate network activity
  
T=nsec*1000/dt;
ntr=100;

beta_vec=2:0.5:25;
n=length(beta_vec);

rmse_tr=zeros(n,ntr);
kappa_tr=zeros(n,ntr);

for k=1:n

    disp(n-k);
    beta=beta_vec(k);                
    
    for ii=1:ntr
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        
        [xhat,f,r] = network_1ct_fun(N,s,dt,tau,beta,sigmav);    
        [rmse,kappa] = performance_fun1(x,xhat,r);

        rmse_tr(k,ii)=rmse;
        kappa_tr(k,ii)=kappa;
    end
end
%%
ms=mean(rmse_tr,2);
mc=mean(kappa_tr,2);

error=(ms-min(ms))./max(ms-min(ms));
cost=(mc-min(mc))./max(mc-min(mc));
gl=0.7;

loss=(gl.*error)+((1-gl).*(cost));

[~,idx]=min(loss);
beta_star=beta_vec(idx);

display(beta_star,'optimal metabolic cost (beta)')

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{},{sigmav},{tau},{dt},{nsec},{ntr}};

    savefile='result/implementation/';
    savename='optimization_1ct_beta_500';
    save([savefile,savename],'beta_vec','beta_star','ms','mc','error','cost','loss','gl','param_name','parameters');
end

%% show figure?
if showfig==1

    figure()
    hold on
    plot(beta_vec,error,'r')
    plot(beta_vec,cost,'g')
    plot(beta_vec,loss,'k')
    hold off
    xlabel('b parameter')
    ylabel('loss measures')

end