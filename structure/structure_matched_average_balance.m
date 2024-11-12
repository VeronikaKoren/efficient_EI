
clear all

type=2;
namet={'structured','perm_full_all','perm_partial_all'};

saveres=1;
showfig=0;
ntr=200;

addpath([cd,'/code/function/'])
disp(['computing measures matching average E-I balance with ',namet{type}]);

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
   
%b=1;
%c=33;
if type==1
    beta=14;
    sigmav=5;
else
    beta=16.3;                           % quadratic cost constant
    sigmav=3;                       % standard deviation of the noise
end

dt=0.02;                               % time step in ms     
q=4;
d=3.0;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re,tau_ri);
which_permuted={'I to I','E to I','I to E','all'};      % which matrix is shuffled

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
    [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    s=s.*0.88;
    if type==1
        [w,J] = w_fun(M,N,q,d);
        
    else
        [w,J] = w_structure_fun(M,N,q,d,type,f);
        %J{3}=J{3}.*1.5; % increase excitation to I
        %J{4}=J{4}.*1.0;  % decrease inhibition to E
    end
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
mnet=mean(net_tr);
display(mnet,'average balance E and I')

%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/connectivity/';
    savename=['measures_matching_average2_',namet{type}];
    save([savefile,savename],'fr_tr','CV_tr','r_tr','net_tr','kappa_tr','rmse_tr','parameters','param_name')
end

%%
if showfig==1

    %%
    figure()
    subplot(2,2,1)
    bar([mean(currE_tr),mean(sum(currE_tr,2))])
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',{'E','I','net'})
    line([2,4],[-0.97,-0.97])

    subplot(2,2,2)
    bar([mean(currI_tr),mean(sum(currI_tr,2))])
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',{'E','I','net'})
    line([2,4],[-0.43,-0.43])


    %{
    figure()
    boxplot(net_tr)
    
    subplot(3,2,1)
    boxplot(rmse_tr)

    subplot(3,2,2)
    boxplot(kappa_tr)

    subplot(3,2,3)
    boxplot(fr_tr)

    subplot(3,2,4)
    boxplot(CV_tr)

    subplot(3,2,5)
    boxplot(r_tr)

    subplot(3,2,6)
    %}
    

end
%%



