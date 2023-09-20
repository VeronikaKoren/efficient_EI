% simple net with function

clear all
close all
clc

saveres=0;
type=1;


disp('computing RMSE, cost, sc for the 1CT network ')

%% parameters

nsec=1;                     % simulation length in seconds

M=3;                        % number of inputs
N=400;
tau=10;                     % time constant of the membrane potential

b=1.4;
c=33;

beta=b*log(N);                % quadratic cost
sigmav=c/log(N);            % standard deviation of the noise

dt=0.02;                    % time step  

%% external input and signal

sigma_s=2;
tau_s=10;
tau_x=10; 
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% simulate network activity
  
ntr=150;

rmse1=zeros(ntr,1);
kappa1=zeros(ntr,1);
sc1=zeros(ntr,1);
for ii=1:ntr

    [xhat,f,r] =network_1ct_fun(N,s,dt,tau,beta,sigmav);
   
    kappa1(ii)=sqrt(mean(sum(f.^2,1))); 
    rmse1(ii)=sqrt(mean(mean((x-xhat).^2,2)));
    sc1(ii)=sum(mean(f,1))./nsec;           % spike count / sec

end
 
%%

if saveres==1
    savefile='result/one_ct/';
    savename='error_cost_sc';
    save([savefile,savename],'rmse1','sc1','kappa1');
end
%%

