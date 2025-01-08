
clear
clc
close all

saveres=0;
showfig=1;
type=2;         

namet={'','perm_full','perm_partial'};
disp(['computing correlation of membrane potentials with ',namet{type}]);
addpath([cd,'/code/function/'])

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
   
beta=14;                           % quadratic cost constant
sigmav=5;                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
mu_s=[0,0,0]';    

ntr=10;

%% compute correlation in membrane potentials with unstructured network

f=5;
Jpermuted='all';

[w,J] = w_structure_fun(M,N,q,d,type,f);
[dp] = dot_prod_fun(w);
dpn=cellfun(@(x) x./max(x),dp,'UniformOutput',false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ni=N/q;
np=cat(1,(N^2-N)/2,(Ni^2-Ni)/2);
rVm=cell(2,1);
rVm_E=zeros(ntr,np(1));
rVm_I=zeros(ntr,np(2));

for tr=1:ntr
    [~,~,~,rVm] = net_fun_V2(dt,sigmav,beta,tau_vec,w,J,1,nsec,tau_s,mu_s);
    rVm_E(tr,:)=rVm{1};
    rVm_I(tr,:)=rVm{2};
end

rVm{1}=mean(rVm_E,'omitnan')';
rVm{2}=mean(rVm_I,'omitnan')';


%%
if showfig==1
    figure('Position',[0,0,16,16])
    subplot(2,1,1)
    plot(dpn{1},rVm{1},'k.')
    title('E-E')
    axis([-1,1,-0.8,1])
    ylabel('voltage correlations')

    subplot(2,1,2)
    plot(dpn{2},rVm{2},'k.')
    title('I-I')
    axis([-1,1,-0.5,1])
    xlabel('tuning similarity')
    ylabel('voltage correlations')
end

%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/perturbation/';
    savename=['corr_Vm_',namet{type}];
    save([savefile,savename],'f','dp','rVm','Jpermuted','parameters','param_name')
end


