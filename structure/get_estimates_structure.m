
clear all

addpath([cd,'/function/'])
saveres=0;
showfig=1;

type=1; 

namet={'perturbation','perm_full','perm_partial'};
disp(['computing estimates with ',namet{type}]);

display(['get estimates with ', namet{type}])
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
   
b=1;
c=33;
beta=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;
%% set the input

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% 

T=nsec*1000/dt;

if type==1 % adding noise to existing connections
    fvec=0.5;  % between 0 and 0.7, try 0.5 or 0.6
elseif or(type==2,type==3) % permutation of connectivity
    fvec=[2,3,4,5];       
end

n=length(fvec);
estE=zeros(n,T);
estI=zeros(n,T);
    
for g=1:n
    
    f=fvec(g);
    [xhat_e,xhat_i] = net_fun_unstructured(dt,sigmav,beta,tau_vec,s,N,q,d,f,type);
    estE(g,:)=xhat_e(1,:);
    estI(g,:)=xhat_i(1,:);
end
    
%%

Ct={'I to I','E to I','I to E','all'}; % those that are permuted

if or(type==2,type==3)
    order=[2,1,3,4];
    fvec=fvec(order);

    Co=Ct(order);
    estE=estE(order,:);
    estI=estI(order,:);
end
    
%%
if showfig==1
    
    tindex=nsec*(1:T)/T*1000;

    figure()
    for g=1:n
        subplot(n,1,g)
        hold on
        plot(tindex,x(1,:),'k')
        plot(tindex,estE(g,:),'r')
        plot(tindex,estI(g,:),'b')
    
        hold off
        if type==1
            title(['noise intensity of ', sprintf('%0.1f',fvec(g))])
        else
            title(Co{g})
        end
    end
end
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec}};
    
    savefile='result/connectivity/';
    savename=['estimate_',namet{type}];
    save([savefile,savename],'s','x','estE','estI','fvec','Co','parameters','param_name')
    
end

