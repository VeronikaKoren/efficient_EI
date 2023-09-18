close all
clear all
clc

saveres=0;
namepop={'different tuning','similar tuning'};

%% parameters

ntr=150;                               % number of trials

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=0.5;                                % duration of the trial in seconds 

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

%% set the input, selectivity and synaptic weights 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

T=(nsec*1000)./dt;
s=zeros(M,T);

[w,J] = w_fun(M,N,q,d);                % randomly draw the selectivity weights and compute the connectivity matrices

cn=100;                                 % choose 1 neuron
[idx_d,idx_s] = tuning_similarity_idx(w{1},cn);  % index of neurosn with simialr and different selectivity

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

%% network with perturbation of a single neuron in trials

apvec=0:0.1:1;

for ii=1:length(apvec)                                

    Ap=apvec(ii)
    deltar_plt=zeros(ntr,2,length(int_plt));
    deltar=zeros(ntr,2,length(int_measure));

    sc=zeros(ntr,2);
    sc_target=zeros(ntr,1);
    for jj=1:ntr

        [fe,fi,~,~,re,~] =p_fun(dt,sigmav,beta,tau_vec,s,w,J,cn,int_stim,Ap);

        sc(jj,1)=sum(mean(fe,1))./nsec;                           % spikes/sec
        sc(jj,2)=sum(mean(fi,1))./nsec;
        sc_target(jj)=sum(fe(cn,:))./nsec;                        % mean firing rate of the target neuron

        r_inst=re./tau_re;                                        % instantaneous firing rate (IFR) of all neurons, skipping the time window at the beginning (non-stationary)
        r_target=r_inst(cn,:);                                    % IFR of the stimulated (target) neuron
        r_inst(cn,:)=NaN;                                         % remove the activity of the stimulated neuron from the activity of other neurons
        md=mean(mean(r_inst(idx_d,int_spont),'omitnan'),'omitnan');   % average spontaneous IFR over time and neurons to compute delta of the activity
        ms=mean(mean(r_inst(idx_s,int_spont),'omitnan'),'omitnan');

        % for plotting the traces (longer time window)
        r1=mean(r_inst(idx_d,int_plt));                       % mean IFR across tested neurons with different selctivity
        r2=mean(r_inst(idx_s,int_plt));                       % with similar selectivity
        deltar_plt(jj,1,:)=r1-md;                                      % difference from the mean of different
        deltar_plt(jj,2,:)=r2-ms;                                      % difference of the mean of similar

        % measure influence
        r1=mean(r_inst(idx_d,int_measure));                       % mean IFR across tested neurons with different selctivity
        r2=mean(r_inst(idx_s,int_measure));                       % with similar selectivity

        deltar(jj,1,:)=r1-md;                                      % difference from the mean of different
        deltar(jj,2,:)=r2-ms;                                      % difference of the mean of similar

    end


    % average across trials
    %display(mean(sc),'average firing rate E and I')
    md=squeeze(mean(deltar));
    md_plt=squeeze(mean(deltar_plt));
    msc_target=mean(sc_target);
    display(msc_target,'firing rate stimulated neuron')

    tidx=[1:length(int_plt)]*dt;
    % save result?

    if saveres==1
        savefile='result/perturbation/';
        savename=['perturbation_trials_Ap',sprintf('%1.0i',Ap*10)];
        save([savefile,savename],'tidx','md_plt','md','namepop','ntr','c','spont_on','spont_off','stim_on','stim_off','Ap','idx_d','idx_s','int_plt','dt','nsec','msc_target');
    end

end
