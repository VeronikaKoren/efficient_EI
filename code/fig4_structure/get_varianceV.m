
% computes the variance over time of the membrane potential in each neuron
% in the optimal model and in models with fully or partially removed
% connectivity structure

%close all
clear
clc

saveres=0;
showfig=0;
addpath([cd,'/code/function/'])

type=1;
ntype={'structured','full_perm_all','partial_perm_all'};

disp(['get variance V ',ntype{type}]);
%% parameters

ntr=20;
nsec=10;                               % duration of the trial in seconds 
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

tau_s=10;                              % time constant of the stimulus features  
sigma_s=2;                             % noise strength for the generation of the OU processes (stimulus features)

%% simulate network activity

f=5;                    % 'all'
Ni=N/q;
stdV_tr_E=zeros(ntr,N);
stdV_tr_I=zeros(ntr,Ni);

for ii=1:ntr
    
    [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    if type==1
        [w,J] = w_fun(M,N,q,d);
    else
        [w,J] = w_structure_fun(M,N,q,d,type,f);
    end
    [~,~,~,~,~,~,~,varV] = current_fun_matching(dt,sigmav,beta,tau_vec,s,N,q,w,J,x);

    stdV_tr_E(ii,:)=sqrt(varV{1});
    stdV_tr_I(ii,:)=sqrt(varV{2});

end

%% reshape neurons x trials

stdV=cell(2,1);
stdV{1}=reshape(stdV_tr_E,N*ntr,1);
stdV{2}=reshape(stdV_tr_I,Ni*ntr,1);

cellfun(@mean, stdV)

%%
if showfig==1
    %%
    figure()
    for k=1:2
        subplot(2,1,k)
        histogram(stdV{k},'normalization','probability')
        
    end
 
end

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{d},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename= ['stdV_',ntype{type}];
    save([savefile,savename],'stdV','parameters','param_name','nsec','ntr')
end

%%
