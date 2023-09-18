
clear all

addpath([cd,'/function/'])
saveres=1;
showfig=1;
type=2;         % type 2 or 3

namet={'noiseC','perm_full','perm_partial','non_rectified','disorder','perm_full2','perm_partial2'};
disp(['computing correlation of membrane potentials with ',namet{type}]);

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

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

sigma_s=2;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
mu_s=[0,0,0]';    

 %% compute correlation in membrane potentials with specific perturbation
tic

Ni=N/q;
np=cat(1,(N^2-N)/2,(Ni^2-Ni)/2);
Ct={'I to I','E to I','I to E','all'}; % those that are permuted
ntr=5;

fvec=[2,3,4,5];

n=length(fvec);
rV_all=cell(n,2);
dpn=cell(n,2);
for g=1:n

    f=fvec(g);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if type==4
        [w,C] = w_nonrectified_fun(M,N,q,d,f);
    elseif or(type==1,type==5)
        [w,C] = w_disorder_fun(M,N,q,d,type,f);
    elseif or(type==2,type==3)
        [w,C] = w_perm13_fun(M,N,q,d,type,f);
    elseif or(type==6,type==7)
        [w,C] = w_perm2_fun(M,N,q,d,type,f);
    end

    [dp] = dot_prod_fun(w);
    dpn(g,:)=cellfun(@(x) x./max(x),dp,'UniformOutput',false);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    rVm_E=zeros(ntr,np(1));
    rVm_I=zeros(ntr,np(2));

    for tr=1:ntr
        [~,~,~,rVm] = net_fun_V2(dt,sigmav,beta,tau_vec,w,C,1,nsec,tau_s,mu_s);
        rVm_E(tr,:)=rVm{1};
        rVm_I(tr,:)=rVm{2};
    end

    rV_all{g,1}=nanmean(rVm_E);
    rV_all{g,2}=nanmean(rVm_I);

end
toc
%%
order=[4,2,1,3];
dpo=dpn(order,:);
Co=Ct(order);
rV=rV_all(order,:);
%%
if showfig==1
    
    
    
    col={'r','b','g','c'};
    figure
    
    for g=1:n
        subplot(2,4,g)
        hold on
        
        plot(dpo{g,1},rV{g,1},'.','color',col{g})
        
        text(0.1,0.9,Co{g},'color',col{g},'units','normalized')
        axis([-1,1,-0.6,1])
        hold off
    end
   
    for g=1:n
        subplot(2,4,g+4)
        hold on
        plot(dpo{g,2},rV{g,2},'.','color',col{g})
        text(0.1,0.9,Co{g},'color',col{g},'units','normalized')
        axis([-1,1,-0.6,1])
        hold off
    end
    
end

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename=['corrV_',namet{type}];
    save([savefile,savename],'dpo','rV','Co','parameters','param_name')
end


