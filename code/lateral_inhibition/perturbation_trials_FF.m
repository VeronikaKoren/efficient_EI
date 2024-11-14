
close all
clear all
clc

a_s=1;  % strength of the stimulus
a_p=1;   % strength of perturbation wrt firing threshold (1 is at the threshold)

saveres=0;
showfig=0;                  
namepop={'different tuning','similar tuning'};

addpath('code/lateral_inhibition/')
addpath('code/function/')

display(['perturbation strength ',sprintf('%0.1f',a_p),' in presence of a stimulus strength ',sprintf('%0.1f',a_s)]);
%% parameters

ntr=100;                               % number of trials

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=0.7;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1.0;                                 % sets the strength of the regularizer     
c=33;                                  % sets the strength of the noise 
beta=b*log(N);                         % quadratic cost constant
sigmav=c/log(N);                       % noise intensity

dt=0.02;                               % time step in ms     
q=4;                                   % ratio number E to I neurons
d=3;                                   % ratio strength of decoding weights 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% set the input, selectivity and synaptic weights 

[w,J] = wJ_fun(M,N,q,d);                % randomly draw the selectivity weights and compute the connectivity matrices

cn=100;                                 % choose 1 neuron
[idx_d,idx_s,phi_vec] = tuning_similarity_idx(w{1},cn);  % index of E neurons with similar / different selectivity
[idx_di,idx_si,phi_veci] = tuning_similarity_ei(w{1},w{2},cn);  % index I neurons with similar / different selectivity

%% design a stimulus that the target neuron is strongly responsive to

T=(nsec*1000)./dt;

w_tar=w{1}(:,cn);
s=ones(M,T).*w_tar*a_s; % static features proportional to the selectivity vector of the target neuron

%{
% O-U stimulus
sigma_s=1;
tau_s=100;
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
%}

%{
ti=(1:T)*dt;
lambda=1/tau_x;
x=zeros(M,T);
for t=1:T-1
    x(:,t+1)=(1-lambda*dt)*x(:,t)+s(:,t)*dt;  
end
figure()
subplot(2,1,1)
hold on
for ii=1:3
    plot(ti,s(ii,:))
end
hold off

subplot(2,1,2)
hold on
for ii=1:3
    plot(ti,x(ii,:))
end
hold off
%}
%% timings

d_spontaneous = 300;     % duration of interval for measuring the spontaneous firing rate
d_stim=50;               % duratio of stimulation
d_measure=d_stim+50;           % duration of interval for measuing the effect of stimulation

spont_on=100;            % start measuring the spontaneus firing rate
spont_off=spont_on + d_spontaneous;          % stop measuring the spontaneous firing rate

stim_on=spont_off;                           % start stimulation
stim_off=spont_off+d_stim;                   % end stimulation

measure_on=stim_on;
measure_off=measure_on + d_measure;

int_spont=spont_on/dt : spont_off/dt -1;      % interval spontaneous
int_stim=stim_on/dt:stim_off/dt -1;           % interval of stimulation
int_measure=measure_on/dt: measure_off/dt -1; % interval for measurement of influence
int_plt=spont_on/dt:T-1;

tidx=[1:length(int_plt)]*dt;

%% network with perturbation of a single neuron in trials

Ni=N/q;

sc=zeros(ntr,2);                          % spike count E and I cell type  
sc_target=zeros(ntr,1);                   % spike count in target neuron  

deltare=zeros(ntr,N,length(int_plt));      % time-dependent E
deltari=zeros(ntr,Ni,length(int_plt));     % time-dependent I
dFE=zeros(ntr,N);                          % time averaged E  
dFI=zeros(ntr,Ni);                        % time averaged I

