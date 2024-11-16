
% computes time-dependent correlation of membrane ptoentials for pairs of
% neurons of the same cell type

clear
clc

namet={'optimal','perm_full'};
type=1;                         

typep=1;                        
namep={'shared','independent'};

disp(['computing correlation of membrane potentials in ',namet{type}, ' model and ', namep{typep}, ' feedforward inputs']);

addpath([cd,'/code/function/'])
saveres=0;
showfig=0;

%% parameters

nsec=1;                                % duration of the trial in seconds 
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

tau_x=10;                              % time constant of the target signals  

tau_e=10;                              % time constant of the excitatory estimates  
tau_i=10;                              % time const I estimates

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity                          % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

tau_s=10;                              % time constant of the OU process (stimulus features)  
sigma_s=2;                             % noise strength for the generation of the OU processes (stimulus features) 
mu_s=[0,0,0]';                         % mean of the OU process (stim. features)

 %% compute correlation in membrane potentials with specific perturbation

ntr=5;

Ni=N/q;
np=cat(1,(N^2-N)/2,(Ni^2-Ni)/2);
Ct={'I to I','E to I','I to E','all'};      % J matrix that is permuted

fvec=[2,3,4,5];

n=length(fvec);
rV_all=cell(n,2);
dpn=cell(n,2);
for g=1:n

    f=fvec(g);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if type==1
        [w,J] = w_fun(M,N,q,d);
    else
        [w,J] = w_structure_fun(M,N,q,d,2,f);
    end
    [dp] = dot_prod_fun(w);
    dpn(g,:)=cellfun(@(x) x./max(x),dp,'UniformOutput',false);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    rVm_E=zeros(ntr,np(1));
    rVm_I=zeros(ntr,np(2));

    for tr=1:ntr
        [~,~,~,rVm] = net_fun_V2(dt,sigmav,beta,tau_vec,w,J,typep,nsec,tau_s,mu_s);
        rVm_E(tr,:)=rVm{1};
        rVm_I(tr,:)=rVm{2};
    end

    rV_all{g,1}=nanmean(rVm_E);
    rV_all{g,2}=nanmean(rVm_I);

end

%%

order=[4,2,1,3];
dpo=dpn(order,:);
Co=Ct(order);
rV=rV_all(order,:);

%%
if showfig==1
    if type==1
        col={'k','k','k','k'};
    else
        col={'r','b','g','c'};
    end
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
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename=['corrV_',namep{type}];
    save([savefile,savename],'dpo','rV','Co','parameters','param_name')
end


