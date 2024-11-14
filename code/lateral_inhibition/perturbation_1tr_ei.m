
close all
clear all
clc

savefig=0;
savefile=[cd,'/figure/lateral/'];
%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   

nsec=0.7;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   

beta=14;                         % quadratic cost constant
sigmav=5;                       % noise intensity

dt=0.02;                               % time step in ms     
q=4;                                   % ratio number E to I neurons
d=3;                                   % ratio strength of decoding weights 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% set the input, selectivity weights, synaptic weights,...

T=(nsec*1000)./dt;
%[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);
s=zeros(M,T);

[w,J] = wJ_fun(M,N,q,d);

cn=100;                                 % choose 1 neuron
%%

[idx_d,idx_s] = tuning_similarity_idx(w{1},cn);  % find E neurons with similar and different selectivity
%[idx_d,idx_s] = tuning_similarity_ei(w{1},w{1},cn);  % find I neurons with similar and different selectivity
[idx_di,idx_si] = tuning_similarity_ei(w{1},w{2},cn);  % find I neurons with similar and different selectivity

%% perturbation windows

Ap=1.5;                  % strength of perturbation wrt firing threshold (1 is at the threshold)
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

[fe,fi,~,~,re,ri] =p_fun(dt,sigmav,beta,tau_vec,s,w,J,cn,int_stim,Ap);

%% measure deviation firing rate in E

r_inst=re./tau_re;           % instantaneous firing rate (IFR) of all neurons, skipping the time window at the beginning (non-stationary)
r_target=r_inst(cn,int_plt);                          % IFR of the stimulated (target) neuron  
r_inst(cn,:)=NaN;                               % remove the activity of the stimulated neuron from the activity of other neurons 

md=mean(mean(r_inst(idx_d,int_spont),'omitnan'),'omitnan');   % average spontaneous IFR over time and neurons to compute delta of the activity
ms=mean(mean(r_inst(idx_s,int_spont),'omitnan'),'omitnan');

r1=mean(r_inst(idx_d,int_plt));                       % mean IFR of tested neurons with different selctivity
r2=mean(r_inst(idx_s,int_plt));                       % with similar selectivity

dr1=r1-md;                                      % difference of activity from the mean
dr2=r2-ms;

%% measure deviation firing rate I

r_insi=ri./tau_ri;           % instantaneous firing rate (IFR) of all neurons, skipping the time window at the beginning (non-stationary)
mdi=mean(mean(r_insi(idx_di,int_spont),'omitnan'),'omitnan');   % average spontaneous IFR over time and neurons to compute delta of the activity
msi=mean(mean(r_insi(idx_si,int_spont),'omitnan'),'omitnan');

r1i=mean(r_insi(idx_di,int_plt));                       % mean IFR of tested neurons with different selctivity
r2i=mean(r_insi(idx_si,int_plt));                       % with similar selectivity

dr1i=r1i-mdi;                                      % difference of activity from the mean
dr2i=r2i-msi;

%%  prepare figure EI

pos_vec=[0,0,18,14];
figname='perturbation_1trial_ei';

red=[0.7,0.2,0.1];
%green=[0.1,0.82,0.1];
magenta=[0.8,0,0.7,0.6];
gray=[0.5,0.5,0.5];
%olive=[0.2,0.7,0.2];
%darkgray=[0.5,0.5,0.5];

col={gray,magenta};                               % for "different", "similar"
coltxt=col;

tidx=[1:length(int_plt)]*dt;

xlimit=[200,nsec*1000 - spont_on-100];
xt=100:100:600;
xtl=xt-200;
fs=14;

namen={'stimulated','measured E (different tuning)','measured E (similar tuning)'};
namepop={'different tuning','similar tuning'};

%% plot stimulated neuron and influence single trial

yt=0:0.005:0.005;
ylimit=[-0.015,0.015];

maxidi=max(cat(2,dr1i,dr2i));
minidi=min(cat(2,dr1i,dr2i))-0.002;
stim_zoneI=abs(minidi-maxidi)+1;

maxid=max(cat(2,dr1,dr2));
minid=min(cat(2,dr1,dr2));
stim_zoneE=abs(minid-maxid)+0.001;

H=figure('name',figname);
subplot(3,1,1)
plot(tidx,r_target,'color',red)
text(0.05,0.9,namen{1},'units','normalized','color',red,'fontsize',fs)
box off

%rectangle('Position',[stim_on-spont_on,max(r_target),stim_off-stim_on,max(r_target)/3],'FaceColor',[0,1,1,0.2],'EdgeColor',[0,1,1,0.2],'Linewidth',1)
text(stim_on-spont_on,max(r_target)+max(r_target)/6,'stim.','color',red,'fontsize',fs)
ylabel('z^E_{i}(t)','interpreter','tex','fontsize',14)
xlim(xlimit)
set(gca,'XTick',xt)
set(gca,'XTickLabel',[])
set(gca,'YTick',[0 0.5],'Fontsize',fs)

%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,2)
hold on
plot(tidx,dr1i,'color',col{1})
plot(tidx,dr2i,'color',col{2})
hold off
box off

for ii=1:2
    text(0.04,0.75+(ii-1)*0.18,namepop{ii},'units','normalized','color',coltxt{ii},'fontsize',fs)
end
line([tidx(1) tidx(end)],[0 0],'color',gray,'linestyle','--')
%rectangle('Position',[stim_on-spont_on,-0.015,stim_off-stim_on,0.03],'FaceColor',[0,1,1,0.2],'EdgeColor',[0,1,1,0.2],'Linewidth',1)
rectangle('Position',[stim_on-spont_on,-0.0135,100,0.0008],'FaceColor','k','EdgeColor',gray,'Linewidth',1)
text(stim_on-spont_on+50,-0.009,'measured','units','data','color','k','fontsize',fs)
ylabel('\Delta z^I(t)','Fontsize',fs)
xlim(xlimit)
set(gca,'XTick',xt)
set(gca,'XTickLabel',[])
set(gca,'YTick',[0,0.01],'Fontsize',fs)
ylim([-0.015,0.017])

%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,3)
plot(tidx,dr1,'color',col{1})
hold on
plot(tidx,dr2,'color',col{2})
hold off
box off

line([tidx(1) tidx(end)],[0 0],'linestyle','--','color',gray)
%rectangle('Position',[stim_on-spont_on,minid-0.01,stim_off-stim_on,stim_zoneI],'FaceColor',[0,1,1,0.2],'EdgeColor',[0,1,1,0.2],'Linewidth',1)
rectangle('Position',[stim_on-spont_on,minid-0.001,100,0.0003],'FaceColor','k','EdgeColor',gray,'Linewidth',1)
ylabel('\Delta z^E(t)','Fontsize',fs)
xlabel('time [ms]','Fontsize',fs)
xlim(xlimit)
ylim([-0.0055,0.0055])

set(gca,'XTick',xt)
set(gca,'XTickLabel',xtl,'Fontsize',fs)
set(gca,'YTick',yt,'Fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