for jj=1:ntr

    disp(jj)
    [fe,fi,~,~,re,ri] =p_fun(dt,sigmav,beta,tau_vec,s,w,J,cn,int_stim,a_p);

    sc_target(jj)=sum(fe(cn,:))./nsec;                        % mean firing rate of the target neuron  
    fe(cn,:)=NaN;                                             % remove stimulated neuron  
    sc(jj,1)=sum(mean(fe,1),'omitnan')./nsec;                           % spikes/sec
    sc(jj,2)=sum(mean(fi,1),'omitnan')./nsec;

    %% E neurons
    
    r_inst=re./tau_re;                                        % instantaneous firing rate (IFR) of all neurons, skipping the time window at the beginning (non-stationary)
    r_target=r_inst(cn,:);                                    % IFR of the stimulated (target) neuron
    r_inst(cn,:)=NaN;                                         % remove the activity of the stimulated neuron from the activity of other neurons
    
    r_base=mean(r_inst(:,int_spont),2,'omitnan');             % baseline firing date  
    deltare(jj,:,:)=r_inst(:,int_plt)-r_base;                 % difference from the baseline

    % time-averaged (influence)
    F=mean(r_inst(:,int_measure),2);                           % time average influenced IFR
    S=mean(r_inst(:,int_spont),2);                             % time average spontaneous IFR 
    dFE(jj,:)=F-S;

    %% I neurons

    r_insti=ri./tau_ri;
    r_basei=mean(r_insti(:,int_spont),2);                        % baseline firing date  
    deltari(jj,:,:)=r_insti(:,int_plt)-r_basei;                 % difference from the baseline

    % time-averaged (influence)
    FI=mean(r_insti(:,int_measure),2);                           % time average influenced IFR
    SI=mean(r_insti(:,int_spont),2);                             % time average spontaneous IFR 
    dFI(jj,:)=FI-SI;

end

%%
dre=cell(2,1);
dre{1}=deltare(:,idx_d,:);
dre{2}=deltare(:,idx_s,:);
drevec=cellfun(@(x) reshape(x,[size(x,1)*size(x,2),size(x,3)]),dre,'un',0);
mdre=cellfun(@(x) mean(x,1),drevec,'un',0);
semdre=cellfun(@(x) std(x,1)./sqrt(size(x,1)),drevec,'un',0);

%%
dri=cell(2,1);
dri{1}=deltari(:,idx_di,:);
dri{2}=deltari(:,idx_si,:);
drivec=cellfun(@(x) reshape(x,[size(x,1)*size(x,2),size(x,3)]),dri,'un',0);
mdri=cellfun(@(x) mean(x,1),drivec,'un',0);
semdri=cellfun(@(x) std(x,1)./sqrt(size(x,1)),drivec,'un',0);

%% trial-averaged statistics

% spike count
msc_target=mean(sc_target);             % mean spike count stimulated neuron
msc=mean(sc);                           % mean sc E and I neurons (excluding the stimulated)

display(msc_target,'firing rate stimulated neuron')
display(msc,'average firing rate E and I')

% time-averaged delta r

dFE(:,cn)=NaN;                         % remove the target neuron  
infE=mean(dFE,1,'omitnan');            % average across trials
infI=mean(dFI,1);

%% save result?

if saveres==1
    savefile='result/perturbation/';
    savename=['perturbation_ap',sprintf('%1.0i',a_p*10),'_stim',sprintf('%1.0i',a_s*10)];
    save([savefile,savename],'tidx','infE','infI','phi_vec','phi_veci','mdri','mdre','semdri','semdre','namepop','ntr','c','spont_on','spont_off','stim_on','stim_off','int_plt','a_p','dt','nsec','msc_target','msc');
end

%% prepare figure

if showfig==1

    red=[0.7,0.2,0.1];
    green=[0.1,0.82,0.1];
    gray=[0.7,0.7,0.7];
    col={gray,green};  % for {"different", "similar"}

    figure('name','influence','Position',[0,0,20,16]);
    
    
    % plot time-dependent traces similar / different tuning
    subplot(3,2,[1 2])
    hold on
    for k=1:2
        plot(tidx,mdri{k}-semdri{k},'color',col{k})
        plot(tidx,mdri{k}+semdri{k},'color',col{k})
    end
    hold off

    subplot(3,2,[3 4])
    hold on
    for k=1:2
        plot(tidx,mdre{k}-semdre{k},'color',col{k})
        plot(tidx,mdre{k}+semdre{k},'color',col{k})
    end
    hold off

    subplot(3,2,5)
    plot(infI,phi_veci,'ko')
    hl=lsline;
    hl.Color='m';
    title('I neurons')
    ylabel('tuning similarity')
    box off
    xlabel('influence')
        
    subplot(3,2,6)
    plot(infE,phi_vec,'ko')
    hl=lsline;
    hl.Color='m';

    title('E neurons')
   
    %set(gca,'XTick',xt)
    %axis([xt(1)-0.005,xt(end)+0.005,-1.1,1.1])
    box off
    xlabel('influence')

end


