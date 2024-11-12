
clear all

saveres=0;
type=2;

addpath([cd,'/function/'])

namet={'','perm_full','perm_partial'};
disp(['computing variance in V with ',namet{type}]);

%% parameters

ntr=100;

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
   
b=1;
c=33;
beta=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% compute performance with noise in the connectivity

Ct={'I to I','E to I','I to E','all'}; % those that are permuted
fvec=[2,3,4,5];
n=length(fvec);
stdV=cell(n,2);

for g=1:n
    
    disp(n-g)
    f=fvec(g);

    stdV_tr_E=zeros(ntr,N);
    stdV_tr_I=zeros(ntr,N/q);

    for ii=1:ntr
        [~,~,~,~,~,~,~,varV] = current_fun_unstructured(dt,sigmav,beta,tau_vec,s,N,q,d,x,f,type);

        stdV_tr_E(ii,:)=sqrt(varV{1});
        stdV_tr_I(ii,:)=sqrt(varV{2});

    end

    stdV{g,1}=mean(stdV_tr_E); % mean across trials
    stdV{g,2}=mean(stdV_tr_I);
end

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename=['stdV_',namet{type}];
    save([savefile,savename],'stdV','Ct','parameters','param_name')
end


