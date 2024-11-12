
close all
clear all
%clc

addpath([cd,'/code/function/'])
saveres=0;
showfig=0;

ntype={'min_error','min_loss'};
type=2;
disp(['computing bias and variance of the estimator in network with ',ntype{type}]);

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=2;                                % duration of the trial in seconds 

sigma_s=2;
tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 

if type==1
    beta=6;
    sigmav=5.7;
else
    beta=14;
    sigmav=5;
end

dt=0.02;                               % time step in ms     
q=4;
d=3;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%%

[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
[w,J] = w_fun(M,N,q,d);

%% compute performance 

T=nsec*1000/dt;
ntr=100;

estE=zeros(ntr,M,T);
estI=zeros(ntr,M,T);
tic
for ii=1:ntr
    
    [~,~,xhat_e,xhat_i] = net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J);
    
    estE(ii,:,:)=xhat_e;
    estI(ii,:,:)=xhat_i;
    
end
toc

%% bias
% time-and dimension-dependent bias of the estimates

Bky=cell(2,1);

bigx=permute(repmat(x,1,1,ntr),[3,1,2]);
Bky{1}=squeeze(mean(estE-bigx));
Bky{2}=squeeze(mean(estE-estI)); 

% time-and dimension dependent variance of estimates
Vky=cell(2,1);

Vky{1}=squeeze(mean((bigx-estE).^2));

mean_estE=squeeze(mean(estE)); % trial average
mbigE=permute(repmat(mean_estE,1,1,ntr),[3,1,2]);
Vky{2}=squeeze(mean(estI - mbigE).^2);

% prepare for boxplot
Bploty=cellfun(@(x) x(:),Bky,'un',0);
Vploty=cellfun(@(x) x(:),Vky,'un',0);

% average bias and variance
By=cellfun(@mean, Bploty);
Vy=cellfun(@mean, Vploty);

display(By,'average bias of estimators E and I')
display(Vy,'average variance of estimators E and I')

% prepare signals in 1 dimension for plotting
sigE=cell(2,1);
sigE{1}=squeeze(x(1,:));
sigE{2}=squeeze(mean(estE(:,1,:)));

sigI=cell(2,1);
sigI{1}=squeeze(mean(estE(:,1,:)));
sigI{2}=squeeze(mean(estI(:,1,:)));

%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{d},{dt},{nsec}};
    
    savefile='result/statistics/bias/';
    savename=['bias_var_',ntype{type}];
    save([savefile,savename],'Bky','Bploty','Vky','Vploty','tidx','sigE','sigI','parameters','param_name')
    
end

%%

