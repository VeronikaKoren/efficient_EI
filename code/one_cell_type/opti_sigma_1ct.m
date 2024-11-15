% simulates the network with one cell type net and measures performance as
% a function of noise strength sigma to find the optimal sigma

clear
close all
clc

addpath([cd,'/code/function/'])
saveres=0;
showfig=0;

type=1;

namet={'1pop','1pop_rectified'};
display(['computing optimal sigma for the network ', namet{type}])
%% parameters

nsec=1;                     % simulation length in seconds

M=3;                        % number of inputs
N=400;                      % number of neurons
tau=10;                     % time constant of the membrane potential and of the population readout

nu=0;                       % linear cost constant
beta=11.4;                  % quadratic cost constant

dt=0.02;                    % time step  in ms

%% external input and signal

sigma_s=2;                  
tau_s=10;
tau_x=10;

%% simulate network activity
  
T=nsec*1000/dt;
ntr=100;

sigma_vec=0:0.17:7.5;
n=length(sigma_vec);

rmse_tr=zeros(n,ntr);
kappa_tr=zeros(n,ntr);

for k=1:n

    disp(n-k);
    sigmav=sigma_vec(k);                    
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
sigma_star=sigma_vec(idx);

display(sigma_star,'optimal noise strength sigma')

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{},{tau},{dt},{nsec},{ntr}};

    savefile='result/implementation/';
    savename='optimization_1ct_sigma';
    save([savefile,savename],'sigma_vec','sigma_star','ms','mc','error','cost','loss','gl','param_name','parameters');
end

%% show figure?

if showfig==1

    figure()
    subplot(2,1,1)
    plot(c_vec/log(N),ms)
    ylabel('RMSE')


    subplot(2,1,2)
    hold on
    plot(c_vec./log(N),error,'r')
    plot(c_vec./log(N),cost,'g')
    plot(c_vec./log(N),loss,'k')
    hold off
    xlabel('c parameter')
    ylabel('loss measures')

end