% simple net with function

clear all
close all

addpath([cd,'/code/function/'])
saveres=1;
showfig=1;

disp('computing optimal b parameter for the network 1 CT')

%% parameters

nsec=1;                  % simulation length in seconds

M=3;                        % number of inputs
N=500;
tau=10;                    % time constant of the membrane potential

nu=0;                       % linear cost

c=20;
sigmav=c/log(N);            % standard deviation of the noise

dt=0.02;                    % time step  

%% external input and signal

sigma_s=2;
tau_s=10;
tau_x=10;


%% simulate network activity
  
T=nsec*1000/dt;
ntr=100;

b_vec=0.5:0.5:4.0;
n=length(b_vec);

rmse_tr=zeros(n,ntr);
kappa_tr=zeros(n,ntr);

for k=1:n

    disp(n-k);
    b=b_vec(k);
    beta=b*log(N);                % quadratic cost
    
    for ii=1:ntr
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
        
        [xhat,f,r] = network_1pop_fun(N,s,dt,tau,beta,nu,sigmav);     
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
b_star=b_vec(idx);
beta_star=b_star*log(N);

display(b_star,'optimal b parameter')

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{},{c},{tau},{dt},{nsec},{ntr}};

    savefile='result/implementation/';
    savename='optimization_1ct_beta_500';
    save([savefile,savename],'b_vec','b_star','beta_star','ms','mc','error','cost','loss','gl','param_name','parameters');
end

%% show figure?
if showfig==1

    figure()
    hold on
    plot(b_vec,error,'r')
    plot(b_vec,cost,'g')
    plot(b_vec,loss,'k')
    hold off
    xlabel('b parameter')
    ylabel('loss measures')

end