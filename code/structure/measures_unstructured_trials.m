
clear all

type=2;
namet={'structured','perm_full_all','perm_partial_all'};
const_stim=1;

saveres=1;
showfig=0;
ntr=200;

addpath([cd,'/code/function/'])
disp(['computing measures in trials with',namet{type}]);

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

sigma_s=2;
tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
beta=14;
sigmav=5;

dt=0.02;                               % time step in ms     
q=4;
d=3.0;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re,tau_ri);
which_permuted={'','I to I','E to I','I to E','all'};      % which matrix is shuffled

% constant stimulus
if const_stim==1
T=(nsec*1000)./dt;
s=ones(M,T).*1.6;
lambda=1/tau_x;
x=zeros(M,T);
for t=1:T-1
    x(:,t+1)=(1-lambda*dt)*x(:,t)+s(:,t)*dt;  
end
end
%% compute performance with noise in the connectivity

f=5; % 'all'

r_tr=zeros(ntr,2);
currE_tr=zeros(ntr,2);
currI_tr=zeros(ntr,2);

fr_tr=zeros(ntr,2);
CV_tr=zeros(ntr,2);
rmse_tr=zeros(ntr,2);
kappa_tr=zeros(ntr,2);

for ii=1:ntr
    disp(ntr-ii)
    if const_stim==0
        [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    end
    [w,J] = w_structure_fun(M,N,q,d,type,f);
    
    [rmse,kappa,fr,CV,r,I_E,I_I] = current_fun_matching(dt,sigmav,beta,tau_vec,s,N,q,w,J,x);
    
    rmse_tr(ii,:)=rmse;
    kappa_tr(ii,:)=kappa;

    currE_tr(ii,:)=I_E;
    currI_tr(ii,:)=I_I;

    r_tr(ii,:)=r;
    CV_tr(ii,:)=CV;
    fr_tr(ii,:)=fr;

end

%%

net_tr=cat(2,sum(currE_tr,2),sum(currI_tr,2));

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    if const_stim==1
        savename=['measures_trials_constant_',namet{type}];
    else
        savename=['measures_trials_',namet{type}];
    end
    save([savefile,savename],'fr_tr','CV_tr','r_tr','net_tr','kappa_tr','rmse_tr','parameters','param_name')
end

%%
if showfig==1

    figure()
   
    subplot(3,2,1)
    boxplot(rmse_tr)
    ylabel('error')

    subplot(3,2,2)
    boxplot(kappa_tr)
    ylabel('cost')

    subplot(3,2,3)
    boxplot(fr_tr)
    ylabel('firing rate')

    subplot(3,2,4)
    boxplot(CV_tr)
    ylabel('CV')

    subplot(3,2,5)
    boxplot(abs(r_tr))
    ylabel('corr. coeff')

    subplot(3,2,6)
    boxplot(net_tr)
    ylabel('net current')
    %}
    

end
%%



