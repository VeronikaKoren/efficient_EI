
% measure effect of activity perturbation of a single E (target) neuron on
% E and I neurons across trials
% without feedforward input
% for a range of stimulation strengths given by apvec

close all
clear
clc

saveres=0;
showfig=0;                  
namepop={'different tuning','similar tuning'};
addpath('code/function/')

%% parameters

ntr=200;                               % number of trials
dt=0.02;                               % time step in ms    

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=0.7;                                % duration of the trial in seconds 

sigma_s=2;
tau_s=10;                              % time constant of the stimulus features  
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity 

%% set the input, selectivity and synaptic weights 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

T=(nsec*1000)./dt;
s=zeros(M,T);

[w,J] = w_fun(M,N,q,d);                % randomly draw the selectivity weights and compute the connectivity matrices

cn=randi(N,1);                                 % choose one E neuron
[idx_d,idx_s,phi_vec] = tuning_similarity_idx(w{1},cn);  % index of neurosn with simialr and different selectivity
[idx_di,idx_si,phi_veci] = tuning_similarity_ei(w{1},w{2},cn);  % find I neurons with similar and different selectivity

%% timings

d_spontaneous = 300;     % duration of interval for measuring the spontaneous firing rate
d_stim=50;               % duratio of stimulation
d_measure=100;           % duration of interval for measuing the effect of stimulation

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

%% network with activity perturbation of a single neuron in trials

Ni=N/q;

apvec=0:0.1:1.5;
n=length(apvec);

sc_target=zeros(n,ntr);                   % spike count in target neuron  

dFE=zeros(n,ntr,N);                          % time averaged E  
dFI=zeros(n,ntr,Ni);                        % time averaged I

for ii=1:length(apvec)

    disp(n-ii)
    Ap=apvec(ii);

    for jj=1:ntr

        [fe,~,~,~,re,ri] =p_fun(dt,sigmav,beta,tau_vec,s,w,J,cn,int_stim,Ap);
        sc_target(ii,jj)=sum(fe(cn,:))./nsec;                        % mean firing rate of the target neuron

        %% E neurons

        r_inst=re./tau_re;                                        % instantaneous firing rate (IFR) of all neurons, skipping the time window at the beginning (non-stationary)
        r_target=r_inst(cn,:);                                    % IFR of the stimulated (target) neuron
        r_inst(cn,:)=NaN;                                         % remove the activity of the stimulated neuron from the activity of other neurons

        % time-averaged deltar = influence
        F=mean(r_inst(:,int_measure),2);                           % time average influenced IFR
        S=mean(r_inst(:,int_spont),2);                             % time average spontaneous IFR
        dFE(ii,jj,:)=F-S;

        %% I neurons

        r_insti=ri./tau_ri;

        % time-averaged infuence
        FI=mean(r_insti(:,int_measure),2);                           % time average influenced IFR
        SI=mean(r_insti(:,int_spont),2);                             % time average spontaneous IFR
        dFI(ii,jj,:)=FI-SI;

    end
end

%% split in 2 groups and get mean and SEM

% split
infE=cell(2,1);
infE{1}=dFE(:,:,idx_d);
infE{2}=dFE(:,:,idx_s);

infI=cell(2,1);
infI{1}=dFI(:,:,idx_di);
infI{2}=dFI(:,:,idx_si);

% reshape
infEvec=cellfun(@(x) reshape(x,[size(x,1),size(x,2)*size(x,3)]),infE,'un',0);
infIvec=cellfun(@(x) reshape(x,[size(x,1),size(x,2)*size(x,3)]),infI,'un',0);

% mean & SEM
minfE=cellfun(@(x) mean(x,2),infEvec,'un',0);
minfI=cellfun(@(x) mean(x,2),infIvec,'un',0);
semfE=cellfun(@(x) std(x,1,2)./sqrt(size(x,2)),infEvec,'un',0);
semfI=cellfun(@(x) std(x,1,2)./sqrt(size(x,2)),infIvec,'un',0);

mtar=mean(sc_target,2);
semtar=std(sc_target,1,2)./sqrt(size(sc_target,2));

%% save result?

if saveres==1
    savefile='result/lateral_inhibition/';
    savename='perturbation_Ei_spont_apvec';
    save([savefile,savename],'minfE','minfI','semfE','semfI','mtar','semtar','namepop','ntr','apvec');
end

%% check result

if showfig==1


    red=[0.7,0.2,0.1];
    green=[0.1,0.82,0.1];
    gray=[0.7,0.7,0.7];
    col={gray,green};  % for {"different", "similar"}

    figure('name','influence_Ap','Position',[0,0,12,12]);

    subplot(3,1,1)
    hold on
    plot(apvec,mtar-semtar,'k')
    plot(apvec,mtar+semtar,'k')

    subplot(3,1,2)
    hold on
    for k=1:2
        plot(apvec,minfI{k}-semfI{k},'color',col{k})
        plot(apvec,minfI{k}+semfI{k},'color',col{k})
    end
    hold off

    subplot(3,1,3)
    hold on
    for k=1:2
        plot(apvec,minfE{k}-semfE{k},'color',col{k})
        plot(apvec,minfE{k}+semfE{k},'color',col{k})
    end
    hold off
end


