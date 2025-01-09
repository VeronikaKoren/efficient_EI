% computes the performance of the optimal network with one cell type

clear
close all
clc

saveres=0;

addpath([cd,'/code/function/'])

disp('computing RMSE, cost, sc for the network 1ct')

%% parameters

nsec=1;                     % simulation length in seconds

M=3;                        % number of inputs
N=400;
tau=10;                     % time constant of the membrane potential

nu=0;                       % linear cost
sigma1=1.8;            % standard deviation of the noise

dt=0.02;                    % time step  

%% external input and signal

sigma_s=2;
tau_s=10;
tau_x=10; 
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% simulate network activity
  
ntr=100;

muvec=0:2:36;
n=length(muvec);

sc=zeros(n,1);
Rmse=zeros(n,1);
cost=zeros(n,1);

for ii=1:n
    mu=muvec(ii)

    sc_tr=zeros(ntr,1);
    e=zeros(ntr,1);
    c=zeros(ntr,1);

    for tr=1:ntr

        [xhat,f,r] = network_1pop_fun(N,s,dt,tau,mu,nu,sigma1);
        sc_tr(tr,1)=sum(mean(f,1))./nsec;              % spike count in 1 sec
        
        [rmse,kappa] = performance_fun1(x,xhat,f);
        e(tr,:)=rmse;
        c(tr,:)=kappa;
    end

    sc(ii,:)=mean(sc_tr);
    Rmse(ii,:)=mean(e);
    cost(ii,:)=mean(c);

end
 
%% save result?

if saveres==1
    savefile='result/stimulus/';
    savename='measures_mu_1ct';
    save([savefile,savename],'Rmse','cost','sc','muvec','ntr');
end
%%
