format long
addpath([cd,'/code/function/'])
saveres=1;
showfig=0;

type=2;
namet={'normal','permuted'};
%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=12;                                % duration of the trial in seconds 

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
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
%%
[w,C] = w_fun(M,N,q,d);
[dp] = dot_prod_fun(w);
dpn=cellfun(@(x) x./max(x),dp,'UniformOutput',false);

idxp1=cellfun(@(x) find(x>0.5),dpn,'un',0);
idxp2=cellfun(@(x) find((x<0.5).*(x>0)),dpn,'un',0);
idxm=cellfun(@(x) find(x<0),dpn,'un',0);
%% 

tic
ntr=20;
mus_vec=0:5:50;
n=length(mus_vec);
rpm=zeros(n,2,3);

for g=1:n
    
    display(n-g,' to go')
    mu_abs=mus_vec(g);
    mu_s=[mu_abs,mu_abs,mu_abs]';
    
    [s,x]=signal_sepdim_fun(tau_s,tau_x,M,nsec,dt,mu_s); 
   
    rpm_tr=zeros(ntr,2,3);
    for tr=1:ntr
        [~,~,~,rVm] = net_fun_V2(dt,sigmav,mu,tau_vec,w,C,type,nsec,tau_s,mu_s);
        rpm_tr(tr,:,1)=cellfun(@(x,y) nanmean(x(y)),rVm,idxp1);
        rpm_tr(tr,:,2)=cellfun(@(x,y) nanmean(x(y)),rVm,idxp2);
        rpm_tr(tr,:,3)=cellfun(@(x,y) nanmean(x(y)),rVm,idxm);
    end
    
    rpm(g,:,:)=nanmean(rpm_tr);
    
end

toc
%%

if showfig==1
    namepop={'E-E','I-I'};
    col={[0.5,0.5,0],[0.2,0.7,0],[0.2,0.2,0.2]};
    nameg={'strongly similar','weakly similar','different'};
    
    figure('units','centimeters','Position',[0,0,12,10])
    subplot(2,1,1)
    hold on
    for ii=1:3
        plot(mus_vec,squeeze(rpm(:,1,ii)),'color',col{ii})
    end
    legend(nameg,'Location','SouthEast')
    title(namepop{1})
    ylim([-0.4,1])
    ylabel('correlation in V(t)')
    
    subplot(2,1,2)
    hold on
    for ii=1:3
        plot(mus_vec,squeeze(rpm(:,2,ii)),'color',col{ii})
    end
    grid on
    
    title(namepop{2})
    ylim([-0.4,1])
    ylabel('correlation in V(t)')
    xlabel('mu_s')
    
end
%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{dt},{nsec}};
    
    savefile='result/stimulus/';
    savename=['corr_V_mus',namet{type},'_3g'];
    save([savefile,savename],'mus_vec','rpm','parameters','param_name') 
end

