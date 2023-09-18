
close all
clear all
clc

savefig=0;

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=0.7;                                % duration of the trial in seconds 


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

%% set the input, selectivity weights, synaptic weights,...

T=(nsec*1000)./dt;
s=zeros(M,T);

[w,J] = w_fun(M,N,q,d);

cn=100;                                 % choose index of a neuron
[idx_d,idx_s] = tuning_similarity_idx(w{1},cn);  % find neurons with similar and different selectivity

%% network with perturbation

Ap=1.0;                  % strength of perturbation wrt firing threshold (1 is at the threshold)
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

%% simulate network

[fe,fi,~,~,re,~] =p_fun(dt,sigmav,beta,tau_vec,s,w,J,cn,int_stim,Ap);

%% measure influence

r_inst=re./tau_re;           % instantaneous firing rate (IFR) of all neurons, skipping the time window at the beginning (non-stationary)
r_target=r_inst(cn,int_plt);                          % IFR of the stimulated (target) neuron  
r_inst(cn,:)=NaN;                               % remove the activity of the stimulated neuron from the activity of other neurons 

md=mean(mean(r_inst(idx_d,int_spont),'omitnan'),'omitnan');   % average spontaneous IFR over time and neurons to compute delta of the activity
ms=mean(mean(r_inst(idx_s,int_spont),'omitnan'),'omitnan');

r1=mean(r_inst(idx_d,int_plt));                       % mean IFR of tested neurons with different selctivity
r2=mean(r_inst(idx_s,int_plt));                       % with similar selectivity

dr1=r1-md;                                      % difference of activity from the mean
dr2=r2-ms;

%%  prepare figure

pos_vec=[0,0,18,12];
figname='perturbation_1trial';

green=[0.1,0.82,0.1];
gray=[0.7,0.7,0.7];
red=[0.7,0.2,0.1];
olive=[0.2,0.7,0.2];
darkgray=[0.5,0.5,0.5];

col={gray,green};                               % for "different", "similar"
coltxt={darkgray,olive};
coln={red,gray,green};
colntxt={red,darkgray,olive};

tidx=[1:length(int_plt)]*dt;
maxid=max(cat(2,dr1,dr2));
minid=min(cat(2,dr1,dr2));
yellow_zone=abs(minid-maxid);

xlimit=[100,nsec*1000 - spont_on-100];
xt=100:200:600;
xtl=xt-100;
fs=14;

namen={'stimulated','measured (different tuning)','measured (similar tuning)'};
namepop={'different tuning','similar tuning'};

%% plot stimulated neurosn and influence single trial


H=figure('name',figname);
subplot(2,1,1)
plot(tidx,r_target,'color',red)
hold on
plot(tidx,r_inst(idx_d(1),int_plt),'color',col{1})
plot(tidx,r_inst(idx_s(end),int_plt),'color',col{2})
hold off
box off

rectangle('Position',[stim_on-spont_on,max(r_target),stim_off-stim_on,max(r_target)/3],'FaceColor',[1,1,0,0.3],'EdgeColor','y','Linewidth',1)
text(stim_on-spont_on,max(r_target)+max(r_target)/6,'stim.','color',red,'fontsize',fs)

for ii=1:3
    text(0.05,0.95-(ii-1)*0.13,namen{ii},'units','normalized','color',colntxt{ii},'fontsize',fs)
end

ylabel('r^E_{i}(t)')
xlim(xlimit)
set(gca,'XTick',xt)
set(gca,'XTickLabel',[])
set(gca,'YTick',[0 0.5])
%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2)
plot(tidx,dr1,'color',col{1})
hold on
plot(tidx,dr2,'color',col{2})
hold off
box off

line([tidx(1) tidx(end)],[0 0],'color',gray)
rectangle('Position',[stim_on-spont_on,minid,stim_off-stim_on,yellow_zone],'FaceColor',[1,1,0,0.3],'EdgeColor','y','Linewidth',1)
text(stim_on-spont_on,maxid,'stim.','color',red,'fontsize',fs)

for ii=1:2
    text(0.07,0.85+(ii-1)*0.13,namepop{ii},'units','normalized','color',coltxt{ii},'fontsize',fs)
end

ylabel('\Delta r(t)')
xlabel('time [ms]')
xlim(xlimit)
%ylim([-0.0013,0.0008])

set(gca,'XTick',xt)
set(gca,'XTickLabel',xtl)
set(gca,'YTick',-0.003:0.003:0.003)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    savefile=[cd,'/figure/lateral/'];
    print(H,[savefile,figname],'-dpng','-r300');
end

