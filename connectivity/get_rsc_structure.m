clear all

addpath([cd,'/code/function/'])
saveres=0;
showfig=1;
type=2;         % type 2 or 3

namet={'noiseC','perm_full','perm_partial','non_rectified','disorder','perm_full2','perm_partial2'};
disp(['computing correlation of membrane potentials with ',namet{type}]);

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=3;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1;
c=33;
mu=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);
%mu_s=[0,0,0]';    

L=30;                               % bin length in ms
Ldt=L/dt;                           % bin length in timesteps
 %% compute correlation in membrane potentials with specific perturbation
tic

Ct={'I to I','E to I','I to E','all'}; % those that are permuted

fvec=[2,3,4,5];

n=length(fvec);
r_all=cell(n,2);
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

    %[dp] = dot_prod_fun(w);
    %dpn(g,:)=cellfun(@(x) x./max(x),dp,'UniformOutput',false);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [ye,yi] = net_fun_complete(dt,sigmav,mu,tau_vec,s,w,C);
    [rsc,corr_vec] = rsc_fun(ye,yi,Ldt);

    r_all(g,:)=corr_vec;

end
toc

%%

if showfig==1
    figure
    for g=1:4
        hold on
        %subplot(2,2,g)
        ksdensity(r_all{g,1})
        legend(Ct{g})
    end
    %axis([-1,1,-0.5,0.7])
    figure()
    hold on
    for g=1:4
    
        ksdensity(r_all{g,2})
        legend(Ct{g})
    %axis([-1,1,-0.5,0.7])
    end
end
%}
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename=['rsc_',namet{type}];
    save([savefile,savename],'fvec','dpn','r_all','Ct','parameters','param_name')
end


