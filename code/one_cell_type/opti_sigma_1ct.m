% simple net with function

clear all
close all

addpath([cd,'/code/function/'])
saveres=1;
showfig=0

type=1;

namet={'1pop','1pop_rectified'};
display(['computing optimal sigma for the network ', namet{type}])
%% parameters

nsec=1;                     % simulation length in seconds

M=3;                        % number of inputs
N=400;
tau=10;                     % time constant of the membrane potential

nu=0;                       % linear cost
b=1.5;
beta=b*log(N);              % quadratic cost

dt=0.02;                    % time step  

%% external input and signal

sigma_s=2;
tau_s=10;
tau_x=10;

%% simulate network activity
  
T=nsec*1000/dt;
ntr=100;

%c_vec=14:20;
c_vec=0:1:45;
n=length(c_vec);

rmse_tr=zeros(n,ntr);
kappa_tr=zeros(n,ntr);

for k=1:n

    disp(n-k);
    c=c_vec(k);
    sigmav=c/log(N);                % quadratic cost
    
    for ii=1:ntr
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        [xhat,f,r] =network_1pop_fun(N,s,dt,tau,beta,nu,sigmav,type);
             
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
c_star=c_vec(idx);
sigma_star=c_star/log(N);

display(c_star,'optimal c parameter')

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{},{c},{tau},{dt},{nsec},{ntr}};

    savefile='result/implementation/';
    savename='optimization_1ct_sigma';
    save([savefile,savename],'c_vec','c_star','sigma_star','ms','mc','error','cost','loss','gl','param_name','parameters');
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