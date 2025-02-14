% simulates the optimal network with one cell type and measures performance

clear
close all
clc

saveres=0;

addpath([cd,'/code/function/'])
disp('computing performance of the optimal 1CT network ')

%% parameters

nsec=1;                     % simulation length in seconds

M=3;                        % number of inputs
N=400;                      % number of neruons

tau=10;                     % time constant of the membrane potential

nu=0;                       % linear cost
beta1=11.4;                 % quadratic cost (for N=400)
sigma1=1.84;                % noise strength (for N =400)

dt=0.02;                    % time step  

sigma_s=2;
tau_s=10;
tau_x=10; 

%% simulate network activity
  
ntr=100;

rmse1=zeros(ntr,1);
kappa1=zeros(ntr,1);
sc1=zeros(ntr,1);
for ii=1:ntr

    disp(ntr-ii+1)

    [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    [xhat,f,r] =network_1pop_fun(N,s,dt,tau,beta1,nu,sigma1);
    [rmse,kappa] = performance_fun1(x,xhat,r);
    
    rmse1(ii)=rmse;
    kappa1(ii)=kappa;
    sc1(ii)=sum(mean(f,1))./nsec;           % average nb.spikes/sec

end
 
%%

if saveres==1

    param_name={{'N'},{'M'},{'tau_s'},{'beta1'},{'sigmav1'},{'tau'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta1},{sigma1},{tau},{dt},{nsec},{ntr}};

    savefile='result/EI_net/';
    savename=['loss_measures_optimal_1CT_',sprintf('%1.0i',N)];
    save([savefile,savename],'rmse1','kappa1','sc1','beta1','sigma1','param_name','parameters');
end
%%
